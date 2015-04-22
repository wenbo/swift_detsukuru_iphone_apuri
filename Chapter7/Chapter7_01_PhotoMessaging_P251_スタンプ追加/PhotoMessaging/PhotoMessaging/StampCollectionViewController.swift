//
//  StampCollectionViewController.swift
//  PhotoMessaging
//
//  Created by ryo on 11/5/14.
//  Copyright (c) 2014 naoki.izumi. All rights reserved.
//

import UIKit

let reuseIdentifier = "Cell"

class StampCollectionViewController: UICollectionViewController {
    
    // MARK: - IB
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    // MARK: - properties
    
    /// スタンプ画像
    let stampRefs = [
        "stamp_pictures/stamp01.png",
        "stamp_pictures/stamp02.png",
        "stamp_pictures/stamp03.png",
        "stamp_pictures/stamp04.png",
        "stamp_pictures/stamp05.png",
        "stamp_pictures/stamp06.png",
        "stamp_pictures/stamp07.png",
        "stamp_pictures/stamp08.png",
        "stamp_pictures/stamp09.png",
        "stamp_pictures/stamp10.png",
    ]
    
    // MARK: - UICollectionViewController override
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Register cell classes
        self.collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        // Do any additional setup after loading the view.
        
        /// マージンの幅。単位はピクセル
        let outlineMargin: CGFloat = 8
        
        /// 一行当たりの表示させたいセルの数
        let cellRowCount: CGFloat = 3
        
        /// セルのサイズ
        let cellSize = CGSizeMake(
            (self.view.frame.width - (outlineMargin * 2)) / cellRowCount,
            (self.view.frame.width - (outlineMargin * 2)) / cellRowCount
        )
        
        flowLayout.itemSize = cellSize
        flowLayout.minimumInteritemSpacing = outlineMargin
        flowLayout.minimumLineSpacing = outlineMargin
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    // MARK: - UICollectionViewDataSource
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        //#warning Incomplete method implementation -- Return the number of sections
        return 1
    }
    
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //#warning Incomplete method implementation -- Return the number of items in the section
        return 10
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as UICollectionViewCell
        
        // Configure the cell
        
        let fileName = stampRefs[indexPath.row]
        
        let stampView = UIImageView(image: UIImage(named: fileName))
        
        cell.backgroundView = stampView
        
        return cell
    }
}
