import Foundation

/// Descibes Swift generic type parameter
@objcMembers public final class GenericTypeParameter: NSObject, SourceryModel {

    /// Generic parameter type name
    public var typeName: TypeName

    // sourcery: skipEquality, skipDescription
    /// Generic parameter type, if known
    public var type: Type?

    /// :nodoc:
    public init(typeName: TypeName, type: Type? = nil) {
        self.typeName = typeName
        self.type = type
    }

// sourcery:inline:GenericTypeParameter.AutoCoding

        /// :nodoc:
        required public init?(coder aDecoder: NSCoder) {
            guard let typeName: TypeName = aDecoder.decode(forKey: "typeName") else { NSException.raise(NSExceptionName.parseErrorException, format: "Key '%@' not found.", arguments: getVaList(["typeName"])); fatalError() }; self.typeName = typeName
            self.type = aDecoder.decode(forKey: "type")
        }

        /// :nodoc:
        public func encode(with aCoder: NSCoder) {
            aCoder.encode(self.typeName, forKey: "typeName")
            aCoder.encode(self.type, forKey: "type")
        }

// sourcery:end

// sourcery:inline:GenericTypeParameter.Equality
    /// :nodoc:
    public override func isEqual(_ object: Any?) -> Bool {
        guard let rhs = object as? GenericTypeParameter else { return false }
        if self.typeName != rhs.typeName { return false }
        return true
    }

    // MARK: - GenericTypeParameter AutoHashable
    public override var hash: Int {
        var hasher = Hasher()
        hasher.combine(self.typeName)
        return hasher.finalize()
    }
// sourcery:end

// sourcery:inline:GenericTypeParameter.Description
    /// :nodoc:
    override public var description: String {
        var string = "\(Swift.type(of: self)): "
        string += "typeName = \(String(describing: self.typeName))"
        return string
    }
// sourcery:end

// sourcery:inline:GenericTypeParameter.AutoDiffable
    @objc public func diffAgainst(_ object: Any?) -> DiffableResult {
        let results = DiffableResult()
        guard let castObject = object as? GenericTypeParameter else {
            results.append("Incorrect type <expected: GenericTypeParameter, received: \(Swift.type(of: object))>")
            return results
        }
        results.append(contentsOf: DiffableResult(identifier: "typeName").trackDifference(actual: self.typeName, expected: castObject.typeName))
        return results
    }
// sourcery:end

}
