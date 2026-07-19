import SwiftUI

enum LevenbergMarquardtRegressionModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .levenbergMarquardtRegression,
            title: "Levenberg–Marquardt Regression",
            subtitle: "Fit nonlinear two-parameter engineering models with adaptive damping.",
            category: .numericalMethods,
            symbolName: "scope",
            keywords: ["numerical methods", "solver", "levenberg–marquardt regression"]
        ),
        destination: {
            LevenbergMarquardtRegressionView()
        }
    )
}
