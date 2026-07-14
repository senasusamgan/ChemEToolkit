import SwiftUI

enum SolutionConcentrationModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .solutionConcentration,
            title: "Solution Concentration",
            subtitle: "Calculate molarity and molality",
            category: .engineeringFundamentals,
            symbolName: "testtube.2",
            keywords: [
                "solution",
                "concentration",
                "molarity",
                "molality",
                "moles",
                "solute",
                "solvent",
                "volume",
                "mass"
            ],
            isFeatured: true
        ),
        destination: {
            ConcentrationView()
        }
    )
}
