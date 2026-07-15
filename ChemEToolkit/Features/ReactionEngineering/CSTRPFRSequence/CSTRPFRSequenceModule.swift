import SwiftUI

enum CSTRPFRSequenceModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .cstrPFRSequence,
            title: "CSTR–PFR Sequence",
            subtitle: "Calculate a CSTR followed by a PFR with different kinetics",
            category: .reactionEngineering,
            symbolName: "arrow.right.square.fill",
            keywords: [
                "CSTR PFR sequence",
                "reactor train",
                "first order",
                "series reactors"
            ]
        ),
        destination: {
            CSTRPFRSequenceView()
        }
    )
}
