import SwiftUI

enum SegregationModelConversionModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .segregationModelConversion,
            title: "Segregation Model Conversion",
            subtitle: "Predict nonideal-reactor conversion for general-order kinetics",
            category: .reactionEngineering,
            symbolName: "circle.grid.cross.fill",
            keywords: [
                "segregation model",
                "general reaction order",
                "RTD conversion",
                "micromixing",
                "power law kinetics"
            ]
        ),
        destination: {
            SegregationModelConversionView()
        }
    )
}
