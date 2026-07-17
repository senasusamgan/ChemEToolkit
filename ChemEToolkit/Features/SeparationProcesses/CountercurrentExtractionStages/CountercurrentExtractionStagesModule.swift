import SwiftUI

enum CountercurrentExtractionStagesModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .countercurrentExtractionStages,
            title: "Countercurrent Extraction Stages",
            subtitle: "Estimate ideal countercurrent extraction stages",
            category: .separationProcesses,
            symbolName: "arrow.left.arrow.right.square.fill",
            keywords: [
                "countercurrent extraction",
                "Kremser extraction",
                "extraction factor",
                "ideal stages",
                "solute removal"
            ]
        ),
        destination: {
            CountercurrentExtractionStagesView()
        }
    )
}
