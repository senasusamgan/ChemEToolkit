import SwiftUI

enum GasLeakRateScreeningModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .gasLeakRateScreening,
            title: "Gas Leak Rate Screening",
            subtitle: "Estimate ideal-gas orifice release",
            category: .processSafetyAndEconomics,
            symbolName: "cloud.fog.fill",
            keywords: [
                "gas leak rate",
                "choked release",
                "orifice leak",
                "mass flux",
                "process safety"
            ]
        ),
        destination: {
            GasLeakRateScreeningView()
        }
    )
}
