import Foundation

import Foundation

open class MConHudKit: NSObject {
    public static let shared = MConHudKit()
    private lazy var core: MConHudKitCore = MConHudKitCore()
    private lazy var messageManager: MConHudMessageManager = MConHudMessageManager()
    private var authStatus: Bool = false
    public weak var hudScanDelegate: MConHudScanDelegate? = nil
    public weak var hudDelegate: MConHudDelegate? = nil
//    public weak var hudFirmwareDelegate: MConHudFirmwareDelegate? = nil
    
    private var initializeCompletion: ((MConHudKitError?)->())? = nil
    
    public func checkBluetoothPermission(completion: @escaping(MConHudKitError?)->()) {
        if !authStatus {
            completion(.invalidAuthorization)
            return
        }
        
        initializeCompletion = completion
        core.delegate = self
        core.checkBluetoothPermission()
    }
    
    public func initialize(appKey: String, completion: @escaping(MConHudKitError?)->()) {
        //Bundle.main.bundleIdentifier
        let identifier = Bundle.main.bundleIdentifier
        
        
        core.authAppKey(appKey: appKey) { result in
            if(result) {
                self.authStatus = true
                self.initializeCompletion = completion
                self.core.delegate = self
                self.core.checkBluetoothPermission()
            } else {
                self.authStatus = false
                completion(.invalidAuthorization)
            }
        }
        
        
        
    }
    
    public func startScanPeripheral(timeoutSec: Int?) {
        if !authStatus {
            return
        }
        core.startScan(timeout: timeoutSec)
    }
    
    public func stopScanPeripheral() {
        if !authStatus {
            return
        }
        core.stopScan()
    }
    
    public func connectPeripheral(peripheral: MConHudPeripheral) {
        if !authStatus {
            return
        }
        core.connectPeripheral(peripheral: peripheral)
    }
    
    public func disconnectPeripheral(peripheral: MConHudPeripheral) {
        if !authStatus {
            return
        }
        core.disconnectPeripheral(peripheral: peripheral)
    }
    
    public func sendTurnByTurnInfo(tbtCode: TurnByTurnCode, distance: Int) {
        if !authStatus {
            return
        }
        core.write(message: messageManager.tbtMessage(turnByTurnCode: tbtCode, distance: distance))
    }
    
    public func sendSafetyInfo(safetyCodes: [SafetyCode], limitSpeed: Int?, remainDistance: Int, isOverSpeed: Bool) {
        core.write(message: messageManager.safetyMessage(safetyCodes: safetyCodes, limitSpeed: limitSpeed, remainDistance: remainDistance, isOverSpeed: isOverSpeed))
    }
    
    public func sendCarSpeed(carSpeedCode: CarSpeedCode, speed: Int) {
        if !authStatus {
            return
        }
        if speed > -1 {
            core.write(message: messageManager.carSpeedMessage(carSpeedCode: carSpeedCode, speed: speed))
        }
    }
    
    public func sendClear(clearCodes: [ClearCode]) {
        if !authStatus {
            return
        }
        core.write(message: messageManager.clearMessage(clearCodes: clearCodes))
    }
    
    public func sendTime(yyyyMMddHHmmss: String) {
        
    }
    
    /*
     case birght = 1
     case sound = 2
     case firmware = 3
     */
    
    public func sendHudBrightnessLevel(brightnessLevel: BrightnessLevel) {
        if !authStatus {
            return
        }
        core.write(message: messageManager.brightnessMessage(brightnessLevel: brightnessLevel))
        
    }
    
    public func getHudBrightnessLevel() {
        if !authStatus {
            return
        }
        core.write(message: messageManager.deviceInfoMessage(deviceInfoType: .birght))
    }
    
    public func sendHudBuzzerLevel(buzzerLevel: BuzzerLevel) {
        if !authStatus {
            return
        }
        core.write(message: messageManager.buzzerLevelMessage(buzzerLevel: buzzerLevel))
    }
    
    public func getHudBuzzerLevel() {
        if !authStatus {
            return
        }
        core.write(message: messageManager.deviceInfoMessage(deviceInfoType: .buzzer))
    }
    
//    public func getFirmwareInfo() {
//        if !authStatus {
//            return
//        }
//        core.write(message: messageManager.deviceInfoMessage(deviceInfoType: .firmware))
//    }
    
//    public func startFirmwareUpdate() {
//
//    }
}


extension MConHudKit: MConHudKitCoreDeletage {
    func scanPeripherals(peripherals: [MConHudPeripheral]) {
        hudScanDelegate?.scanPeripheral(peripherals: peripherals)
    }
    
    func connectResult(result: Bool, peripheral: MConHudPeripheral?) {
        if result {
            if let peripheral = peripheral {
                hudScanDelegate?.connectPeripheralResult(peripheral: peripheral)
            } else {
                hudScanDelegate?.error(error: .peripheralConnectFail)
            }
            
        } else {
            hudScanDelegate?.error(error: .peripheralConnectFail)
        }
    }
    
    func scannerTimeout() {
        hudScanDelegate?.scanTimeOut()
    }
    
    func notifyData(data: [UInt8]) {
        
        let id = String(format: "%02X", data[1])
        let command = String(format: "%02X", data[2])
        
        if id == "4E" {
            // 조도 단계
            if command == "0B" {
                if Int(data[4]) == 0 {
                    hudDelegate?.receiveHudBrightnessLevel(brightnessLevel: .low)
                }
                else if Int(data[4]) == 1 {
                    hudDelegate?.receiveHudBrightnessLevel(brightnessLevel: .medium)
                }
                else if Int(data[4]) == 2 {
                    hudDelegate?.receiveHudBrightnessLevel(brightnessLevel: .high)
                }
            } else if command == "0A" {
                if Int(data[4]) == 0 {
                    hudDelegate?.receiveHudBuzzerStatus(buzzerStatus: .off)
                } else {
                    hudDelegate?.receiveHudBuzzerStatus(buzzerStatus: .on)
                }
            }
        }
        
    }
    
    func permissionDenied() {
        guard let initializeCompletion = initializeCompletion else {return}
        initializeCompletion(.bluetoothPermissionDenied)
        self.initializeCompletion = nil
    }
    func initializeComplete() {
        guard let initializeCompletion = initializeCompletion else {return}
        initializeCompletion(nil)
        self.initializeCompletion = nil
    }
    
    func disconnectedPeripheral() {
        hudScanDelegate?.disconnectedPeripheral()
    }
    
}
