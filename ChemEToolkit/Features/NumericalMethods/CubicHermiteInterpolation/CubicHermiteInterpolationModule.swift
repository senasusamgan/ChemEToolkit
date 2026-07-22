import SwiftUI

enum CubicHermiteInterpolationModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .cubicHermiteInterpolation,
            title: "Cubic Hermite Interpolation",
            subtitle: "Interpolate between two points while preserving endpoint slopes.",
            category: .numericalMethods,
            symbolName: "scope",
            keywords: ["numerical methods", "approximation", "cubic hermite interpolation"]
        ),
        destination: {
            CubicHermiteInterpolationView()
        }
    )
}
