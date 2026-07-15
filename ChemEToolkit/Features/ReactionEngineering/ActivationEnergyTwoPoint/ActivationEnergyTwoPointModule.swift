import SwiftUI

enum ActivationEnergyTwoPointModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .activationEnergyTwoPoint,
            title: "Activation Energy from Two Temperatures",
            subtitle: "Determine activation energy and A from two rate constants",
            category: .reactionEngineering,
            symbolName: "chart.line.uptrend.xyaxis",
            keywords: [
                "activation energy",
                "two point Arrhenius",
                "rate constants",
                "pre-exponential factor",
                "temperature kinetics"
            ]
        ),
        destination: {
            ActivationEnergyTwoPointView()
        }
    )
}
