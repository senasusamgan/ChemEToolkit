import SwiftUI

enum MIMODecouplingControlModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .mimoDecouplingControl,
            title: "2×2 MIMO Decoupling",
            subtitle: "Calculate RGA and loop pairing",
            category: .processControl,
            symbolName: "square.grid.2x2.fill",
            keywords: [
                "MIMO decoupling",
                "Relative Gain Array",
                "RGA",
                "loop pairing",
                "2x2 process"
            ]
        ),
        destination: {
            MIMODecouplingControlView()
        }
    )
}
