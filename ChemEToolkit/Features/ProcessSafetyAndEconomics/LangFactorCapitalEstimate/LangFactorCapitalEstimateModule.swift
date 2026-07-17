import SwiftUI

enum LangFactorCapitalEstimateModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .langFactorCapitalEstimate,
            title: "Lang-Factor Capital Estimate",
            subtitle: "Estimate capital from equipment cost",
            category: .processSafetyAndEconomics,
            symbolName: "building.2.fill",
            keywords: [
                "Lang factor",
                "fixed capital investment",
                "purchased equipment cost",
                "working capital",
                "total capital investment"
            ]
        ),
        destination: {
            LangFactorCapitalEstimateView()
        }
    )
}
