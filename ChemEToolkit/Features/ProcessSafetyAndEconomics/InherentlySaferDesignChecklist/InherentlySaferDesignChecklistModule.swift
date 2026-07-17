import SwiftUI

enum InherentlySaferDesignChecklistModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .inherentlySaferDesignChecklist,
            title: "Inherently Safer Design",
            subtitle: "Screen four hazard-reduction principles",
            category: .processSafetyAndEconomics,
            symbolName: "shield.lefthalf.filled",
            keywords: [
                "inherently safer design",
                "minimize",
                "substitute",
                "moderate",
                "simplify"
            ]
        ),
        destination: {
            InherentlySaferDesignChecklistView()
        }
    )
}
