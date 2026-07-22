import SwiftUI

enum OneDimensionalWaveEquationModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .oneDimensionalWaveEquation,
            title: "One-Dimensional Wave Equation",
            subtitle: "Explicit finite-difference vibration of a fixed-end domain.",
            category: .numericalMethods,
            symbolName: "scope",
            keywords: ["numerical methods", "differential equations", "one-dimensional wave equation"]
        ),
        destination: {
            OneDimensionalWaveEquationView()
        }
    )
}
