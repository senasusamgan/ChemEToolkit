import SwiftUI

enum RateConstantTemperatureShiftModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .rateConstantTemperatureShift,
            title: "Rate Constant Temperature Shift",
            subtitle: "Predict a rate constant at a new temperature",
            category: .reactionEngineering,
            symbolName: "arrow.up.right.circle.fill",
            keywords: [
                "temperature shift",
                "Arrhenius ratio",
                "reference rate constant",
                "activation energy",
                "temperature dependence"
            ]
        ),
        destination: {
            RateConstantTemperatureShiftView()
        }
    )
}
