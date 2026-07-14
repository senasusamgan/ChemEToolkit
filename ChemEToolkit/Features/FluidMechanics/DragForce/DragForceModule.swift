import SwiftUI

enum DragForceModule {

    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .dragForce,
            title: "Drag Force",
            subtitle:
                "Calculate fluid drag force and associated power",
            category: .fluidMechanics,
            symbolName: "wind",
            keywords: [
                "drag force",
                "drag coefficient",
                "dynamic pressure",
                "projected area",
                "relative velocity",
                "fluid resistance",
                "drag power",
                "fluid mechanics"
            ]
        ),
        destination: {
            DragForceView()
        }
    )
}
