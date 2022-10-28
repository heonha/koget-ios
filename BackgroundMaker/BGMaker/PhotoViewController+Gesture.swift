//
//  PhotoViewController+Gesture.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/09/29.
//

import UIKit

extension PhotoViewController {
    
    //MARK: - Gesture 셋업
    
    //MARK: 사진 확대/축소 제스쳐
    
    /// 두손가락으로 핀치하는 제스쳐를 SuperView에 추가합니다.
    func makePinchGesture(selector: Selector) {
        var pinch = UIPinchGestureRecognizer()
        
        pinch = UIPinchGestureRecognizer(target: self, action: selector)
        self.view.addGestureRecognizer(pinch)
    }
    
    /// 두손가락으로 이미지를 확대, 축소 할수 있는 핀치액션을 구성합니다.
    @objc func pinchZoomAction(_ pinch: UIPinchGestureRecognizer) {
        mainImageView.transform = mainImageView.transform.scaledBy(x: pinch.scale, y: pinch.scale)
        pinch.scale = 1
    }
    
    //MARK: 더블 탭 제스쳐
    /// 화면을 두번 탭하면 이벤트가 발생하는 TapRecognizer를 구성합니다.
    /// - selector : 제스쳐의 action을 구성할 objc 메소드입니다.
    func addDoubleTapRecognizer(selector: Selector) {
        let doubleTap = UITapGestureRecognizer(target: self, action: selector)
        doubleTap.numberOfTapsRequired = 2
        self.view.addGestureRecognizer(doubleTap)
    }
    
    /// 더블 탭 액션 ( 기본배율에서 더블탭하면 배율 2배, 그외에는 1배로 초기화, )
    @objc func doubleTapZoomAction(_ recognizer: UITapGestureRecognizer) {
        UIView.animate(withDuration: 0.3) {
            if self.mainImageView.transform == CGAffineTransform(scaleX: 1, y: 1) {
                self.mainImageView.transform = CGAffineTransform(scaleX: 2, y: 2)
                
            } else {
                self.mainImageView.center = self.view.center
                self.mainImageView.transform = CGAffineTransform(scaleX: 1, y: 1)
            }
        }
    }
    
    
    /// PanGesture를 추가합니다.
    /// - selector : 제스쳐의 action을 구성할 objc 메소드입니다.
    func addPanGesture(selector: Selector) {
        let gesture = UIPanGestureRecognizer(target: self, action: selector)
        self.view.addGestureRecognizer(gesture)
    }
    
    /// 이미지를 드래그 할수 있는 제스쳐를 만듭니다.
    @objc func makeDragImageGesture(_ sender: UIPanGestureRecognizer) {
        
        
        // 지정된 보기의 좌표계에서 팬 제스처를 해석합니다.
        let translation = sender.translation(in: mainImageView)
        // print("Pan Gesture Translation(CGPoint) : \(translation)")
        
        ///.Began각 제스처 인식의 맨 처음에 한 번 호출됩니다.
        ///.Changed사용자가 "제스처" 과정에 있으므로 계속 호출됩니다.
        ///.Ended제스처의 끝에서 한 번 호출됩니다.
        switch sender.state {
        case .began:
            /// 처음 클릭하기 시작했을 때
            self.imageOriginalCenter = mainImageView.center // TrayView의 센터포인트를 저장합니다.
            
        case .changed:
            self.mainImageView.center = CGPoint(x: self.imageOriginalCenter.x + translation.x, y: self.imageOriginalCenter.y + translation.y)
        default:
            break
        }
        
    }
    
    /// PanGesture를 추가합니다.
    /// - selector : 제스쳐의 action을 구성할 objc 메소드입니다.
    func addEdgeGesture(selector: Selector) {
        let gesture = UIScreenEdgePanGestureRecognizer(target: self, action: selector)
        gesture.edges = .bottom
        self.view.addGestureRecognizer(gesture)
    }
    
    /// 불러온 이미지에 따라서 이미지 뷰의 크기를 조절합니다.
    func resizeImageView() {
        /// 이미지뷰 레이아웃
        let screenSize = UIScreen.main.bounds
        let imageSize = mainImageView.image?.size

        let imageHeight = (imageSize!.height * screenSize.width) / imageSize!.width
        let resizeHeight = (screenSize.height - imageHeight) / 2
        
        mainImageView.snp.remakeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.equalTo(screenSize.width)
            make.height.equalToSuperview().inset(resizeHeight)
        }
    }
    

    
    //MARK: Gesture 셋업 END -
    
    
}
