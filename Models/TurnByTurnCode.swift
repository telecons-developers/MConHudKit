//
//  TurnByTurnCode.swift
//  MConHudKit
//
//  Created by 정지성 on 2023/09/25.
//

import Foundation

public enum TurnByTurnCode {
    case straight               // 직진
    case leftTurn               // 좌회전
    case rightTurn              // 우회전
    case uTurn
//    case leftUTurn              // 왼쪽 유턴
//    case rightUTurn             // 오른쪽 유턴
    case sharpLeftTurn          // 11시방향 좌회전
    case curveLeftTurn          // 7시방향 좌회전
    case sharpRightTurn         // 1시방향 우회전
    case curveRightTurn         // 5시방향 우회전
    case leftOutHighway         // 왼쪽 고속도로 출구
    case rightOutHighway        // 오른쪽 고속도로 출구
    case leftInHighway          // 왼쪽 고속도로 입구
    case rightInHighway         // 오른쪽 고속도로 입구
    case tunnel                 // 터널 진입
    case overPath               // 고가 진입
    case underPath              // 지하차도 진입
    case overPathSide           // 고가 옆길
    case underPathSide          // 지하차도 우측
    case tollgate               // 요금소
    case restarea               // 휴게소, 졸음쉼터
    case rotaryDirection_1
    case rotaryDirection_2
    case rotaryDirection_3
    case rotaryDirection_4
    case rotaryDirection_5
    case rotaryDirection_6
    case rotaryDirection_7
    case rotaryDirection_8
    case rotaryDirection_9
    case rotaryDirection_10
    case rotaryDirection_11
    case rotaryDirection_12
}
