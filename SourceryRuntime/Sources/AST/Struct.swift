//
//  Struct.swift
//  Sourcery
//
//  Created by Krzysztof Zablocki on 13/09/2016.
//  Copyright © 2016 Pixle. All rights reserved.
//

import Foundation

// sourcery: skipDescription
/// Describes Swift struct
@objcMembers public final class Struct: Type {

    /// Returns "struct"
    public override var kind: String { return "struct" }

    /// :nodoc:
    public override init(name: String = "",
                         parent: Type? = nil,
                         accessLevel: AccessLevel = .internal,
                         isExtension: Bool = false,
                         variables: [Variable] = [],
                         methods: [Method] = [],
                         subscripts: [Subscript] = [],
                         inheritedTypes: [String] = [],
                         containedTypes: [Type] = [],
                         typealiases: [Typealias] = [],
                         attributes: AttributeList = [:],
                         modifiers: [SourceryModifier] = [],
                         annotations: [String: NSObject] = [:],
                         isGeneric: Bool = false) {
        super.init(
            name: name,
            parent: parent,
            accessLevel: accessLevel,
            isExtension: isExtension,
            variables: variables,
            methods: methods,
            subscripts: subscripts,
            inheritedTypes: inheritedTypes,
            containedTypes: containedTypes,
            typealiases: typealiases,
            attributes: attributes,
            modifiers: modifiers,
            annotations: annotations,
            isGeneric: isGeneric
        )
    }

// sourcery:inline:Struct.AutoCoding

        /// :nodoc:
        required public init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }

        /// :nodoc:
        override public func encode(with aCoder: NSCoder) {
            super.encode(with: aCoder)
        }
// sourcery:end

// sourcery:inline:Struct.Equality
    /// :nodoc:
    public override func isEqual(_ object: Any?) -> Bool {
        guard let rhs = object as? Struct else { return false }
        return super.isEqual(rhs)
    }

    // MARK: - Struct AutoHashable
    public override var hash: Int {
        var hasher = Hasher()
        hasher.combine(super.hash)
        return hasher.finalize()
    }
// sourcery:end

// sourcery:inline:Struct.Description
    /// :nodoc:
    override public var description: String {
        var string = super.description
        string += ", "
        string += "kind = \(String(describing: self.kind))"
        return string
    }
// sourcery:end

}
