import SwiftUI

enum DeactivatingPackedBedReactorModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .deactivatingPackedBedReactor,
            title: "Deactivating Packed-Bed Reactor",
            subtitle: "Predict conversion loss and catalyst-weight demand with time on stream",
            category: .reactionEngineering,
            symbolName: "shippingbox.and.arrow.backward.fill",
            keywords: [
                "packed bed deactivation",
                "catalyst weight",
                "time on stream",
                "conversion loss",
                "activity adjusted Damkohler"
            ]
        ),
        destination: {
            DeactivatingPackedBedReactorView()
        }
    )
}
