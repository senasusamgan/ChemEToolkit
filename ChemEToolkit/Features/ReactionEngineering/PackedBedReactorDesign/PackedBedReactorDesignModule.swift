import SwiftUI

enum PackedBedReactorDesignModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .packedBedReactorDesign,
            title: "Packed-Bed Reactor Design",
            subtitle: "Calculate catalyst weight for a target first-order conversion",
            category: .reactionEngineering,
            symbolName: "shippingbox.fill",
            keywords: [
                "packed bed reactor",
                "PBR design",
                "catalyst weight",
                "first order",
                "heterogeneous catalysis"
            ]
        ),
        destination: {
            PackedBedReactorDesignView()
        }
    )
}
