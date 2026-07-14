import SwiftUI

enum CurveFittingModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .curveFitting,
            title:
                "Curve Fitting & Regression",
            subtitle:
                "Linear and polynomial least-squares regression",
            category: .numericalMethods,
            symbolName:
                "chart.line.uptrend.xyaxis",
            keywords: [
                "curve fitting",
                "regression",
                "linear regression",
                "polynomial regression",
                "least squares",
                "R squared",
                "RMSE",
                "experimental data",
                "prediction",
                "extrapolation"
            ]
        ),
        destination: {
            CurveFittingView()
        }
    )
}
