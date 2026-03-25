import SwiftUI

@main
struct FocusFlowApp: App {
    let persistenceController = PersistenceController.shared
    
    init() {
        NotificationManager.shared.requestAuthorization()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
