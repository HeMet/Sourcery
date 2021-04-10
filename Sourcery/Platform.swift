//
// Created by hemet_000 on 10.04.2021.
//

import Foundation

public enum Platform {
    #if os(Windows)
    public static let lineTerminator: Character = "\r\n"
    #else
    public static let lineTerminator: Character = "\n"
    #endif
}

extension String {
    public var withPlatformLineTerminator: String {
        #if os(Windows)
        return replacingOccurrences(of: "\n", with: String(Platform.lineTerminator))
        #else
        return self
        #endif
    }
}