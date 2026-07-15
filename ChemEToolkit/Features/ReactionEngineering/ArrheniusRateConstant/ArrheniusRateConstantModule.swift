import SwiftUI

enum ArrheniusRateConstantModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .arrheniusRateConstant,
            title: "Arrhenius Rate Constant",
            subtitle: "Calculate k from A, activation energy and temperature",
            category: .reactionEngineering,
            symbolName: "thermometer.medium",
            keywords: [
                "Arrhenius equation",
                "rate constant",
                "activation energy",
                "pre-exponential factor",
                "temperature dependence"
            ]
        ),
        destination: {
            ArrheniusRateConstantView()
        }
    )
}
