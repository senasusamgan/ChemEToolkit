import SwiftUI

enum AnnualizedLossExpectancyModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .annualizedLossExpectancy,
            title: "Annualized Loss Expectancy",
            subtitle: "Estimate expected annual retained loss",
            category: .processSafetyAndEconomics,
            symbolName: "exclamationmark.arrow.triangle.2.circlepath",
            keywords: [
                "annualized loss expectancy",
                "expected annual loss",
                "risk cost",
                "insurance recovery",
                "consequence cost"
            ]
        ),
        destination: {
            AnnualizedLossExpectancyView()
        }
    )
}
