//
//  Result.swift
//  Rubick
//
//  Created by WuFan on 16/9/8.
//
//

import Foundation

public enum Result<Value, Error: ErrorType> {
    case Success(Value)
    case Failure(Error)
}
