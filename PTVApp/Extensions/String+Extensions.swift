//
//  String+Extensions.swift
//  PTVApp
//
//  Created by Chirag Chaplot on 8/8/21.
//

import Foundation
import CommonCrypto

extension String {
    func hmac(key: String) -> String {
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA1_DIGEST_LENGTH))
        CCHmac(CCHmacAlgorithm(kCCHmacAlgSHA1), key, key.count, self, self.count, &digest)
        let data = Data(digest)
        return data.map { String(format: "%02x", $0) }.joined()
    }
}
