import SwiftUI

enum CountercurrentLiquidLiquidExtractionModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id:
                .countercurrentLiquidLiquidExtraction,
            title:
                "Countercurrent Liquid–Liquid Extraction",
            subtitle:
                "Estimate ideal stages and achieved raffinate composition",
            category: .massTransfer,
            symbolName:
                "arrow.up.arrow.down.circle.fill",
            keywords: [
                "countercurrent extraction",
                "extraction factor",
                "ideal stages",
                "kremser extraction",
                "raffinate target",
                "solvent outlet"
            ]
        ),
        destination: {
            CountercurrentLiquidLiquidExtractionView()
        }
    )
}
