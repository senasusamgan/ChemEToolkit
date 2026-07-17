import SwiftUI

enum KremserStrippingStagesModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .kremserStrippingStages,
            title: "Kremser Stripping Stages",
            subtitle: "Estimate ideal stripper stages",
            category: .separationProcesses,
            symbolName: "square.stack.3d.up.left.fill",
            keywords: [
                "Kremser stripping",
                "stripper stages",
                "solute removal",
                "stripping factor",
                "stage estimate"
            ]
        ),
        destination: {
            KremserStrippingStagesView()
        }
    )
}
