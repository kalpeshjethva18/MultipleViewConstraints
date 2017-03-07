//
//  ViewController.swift
//  GallaryControll
//
//  Created by Harshul Shah on 20/12/16.
//  Copyright © 2016 Harshul Shah. All rights reserved.
//

import UIKit
import AssetsLibrary

class ViewController: UIViewController, UIScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var pageControll: UIPageControl!
    @IBOutlet weak var lblCaption: UILabel!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var lblPageIndex: UILabel!
    @IBOutlet weak var actView: UIView!
    @IBOutlet weak var actLoader: UIActivityIndicatorView!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var btnDownload: UIButton!
    @IBOutlet weak var btnSlide: UIButton!
    @IBOutlet weak var btnzoomIN: UIButton!
    @IBOutlet weak var btnZoomOut: UIButton!
    @IBOutlet weak var btnGallary: UIButton!
    @IBOutlet weak var scrollBottom: UIScrollView!
    @IBOutlet weak var clsView: UICollectionView!
    @IBOutlet weak var scrollTop:UIScrollView!
    @IBOutlet weak var imgFullSize:UIImageView!
    
    var counter = NSInteger()
    var Swipecounter = NSInteger()
    var highlighCounter = NSInteger()
    var timer = NSTimer()
    var reverseCounter = NSInteger()
    var totalImages = NSInteger()
    var isStop = Bool()
    
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var btnPrev: UIButton!
    
    //MARK: class and other methods
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        clsView.registerNib(UINib(nibName: "imgCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        
        
        let library = ALAssetsLibrary()
        library.enumerateGroupsWithTypes(ALAssetsGroupType(ALAssetsGroupSavedPhotos),
                                         usingBlock: {(group : ALAssetsGroup!, stop : UnsafeMutablePointer<ObjCBool>) in
                                            if group != nil
                                            {
                                                print("success")
                                            }
            }, failureBlock: { (error:NSError?) in
                //lapApp.logger.addLog("Problem loading albums: \(error)") })
                let alert = UIAlertView(title: "", message: "Please give permisson from the setting to this app for photo", delegate: self, cancelButtonTitle: "ok")
                alert.show()
        })
        
        lblCaption.layer.cornerRadius = 15
        lblCaption.layer.masksToBounds = true
        
        
        //Set controll which want do not want
        getControlls()
        //Set button images from fontawesome
        setButtonsTitle()
        
        //Set image zoom tap gestures
        setTopScroll()
    }
    func getControlls()
    {
        auto = true
        loop = true
        controls = true
        thumbnails = true
        lblcounter = true
        caption = true
        Pager = true
        pagingArrow = true
        zoom = true
        download = true
        speed = 2
        //Dark / light
        theme = "Dark"
        themeColor = UIColor(red:8/255.0, green:200/255.0,blue:189/255.0, alpha:1);
        mode = ""
        start_index = 1
        duration = 0.5

        //Dark / light
      /*  if theme == "Dark"
        {
            self.topView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
            scrollTop.backgroundColor = UIColor.blackColor()
            scrollBottom.backgroundColor = UIColor(red: 20.0/255.0, green: 20.0/255.0, blue: 20.0/255.0, alpha: 1)
            clsView.backgroundColor = UIColor(red: 20.0/255.0, green: 20.0/255.0, blue: 20.0/255.0, alpha: 1)
            self.view.backgroundColor = UIColor.blackColor()
        }
        else
        {
            topView.backgroundColor = UIColor.whiteColor()
            topView.opaque = true
            topView.layer.opacity = 50
            
            scrollBottom.backgroundColor = UIColor.whiteColor()
            clsView.backgroundColor = UIColor.whiteColor()
            scrollTop.backgroundColor = UIColor.whiteColor()
            self.view.backgroundColor = UIColor.whiteColor()
        }
        if controls == false
        {
            topView.hidden = true
            scrollBottom.hidden = true
            btnGallary.hidden = true
        }
        if thumbnails == false
        {
            scrollBottom.hidden = true
            btnGallary.hidden = true
        }
        if lblcounter == false
        {
            lblPageIndex.hidden = true
        }
        if Pager == false
        {
            pageControll.hidden = true
        }
        if pagingArrow == false
        {
            btnNext.hidden = true
            btnPrev.hidden = true
        }
        if zoom == false
        {
            btnzoomIN.hidden = true
            btnZoomOut.hidden = true
        }
        if download == false
        {
            btnDownload.hidden = true
            btnzoomIN.frame.origin.x = UIScreen.mainScreen().bounds.size.width - 180
            btnZoomOut.frame.origin.x = UIScreen.mainScreen().bounds.size.width - 140
            btnSlide.frame.origin.x = UIScreen.mainScreen().bounds.size.width - 100
        }
        if caption == true
        {
            lblCaption.hidden = false
        }
        else
        {
            lblCaption.hidden = true
        }
        */
        
    }
    @IBAction func btnPopView(sender: UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    func setTopScroll()
    {
        actLoader.startAnimating()
        actView.hidden = true
        actView.layer.cornerRadius = 10
        actView.layer.masksToBounds = true
        
        
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(self.handleDoubleTap))
        doubleTap.numberOfTapsRequired = 2
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .Horizontal
        self.clsView.pagingEnabled = true
        self.clsView.collectionViewLayout = layout
        
        lblPageIndex.text = "\(Swipecounter)/16"
        scrollTop.minimumZoomScale = 1.0
        scrollTop.maximumZoomScale = 10.0
        imgFullSize.image = UIImage(named: "k\(Swipecounter).jpeg")
        
        lblCaption.text = "k\(Swipecounter)"
        let customRect = self.calculateRectOfImageInImageView(self.imgFullSize)
        btnNext.frame.origin.y = (customRect.height - 22)/2 + customRect.origin.y
        btnPrev.frame.origin.y = (customRect.height - 22)/2 + customRect.origin.y
        
        scrollTop.delegate = self
        scrollTop.alwaysBounceHorizontal = false
        scrollTop.alwaysBounceVertical = false
        scrollTop.showsVerticalScrollIndicator = true
        scrollTop.flashScrollIndicators()
        imgFullSize.layer.cornerRadius = 11.0
        imgFullSize.clipsToBounds = false
        scrollTop.addSubview(imgFullSize)
        scrollTop.addGestureRecognizer(doubleTap)
        
        let single = UITapGestureRecognizer(target: self, action: #selector(self.singletap(_:)))
        single.numberOfTapsRequired = 1
        scrollTop.addGestureRecognizer(single)
        single.requireGestureRecognizerToFail(doubleTap)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture(_:)))
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        self.scrollTop.addGestureRecognizer(swipeRight)
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture(_:)))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
        self.scrollTop.addGestureRecognizer(swipeLeft)
        self.scrollTop.addSubview(actView)
        
        
        let width = 19 * 54
        clsView.scrollEnabled = false
        clsView.frame = CGRectMake(10, 10, CGFloat(width), 62)
        scrollBottom.contentSize = CGSizeMake(CGFloat(width), 80.0)
        if auto == true
        {
            setButtonColor(3)
            timer = NSTimer.scheduledTimerWithTimeInterval(Double(speed), target: self, selector:  #selector(ViewController.methodToBeCalled), userInfo: nil, repeats: true)
            self.scrollBottom.frame.origin.y = 1000
            self.btnGallary.frame.origin.y = UIScreen.mainScreen().bounds.size.height - 28
            btnSlide.setTitle("\u{f28c}", forState: UIControlState.Normal)
        }
    }
    func setButtonColor(number:NSInteger)
    {
        //Button color set
        switch number
        {
        case 1:
            btnzoomIN.setTitleColor(themeColor, forState: UIControlState.Normal)
        case 2:
            btnZoomOut.setTitleColor(themeColor, forState: UIControlState.Normal)
        case 3:
            btnSlide.setTitleColor(themeColor, forState: UIControlState.Normal)
        case 4:
            btnDownload.setTitleColor(themeColor, forState: UIControlState.Normal)
        case 5:
            btnClose.setTitleColor(themeColor, forState: UIControlState.Normal)
        default:
            print("number 2");
        }
    }
    func setButtonsTitle()
    {
        isStop = false
        reverseCounter = 0
        totalImages = 16
        counter = -1
        Swipecounter = 1
        pageControll.numberOfPages = 16
        pageControll.currentPage = 0
        
        
        if start_index > 1 && start_index < 15
        {
            Swipecounter = start_index
            pageControll.currentPage = Swipecounter-1
        }
        highlighCounter = Swipecounter
        
        if Swipecounter > 3
        {
            let xpos = 54 * Swipecounter
            scrollBottom.setContentOffset(CGPoint(x: xpos - 100, y: 0), animated: true)
        }
        else
        {
            scrollBottom.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            
        }
        
        btnGallary.setTitle("\u{f009}", forState: UIControlState.Normal)
        btnzoomIN.setTitle("\u{F00e}", forState: UIControlState.Normal)
        btnZoomOut.setTitle("\u{F010}", forState: UIControlState.Normal)
        btnSlide.setTitle("\u{f01d}", forState: UIControlState.Normal)
        btnDownload.setTitle("\u{F019}", forState: UIControlState.Normal)
        btnClose.setTitle("\u{f2d4}", forState: UIControlState.Normal)
        btnPrev.setTitle("\u{f053}", forState: UIControlState.Normal)
        btnNext.setTitle("\u{f054}", forState: UIControlState.Normal)
        
        btnNext.setTitleColor(themeColor, forState: UIControlState.Normal)
        btnPrev.setTitleColor(themeColor, forState: UIControlState.Normal)
        
        btnNext.layer.cornerRadius = 23.5
        btnNext.layer.masksToBounds = true
        btnPrev.layer.cornerRadius = 23.5
        btnPrev.layer.masksToBounds = true
        btnGallary.backgroundColor = UIColor(red: 20.0/255.0, green: 20.0/255.0, blue: 20.0/255.0, alpha: 1)
        btnGallary.layer.cornerRadius = 2
        btnGallary.layer.masksToBounds = true
    }
    func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo:UnsafePointer<Void>) {
        //Image download or not validation
        actView.hidden = true
        btnDownload.setTitleColor(UIColor(red: 184.0/255.0, green: 184.0/255.0, blue: 184.0/255.0, alpha: 1), forState: UIControlState.Normal)
        if error == nil {
            let alert = UIAlertView(title: "", message: "Your altered image has been saved to your photos.", delegate: self, cancelButtonTitle: "ok")
            alert.show()
        } else {
            let alert = UIAlertView(title: "", message: "Error", delegate: self, cancelButtonTitle: "ok")
            alert.show()
        }
    }
    func calculateRectOfImageInImageView(imageView: UIImageView) -> CGRect {
        //After applying aspact fit mode to image get the image virtual size
        let imageViewSize = imageView.frame.size
        let imgSize = imageView.image?.size
        
        guard let imageSize = imgSize where imgSize != nil else {
            return CGRectZero
        }
        let scaleWidth = imageViewSize.width / imageSize.width
        let scaleHeight = imageViewSize.height / imageSize.height
        let aspect = fmin(scaleWidth, scaleHeight)
        
        var imageRect = CGRect(x: 0, y: 0, width: imageSize.width * aspect, height: imageSize.height * aspect)
        imageRect.origin.x = (imageViewSize.width - imageRect.size.width) / 2
        imageRect.origin.y = (imageViewSize.height - imageRect.size.height) / 2
        
        imageRect.origin.x += imageView.frame.origin.x
        imageRect.origin.y += imageView.frame.origin.y
        return imageRect
    }
    func methodToBeCalled(){
        //Auto called method to next the image load
        if isStop == false
        {
            //        NSThread.detachNewThreadSelector(#selector(AnimatedThreadStarting), toTarget: self, withObject: nil)
            counter  = -20
            scrollTop.zoomScale = 1.0
            if Swipecounter > 15
            {
                
                if Swipecounter > 15 && loop == false
                {
                    return
                }
                else
                {
                    Swipecounter = 1
                }
            }
            else
            {
                Swipecounter += 1
            }
            highlighCounter = Swipecounter
            let xpos = 54 * Swipecounter
            scrollBottom.setContentOffset(CGPoint(x: xpos-100, y: 0), animated: true)
            let customRect = self.calculateRectOfImageInImageView(self.imgFullSize)
            btnNext.frame.origin.y = (customRect.height - 22)/2 + customRect.origin.y
            btnPrev.frame.origin.y = (customRect.height - 22)/2 + customRect.origin.y
            UIView.transitionWithView(self.imgFullSize, duration: duration, options: Isfade, animations: {
                self.imgFullSize.image = UIImage(named: "k\(self.Swipecounter).jpeg")
                
                self.actView.hidden = true
                }, completion: nil)
            
            lblCaption.text = "k\(Swipecounter)"
            
            lblPageIndex.text = "\(Swipecounter)/\(totalImages)"
            pageControll.currentPage = Swipecounter - 1
            clsView.reloadData()
            actView.hidden = true
        }
        actView.hidden = true
    }
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        //For image zoom in zoom out
        return self.imgFullSize
    }
    //MARK: Actions
    @IBAction func zoomInAction(sender: UIButton) {
        btnZoomOut.setTitleColor(UIColor(red: 184.0/255.0, green: 184.0/255.0, blue: 184.0/255.0, alpha: 1), forState: UIControlState.Normal)
        btnzoomIN.setTitleColor(themeColor, forState: UIControlState.Normal)
        scrollTop.zoomScale = 5.0
    }
    func textToImage(drawText: NSString, inImage: UIImage, atPoint: CGPoint) -> UIImage{
        
        // Setup the font specific variables
        let textColor = UIColor.whiteColor()
        let textFont = UIFont(name: "Helvetica Bold", size: 12)!
        // Setup the image context using the passed image
        let scale = UIScreen.mainScreen().scale
        UIGraphicsBeginImageContextWithOptions(inImage.size, false, scale)
        // Setup the font attributes that will be later used to dictate how the text should be drawn
        let textFontAttributes = [
            NSFontAttributeName: textFont,
            NSForegroundColorAttributeName: textColor,
            ]
        // Put the image into a rectangle as large as the original image
        inImage.drawInRect(CGRectMake(0, 0, inImage.size.width, inImage.size.height))
        // Create a point within the space that is as bit as the image
        let rect = CGRectMake(atPoint.x, atPoint.y, inImage.size.width, inImage.size.height)
        // Draw the text into an image
        drawText.drawInRect(rect, withAttributes: textFontAttributes)
        // Create a new image out of the images we have created
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        // End the context now that we have the image we need
        UIGraphicsEndImageContext()
        //Pass the image back up to the caller
        return newImage
    }
    @IBAction func btnCloseAction(sender: UIButton) {
        //Stop animation slide
        actView.hidden = true
        btnSlide.setTitleColor(UIColor(red: 184.0/255.0, green: 184.0/255.0, blue: 184.0/255.0, alpha: 1), forState: UIControlState.Normal)
        btnSlide.setTitle("\u{f01d}", forState: UIControlState.Normal)
        isStop = true
        timer.fire()
        timer.invalidate()
        UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.scrollBottom.frame.origin.y = UIScreen.mainScreen().bounds.size.height - 80
            self.btnGallary.frame.origin.y = self.scrollBottom.frame.origin.y - 28
            }, completion: nil)
    }
    @IBAction func zoomOut(sender: UIButton)
    {
        //Zoom out of image and stay as it is image
        btnZoomOut.setTitleColor(UIColor(red: 184.0/255.0, green: 184.0/255.0, blue: 184.0/255.0, alpha: 1), forState: UIControlState.Normal)
        btnzoomIN.setTitleColor(UIColor(red: 184.0/255.0, green: 184.0/255.0, blue: 184.0/255.0, alpha: 1), forState: UIControlState.Normal)
        scrollTop.zoomScale = 1.0
    }
    @IBAction func SlideAction(sender: UIButton)
    {
        //Play pause slide images
        if btnSlide.titleLabel?.text == "\u{f01d}"
        {
            btnSlide.setTitle("\u{f28c}", forState: UIControlState.Normal)
            isStop = false
            btnZoomOut.setTitleColor(UIColor(red: 184.0/255.0, green: 184.0/255.0, blue: 184.0/255.0, alpha: 1), forState: UIControlState.Normal)
            btnzoomIN.setTitleColor(UIColor(red: 184.0/255.0, green: 184.0/255.0, blue: 184.0/255.0, alpha: 1), forState: UIControlState.Normal)
            self.setButtonColor(3)
            timer = NSTimer.scheduledTimerWithTimeInterval(Double(speed), target: self, selector:  #selector(ViewController.methodToBeCalled), userInfo: nil, repeats: true)
            UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                self.scrollBottom.frame.origin.y = 1000
                self.btnGallary.frame.origin.y = UIScreen.mainScreen().bounds.size.height - 28
                }, completion: nil)
        }
        else
        {
            btnSlide.setTitle("\u{f01d}", forState: UIControlState.Normal)
            btnSlide.setTitleColor(UIColor(red: 184.0/255.0, green: 184.0/255.0, blue: 184.0/255.0, alpha: 1), forState: UIControlState.Normal)
            btnSlide.setTitle("\u{f01d}", forState: UIControlState.Normal)
            isStop = true
            timer.fire()
            timer.invalidate()
            UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                self.scrollBottom.frame.origin.y = UIScreen.mainScreen().bounds.size.height - 80
                self.btnGallary.frame.origin.y = self.scrollBottom.frame.origin.y - 28
                }, completion: nil)
        }
    }
    @IBAction func btnhideGallary(sender: UIButton) {
        //show hide bottom image gallay
        if scrollBottom.frame.origin.y == 1000
        {
            UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                self.scrollBottom.frame.origin.y = UIScreen.mainScreen().bounds.size.height - 80
                self.btnGallary.frame.origin.y = self.scrollBottom.frame.origin.y - 28
                }, completion: nil)
            
        }else
        {
            UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                self.scrollBottom.frame.origin.y = 1000
                self.btnGallary.frame.origin.y = UIScreen.mainScreen().bounds.size.height - 28
                }, completion: nil)
        }
    }
    func AnimatedThreadStarting()
    {
        actView.hidden = false
    }
    @IBAction func btnNextAction(sender: UIButton) {
        
        //Next image load set scroll and reload tableview
        //        NSThread.detachNewThreadSelector(#selector(AnimatedThreadStarting), toTarget: self, withObject: nil)
        counter  = -20
        scrollTop.zoomScale = 1.0
        reverseCounter = 0
        if Swipecounter > 15
        {
            if Swipecounter > 15 && loop == false
            {
                return
            }
            else
            {
                Swipecounter = 1
                reverseCounter = 1
            }
        }
        else
        {
            Swipecounter += 1
        }
        highlighCounter = Swipecounter
        print("swipe left \(Swipecounter)")
        let xpos = 54 * Swipecounter
        
        if Swipecounter == 1
        {
            scrollBottom.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        }
        else
        {
            scrollBottom.setContentOffset(CGPoint(x: xpos-100, y: 0), animated: true)
        }
        lblPageIndex.text = "\(Swipecounter)/\(totalImages)"
        
        
        
        UIView.transitionWithView(self.imgFullSize, duration: duration, options: Isfade, animations: {
            self.imgFullSize.image = UIImage(named: "k\(self.Swipecounter).jpeg")
            self.actView.hidden = true
            
            }, completion: nil)
        lblCaption.text = "k\(Swipecounter)"
        
        let customRect = self.calculateRectOfImageInImageView(self.imgFullSize)
        btnNext.frame.origin.y = (customRect.height - 22)/2 + customRect.origin.y
        btnPrev.frame.origin.y = (customRect.height - 22)/2 + customRect.origin.y
        pageControll.currentPage = Swipecounter - 1
        clsView.reloadData()
        actView.hidden = true
    }
    @IBAction func btnBackAction(sender: UIButton) {
        
        //Previous image load and set scroll and reload tableview
        //        NSThread.detachNewThreadSelector(#selector(AnimatedThreadStarting), toTarget: self, withObject: nil)
        scrollTop.zoomScale = 1.0
        counter  = -20
        if Swipecounter >= 2
        {
            Swipecounter -= 1
        }
        highlighCounter = Swipecounter
        
        if Swipecounter == 1 && loop == false && reverseCounter == 1
        {
            return
        }
        if Swipecounter == 1 && reverseCounter == 0 || reverseCounter >= totalImages
        {
            reverseCounter = 1
        }
        else if reverseCounter > 0
        {
            if reverseCounter == 1 //||  reverseCounter == 2
            {
                Swipecounter = totalImages
            }
            else
            {
                Swipecounter = totalImages - reverseCounter + 1
            }
            highlighCounter = Swipecounter
            reverseCounter += 1
        }
        else
        {
            reverseCounter = 0
        }
        let xpos = 54 * Swipecounter
        
        if Swipecounter == 1
        {
            scrollBottom.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        }
        else
        {
            scrollBottom.setContentOffset(CGPoint(x: xpos-100, y: 0), animated: true)
        }
        UIView.transitionWithView(self.imgFullSize, duration: duration, options: Isfade, animations: {
            self.imgFullSize.image = UIImage(named: "k\(self.Swipecounter).jpeg")
            }, completion: nil)
        lblCaption.text = "k\(Swipecounter)"
        
        let customRect = self.calculateRectOfImageInImageView(self.imgFullSize)
        btnNext.frame.origin.y = (customRect.height - 22)/2 + customRect.origin.y
        btnPrev.frame.origin.y = (customRect.height - 22)/2 + customRect.origin.y
        
        lblPageIndex.text = "\(Swipecounter)/\(totalImages)"
        
        pageControll.currentPage = Swipecounter - 1
        
        
        
        /*
         self.imgFullSize.alpha = 0.5
         let shortDelay = dispatch_time(DISPATCH_TIME_NOW, Int64(1_000))
         dispatch_after(shortDelay, dispatch_get_main_queue()) {
         UIView.animateWithDuration(1.0) {
         self.imgFullSize.alpha = 1.0
         }
         }*/
        clsView.reloadData()
        actView.hidden = true
    }
    @IBAction func btnDownloadAction(sender: UIButton) {
        
        //Image download to gallary
        NSThread.detachNewThreadSelector(#selector(AnimatedThreadStarting), toTarget: self, withObject: nil)
        setButtonColor(4)
        UIImageWriteToSavedPhotosAlbum(self.imgFullSize.image!, self, #selector(ViewController.image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    //MARK: Gesture event
    func singletap(gestureRecognizer: UIGestureRecognizer) {
        
        //Tap on scroll and hide controll and show controll
        if controls == true && thumbnails == true
        {
            if scrollBottom.frame.origin.y == 1000
            {
                UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                    self.scrollBottom.frame.origin.y = UIScreen.mainScreen().bounds.size.height - 80
                    self.btnGallary.frame.origin.y = self.scrollBottom.frame.origin.y - 28
                    }, completion: nil)
            }
            else
            {
                UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                    self.scrollBottom.frame.origin.y = 1000
                    self.btnGallary.frame.origin.y = UIScreen.mainScreen().bounds.size.height - 28
                    }, completion: nil)
            }
            
        }
    }
    func handleDoubleTap(gestureRecognizer: UIGestureRecognizer) {
        //Hanlde double tap gesture for image zoom and zoom out
        if scrollTop.zoomScale > 1.0
        {
            scrollTop.zoomScale = 1.0
        }
        else
        {
            scrollTop.zoomScale = 5.0
        }
    }
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        
        //Identify gestru and load image right left swipe gesture set scroll and reload tableview
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.Right:
                
                scrollTop.zoomScale = 1.0
                counter  = -20
                if Swipecounter >= 2
                {
                    Swipecounter -= 1
                }
                highlighCounter = Swipecounter
                
                if Swipecounter == 1 && loop == false && reverseCounter == 1
                {
                    return
                }
                
                print("swipe right \(Swipecounter)")
                
                if Swipecounter == 1 && reverseCounter == 0 || reverseCounter >= totalImages
                {
                    
                    reverseCounter = 1
                    scrollBottom.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
                    UIView.transitionWithView(self.imgFullSize, duration: duration, options: Isfade, animations: {
                        self.imgFullSize.image = UIImage(named: "k\(self.Swipecounter).jpeg")
                        }, completion: nil)
                    
                    lblCaption.text = "k\(Swipecounter)"
                    
                }
                else if reverseCounter > 0
                {
                    
                    if reverseCounter == 1 //||  reverseCounter == 2
                    {
                        Swipecounter = totalImages
                    }
                    else
                    {
                        Swipecounter = totalImages - reverseCounter + 1
                    }
                    highlighCounter = Swipecounter
                    
                    reverseCounter += 1
                    
                    let xpos = 54 * Swipecounter
                    scrollBottom.setContentOffset(CGPoint(x: xpos-100, y: 0), animated: true)
                    UIView.transitionWithView(self.imgFullSize, duration: duration, options: Isfade, animations: {
                        self.imgFullSize.image = UIImage(named: "k\(self.Swipecounter).jpeg")
                        }, completion: nil)
                    lblCaption.text = "k\(Swipecounter)"
                    
                }
                else
                {
                    reverseCounter = 0
                    let xpos = 54 * Swipecounter
                    scrollBottom.setContentOffset(CGPoint(x: xpos-100, y: 0), animated: true)
                    UIView.transitionWithView(self.imgFullSize, duration: duration, options: Isfade, animations: {
                        self.imgFullSize.image = UIImage(named: "k\(self.Swipecounter).jpeg")
                        }, completion: nil)
                    lblCaption.text = "k\(Swipecounter)"
                    
                }
                lblPageIndex.text = "\(Swipecounter)/\(totalImages)"
                let customRect = self.calculateRectOfImageInImageView(self.imgFullSize)
                btnNext.frame.origin.y = (customRect.height - 22)/2 + customRect.origin.y
                btnPrev.frame.origin.y = (customRect.height - 22)/2 + customRect.origin.y
                pageControll.currentPage = Swipecounter - 1
                clsView.reloadData()
                actView.hidden = true
                
            case UISwipeGestureRecognizerDirection.Left:
                
                //        NSThread.detachNewThreadSelector(#selector(AnimatedThreadStarting), toTarget: self, withObject: nil)
                
                reverseCounter = 0
                
                
                if Swipecounter > 15
                {
                    if Swipecounter > 15 && loop == false
                    {
                        return
                    }
                    else
                    {
                        Swipecounter = 1
                        reverseCounter = 1
                    }
                }
                else
                {
                    Swipecounter += 1
                }
                counter  = -20
                scrollTop.zoomScale = 1.0
                highlighCounter = Swipecounter
                print("swipe left \(Swipecounter)")
                
                let xpos = 54 * Swipecounter
                
                if Swipecounter == 1
                {
                    scrollBottom.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
                    
                }
                else
                {
                    scrollBottom.setContentOffset(CGPoint(x: xpos-100, y: 0), animated: true)
                    
                }
                lblPageIndex.text = "\(Swipecounter)/\(totalImages)"
                
                //  self.imgFullSize.image = UIImage(named: "k\(Swipecounter).jpeg")
                let customRect = self.calculateRectOfImageInImageView(self.imgFullSize)
                btnNext.frame.origin.y = (customRect.height - 22)/2 + customRect.origin.y
                btnPrev.frame.origin.y = (customRect.height - 22)/2 + customRect.origin.y
                
                
                UIView.transitionWithView(self.imgFullSize, duration: duration, options: Isfade, animations: {
                    self.imgFullSize.image = UIImage(named: "k\(self.Swipecounter).jpeg")
                    }, completion: nil)
                
                lblCaption.text = "k\(Swipecounter)"
                
                pageControll.currentPage = Swipecounter - 1
                
                
                clsView.reloadData()
                actView.hidden = true
                
                
            default:
                break
            }
        }
    }
    //MARK: collectionView Delegate method
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 16
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell : imgCell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! imgCell
        
        if counter == indexPath.row || highlighCounter-1 == indexPath.row
        {
            cell.contentView.backgroundColor = themeColor
        }
        else
        {
            cell.contentView.backgroundColor = UIColor.clearColor()
        }
        cell.imgView.layer.cornerRadius = 5
        cell.imgView.layer.masksToBounds = true
        cell.contentView.layer.cornerRadius = 5
        cell.contentView.layer.masksToBounds = true
        
        cell.imgView.image = UIImage(named: "k\(indexPath.row+1).jpeg")
        return cell
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        if indexPath.row == 0
        {
            reverseCounter = 1
        }
        else
        {
            reverseCounter = 0
        }
        counter = indexPath.row
        Swipecounter = indexPath.row+1
        lblPageIndex.text = "\(Swipecounter)/\(totalImages)"
        highlighCounter = -2
        scrollTop.zoomScale = 1.0
        let xpos = 54 * indexPath.row + 1
        scrollBottom.setContentOffset(CGPoint(x: xpos, y: 0), animated: true)
        
        
        UIView.transitionWithView(self.imgFullSize, duration: duration, options: Isfade, animations: {
            self.imgFullSize.image = UIImage(named: "k\(self.Swipecounter).jpeg")
            }, completion: nil)
        lblCaption.text = "k\(Swipecounter)"
        
        let customRect = self.calculateRectOfImageInImageView(self.imgFullSize)
        btnNext.frame.origin.y = (customRect.height - 22)/2 + customRect.origin.y
        btnPrev.frame.origin.y = (customRect.height - 22)/2 + customRect.origin.y
        pageControll.currentPage = Swipecounter - 1
        clsView.reloadData()
    }
    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(52, 52)
    }
    func collectionView(collectionView: UICollectionView, didHighlightItemAtIndexPath indexPath: NSIndexPath) {
    }
    func collectionView(collectionView: UICollectionView, didUnhighlightItemAtIndexPath indexPath: NSIndexPath) {
        let cell = clsView.cellForItemAtIndexPath(indexPath)
        cell?.contentView.backgroundColor = nil
    }
    func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}