import SwiftUI

enum LiquidLeakRateScreeningModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .liquidLeakRateScreening,
            title: "Liquid Leak Rate Screening",
            subtitle: "Estimate liquid orifice release",
            category: .processSafetyAndEconomics,
            symbolName: "drop.fill",
            keywords: [
                "liquid leak rate",
                "orifice release",
                "inventory release time",
                "Bernoulli leak",
                "process safety"
            ]
        ),
        destination: {
            LiquidLeakRateScreeningView()
        }
    )
}
