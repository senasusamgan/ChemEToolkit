import SwiftUI

enum MinorLossModule {

    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .minorLosses,
            title: "Minor Losses",
            subtitle:
                "Calculate fitting, valve and local pressure losses",
            category: .fluidMechanics,
            symbolName:
                "arrow.down.right.circle.fill",
            keywords: [
                "minor losses",
                "loss coefficient",
                "K factor",
                "fitting loss",
                "valve loss",
                "entrance loss",
                "exit loss",
                "head loss",
                "pressure loss",
                "fluid mechanics"
            ]
        ),
        destination: {
            MinorLossView()
        }
    )
}
