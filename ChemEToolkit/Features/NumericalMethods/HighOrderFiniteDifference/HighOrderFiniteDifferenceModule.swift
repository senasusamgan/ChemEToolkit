import SwiftUI

enum HighOrderFiniteDifferenceModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .highOrderFiniteDifference,
            title: "High-Order Finite Difference",
            subtitle: "Five-point numerical first and second derivatives.",
            category: .numericalMethods,
            symbolName: "scope",
            keywords: ["numerical methods", "differential equations", "high-order finite difference"]
        ),
        destination: {
            HighOrderFiniteDifferenceView()
        }
    )
}
