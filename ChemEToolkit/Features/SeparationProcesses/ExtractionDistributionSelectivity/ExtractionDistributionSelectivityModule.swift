import SwiftUI

enum ExtractionDistributionSelectivityModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id:
                .extractionDistributionSelectivity,
            title:
                "Extraction Distribution & Selectivity",
            subtitle:
                "Compare target and impurity solvent extraction",
            category: .separationProcesses,
            symbolName:
                "arrow.left.arrow.right.circle.fill",
            keywords: [
                "distribution selectivity",
                "extraction selectivity",
                "distribution coefficient",
                "target impurity",
                "solvent screening"
            ]
        ),
        destination: {
            ExtractionDistributionSelectivityView()
        }
    )
}
