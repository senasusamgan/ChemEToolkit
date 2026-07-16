import SwiftUI

enum CatalystTimeOnStreamModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .catalystTimeOnStream,
            title: "Catalyst Time-on-Stream",
            subtitle: "Estimate when ideal-reactor conversion falls below an operating limit",
            category: .reactionEngineering,
            symbolName: "clock.arrow.trianglehead.counterclockwise.rotate.90",
            keywords: [
                "time on stream",
                "catalyst lifetime",
                "minimum conversion",
                "PFR CSTR deactivation",
                "activity threshold"
            ]
        ),
        destination: {
            CatalystTimeOnStreamView()
        }
    )
}
