import SwiftUI

enum DistributionCoefficientSelectivityModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id:
                .distributionCoefficientSelectivity,
            title:
                "Distribution Coefficient & Selectivity",
            subtitle:
                "Evaluate phase preference and liquid–liquid solvent selectivity",
            category: .massTransfer,
            symbolName: "scale.3d",
            keywords: [
                "distribution coefficient",
                "partition coefficient",
                "selectivity",
                "separation factor",
                "liquid liquid extraction",
                "solvent selection"
            ]
        ),
        destination: {
            DistributionCoefficientSelectivityView()
        }
    )
}
