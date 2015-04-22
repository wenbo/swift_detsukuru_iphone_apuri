//
//  FrameImageView.swift
//  PhotoMessaging
//
//  Created by ryo on 11/5/14.
//  Copyright (c) 2014 naoki.izumi. All rights reserved.
//

import UIKit

class FrameImageView: UIImageView {
    
    // MARK: - propaeties
    
    /// 使用するフレーム画像
    let frameImageResources :[String] = [
        "frame_pictures/frame01.png",
        "frame_pictures/frame02.png",
        "frame_pictures/frame03.png",
        "frame_pictures/frame04.png",
        "frame_pictures/frame05.png",
        "frame_pictures/frame06.png",
        "frame_pictures/frame07.png",
        "frame_pictures/frame08.png",
        "frame_pictures/frame09.png",
        "frame_pictures/frame10.png",
        ""]
    
    ///現在のフレーム画像のインデックス
    private var frameImageIndex = 0
    
    /**
    フレーム画像を変更する
    */
    func changeFrame() {
        println("フレームの変更")
        
        if self.frameImageIndex > self.frameImageResources.count - 1 {
           self.frameImageIndex = 0
        }
        
        self.image = UIImage(named: self.frameImageResources[self.frameImageIndex])
        self.frameImageIndex++
    }
}
