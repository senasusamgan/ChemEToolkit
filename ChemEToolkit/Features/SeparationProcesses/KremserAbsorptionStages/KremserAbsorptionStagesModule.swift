import SwiftUI

enum KremserAbsorptionStagesModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .kremserAbsorptionStages,
            title: "Kremser Absorption Stages",
            subtitle: "Estimate ideal absorber stages",
            category: .separationProcesses,
            symbolName: "square.stack.3d.down.right.fill",
            keywords: [
                "Kremser absorption",
                "absorber stages",
                "solute removal",
                "absorption factor",
                "stage estimate"
            ]
        ),
        destination: {
            KremserAbsorptionStagesView()
        }
    )
}
