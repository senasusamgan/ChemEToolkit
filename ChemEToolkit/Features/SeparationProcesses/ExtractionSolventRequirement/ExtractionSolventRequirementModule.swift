import SwiftUI

enum ExtractionSolventRequirementModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .extractionSolventRequirement,
            title: "Extraction Solvent Requirement",
            subtitle: "Calculate single-stage fresh-solvent demand",
            category: .separationProcesses,
            symbolName: "drop.triangle.fill",
            keywords: [
                "solvent requirement",
                "single stage extraction",
                "distribution coefficient",
                "solvent feed ratio",
                "target removal"
            ]
        ),
        destination: {
            ExtractionSolventRequirementView()
        }
    )
}
