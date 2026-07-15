import SwiftUI

enum SingleStageLiquidLiquidExtractionModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id:
                .singleStageLiquidLiquidExtraction,
            title:
                "Single-Stage Liquid–Liquid Extraction",
            subtitle:
                "Solve one equilibrium contact and its solute balance",
            category: .massTransfer,
            symbolName:
                "arrow.triangle.2.circlepath.circle.fill",
            keywords: [
                "single stage extraction",
                "liquid liquid extraction",
                "distribution coefficient",
                "extraction factor",
                "raffinate",
                "extract"
            ]
        ),
        destination: {
            SingleStageLiquidLiquidExtractionView()
        }
    )
}
