//
//  Result.swift
//  Rubick
//
//  Created by WuFan on 16/9/8.
//
//

import Foundation

public enum Result<Value, E: Error> {
    case success(Value)
    case failure(E)
}
