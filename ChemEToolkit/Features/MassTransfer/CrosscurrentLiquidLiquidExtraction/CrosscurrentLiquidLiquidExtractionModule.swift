import SwiftUI

enum CrosscurrentLiquidLiquidExtractionModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id:
                .crosscurrentLiquidLiquidExtraction,
            title:
                "Crosscurrent Liquid–Liquid Extraction",
            subtitle:
                "Evaluate repeated contacts with equal fresh-solvent portions",
            category: .massTransfer,
            symbolName:
                "square.stack.3d.down.right",
            keywords: [
                "crosscurrent extraction",
                "multiple extraction",
                "fresh solvent",
                "liquid liquid extraction",
                "stagewise extraction",
                "raffinate removal"
            ]
        ),
        destination: {
            CrosscurrentLiquidLiquidExtractionView()
        }
    )
}
