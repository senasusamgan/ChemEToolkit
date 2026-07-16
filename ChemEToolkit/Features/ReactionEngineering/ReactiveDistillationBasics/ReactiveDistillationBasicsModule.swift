import SwiftUI

enum ReactiveDistillationBasicsModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .reactiveDistillationBasics,
            title: "Reactive Distillation Basics",
            subtitle: "Estimate conversion enhancement from stagewise product removal",
            category: .reactionEngineering,
            symbolName: "arrow.down.right.and.arrow.up.left",
            keywords: [
                "reactive distillation",
                "equilibrium stages",
                "product removal",
                "conversion enhancement",
                "hybrid separation reaction"
            ]
        ),
        destination: {
            ReactiveDistillationBasicsView()
        }
    )
}
