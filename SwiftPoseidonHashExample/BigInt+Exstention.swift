//
//  BigInt+Exstention.swift
//  SwiftPoseidonHashExample
//
//  Created by Hiroshi Chiba on 2024/09/20.
//

import BigInt
import Foundation

public extension BigUInt {
    func toFelt() -> Felt? {
        Felt(self)
    }
}
