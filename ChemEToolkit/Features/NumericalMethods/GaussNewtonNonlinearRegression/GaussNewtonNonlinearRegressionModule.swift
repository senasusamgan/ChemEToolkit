import SwiftUI

enum GaussNewtonNonlinearRegressionModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .gaussNewtonNonlinearRegression,
            title: "Gauss–Newton Nonlinear Regression",
            subtitle: "Fit y = a·exp(bx) to three observations",
            category: .numericalMethods,
            symbolName: "chart.xyaxis.line",
            keywords: [
                "gauss–newton nonlinear regression",
                "numerical methods",
                "advanced solver"
            ]
        ),
        destination: {
            GaussNewtonNonlinearRegressionView()
        }
    )
}
