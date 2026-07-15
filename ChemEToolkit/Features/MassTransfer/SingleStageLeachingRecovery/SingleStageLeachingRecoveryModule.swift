import SwiftUI

enum SingleStageLeachingRecoveryModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id:
                .singleStageLeachingRecovery,
            title:
                "Single-Stage Leaching & Recovery",
            subtitle:
                "Calculate ideal extract recovery and underflow solute loss",
            category: .massTransfer,
            symbolName: "cube.fill",
            keywords: [
                "leaching",
                "solid liquid extraction",
                "single stage leaching",
                "underflow retention",
                "solute recovery",
                "overflow extract"
            ]
        ),
        destination: {
            SingleStageLeachingRecoveryView()
        }
    )
}
