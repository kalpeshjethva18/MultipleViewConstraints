//
//  secview.swift
//  gallaryControlXIB
//
//  Created by Harshul Shah on 06/03/17.
//  Copyright © 2017 Harshul shah. All rights reserved.
//

import UIKit

class secview: UIViewController, UITableViewDataSource, UITableViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet var viewDirectionConstatn: NSLayoutConstraint!
    
    @IBOutlet var viewDirection: UIView!
    @IBOutlet var viewStarRating: UIView!
    @IBOutlet var lblDirectionText: UILabel!
    @IBOutlet var clsAminiView: NSLayoutConstraint!
    @IBOutlet var clsConstant: NSLayoutConstraint!
    @IBOutlet var clsView: UICollectionView!
    @IBOutlet var msuperConstant: NSLayoutConstraint!
    @IBOutlet var bblogo: UIView!
    @IBOutlet var lblConstatnt: NSLayoutConstraint!
    @IBOutlet var firstViewConstatn: NSLayoutConstraint!
    @IBOutlet var MsuperView: UIView!
    @IBOutlet var tblConstatnheight: NSLayoutConstraint!
    @IBOutlet var tblView: UITableView!
    @IBOutlet var lbl2Text: UILabel!
    @IBOutlet var firstView: UIView!
    @IBOutlet var lblText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        msuperConstant.constant = 5500

        
        lblText.text = "In a storyboard-based application, you will often want to do a little preparation before navigationIn a storyboard-based application, you will often want to do a little preparation before navigationIn a storyboard-based application, you will often want to do a little preparation before navigationIn a storyboard-based application, you will often want to do a little preparation before navigationIn a storyboard-based application, you will often want to do a little preparation before navigationIn a storyboard-based application, you will often want to do a little preparation before navigationIn a storyboard-based application, you will often want to do a little preparation before navigationIn a storyboard-based application, you will often want to do a little preparation before navigationIn a storyboard-based application, you will often want to do a little preparation before navigation 123456"
        lblText.numberOfLines = 3
        lblText.sizeToFit()
        //bblogo.setNeedsUpdateConstraints()
        
        tblView.registerNib(UINib(nibName: "custCell", bundle: nil), forCellReuseIdentifier: "cell")
        clsView.registerNib(UINib(nibName: "imgCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        
        tblConstatnheight.constant = 1500
        tblView.scrollEnabled = false
        //tblView.setNeedsUpdateConstraints()
        
        lbl2Text.text = lblText.text
        lbl2Text.numberOfLines = 0
        lbl2Text.sizeToFit()
        
        
        clsConstant.constant = 200
        clsView.scrollEnabled = false
        clsAminiView.constant = 250
        
        lblDirectionText.text = "" //lblText.text
        lblDirectionText.numberOfLines = 0
        lblDirectionText.sizeToFit()
        
        viewDirectionConstatn.constant = 0 //lbl2Text.frame.size.height/2

        
        print(viewStarRating.frame)
      //  viewDirectionConstatn.constant = 0
       // let ypost = viewStarRating.constraints.
       // print("ypost \(ypost)")
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 15
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath)
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 16
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! custCell
        cell.lblName.text = "auto layout \(indexPath.row)"
        return cell
    }
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 150
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 150
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
