#if targetEnvironment(macCatalyst) || os(iOS) || os(tvOS)

import UIKit

enum FrameLength {

    static var standardLength: TimeInterval {
        1 / TimeInterval(UIScreen.main.maximumFramesPerSecond)
    }

}

#elseif os(macOS)

import AppKit

enum FrameLength {

    static var standardLength: TimeInterval {
        if #available(macOS 12.0, *) {
            return /* NSScreen.main?.minimumRefreshInterval ?? */ 1 / 60
        } else {
            let refreshRate = CGDisplayCopyDisplayMode(CGMainDisplayID())?.refreshRate ?? 60
            return refreshRate > 0 ? 1 / refreshRate : 1 / 60
        }
    }

}

#elseif os(watchOS)

enum FrameLength {

    static var standardLength: TimeInterval {
        return 1 / 60
    }

}

#endif

