import Foundation

/// Descibes Swift generic type
@objcMembers public final class GenericType: NSObject, SourceryModelWithoutDescription {
    /// The name of the base type, i.e. `Array` for `Array<Int>`
    public var name: String

    /// This generic type parameters
    public let typeParameters: [GenericTypeParameter]

    /// :nodoc:
    public init(name: String, typeParameters: [GenericTypeParameter] = []) {
        self.name = name
        self.typeParameters = typeParameters
    }

    public var asSource: String {
        let arguments = typeParameters
          .map({ $0.typeName.asSource })
          .joined(separator: ", ")
        return "\(name)<\(arguments)>"
    }

    public override var description: String {
        asSource
    }

// sourcery:inline:GenericType.AutoCoding

        /// :nodoc:
        required public init?(coder aDecoder: NSCoder) {
            guard let name: String = aDecoder.decode(forKey: "name") else { NSException.raise(NSExceptionName.parseErrorException, format: "Key '%@' not found.", arguments: getVaList(["name"])); fatalError() }; self.name = name
            guard let typeParameters: [GenericTypeParameter] = aDecoder.decode(forKey: "typeParameters") else { NSException.raise(NSExceptionName.parseErrorException, format: "Key '%@' not found.", arguments: getVaList(["typeParameters"])); fatalError() }; self.typeParameters = typeParameters
        }

        /// :nodoc:
        public func encode(with aCoder: NSCoder) {
            aCoder.encode(self.name, forKey: "name")
            aCoder.encode(self.typeParameters, forKey: "typeParameters")
        }

// sourcery:end

// sourcery:inline:GenericType.Equality
    /// :nodoc:
    public override func isEqual(_ object: Any?) -> Bool {
        guard let rhs = object as? GenericType else { return false }
        if self.name != rhs.name { return false }
        if self.typeParameters != rhs.typeParameters { return false }
        return true
    }

    // MARK: - GenericType AutoHashable
    public override var hash: Int {
        var hasher = Hasher()
        hasher.combine(self.name)
        hasher.combine(self.typeParameters)
        return hasher.finalize()
    }
// sourcery:end

}

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

}
