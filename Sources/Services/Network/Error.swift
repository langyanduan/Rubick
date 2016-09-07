//
//  Error.swift
//  Connect
//
//  Created by WuFan on 16/9/6.
//  Copyright © 2016年 dacai. All rights reserved.
//

import Foundation

public enum Error: ErrorType {
    case URL
    case Encoding
    case Parser
    
    case Custom(String)
}