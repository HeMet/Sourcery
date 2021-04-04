//
//  Created by Sébastien Duperron on 03/01/2018.
//  Copyright © 2018 Pixle. All rights reserved.
//

import Foundation

/// :nodoc:
@objcMembers public final class BytesRange: NSObject, SourceryModel {

    public let offset: Int64
    public let length: Int64

    public init(offset: Int64, length: Int64) {
        self.offset = offset
        self.length = length
    }

    public convenience init(range: (offset: Int64, length: Int64)) {
        self.init(offset: range.offset, length: range.length)
    }

// sourcery:inline:BytesRange.AutoCoding

        /// :nodoc:
        required public init?(coder aDecoder: NSCoder) {
            self.offset = aDecoder.decodeInt64(forKey: "offset")
            self.length = aDecoder.decodeInt64(forKey: "length")
        }

        /// :nodoc:
        public func encode(with aCoder: NSCoder) {
            aCoder.encode(self.offset, forKey: "offset")
            aCoder.encode(self.length, forKey: "length")
        }
// sourcery:end

// sourcery:inline:BytesRange.Equality
    /// :nodoc:
    public override func isEqual(_ object: Any?) -> Bool {
        guard let rhs = object as? BytesRange else { return false }
        if self.offset != rhs.offset { return false }
        if self.length != rhs.length { return false }
        return true
    }

    // MARK: - BytesRange AutoHashable
    public override var hash: Int {
        var hasher = Hasher()
        hasher.combine(self.offset)
        hasher.combine(self.length)
        return hasher.finalize()
    }
// sourcery:end

// sourcery:inline:BytesRange.Description
    /// :nodoc:
    override public var description: String {
        var string = "\(Swift.type(of: self)): "
        string += "offset = \(String(describing: self.offset)), "
        string += "length = \(String(describing: self.length))"
        return string
    }
// sourcery:end
}
