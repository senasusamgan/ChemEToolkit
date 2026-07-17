import SwiftUI

enum ModelPredictiveControlModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .modelPredictiveControl,
            title: "Model Predictive Control",
            subtitle: "Optimize a constrained finite-horizon input move",
            category: .processControl,
            symbolName: "square.grid.3x3",
            keywords: [
                "Model Predictive Control",
                "MPC",
                "prediction horizon",
                "input constraints",
                "move suppression"
            ]
        ),
        destination: { ModelPredictiveControlView() }
    )
}
