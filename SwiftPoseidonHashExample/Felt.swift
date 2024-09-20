//
//  Felt.swift
//  SwiftPoseidonHashExample
//
//  Created by Hiroshi Chiba on 2024/09/20.
//

import BigInt
import Foundation

public struct Felt {
    public let value: BigUInt

    public static let prime = BigUInt(2).power(251) + 17 * BigUInt(2).power(192) + 1

    public static let zero = Felt(0)
    public static let one = Felt(1)

    public static let min = Felt.zero
    public static let max = Felt(Felt.prime - 1)!

    public init?(_ exactly: some BinaryInteger) {
        let value = BigUInt(exactly: exactly)

        guard let value, value < Felt.prime else {
            return nil
        }

        self.value = value
    }

    public init(clamping: some BinaryInteger) {
        let value = BigUInt(clamping: clamping)

        self.value = value < Felt.prime ? value : Felt.prime - 1
    }

    /// Initializes a new Felt instance from a signed integer.
    ///
    /// Calculated as `fromSigned mod Felt.prime`.
    ///
    /// - Parameter fromSigned: The signed integer to convert to Felt. The integer must be greater than `-Felt.prime` and less than `Felt.prime`.
    public init?(fromSigned exactly: some BinaryInteger) {
        let value = BigInt(exactly: exactly)

        guard let value, abs(value) < Felt.prime else {
            return nil
        }

        self.value = BigUInt(value.modulus(BigInt(Felt.prime)))
    }

    public init?(fromHex hex: String) {
        guard hex.hasPrefix("0x") else { return nil }

        if let value = BigUInt(hex.dropFirst(2), radix: 16) {
            self.init(value)
        } else {
            return nil
        }
    }
}

public extension Felt {
    func toUInt256() -> [Felt] {
        let (high, low) = self.value.quotientAndRemainder(dividingBy: BigUInt(2).power(128))

        return [Felt(low)!, Felt(high)!]
    }
}
