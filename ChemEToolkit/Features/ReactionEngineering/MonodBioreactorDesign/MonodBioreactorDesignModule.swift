import SwiftUI
enum MonodBioreactorDesignModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .monodBioreactorDesign,
            title: "Monod Bioreactor Design",
            subtitle: "Size a continuous bioreactor with Monod growth",
            category: .reactionEngineering,
            symbolName: "microbe.fill",
            keywords: ["enzyme", "bioreactor", "reaction engineering"]
        ),
        destination: { MonodBioreactorDesignView() }
    )
}
