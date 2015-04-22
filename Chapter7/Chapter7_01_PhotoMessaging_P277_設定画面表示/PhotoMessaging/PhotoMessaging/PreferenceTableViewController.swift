//
//  PreferenceTableViewController.swift
//  PhotoMessaging
//
//  Created by ryo on 11/7/14.
//  Copyright (c) 2014 naoki.izumi. All rights reserved.
//

import UIKit

class PreferenceTableViewController: UITableViewController, UIActionSheetDelegate {
    
    // MARK: - properties
    
    var selectedCell: UITableViewCell!
    let actionSheetTitle = "画質選択"
    let sectionName = "写真設定"
    let cellText = "画像の画質"
    
    let titles = ["小", "中", "大", "オリジナル", "キャンセル"]
    
    // MARK: - UITableViewController override
    
    override func viewDidLoad() {
        super.viewDidLoad()        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.section == 0 {
            
            if indexPath.row == 0 {
                
                let activityViewController = UIActivityViewController()
                
                /// 画質設定アクションシート
                let actionSheet =  UIActionSheet()
                
                // アクションシート設定
                actionSheet.title = actionSheetTitle
                actionSheet.delegate = self
                
                // ボタン作成
                for title in titles {
                    actionSheet.addButtonWithTitle(title)
                }
                
                // キャンセルボタンは一番最後の要素
                actionSheet.cancelButtonIndex = titles.count - 1
                
                actionSheet.actionSheetStyle = UIActionSheetStyle.Automatic
                
                actionSheet.showInView(self.view)
                
                // セルを取っておく
                selectedCell = tableView.cellForRowAtIndexPath(indexPath)
            }
        }
    }
    
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    // MARK: - UIActionSheetDelegate
    
    /**
    アクションシートボタンタップ時のイベント
    */
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        println("actionSheet実行")
        
        // キャンセルボタン以外の処理
        if buttonIndex != actionSheet.cancelButtonIndex{
            
            selectedCell.detailTextLabel?.text = actionSheet.buttonTitleAtIndex(buttonIndex)

        }
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        switch section {
        case 0:
            return sectionName
        default:
            return ""
        }
    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 1
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CellPictureQuality", forIndexPath: indexPath) as UITableViewCell
        
        // Configure the cell...

        cell.textLabel?.text = cellText

        return cell
    }
}