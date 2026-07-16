import SwiftUI

enum BypassDeadVolumeReactorModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .bypassDeadVolumeReactor,
            title: "Bypass–Dead-Volume Reactor",
            subtitle: "Estimate first-order conversion with bypass and inaccessible volume",
            category: .reactionEngineering,
            symbolName: "arrow.triangle.pull",
            keywords: [
                "bypass dead volume",
                "nonideal reactor conversion",
                "short circuiting",
                "active PFR",
                "conversion penalty"
            ]
        ),
        destination: {
            BypassDeadVolumeReactorView()
        }
    )
}
