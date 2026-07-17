import SwiftUI

enum ClosedSystemFirstLawModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .closedSystemFirstLaw,
            title: "Closed-System First Law",
            subtitle: "Calculate internal-energy change from energy transfers",
            category: .thermodynamics,
            symbolName: "arrow.left.arrow.right.circle.fill",
            keywords: [
                "first law",
                "closed system",
                "internal energy",
                "heat and work",
                "energy balance"
            ]
        ),
        destination: { ClosedSystemFirstLawView() }
    )
}
