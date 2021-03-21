import Foundation

#if os(Windows)
class NSException {
    class func raise(_ name: NSExceptionName, format: String, arguments: CVaListPointer?) {        
        // do nothing
        // withVaList(args: [CVarArg], body: (CVaListPointer) -> R)
    }
}

func getVaList(_ args: [CVarArg]) -> CVaListPointer? {
    nil
}

extension NSExceptionName {
    static let parseErrorException: NSExceptionName = NSExceptionName("parseErrorException")
}

func CFAbsoluteTimeGetCurrent() -> TimeInterval {
    Date().timeIntervalSinceReferenceDate
}
#endif