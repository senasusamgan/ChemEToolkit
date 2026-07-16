import SwiftUI
enum MichaelisMentenReactorModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .michaelisMentenReactor,
            title: "Michaelis–Menten Reactor",
            subtitle: "Compare ideal PFR and CSTR size for enzyme conversion",
            category: .reactionEngineering,
            symbolName: "function",
            keywords: ["enzyme", "bioreactor", "reaction engineering"]
        ),
        destination: { MichaelisMentenReactorView() }
    )
}
