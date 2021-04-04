import Foundation

/// Describes tuple type element
@objcMembers public final class TupleElement: NSObject, SourceryModel, Typed {

    /// Tuple element name
    public let name: String?

    /// Tuple element type name
    public var typeName: TypeName

    // sourcery: skipEquality, skipDescription
    /// Tuple element type, if known
    public var type: Type?

    /// :nodoc:
    public init(name: String? = nil, typeName: TypeName, type: Type? = nil) {
        self.name = name
        self.typeName = typeName
        self.type = type
    }

    public var asSource: String {
        // swiftlint:disable:next force_unwrapping
        "\(name != nil ? "\(name!): " : "")\(typeName.asSource)"
    }

// sourcery:inline:TupleElement.AutoCoding

        /// :nodoc:
        required public init?(coder aDecoder: NSCoder) {
            self.name = aDecoder.decode(forKey: "name")
            guard let typeName: TypeName = aDecoder.decode(forKey: "typeName") else { NSException.raise(NSExceptionName.parseErrorException, format: "Key '%@' not found.", arguments: getVaList(["typeName"])); fatalError() }; self.typeName = typeName
            self.type = aDecoder.decode(forKey: "type")
        }

        /// :nodoc:
        public func encode(with aCoder: NSCoder) {
            aCoder.encode(self.name, forKey: "name")
            aCoder.encode(self.typeName, forKey: "typeName")
            aCoder.encode(self.type, forKey: "type")
        }
// sourcery:end

// sourcery:inline:TupleElement.Equality
    /// :nodoc:
    public override func isEqual(_ object: Any?) -> Bool {
        guard let rhs = object as? TupleElement else { return false }
        if self.name != rhs.name { return false }
        if self.typeName != rhs.typeName { return false }
        return true
    }

    // MARK: - TupleElement AutoHashable
    public override var hash: Int {
        var hasher = Hasher()
        hasher.combine(self.name)
        hasher.combine(self.typeName)
        return hasher.finalize()
    }
// sourcery:end

// sourcery:inline:TupleElement.Description
    /// :nodoc:
    override public var description: String {
        var string = "\(Swift.type(of: self)): "
        string += "name = \(String(describing: self.name)), "
        string += "typeName = \(String(describing: self.typeName)), "
        string += "asSource = \(String(describing: self.asSource))"
        return string
    }
// sourcery:end

// sourcery:inline:TupleElement.AutoDiffable
    @objc public func diffAgainst(_ object: Any?) -> DiffableResult {
        let results = DiffableResult()
        guard let castObject = object as? TupleElement else {
            results.append("Incorrect type <expected: TupleElement, received: \(Swift.type(of: object))>")
            return results
        }
        results.append(contentsOf: DiffableResult(identifier: "name").trackDifference(actual: self.name, expected: castObject.name))
        results.append(contentsOf: DiffableResult(identifier: "typeName").trackDifference(actual: self.typeName, expected: castObject.typeName))
        return results
    }
// sourcery:end

}

extension Array where Element == TupleElement {
    public var asSource: String {
        "(\(map { $0.asSource }.joined(separator: ", ")))"
    }

    public var asTypeName: String {
        "(\(map { $0.typeName.asSource }.joined(separator: ", ")))"
    }
}
