import SwiftUI

enum CountercurrentSolidsWashingModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id:
                .countercurrentSolidsWashing,
            title:
                "Countercurrent Solids Washing",
            subtitle:
                "Solve ideal washer stages, final underflow loss and solute recovery",
            category: .massTransfer,
            symbolName:
                "arrow.left.arrow.right.circle.fill",
            keywords: [
                "countercurrent washing",
                "solids washing",
                "leaching",
                "washing stages",
                "underflow",
                "overflow",
                "solute recovery"
            ]
        ),
        destination: {
            CountercurrentSolidsWashingView()
        }
    )
}
