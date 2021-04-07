import Foundation

/// Describes tuple type element
public final class TupleElement: NSObject, SourceryModel, Typed {

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
    public func diffAgainst(_ object: Any?) -> DiffableResult {
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

// sourcery:inline:TupleElement.Mirror
    //sourcery:skipJSExport
    public var customMirror: Mirror {
        Mirror(self, children: [
            "name": name as Any,
            "typeName": typeName,
            "type": type as Any,
            "asSource": asSource,
            "isOptional": isOptional ? 1 : 0,
            "isImplicitlyUnwrappedOptional": isImplicitlyUnwrappedOptional ? 1 : 0,
            "unwrappedTypeName": unwrappedTypeName,
            "actualTypeName": actualTypeName as Any,
            "isTuple": isTuple ? 1 : 0,
            "isClosure": isClosure ? 1 : 0,
            "isArray": isArray ? 1 : 0,
            "isDictionary": isDictionary ? 1 : 0
        ])
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
