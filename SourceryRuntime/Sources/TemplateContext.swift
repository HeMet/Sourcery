//
// Created by Krzysztof Zablocki on 31/12/2016.
// Copyright (c) 2016 Pixle. All rights reserved.
//

import Foundation

/// :nodoc:
// sourcery: skipCoding
@objcMembers public final class TemplateContext: NSObject, SourceryModel, NSCoding {
    // sourcery: skipJSExport
    public let parserResult: FileParserResult?
    public let functions: [SourceryMethod]
    public let types: Types
    public let argument: [String: NSObject]

    // sourcery: skipDescription
    public var type: [String: Type] {
        return types.typesByName
    }

    public init(parserResult: FileParserResult?, types: Types, functions: [SourceryMethod], arguments: [String: NSObject]) {
        self.parserResult = parserResult
        self.types = types
        self.functions = functions
        self.argument = arguments
    }

    /// :nodoc:
    required public init?(coder aDecoder: NSCoder) {
        guard let parserResult: FileParserResult = aDecoder.decode(forKey: "parserResult") else { NSException.raise(NSExceptionName.parseErrorException, format: "Key '%@' not found. FileParserResults are required for template context that needs persisting.", arguments: getVaList(["parserResult"])); fatalError() }
        guard let argument: [String: NSObject] = aDecoder.decode(forKey: "argument") else { NSException.raise(NSExceptionName.parseErrorException, format: "Key '%@' not found.", arguments: getVaList(["argument"])); fatalError() }

        // if we want to support multiple cycles of encode / decode we need deep copy because composer changes reference types
        let fileParserResultCopy: FileParserResult? = nil
//      fileParserResultCopy = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(NSKeyedArchiver.archivedData(withRootObject: parserResult)) as? FileParserResult

        let composed = Composer.uniqueTypesAndFunctions(parserResult)
        self.types = .init(types: composed.types, typealiases: composed.typealiases)
        self.functions = composed.functions

        self.parserResult = fileParserResultCopy
        self.argument = argument
    }

    /// :nodoc:
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.parserResult, forKey: "parserResult")
        aCoder.encode(self.argument, forKey: "argument")
    }

    public var stencilContext: [String: Any] {
        return [
            "types": types,
            "functions": functions,
            "type": types.typesByName,
            "argument": argument
        ]
    }

    // sourcery: skipDescription, skipEquality
    public var jsContext: [String: Any] {
        return [
            "types": [
                "all": types.all,
                "protocols": types.protocols,
                "classes": types.classes,
                "structs": types.structs,
                "enums": types.enums,
                "extensions": types.extensions,
                "based": types.based,
                "inheriting": types.inheriting,
                "implementing": types.implementing
            ],
            "functions": functions,
            "type": types.typesByName,
            "argument": argument
        ]
    }

    // sourcery:inline:TemplateContext.Equality
        /// :nodoc:
        public override func isEqual(_ object: Any?) -> Bool {
            guard let rhs = object as? TemplateContext else { return false }
            if self.parserResult != rhs.parserResult { return false }
            if self.functions != rhs.functions { return false }
            if self.types != rhs.types { return false }
            if self.argument != rhs.argument { return false }
            return true
        }

        // MARK: - TemplateContext AutoHashable
        public override var hash: Int {
            var hasher = Hasher()
            hasher.combine(self.parserResult)
            hasher.combine(self.functions)
            hasher.combine(self.types)
            hasher.combine(self.argument)
            return hasher.finalize()
        }
    // sourcery:end

    // sourcery:inline:TemplateContext.Description
        /// :nodoc:
        override public var description: String {
            var string = "\(Swift.type(of: self)): "
            string += "parserResult = \(String(describing: self.parserResult)), "
            string += "functions = \(String(describing: self.functions)), "
            string += "types = \(String(describing: self.types)), "
            string += "argument = \(String(describing: self.argument)), "
            string += "stencilContext = \(String(describing: self.stencilContext))"
            return string
        }
    // sourcery:end

    // sourcery:inline:TemplateContext.AutoDiffable
        public func diffAgainst(_ object: Any?) -> DiffableResult {
            let results = DiffableResult()
            guard let castObject = object as? TemplateContext else {
                results.append("Incorrect type <expected: TemplateContext, received: \(Swift.type(of: object))>")
                return results
            }
            results.append(contentsOf: DiffableResult(identifier: "parserResult").trackDifference(actual: self.parserResult, expected: castObject.parserResult))
            results.append(contentsOf: DiffableResult(identifier: "functions").trackDifference(actual: self.functions, expected: castObject.functions))
            results.append(contentsOf: DiffableResult(identifier: "types").trackDifference(actual: self.types, expected: castObject.types))
            results.append(contentsOf: DiffableResult(identifier: "argument").trackDifference(actual: self.argument, expected: castObject.argument))
            return results
        }
    // sourcery:end

}

extension ProcessInfo {
    /// :nodoc:
    public var context: TemplateContext! {
        return NSKeyedUnarchiver.unarchiveObject(withFile: arguments[1]) as? TemplateContext
    }
}

/// :nodoc:
@objcMembers public class TypesCollection: NSObject, AutoJSExport {

    // sourcery:begin: skipJSExport
    let all: [Type]
    let types: [String: [Type]]
    let validate: ((Type) throws -> Void)?
    // sourcery:end

    init(types: [Type], collection: (Type) -> [String], validate: ((Type) throws -> Void)? = nil) {
        self.all = types
        var content = [String: [Type]]()
        self.all.forEach { type in
            collection(type).forEach { name in
                var list = content[name] ?? [Type]()
                list.append(type)
                content[name] = list
            }
        }
        self.types = content
        self.validate = validate
    }

    public func types(forKey key: String) throws -> [Type] {
        // In some configurations, the types are keyed by "ModuleName.TypeName"
        var longKey: String?

        if let validate = validate {
            guard let type = all.first(where: { $0.name == key }) else {
                throw "Unknown type \(key), should be used with `based`"
            }

            try validate(type)

            if let module = type.module {
                longKey = [module, type.name].joined(separator: ".")
            }
        }

        // If we find the types directly, return them
        if let types = types[key] {
            return types
        }

        // if we find a types for the longKey, return them
        if let longKey = longKey, let types = types[longKey] {
            return types
        }

        return []
    }

    /// :nodoc:
    public override func value(forKey key: String) -> Any? {
        do {
            return try types(forKey: key)
        } catch {
            Log.error(error)
            return nil
        }
    }

    /// :nodoc:
    public subscript(_ key: String) -> [Type] {
        do {
            return try types(forKey: key)
        } catch {
            Log.error(error)
            return []
        }
    }

    public override func responds(to aSelector: Selector!) -> Bool {
        return true
    }
}
