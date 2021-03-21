//
//  FolderWatcher.swift
//  Sourcery
//
//  Created by Krzysztof Zabłocki on 24/12/2016.
//  Copyright © 2016 Pixle. All rights reserved.
//

import Foundation

#if !canImport(Darwin)
typealias FSEventStreamEventFlags = Int
let kFSEventStreamEventFlagItemIsDir: Int = 0
let kFSEventStreamEventFlagItemIsFile: Int = 0
let kFSEventStreamEventFlagItemCreated: Int = 0
let kFSEventStreamEventFlagItemModified: Int = 0
let kFSEventStreamEventFlagItemRemoved: Int = 0
let kFSEventStreamEventFlagItemRenamed: Int = 0
let kFSEventStreamEventFlagItemIsHardlink: Int = 0
let kFSEventStreamEventFlagItemIsLastHardlink: Int = 0
let kFSEventStreamEventFlagItemIsSymlink: Int = 0
let kFSEventStreamEventFlagItemChangeOwner: Int = 0
let kFSEventStreamEventFlagItemFinderInfoMod: Int = 0
let kFSEventStreamEventFlagItemInodeMetaMod: Int = 0
let kFSEventStreamEventFlagItemXattrMod: Int = 0
#endif

enum FolderWatcher {

    struct Event {
        let path: String
        let flags: Flag

        struct Flag: OptionSet {
            let rawValue: FSEventStreamEventFlags
            init(rawValue: FSEventStreamEventFlags) {
                self.rawValue = rawValue
            }
            init(_ value: Int) {
                self.rawValue = FSEventStreamEventFlags(value)
            }

            static let isDirectory = Flag(kFSEventStreamEventFlagItemIsDir)
            static let isFile = Flag(kFSEventStreamEventFlagItemIsFile)

            static let created = Flag(kFSEventStreamEventFlagItemCreated)
            static let modified = Flag(kFSEventStreamEventFlagItemModified)
            static let removed = Flag(kFSEventStreamEventFlagItemRemoved)
            static let renamed = Flag(kFSEventStreamEventFlagItemRenamed)

            static let isHardlink = Flag(kFSEventStreamEventFlagItemIsHardlink)
            static let isLastHardlink = Flag(kFSEventStreamEventFlagItemIsLastHardlink)
            static let isSymlink = Flag(kFSEventStreamEventFlagItemIsSymlink)
            static let changeOwner = Flag(kFSEventStreamEventFlagItemChangeOwner)
            static let finderInfoModified = Flag(kFSEventStreamEventFlagItemFinderInfoMod)
            static let inodeMetaModified = Flag(kFSEventStreamEventFlagItemInodeMetaMod)
            static let xattrsModified = Flag(kFSEventStreamEventFlagItemXattrMod)

            var description: String {

                var names: [String] = []
                if self.contains(.isDirectory) { names.append("isDir") }
                if self.contains(.isFile) { names.append("isFile") }

                if self.contains(.created) { names.append("created") }
                if self.contains(.modified) { names.append("modified") }
                if self.contains(.removed) { names.append("removed") }
                if self.contains(.renamed) { names.append("renamed") }

                if self.contains(.isHardlink) { names.append("isHardlink") }
                if self.contains(.isLastHardlink) { names.append("isLastHardlink") }
                if self.contains(.isSymlink) { names.append("isSymlink") }
                if self.contains(.changeOwner) { names.append("changeOwner") }
                if self.contains(.finderInfoModified) { names.append("finderInfoModified") }
                if self.contains(.inodeMetaModified) { names.append("inodeMetaModified") }
                if self.contains(.xattrsModified) { names.append("xattrsModified") }

                return names.joined(separator: ", ")
            }
        }
    }

    class Local {
        #if canImport(Darwin)
        private let path: String
        private var stream: FSEventStreamRef!
        private let closure: (_ events: [Event]) -> Void
        #endif

        /// Creates folder watcher.
        ///
        /// - Parameters:
        ///   - path: Path to observe
        ///   - latency: Latency to use
        ///   - closure: Callback closure
        init(path: String, latency: TimeInterval = 1/60, closure: @escaping (_ events: [Event]) -> Void) {
            #if canImport(Darwin)
            self.path = path
            self.closure = closure

            func handler(_ stream: ConstFSEventStreamRef, clientCallbackInfo: UnsafeMutableRawPointer?, numEvents: Int, eventPaths: UnsafeMutableRawPointer, eventFlags: UnsafePointer<FSEventStreamEventFlags>, eventIDs: UnsafePointer<FSEventStreamEventId>) {
                let eventStream = unsafeBitCast(clientCallbackInfo, to: Local.self)
                let paths = unsafeBitCast(eventPaths, to: NSArray.self)

                let events = (0..<numEvents).compactMap { idx in
                    return (paths[idx] as? String).flatMap { Event(path: $0, flags: Event.Flag(rawValue: eventFlags[idx])) }
                }

                eventStream.closure(events)
            }

            var context = FSEventStreamContext()
            context.info = unsafeBitCast(self, to: UnsafeMutableRawPointer.self)
            let flags = UInt32(kFSEventStreamCreateFlagUseCFTypes | kFSEventStreamCreateFlagFileEvents)

            stream = FSEventStreamCreate(nil, handler, &context, [path] as CFArray, FSEventStreamEventId(kFSEventStreamEventIdSinceNow), latency, flags)

            FSEventStreamScheduleWithRunLoop(stream, CFRunLoopGetCurrent(), CFRunLoopMode.defaultMode.rawValue)
            FSEventStreamStart(stream)
            #else
            fatalError("File watching supported on Darwin only")
            #endif
        }

        deinit {
            #if canImport(Darwin)
            FSEventStreamStop(stream)
            FSEventStreamInvalidate(stream)
            FSEventStreamRelease(stream)
            #else
            fatalError("File watching supported on Darwin only")
            #endif
        }
    }
}
