import SwiftUI

enum IdealGasMembraneStageCutModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .idealGasMembraneStageCut,
            title: "Ideal Gas-Membrane Stage Cut",
            subtitle: "Estimate binary permeate and retentate streams",
            category: .separationProcesses,
            symbolName: "rectangle.split.2x1.fill",
            keywords: [
                "gas membrane",
                "stage cut",
                "selectivity",
                "permeate",
                "retentate"
            ]
        ),
        destination: {
            IdealGasMembraneStageCutView()
        }
    )
}
