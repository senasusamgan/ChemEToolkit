import SwiftUI

enum AutocatalyticBatchReactorModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .autocatalyticBatchReactor,
            title: "Autocatalytic Batch Reactor",
            subtitle: "Calculate batch time for A + B → 2B with autocatalytic kinetics",
            category: .reactionEngineering,
            symbolName: "bolt.circle.fill",
            keywords: [
                "autocatalytic reactor",
                "A plus B to 2B",
                "batch reactor",
                "maximum reaction rate",
                "product catalysis"
            ]
        ),
        destination: {
            AutocatalyticBatchReactorView()
        }
    )
}
