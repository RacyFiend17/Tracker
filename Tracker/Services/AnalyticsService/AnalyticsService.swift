import Foundation
import AppMetricaCore

final class AnalyticsService {
    
    static let shared = AnalyticsService()
    
    private init() {}
    
    func activate() {
        if let configuration = AppMetricaConfiguration(apiKey: "1fe5c8f6-95ad-4cb5-9783-e1aecd39f445") {
            AppMetrica.activate(with: configuration)
        }
    }
    
    func sendEvent(event: String, screen: String, item: String? = nil) {
        var parameters: [String: Any] = [
            "event": event,
            "screen": screen
        ]
        
        if let item {
            parameters["item"] = item
        }
        
        AppMetrica.reportEvent(name: "event", parameters: parameters) { error in
            print("Error reporting event: \(error.localizedDescription)")
        }
        
        print("Analytics event: \(parameters)")
    }
}
