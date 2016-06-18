import WatchKit

class CrowDelegate: NSObject, WKCrownDelegate {

    weak var delegate: CrowEventsDelegate?

    var rotating = false

    @available(watchOSApplicationExtension 3.0, *)
    func crownDidRotate(_ crownSequencer: WKCrownSequencer?, rotationalDelta: Double) {

        if rotating {
            return
        }

        rotating = rotationalDelta != 0.0

        if !rotating {
            return
        }

        if rotationalDelta > 0 {
            delegate?.crownIsRotatingUp()
        } else {
            delegate?.crownIsRotatingDown()
        }
    }

    @available(watchOSApplicationExtension 3.0, *)
    func crownDidBecomeIdle(_ crownSequencer: WKCrownSequencer?) {
        rotating = false
        delegate?.crownStopped()
    }
}
