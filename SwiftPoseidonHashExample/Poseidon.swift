//
//  Poseidon.swift
//  SwiftPoseidonHashExample
//
//  Created by Hiroshi Chiba on 2024/09/20.
//

import Foundation
import BigInt
import SwiftyPoseidon

public class Poseidon {
    
    public class func poseidonHash(_ value: Felt) -> Felt {
        var state = [
            splitBigUInt(value.value),
            (0, 0, 0, 0),
            (1, 0, 0, 0),
        ]
        
        permutation_3(&state)
        
        return combineToBigUInt(state[0]).toFelt()!
    }
    
    
    /// Convert a BigUInt into a tuple of four 64-bit chunks.
    ///
    /// - Parameters:
    ///    - value: BigUInt to convert.
    /// - Returns: Tuple of 64-bit chunks.
    private static func splitBigUInt(_ value: BigUInt) -> (UInt64, UInt64, UInt64, UInt64) {
        var result: [UInt64] = [0, 0, 0, 0]

        // if the input is zero, return the array of zeros
        if value != BigUInt(0) {
            // mask has all bits set to 1 except the least significant one
            let mask = BigUInt(2).power(64) - 1

            // loop through the 64-bit chunks of the BigUInt, shift them and store in the result array
            for i in 0 ..< 4 {
                result[i] = UInt64(value >> (i * 64) & mask)
            }
        }

        return (result[0], result[1], result[2], result[3])
    }
    
    /// Combine a tuple of 64-bit chunks into a single BigUInt.
    ///
    /// - Parameters:
    ///    - values: Tuple of four 64-bit chunks.
    /// - Returns: BigUInt.
    private static func combineToBigUInt(_ values: (UInt64, UInt64, UInt64, UInt64)) -> BigUInt {
        let arr: [UInt64] = [values.0, values.1, values.2, values.3]
        let powersOfTwo = [0, 64, 128, 192].map { BigUInt(2).power($0) }

        // w * 2**0 + x * 2**64 + y * 2**128 + z * 2**192
        var result = BigUInt(0)
        for (b, p) in zip(arr, powersOfTwo) {
            result += BigUInt(b) * p
        }
        return result
    }
}
