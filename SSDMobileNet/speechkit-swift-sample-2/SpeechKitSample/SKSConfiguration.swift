//
//  SKSConfiguration.swift
//  SpeechKitSample
//
//  All Nuance Developers configuration parameters can be set here.
//
//  Copyright (c) 2015 Nuance Communications. All rights reserved.
//

import Foundation

// All fields are required.
// Your credentials can be found in your Nuance Developers portal, under "Manage My Apps".

var SKSAppKey = "!APPKEY!"
var SKSAppId = "!APPID!"
var SKSServerHost = "!HOST!"
var SKSServerPort = "!PORT!"

var SKSServerUrl = String(format: "nmsps://%@@%@:%@", SKSAppId, SKSServerHost, SKSServerPort)

var SKSLanguage = "!LANGUAGE!"
let LANGUAGE = SKSLanguage == "!LANGUAGE!" ? "eng-USA" : SKSLanguage

// Only needed if using Mix.nlu
var SKSNLUContextTag = "!NLU_CONTEXT_TAG!"

