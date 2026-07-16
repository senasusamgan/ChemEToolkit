import SwiftUI
enum EnzymeBatchReactorModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .enzymeBatchReactor,
            title: "Enzyme Batch Reactor",
            subtitle: "Calculate enzyme batch time and product formation",
            category: .reactionEngineering,
            symbolName: "flask.fill",
            keywords: ["enzyme", "bioreactor", "reaction engineering"]
        ),
        destination: { EnzymeBatchReactorView() }
    )
}
