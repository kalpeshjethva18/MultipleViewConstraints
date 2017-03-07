//
//  globalFile.swift
//  GallaryControll
//
//  Created by Harshul Shah on 27/12/16.
//  Copyright © 2016 Harshul Shah. All rights reserved.
//

import Foundation
import UIKit
var auto = Bool()
var loop = Bool()
var controls = Bool()
var download = Bool()
var zoom = Bool()
var thumbnails = Bool()
var lblcounter = Bool()
var caption = Bool()
var Pager = Bool()
var pagingArrow = Bool()
var theme = NSString()
var themeColor: UIColor!
var mode = NSString()
var start_index = NSInteger()
var speed = NSInteger()
var duration = Double()
var Isfade = UIViewAnimationOptions.TransitionCrossDissolve

func myfuctninon()
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
}
