import SwiftUI

enum SemibatchReactorModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .semibatchReactor,
            title: "Semibatch Reactor",
            subtitle: "Integrate variable-volume A feed reacting with initially charged B",
            category: .reactionEngineering,
            symbolName: "drop.degreesign.fill",
            keywords: [
                "semibatch reactor",
                "variable volume",
                "A plus B reaction",
                "fed batch",
                "RK4 integration"
            ]
        ),
        destination: {
            SemibatchReactorView()
        }
    )
}
