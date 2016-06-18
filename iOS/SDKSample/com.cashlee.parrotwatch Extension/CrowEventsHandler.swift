import WatchConnectivity

class CrowEventsHandler: CrowEventsDelegate {

    var defaultSession:WCSession?

    init() {
        if(WCSession.isSupported()){
            defaultSession = WCSession.default()
            defaultSession?.activate()
        }
    }

    func crownIsRotatingUp() {
        sendMessage("up")
    }

    func crownIsRotatingDown() {
        sendMessage("down")
    }

    func crownStopped() {
        sendMessage("stop")
    }

    func sendMessage(_ message: String) {
        if defaultSession?.isReachable ?? false {
            let sendData: [String:AnyObject] = ["altitude":message]
            defaultSession?.sendMessage(sendData,
                                        replyHandler: nil,
                                        errorHandler: nil)
        }
    }
}
