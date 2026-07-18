import SwiftUI

enum SingleStageLeachingBalanceModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .singleStageLeachingBalance,
            title: "Single-Stage Leaching Balance",
            subtitle: "Estimate solute extraction from an insoluble solid",
            category: .separationProcesses,
            symbolName: "cube.transparent.fill",
            keywords: [
                "leaching",
                "solid liquid extraction",
                "solution retention",
                "distribution coefficient",
                "solute recovery"
            ]
        ),
        destination: {
            SingleStageLeachingBalanceView()
        }
    )
}
