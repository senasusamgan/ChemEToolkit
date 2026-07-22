import SwiftUI

enum GaussLegendreQuadratureModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .gaussLegendreQuadrature,
            title: "Gauss–Legendre Quadrature",
            subtitle: "High-order fixed-node integration on a finite interval.",
            category: .numericalMethods,
            symbolName: "scope",
            keywords: ["numerical methods", "approximation", "gauss–legendre quadrature"]
        ),
        destination: {
            GaussLegendreQuadratureView()
        }
    )
}
