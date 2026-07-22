import SwiftUI

enum NaturalCubicSplineInterpolationModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .naturalCubicSplineInterpolation,
            title: "Natural Cubic Spline Interpolation",
            subtitle: "Smooth piecewise-cubic interpolation with natural boundary conditions.",
            category: .numericalMethods,
            symbolName: "scope",
            keywords: ["numerical methods", "approximation", "natural cubic spline interpolation"]
        ),
        destination: {
            NaturalCubicSplineInterpolationView()
        }
    )
}
