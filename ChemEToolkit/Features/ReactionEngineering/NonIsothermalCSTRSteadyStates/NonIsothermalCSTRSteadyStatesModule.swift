import SwiftUI

enum NonIsothermalCSTRSteadyStatesModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .nonIsothermalCSTRSteadyStates,
            title: "Non-Isothermal CSTR Steady States",
            subtitle: "Locate one or multiple temperature and conversion intersections",
            category: .reactionEngineering,
            symbolName: "point.3.filled.connected.trianglepath.dotted",
            keywords: [
                "multiple steady states",
                "non-isothermal CSTR",
                "ignition extinction",
                "energy balance",
                "thermal multiplicity"
            ]
        ),
        destination: {
            NonIsothermalCSTRSteadyStatesView()
        }
    )
}
