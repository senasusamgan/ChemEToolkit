import SwiftUI

enum InversePowerMethodEigenvalueModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .inversePowerMethodEigenvalue,
            title: "Inverse Power Method",
            subtitle: "Estimate the eigenvalue nearest a shift",
            category: .numericalMethods,
            symbolName: "arrow.down.right.circle.fill",
            keywords: [
                "inverse power method",
                "numerical methods",
                "advanced solver"
            ]
        ),
        destination: {
            InversePowerMethodEigenvalueView()
        }
    )
}
