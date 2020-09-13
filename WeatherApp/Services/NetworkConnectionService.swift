import Foundation
import Network

class NetworkConnectionService {
    private let monitor = NWPathMonitor()
    private var networkStatusUpdated: ((Bool) -> ())?
    private var oldConnectionStatus: NWPath.Status = .requiresConnection
    
    init() {
        monitor.pathUpdateHandler = {
            let connectionStatus = $0.status
            if self.oldConnectionStatus != connectionStatus {
                self.networkStatusUpdated?($0.status == .satisfied)
                self.oldConnectionStatus = connectionStatus
            }
            
        }
        let queue = DispatchQueue(label: String(describing: NWPathMonitor.self))
        monitor.start(queue: queue)
    }
    
    func trackConnection(_ handler: @escaping (Bool) -> ()) {
        networkStatusUpdated = handler
    }
}
