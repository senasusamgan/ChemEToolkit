import SwiftUI

enum InterphaseEquilibriumDrivingForcesModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id:
                .interphaseEquilibriumDrivingForces,
            title:
                "Interphase Equilibrium & Driving Forces",
            subtitle:
                "Calculate interface equilibrium and signed phase driving forces",
            category: .massTransfer,
            symbolName:
                "arrow.left.arrow.right.circle.fill",
            keywords: [
                "interphase equilibrium",
                "henry law",
                "equilibrium line",
                "driving force",
                "absorption",
                "stripping"
            ]
        ),
        destination: {
            InterphaseEquilibriumDrivingForcesView()
        }
    )
}
