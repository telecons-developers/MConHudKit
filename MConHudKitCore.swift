//
//  MConHudKitCore.swift
//  MConHudKit
//
//  Created by 정지성 on 2023/09/25.
//

import Foundation
import CoreBluetooth

protocol MConHudKitCoreDeletage: AnyObject {
    func scanPeripherals(peripherals: [MConHudPeripheral])
    func connectResult(result: Bool, peripheral: MConHudPeripheral?)
    func scannerTimeout()
    func notifyData(data: [UInt8])
    func permissionDenied()
    func initializeComplete()
    func disconnectedPeripheral()
}

final class MConHudKitCore: NSObject {
    weak var delegate: MConHudKitCoreDeletage?
    private var centralManager: CBCentralManager?
    private var scanUUID = CBUUID(string: "1812")
    private var serviceUUID = CBUUID(string: "FFEA")
    private var writeCharacteristicUUID = CBUUID(string: "FFF2")
    private var readCharacteristicUUID = CBUUID(string: "FFF1")
    private var isPermissionCheckMode = false
    private var scanTime: Int?
    private var scanTimeOutWork:DispatchWorkItem? = nil
    private var connectedPeripheral: CBPeripheral?
    private weak var writeCharacteristic: CBCharacteristic?
    
    private var peripheralList : [(peripheral : CBPeripheral, RSSI : Float)] = []
    
    override init() {
        super.init()
        peripheralList.removeAll()
    }
    
    func authAppKey(appKey: String, completion: @escaping(Bool)->()) {
        guard let url = URL(string: "https://asd-test001.azurewebsites.net/api/auth?appKey=\(appKey)") else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let urlSession = URLSession(configuration: URLSessionConfiguration.default)
        let task = urlSession.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(false)
                return
            }
            guard let response = response as? HTTPURLResponse else {return}
            if response.statusCode == 200 {
                if let data = data {
                    do {
                        let res = try JSONDecoder().decode(AuthResponse.self, from: data)
                        if res.code == 200 {
                            completion(true)
                        } else {
                            completion(false)
                        }
                    } catch {
                        completion(false)
                    }
                }else {
                    completion(false)
                }
            } else {
                completion(false)
            }
        }
        
        task.resume()
    }
    
    func checkBluetoothPermission() {
        isPermissionCheckMode = true
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }

    
    func startScan(timeout: Int?) {
        scanTime = timeout
        guard let centralManager = centralManager else {return}
        centralManager.scanForPeripherals(withServices: [scanUUID], options: ["CBCentralManagerScanOptionAllowDuplicatesKey": true])
        // Find Bonded Device
        let peripherals = centralManager.retrieveConnectedPeripherals(withServices: [scanUUID])
        for peripheral in peripherals {
            didDiscoverPeripheral(peripheral: peripheral, RSSI: nil)
        }
        
        if let scanTime = scanTime {
            self.scanTimeOutWork = DispatchWorkItem(block: {
                self.delegate?.scannerTimeout()
                self.stopScan()
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(scanTime), execute: scanTimeOutWork!)
        }
    }
    
    func stopScan() {
        centralManager?.stopScan()
    }
    
    func connectPeripheral(peripheral: MConHudPeripheral) {
        stopScan()
        var connectPeripheral : CBPeripheral? = nil
        peripheralList.forEach { item in
            if item.peripheral.identifier.uuidString == peripheral.uuid {
                connectPeripheral = item.peripheral
            }
        }
        if let connectPeripheral = connectPeripheral {
            centralManager?.connect(connectPeripheral, options: nil)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 5 ) {
                if self.connectedPeripheral == nil {
                    self.centralManager?.cancelPeripheralConnection(connectPeripheral)
                    self.delegate?.connectResult(result: false, peripheral: nil)
                }
            }
            
        } else {
            delegate?.connectResult(result: false, peripheral: nil)
        }
    }
    
    func disconnectPeripheral(peripheral: MConHudPeripheral) {
        guard let connectedPeripheral = connectedPeripheral else {return}
        if connectedPeripheral.identifier.uuidString == peripheral.uuid {
            centralManager?.cancelPeripheralConnection(connectedPeripheral)
            self.connectedPeripheral = nil
        }
    }
    
    func write(message: String) {
        guard let peripheral = connectedPeripheral, let writeCharacteristic = writeCharacteristic else {return}
        let data = hexStringToData(message)
        peripheral.writeValue(data, for: writeCharacteristic, type: .withResponse)
    }
    
    private func hexStringToData(_ hex: String) -> Data {
        var hex = hex
        var data = Data()
        while(hex.count > 0) {
            let subIndex = hex.index(hex.startIndex, offsetBy: 2)
            let c = String(hex[..<subIndex])
            hex = String(hex[subIndex...])
            var ch: UInt32 = 0
            Scanner(string: c).scanHexInt32(&ch)
            var char = UInt8(ch)
            data.append(&char, count: 1)
        }
        return data
    }
}

extension MConHudKitCore: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if isPermissionCheckMode {
            if central.state == .poweredOn {
                delegate?.initializeComplete()
            } else {
                delegate?.permissionDenied()
            }
            isPermissionCheckMode = false
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        delegate?.disconnectedPeripheral()
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        if let scanTimeOutWork = scanTimeOutWork {
            scanTimeOutWork.cancel()
            self.scanTimeOutWork = nil
        }
        
        peripheral.delegate = self
        peripheral.discoverServices([serviceUUID])

    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        didDiscoverPeripheral(peripheral: peripheral, RSSI: RSSI)
    }
    
    func centralManager(_ central: CBCentralManager, willRestoreState dict: [String : Any]) {
        
    }
    
    func centralManager(_ central: CBCentralManager, didUpdateANCSAuthorizationFor peripheral: CBPeripheral) {
        
    }
}

extension MConHudKitCore: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else {return}
        for service in services {
            peripheral.discoverCharacteristics([writeCharacteristicUUID, readCharacteristicUUID], for: service)
        }

    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else {return}
        var isReadCharacteristic = false
        for characteristic in characteristics {
            if characteristic.uuid == writeCharacteristicUUID {
                self.writeCharacteristic = characteristic
            }
            if characteristic.uuid == readCharacteristicUUID {
                isReadCharacteristic = true
                peripheral.setNotifyValue(true, for: characteristic)
            }
        }
        
        if writeCharacteristic != nil && isReadCharacteristic == true {
            self.connectedPeripheral = peripheral
            guard let name = peripheral.name else {return}
            delegate?.connectResult(result: true, peripheral: MConHudPeripheral(name: name, uuid: peripheral.identifier.uuidString, paired: false, rssi: 0.0))
        }else {
            self.connectedPeripheral = nil
            delegate?.connectResult(result: false, peripheral: nil)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if let receivceValue = characteristic.value {
            let readValue = [UInt8](receivceValue)
            delegate?.notifyData(data: readValue)
            var byteString = ""
            for byte in readValue {
                byteString.append( String(format: "%02X", byte) )
            }
        }
    }
}

private extension MConHudKitCore {
    private func didDiscoverPeripheral(peripheral : CBPeripheral, RSSI : NSNumber?) {
        for existing in peripheralList {
            if existing.peripheral.identifier == peripheral.identifier {return}
        }
        let fRSSI = RSSI?.floatValue ?? 0.0
        
        peripheralList.append((peripheral : peripheral , RSSI : fRSSI))
        peripheralList.sort { $0.RSSI < $1.RSSI}
        guard let delegate = delegate else {return}
        delegate.scanPeripherals(peripherals: peripheralList.to())
    }
}

extension [(peripheral : CBPeripheral, RSSI : Float)] {
    func to() -> [MConHudPeripheral] {
        var list = [MConHudPeripheral]()
        self.forEach { item in
            
            if let name = item.peripheral.name {
                var paired = false
                if item.RSSI == 0.0 {
                    paired = true
                }
                list.append( MConHudPeripheral.init(name: name, uuid: item.peripheral.identifier.uuidString, paired: paired, rssi: item.RSSI) )
            }
        }
        return list
    }
}

struct AuthResponse: Codable {
    let code: Int
}
