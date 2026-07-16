import SwiftUI

enum CubicRouthHurwitzStabilityModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .cubicRouthHurwitzStability,
            title: "Cubic Routh–Hurwitz Stability",
            subtitle: "Determine cubic stability without solving for roots",
            category: .processControl,
            symbolName: "checkmark.shield",
            keywords: [
                "Routh Hurwitz",
                "stability",
                "characteristic polynomial",
                "right half plane roots",
                "cubic system"
            ]
        ),
        destination: { CubicRouthHurwitzStabilityView() }
    )
}
