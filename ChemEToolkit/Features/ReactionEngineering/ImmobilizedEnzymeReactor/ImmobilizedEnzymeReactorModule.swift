import SwiftUI
enum ImmobilizedEnzymeReactorModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .immobilizedEnzymeReactor,
            title: "Immobilized Enzyme Reactor",
            subtitle: "Estimate pellet effectiveness and internal diffusion loss",
            category: .reactionEngineering,
            symbolName: "circle.hexagongrid.fill",
            keywords: ["enzyme", "bioreactor", "reaction engineering"]
        ),
        destination: { ImmobilizedEnzymeReactorView() }
    )
}
