import SwiftUI

enum CrosscurrentExtractionStagesModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .crosscurrentExtractionStages,
            title: "Crosscurrent Extraction Stages",
            subtitle: "Estimate stages using equal fresh solvent contacts",
            category: .separationProcesses,
            symbolName: "arrow.triangle.branch",
            keywords: [
                "crosscurrent extraction",
                "fresh solvent",
                "extraction stages",
                "distribution coefficient",
                "solute removal"
            ]
        ),
        destination: {
            CrosscurrentExtractionStagesView()
        }
    )
}
