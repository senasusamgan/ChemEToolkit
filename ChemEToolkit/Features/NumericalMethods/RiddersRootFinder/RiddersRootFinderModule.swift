import SwiftUI

enum RiddersRootFinderModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .riddersRootFinder,
            title: "Ridders Root Finder",
            subtitle: "Bracketed nonlinear root finding with exponential interpolation.",
            category: .numericalMethods,
            symbolName: "scope",
            keywords: ["numerical methods", "approximation", "ridders root finder"]
        ),
        destination: {
            RiddersRootFinderView()
        }
    )
}
