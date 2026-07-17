import SwiftUI

enum CostIndexEscalationModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .costIndexEscalation,
            title: "Cost Index Escalation",
            subtitle: "Update historical cost with an index ratio",
            category: .processSafetyAndEconomics,
            symbolName: "calendar",
            keywords: [
                "cost index escalation",
                "CEPCI",
                "historical cost",
                "capital cost index",
                "cost update"
            ]
        ),
        destination: {
            CostIndexEscalationView()
        }
    )
}
