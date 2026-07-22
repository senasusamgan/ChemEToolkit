import SwiftUI
enum ConversionFromRTDModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .conversionFromRTD,
            title: "Conversion from RTD",
            subtitle: "Predict first-order conversion from residence-time data",
            category: .reactionEngineering,
            symbolName: "function",
            keywords: ["RTD", "residence time", "nonideal reactor"]
        ),
        destination: { ConversionFromRTDView() }
    )
}
