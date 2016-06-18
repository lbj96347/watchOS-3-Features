import WatchKit

class CrowDelegate: NSObject, WKCrownDelegate {

    @available(watchOSApplicationExtension 3.0, *)
    func crownDidRotate(_ crownSequencer: WKCrownSequencer?, rotationalDelta: Double) {
        print("crownDidRotate")
        print("rotationalDelta: \(rotationalDelta)")
    }

    @available(watchOSApplicationExtension 3.0, *)
    func crownDidBecomeIdle(_ crownSequencer: WKCrownSequencer?) {
        print("crownDidBecomeIdle")
    }
}
