import Foundation
import Maestro_ObjC

// TODO: implement unit Béziers manually and drop the Objective-C
extension CAMediaTimingFunction {

    func value(at t: Double) -> Double {
        Double(_solve(forInput: Float(t)))
    }

}
