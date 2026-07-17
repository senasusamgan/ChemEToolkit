import SwiftUI

enum BinaryDistillationBalanceModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .binaryDistillationBalance,
            title: "Binary Distillation Balance",
            subtitle: "Calculate distillate and bottoms flow rates",
            category: .separationProcesses,
            symbolName: "arrow.up.arrow.down.circle.fill",
            keywords: [
                "distillation balance",
                "distillate",
                "bottoms",
                "component recovery",
                "binary separation"
            ]
        ),
        destination: {
            BinaryDistillationBalanceView()
        }
    )
}
