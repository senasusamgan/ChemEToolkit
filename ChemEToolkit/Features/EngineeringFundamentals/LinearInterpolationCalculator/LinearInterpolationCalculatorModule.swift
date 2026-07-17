import SwiftUI

enum LinearInterpolationCalculatorModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .linearInterpolationCalculator,
            title: "Linear Interpolation",
            subtitle: "Estimate a value between two points",
            category: .engineeringFundamentals,
            symbolName: "point.topleft.down.to.point.bottomright.curvepath",
            keywords: [
                "linear interpolation",
                "extrapolation",
                "property table",
                "slope",
                "engineering estimate"
            ]
        ),
        destination: {
            LinearInterpolationCalculatorView()
        }
    )
}
