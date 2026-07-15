import SwiftUI

enum RecyclePFRModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .recyclePFR,
            title: "Recycle PFR",
            subtitle: "Calculate a first-order PFR with stream recycle",
            category: .reactionEngineering,
            symbolName: "arrow.trianglehead.2.clockwise.rotate.90",
            keywords: [
                "recycle reactor",
                "recycle PFR",
                "single pass conversion",
                "overall conversion"
            ]
        ),
        destination: {
            RecyclePFRView()
        }
    )
}
