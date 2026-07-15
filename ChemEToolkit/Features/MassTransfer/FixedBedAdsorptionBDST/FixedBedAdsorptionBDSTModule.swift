import SwiftUI

enum FixedBedAdsorptionBDSTModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .fixedBedAdsorptionBDST,
            title:
                "Fixed-Bed Adsorption BDST",
            subtitle:
                "Estimate minimum bed depth and service time to breakthrough",
            category: .massTransfer,
            symbolName:
                "chart.line.uptrend.xyaxis",
            keywords: [
                "BDST",
                "bed depth service time",
                "fixed bed adsorption",
                "breakthrough time",
                "minimum bed depth",
                "adsorption column"
            ]
        ),
        destination: {
            FixedBedAdsorptionBDSTView()
        }
    )
}
