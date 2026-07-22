import SwiftUI

enum AdamsBashforthMoultonModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .adamsBashforthMoulton,
            title: "Adams-Bashforth-Moulton ODE",
            subtitle: "Fourth-order predictor-corrector integration for supported ODEs.",
            category: .numericalMethods,
            symbolName: "scope",
            keywords: ["numerical methods", "differential equations", "adams-bashforth-moulton ode"]
        ),
        destination: {
            AdamsBashforthMoultonView()
        }
    )
}
