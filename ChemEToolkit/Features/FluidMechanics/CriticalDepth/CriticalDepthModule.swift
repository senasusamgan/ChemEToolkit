import SwiftUI

enum CriticalDepthModule {

    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .criticalDepth,
            title:
                "Critical Depth & Specific Energy",
            subtitle:
                "Calculate critical depth in a rectangular open channel",
            category:
                .fluidMechanics,
            symbolName:
                "ruler.fill",
            keywords: [
                "critical depth",
                "specific energy",
                "minimum energy",
                "rectangular channel",
                "critical velocity",
                "Froude number",
                "open channel flow",
                "channel depth",
                "fluid mechanics"
            ]
        ),
        destination: {
            CriticalDepthView()
        }
    )
}
