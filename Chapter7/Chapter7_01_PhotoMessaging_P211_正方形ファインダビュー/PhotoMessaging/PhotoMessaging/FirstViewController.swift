//
//  FirstViewController.swift
//  PhotoMessaging
//
//  Created by ryo on 2/17/15.
//  Copyright (c) 2015 naoki.izumi. All rights reserved.
//

import UIKit

class FirstViewController: UIImagePickerController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    
    // MARK: - properties
    
    
    /**
    タブバー、ツールバーを除いた画面サイズ
    */
    var cameraAreaSize: CGSize {
        get {
            self.toolbarHidden = false
            return CGSizeMake(
                self.view.frame.width,
                self.toolbar.frame.origin.y
            )
        }
    }
    
    /**
    写真撮影時のファインダのframe
    
    - ファインダーの始点Yを計算する
    - 画面領域の中央Yから、ファインダの中央Yを引く
    - ツールバーを除いた画面領域のサイズを取得する
    - UIImagePickerControllerのデフォルトツールバーのframeを利用している
    - ツールバーの始点Yを画面の高さとする
    - 画面の幅と同じ
    */
    var cameraFinderFrame: CGRect {
        get{
            
            // TODO: デフォルトツールバーにはカスタマイズ出来ないので、frameだけ利用している
            // TODO: デフォルトツールバーのframeはhiddenをfalseにしないと求める値が取得できない
            self.toolbarHidden = false
            
            return CGRectMake(
                0,
                (cameraAreaSize.height * 0.5) - (self.view.frame.width * 0.5),
                self.view.frame.width,
                self.view.frame.width)
        }
    }
    
    /**
    画面下部を隠すマスクビューのフレーム
    
    - photoFinderFrameに準じて計算している
    */
    var maskViewFrame: CGRect {
        get{
            return
                CGRectMake(
                    0,
                    cameraFinderFrame.origin.y + cameraFinderFrame.height,
                    cameraFinderFrame.width ,
                    cameraAreaSize.height - (cameraFinderFrame.origin.y + cameraFinderFrame.height)
            )
        }
    }
    

    // MARK: - UIImagePickerController override
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // カメラの設定
        self.sourceType = UIImagePickerControllerSourceType.Camera
        self.cameraCaptureMode = UIImagePickerControllerCameraCaptureMode.Photo
        self.showsCameraControls = false
        self.delegate = self
        
        // ツールバーを追加する
        self.toolBarCustomize()
        
        // ファインダーカスタマイズする
        self.finderCustomize()
        
        println("カメラエリアサイズ：\(cameraAreaSize)")
        println("カメラファインダフレーム：\(cameraFinderFrame)")
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
    
    /**
    ファインダの表示位置を調整して、表示も正方形に加工する
    本アプリでは写真を正方形で加工するので、ファインダーも正方形に加工して画面に表示します
    */
    func finderCustomize() {
        println("finderCustomize実行")
        
        // cameraViewの始点Yを正方形用に変更する
        self.cameraViewTransform = CGAffineTransformMakeTranslation(
            0,
            cameraFinderFrame.origin.y
        )
        
        /// ファインダを正方形にするために、cameraViewの下を黒いViewで隠す
        let maskView = UIView(frame: self.maskViewFrame)
        maskView.backgroundColor = UIColor.blackColor()
        
        self.view.addSubview(maskView)
    }
    
    
    // MARK: Selector

    /*
    写真保存後に実行される
    */
    func didSaveToPhotosApp(image: UIImage!, error: NSErrorPointer, contextInfo: UnsafeMutablePointer<()>) {
        
        println("撮った写真を写真アプリに保存しました。")
    }

}

