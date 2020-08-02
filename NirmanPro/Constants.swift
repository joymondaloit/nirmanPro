//
//  Constants.swift
//  NirmanPro
//
//  Created by Joy Mondal on 12/07/20.
//  Copyright © 2020 Joy Mondal. All rights reserved.
//

import Foundation
import UIKit

let AUTHORIZATION = "Authorization"
let CONTENT_TYPE = "Content-Type"
let APPLICATION_JSON = "application/json"
let APPLICATION_ENCODED = "application/x-www-form-urlencoded"
let STATUS = "status"
let MESSAGE = "message"
let DATA = "data"
var GoToVCNotificationKey = "VCNotification"
var USERID_KEY = "userId"
var USERNAME_KEY = "userName"
var PROFILEIMAGE_KEY = "profileImage"
//APPDELEGATE instance global
let appDelegate = UIApplication.shared.delegate as! AppDelegate
var Devise_size = UIScreen.main.bounds.size
var LIVE_BASE_URL = ""
var DEV_BASE_URL = "https://quality-web-programming.com/projects/f4/NirmanPro/index.php?route=appapi/"
var IMAGE_BASE_URL = ""
var PlaceHolderImg = "smallImgPlaceholder"
//Storyboard Reference
let STORYBOARD = UIStoryboard.init(name: "Main", bundle: nil)
