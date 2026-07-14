import SwiftUI

enum OpenChannelModule {

    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .openChannelFlow,
            title: "Open Channel Flow",
            subtitle:
                "Calculate rectangular channel flow using Manning’s equation",
            category: .fluidMechanics,
            symbolName: "water.waves",
            keywords: [
                "open channel flow",
                "Manning equation",
                "rectangular channel",
                "hydraulic radius",
                "wetted perimeter",
                "channel slope",
                "Manning coefficient",
                "channel discharge",
                "water depth",
                "fluid mechanics"
            ]
        ),
        destination: {
            OpenChannelView()
        }
    )
}
