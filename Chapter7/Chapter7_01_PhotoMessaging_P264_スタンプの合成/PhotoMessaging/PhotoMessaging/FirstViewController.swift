//
//  FirstViewController.swift
//  PhotoMessaging
//
//  Created by ryo on 2/17/15.
//  Copyright (c) 2015 naoki.izumi. All rights reserved.
//

import UIKit

class FirstViewController: UIImagePickerController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UICollectionViewDelegate {
    
    
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
    
    /**
    写真の画質
    
    - small
    - medium
    - large
    - original
    */
    enum picQuarityType {
        case small
        case medium
        case large
        case original
        
        func width () -> CGFloat {
            
            switch self{
            case .small:
                return 640
            case .medium:
                return 1024
            case .large:
                return 1536
            case .original:
                return 0
            }
        }
    }
    
    /// 画質設定
    var picQuarity: picQuarityType = picQuarityType.medium
    
    /// UIImagePickerControllerから取得する画像サイズ
    var imageOriginalSize: CGSize = CGSizeMake(0, 0)
    
    /**
    UIIMagePickerからの取得画像と編集後サイズの比率
    */
    var picQuarityRetioForEditedImage: CGFloat {
        get {
            if picQuarity == picQuarityType.original {
                return 1
            } else {
                return picQuarity.width() / imageOriginalSize.width
            }
        }
    }
    
    /// フレーム画像のUIImageViewを継承したカスタムクラス
    let frameImageView = FrameImageView()
    
    /**
    cameraFinderFrameに対する実際の画像の比率
    */
    var picQuarityRetio: CGFloat {
        get {
            if picQuarity == picQuarityType.original {
                return imageOriginalSize.width / cameraFinderFrame.width
            } else {
                return picQuarity.width() / cameraFinderFrame.width
            }
        }
    }
    
    /**
    保存する写真のRect
    
    - 計算元はcameraFinderFrame
    */
    var editedPicRect: CGRect {
        get {
            return CGRectMake(
                0,
                0,
                cameraFinderFrame.width * picQuarityRetio,
                cameraFinderFrame.height * picQuarityRetio
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
        
        // ファインダーをカスタマイズする
        self.finderCustomize()
        
        // フレームのサイズをファインダのサイズと同じに設定する
        self.frameImageView.frame = self.cameraFinderFrame
        
        // フレーム画像をオーバーレイに設定する
        self.cameraOverlayView = self.frameImageView
        
        
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
        
        /// 画像の向きを調整した写真
        var editImage = self.adjustImageRotation(image)
        
        // 画像サイズを保持する
        imageOriginalSize = editImage.size
        
        // 画像サイズを変更する
        editImage = changeSizeImage(editImage)
        
        // 画像を四角形にする
        editImage = makeSqureImage(editImage)
        
        // フレーム画像を合成する
        editImage = makeImageWithFrameimage(editImage)
        
        // スタンプ画像を合成する
        editImage = makeImageWithStampimages(editImage)
        
        // 写真アプリに撮影した写真を保存する
        UIImageWriteToSavedPhotosAlbum(
            editImage,
            self,
            Selector("didSaveToPhotosApp:error:contextInfo:"),
            UnsafeMutablePointer()
        )
    }
    
    // MARK: - local method
    
    /**
    ツールバーを作成
    */
    func toolBarCustomize() {
        
        println("toolBarCustomize実行")
        
        /// シャッターボタンを作成
        let takePhotoButton = UIBarButtonItem(
            barButtonSystemItem: UIBarButtonSystemItem.Camera,
            target: self,
            action: Selector("takePicture"))
        
        
        /// フレーム変更ボタン
        let changeFrameButton = UIBarButtonItem(
            title: "フレーム変更",
            style: UIBarButtonItemStyle.Bordered,
            target: self,
            action: Selector("changeFrame")
        )
        
        
        /// スタンプ追加ボタン
        let openStampSelectViewButton = UIBarButtonItem(
            title: "スタンプ追加",
            style: UIBarButtonItemStyle.Bordered,
            target: self,
            action: Selector("openStampSelectView")
        )
        
        /// ボタンの間にいれるスペーサー
        let spaceButton = UIBarButtonItem(
            barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace,
            target: nil,
            action: nil
        )
        
        
        // ツールバーを作成
        self.toolbarHidden = false
        let bottomBar = UIToolbar(frame: self.toolbar.frame)
        
        // ツールバーの設定
        bottomBar.barStyle = UIBarStyle.Black
        bottomBar.translucent = false
        bottomBar.items = [
            changeFrameButton,
            spaceButton,
            takePhotoButton,
            spaceButton,
            openStampSelectViewButton
        ]
        
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
    
    /**
    画像の向きを調整
    */
    func adjustImageRotation(baseImage: UIImage) -> UIImage {
        
        println("adjustImageRotation実行")
        
        var editImage = baseImage
        
        if  baseImage.imageOrientation != UIImageOrientation.Right {
            
            /// CGImageへ変換
            let cgImage = CGImageCreateWithImageInRect(baseImage.CGImage,
                CGRectMake(0, 0, baseImage.size.width, baseImage.size.height))
            
            /// スケール、向きは元の画像と同じ値を設定して、UIImageに変換する
            editImage = UIImage(
                CGImage: cgImage,
                scale: baseImage.scale,
                orientation: UIImageOrientation.Right
                )!
        }
        
        return editImage
    }
    
    /**
    画像サイズを変更する
    */
    func changeSizeImage(baseImage: UIImage) -> UIImage! {
        println("changeSizeImage実行")
        
        /// 変更後のサイズを計算
        let editedSize = CGSizeMake(
            baseImage.size.width * self.picQuarityRetioForEditedImage,
            baseImage.size.height * self.picQuarityRetioForEditedImage
        )
        
        // 描画領域を保持
        UIGraphicsBeginImageContext(editedSize)
        
        // 描画領域に画像を描く
        baseImage.drawInRect(CGRectMake(0, 0, editedSize.width, editedSize.height))
        
        // 描画領域を書き出す
        let editedSizeImage = UIGraphicsGetImageFromCurrentImageContext()
        
        // 描画領域を破棄
        UIGraphicsEndImageContext()
        
        return editedSizeImage
    }
    
    /**
    画像を正方形にする
    
    :param: baseImage: 編集元の画像
    */
    func makeSqureImage(baseImage: UIImage) -> UIImage {
        println("makeSqureImage実行")
        
        var editImage = baseImage
        
        /// 切り取り枠を設定
        let squreRect = CGRectMake(0, 0, baseImage.size.width, baseImage.size.width)
        
        /// 編集処理実行
        let cgImage = CGImageCreateWithImageInRect(baseImage.CGImage, squreRect)
        
        /// スケール、向きは元の画像と同じ値を設定して、UIImageに変換
        editImage = UIImage(
            CGImage: cgImage,
            scale: baseImage.scale,
            orientation: baseImage.imageOrientation
            )!
        
        //step-1
        return editImage
    }
    
    /**
    フレームを合成する
    
    :params: フレームが合成される前の画像
    :return: フレームが合成された後の画像
    */
    func makeImageWithFrameimage(baseImage: UIImage) -> UIImage! {
        println("makeImageWithFrameimage実行")
        
        var editImage = baseImage
        
        // 描画領域を保持
        UIGraphicsBeginImageContext(baseImage.size)
        
        // 写真画像を割り当てる
        editImage.drawInRect(editedPicRect)
        
        // フレーム画像を割り当てる
        self.frameImageView.image?.drawInRect(
            editedPicRect,
            blendMode: kCGBlendModeNormal,
            alpha: 1
        )
        
        // 描画領域を書き出す
        editImage = UIGraphicsGetImageFromCurrentImageContext()
        
        // 描画領域を破棄
        UIGraphicsEndImageContext()
        
        return editImage
    }
    
    /**
    スタンプを合成する
    
    :params: スタンプが合成される前の画像
    :return: スタンプが合成された後の画像
    */
    func makeImageWithStampimages(baseImage: UIImage) -> UIImage! {
        println("makeImageWithStamp実行")
        var editImage = baseImage
        
        // 描画領域を保持
        UIGraphicsBeginImageContext(baseImage.size)
        
        // 写真画像を割り当てる
        editImage.drawInRect(editedPicRect)
        
        // スタンプを合成する
        for v in self.view.subviews {
            println(v)
            
            if let  stampView = v as? StampImageView {
                
                stampView.image!.drawInRect(
                    CGRectMake(
                        (v.frame.origin.x - self.cameraFinderFrame.origin.x) * picQuarityRetio,
                        (v.frame.origin.y - self.cameraFinderFrame.origin.y) * picQuarityRetio,
                        v.frame.width * picQuarityRetio,
                        v.frame.height * picQuarityRetio
                    ),
                    blendMode: kCGBlendModeNormal,
                    alpha: 1
                )
            }
        }
        
        // 描画領域を書き出す
        editImage = UIGraphicsGetImageFromCurrentImageContext()
        
        // 描画領域を破棄
        UIGraphicsEndImageContext()
        
        return editImage
    }
    
    /// フレームとスタンプを画面から消す（初期化）
    func resetAllStamps() {
        
        // スタンプを消す
        for v in self.view.subviews {
            if let  stampView = v as? StampImageView {
                stampView.removeFromSuperview()
            }
        }
    }
    
    
    // MARK: Selector

    /*
    写真保存後に実行される
    */
    func didSaveToPhotosApp(image: UIImage!, error: NSErrorPointer, contextInfo: UnsafeMutablePointer<()>) {
        
        println("撮った写真を写真アプリに保存しました。")
        
        self.resetAllStamps()
    }
    
    /**
    フレームを変更
    */
    func changeFrame() {
        println("changeFrame実行")
        
        self.frameImageView.changeFrame()
    }
    
    /**
    スタンプ選択画面を表示する
    */
    func openStampSelectView() {
        println("openStampSelectView実行")
        
        /// スタンプ選択画面
        let stampCollectionViewController = StampCollectionViewController(
            nibName: "StampCollectionViewController",
            bundle: nil
        )
        
        stampCollectionViewController.collectionView!.delegate = self
        
        let cWidth: CGFloat = self.view.frame.width
        let cHeight: CGFloat = 50.0
        
        let cX: CGFloat = 0.0
        let cY: CGFloat = self.view.frame.height - cHeight
        
        let cancelButton = UIButton(frame: CGRectMake(cX, cY, cWidth, cHeight))
        cancelButton.setTitle("キャンセル", forState: UIControlState.Normal)
        cancelButton.backgroundColor = UIColor.whiteColor()
        cancelButton.setTitleColor(
            UIColor.blackColor(),
            forState: UIControlState.Normal
        )
        
        let tap = UITapGestureRecognizer(
            target: self,
            action: Selector("cancelStampSelection:")
        )
        
        cancelButton.addGestureRecognizer(tap)
        
        stampCollectionViewController.view.addSubview(cancelButton)
        
        self.presentViewController(
            stampCollectionViewController,
            animated: true,
            completion: nil
        )
    }
    
    
    /// スタンプ選択画面でキャンセルされた時の処理
    func cancelStampSelection(sender: UITapGestureRecognizer) {
        println("cancelStampSelection実行")
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        println("collectionView実行")
        
        let stampCell = collectionView.cellForItemAtIndexPath(indexPath)
        
        let stampView = stampCell?.backgroundView
        
        self.view.addSubview(stampView!)
        
        dismissViewControllerAnimated(true, completion: nil)
    }
}