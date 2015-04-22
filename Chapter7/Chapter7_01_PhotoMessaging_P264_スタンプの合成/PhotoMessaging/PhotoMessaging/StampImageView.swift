//
//  StampImageView.swift
//  PhotoMessaging
//
//  Created by ryo on 11/7/14.
//  Copyright (c) 2014 naoki.izumi. All rights reserved.
//

import UIKit

class StampImageView: UIImageView {


    /// MARK: - properties
    
    /// 現在のスケールを保持
    var scale: CGFloat = 1
    
    /// MARK: - UIImageView override
    
    override init(image: UIImage!) {
        super.init(image: image)
        println("init実行")
        
        userInteractionEnabled =  true
        
        let pan = UIPanGestureRecognizer(
            target: self,
            action: Selector("doPanAciton:")
        )
        addGestureRecognizer(pan)
        
        
        let pinch = UIPinchGestureRecognizer(
            target: self,
            action: Selector("doPinchAction:")
        )
        addGestureRecognizer(pinch)

    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - local method
    
    /**
    パンアクションのイベント
    */
    func doPanAciton(sender: UIPanGestureRecognizer) {
//        println("doPanAciton実行")
     
        /// 元の場所から移動した差分
        let translation = sender.translationInView(self.superview!)
        
        /// 新しい移動先の座標
        let movedPoint = CGPointMake(
            self.center.x + translation.x,
            self.center.y + translation.y
        )
        
        // 移動する
        self.center = movedPoint
        
        // 差分を取得しているので移動ごとに座標を初期化する
        sender.setTranslation(CGPointZero, inView: self)
    }

    
    /**
    ピンチジェスチャのイベント
    */
    func doPinchAction(sender: UIPinchGestureRecognizer) {
        println("doPinchAction実行")
        
        if (sender.state == UIGestureRecognizerState.Began) {
            self.scale = self.scale * sender.scale
            sender.scale = self.scale
        } else {
            self.scale = sender.scale
        }

        self.transform = CGAffineTransformMakeScale(self.scale, self.scale)
    }
}
