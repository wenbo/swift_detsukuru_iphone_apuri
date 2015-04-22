//
//  FirstViewController.swift
//  PhotoMessaging
//
//  Created by ryo on 2/17/15.
//  Copyright (c) 2015 naoki.izumi. All rights reserved.
//

import UIKit

class FirstViewController: UIImagePickerController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    // MARK: - UIImagePickerController override
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // カメラの設定
        self.sourceType = UIImagePickerControllerSourceType.Camera
        self.cameraCaptureMode = UIImagePickerControllerCameraCaptureMode.Photo
        self.showsCameraControls = false
        self.delegate = self
        
        // ツールバーを追加
        self.toolBarCustomize()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - UINavigationControllerDelegate, UIImagePickerControllerDelegate
    
    func imagePickerController(picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [NSObject : AnyObject])
    {
            
        println("写真をとりました")
        
        /// カメラで撮影した写真
        let image = info[UIImagePickerControllerOriginalImage] as UIImage
        
        // 写真アプリに撮影した写真を保存する
        UIImageWriteToSavedPhotosAlbum(
            image,
            self,
            Selector("didSaveToPhotosApp:error:contextInfo:"),
            UnsafeMutablePointer()
        )
            
    }
    
    // MARK: - local method
    
    /*
    ツールバーを作成
    */
    func toolBarCustomize() {
        
        /// シャッターボタン
        let takePhotoButton = UIBarButtonItem(
            barButtonSystemItem: UIBarButtonSystemItem.Camera,
            target: self,
            action: Selector("takePicture"))
        
        // ツールバーを表示
        self.toolbarHidden = false
        
        /// ツールバー
        let bottomBar = UIToolbar(frame: self.toolbar.frame)
        
        // ツールバーの設定
        bottomBar.translucent = false
        bottomBar.items = [takePhotoButton]
        
        // ツールバーを画面に追加
        self.view.addSubview(bottomBar)
    }
    
    
    // MARK: Selector

    /*
    写真保存後に実行される
    */
    func didSaveToPhotosApp(image: UIImage!, error: NSErrorPointer, contextInfo: UnsafeMutablePointer<()>) {
        
        println("撮った写真を写真アプリに保存しました。")
    }

}

