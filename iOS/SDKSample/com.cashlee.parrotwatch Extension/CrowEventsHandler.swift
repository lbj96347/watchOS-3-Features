class CrowEventsHandler: CrowEventsDelegate {

    func crownIsRotatingUp() {
        print("up")
    }

    func crownIsRotatingDown() {
        print("down")
    }

    func crownStopped() {
        print("stop")
    }
}
