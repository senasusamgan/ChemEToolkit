import SwiftUI

enum ConversionYieldSelectivityModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .conversionYieldSelectivity,
            title: "Conversion, Yield & Selectivity",
            subtitle: "Calculate reactant conversion, product yield and selectivity",
            category: .reactionEngineering,
            symbolName: "target",
            keywords: [
                "conversion",
                "yield",
                "selectivity",
                "desired product",
                "reaction performance",
                "stoichiometric accounting"
            ]
        ),
        destination: {
            ConversionYieldSelectivityView()
        }
    )
}
