import UIKit

extension UIScreen {

    var frameLength: TimeInterval {
        1 / TimeInterval(maximumFramesPerSecond)
    }

}
