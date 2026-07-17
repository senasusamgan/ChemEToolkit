import SwiftUI

enum FenskeMinimumStagesModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .fenskeMinimumStages,
            title: "Fenske Minimum Stages",
            subtitle: "Estimate total-reflux theoretical stages",
            category: .separationProcesses,
            symbolName: "square.stack.3d.up.fill",
            keywords: [
                "Fenske equation",
                "minimum stages",
                "total reflux",
                "relative volatility",
                "distillation design"
            ]
        ),
        destination: {
            FenskeMinimumStagesView()
        }
    )
}
