import SwiftUI

enum CatalystWeightFromRateDataModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .catalystWeightFromRateData,
            title: "Catalyst Weight from Rate Data",
            subtitle: "Integrate mass-specific rate data for PBR catalyst sizing",
            category: .reactionEngineering,
            symbolName: "scalemass.fill",
            keywords: [
                "catalyst weight",
                "PBR sizing",
                "Levenspiel",
                "Simpson rule",
                "mass-specific reaction rate"
            ]
        ),
        destination: {
            CatalystWeightFromRateDataView()
        }
    )
}
