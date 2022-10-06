//
//  WidgetViewController+WidgetKit.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/10/05.
//

import UIKit
import WidgetKit

extension WidgetViewController {
    
    /// 현재 이 앱이 구성한 위젯의 데이터를 확인합니다.
    func widgetGetData() {
        WidgetCenter.shared.getCurrentConfigurations { (result) in
            switch result {
            case .success(let widgets):
                for info in widgets {
                    print("---- Widget Information ----")

                    print("info Kind : \(info.kind)")
                    print("info Family : \(info.family)")
                    print("info Config : \(info.configuration)")
                    
                    // info Config : Optional({
                    //     app = <INCustomObject: 0x6000016005f0> {
                    //         pronunciationHint = <null>;
                    //         displayString = instagram;
                    //         subtitleString = <null>;
                    //         identifier = instagram;
                    //         alternativeSpeakableMatches = <null>;
                    //     };
                    // })
                }
            case.failure(let error):
                print(" Widget get current Conf. Error: \(error.localizedDescription)")
            }
        }
    } // END - widgetGetData
    
    /// 위젯의 타임라인을 재설정합니다. (리프레쉬와 같은 효과)
    func widgetRefreshTimeLine() {
        WidgetCenter.shared.reloadTimelines(ofKind: "LockScreenWidget")
    } // END - widgetRefreshTimeLine
    

}
