import SwiftUI

enum NumericalInterpolationModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .numericalInterpolation,
            title:
                "Numerical Interpolation",
            subtitle:
                "Linear and Lagrange interpolation",
            category: .numericalMethods,
            symbolName:
                "chart.xyaxis.line",
            keywords: [
                "numerical interpolation",
                "interpolation",
                "linear interpolation",
                "Lagrange",
                "Lagrange polynomial",
                "polynomial",
                "data points",
                "estimate",
                "extrapolation",
                "tabulated data"
            ]
        ),
        destination: {
            NumericalInterpolationView()
        }
    )
}
