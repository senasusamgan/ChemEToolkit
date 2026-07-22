import SwiftUI

enum StandardGasFlowConverterModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .standardGasFlowConverter,
            title: "Standard Gas Flow Conversion",
            subtitle: "Correct ideal-gas flow to standard conditions",
            category: .engineeringFundamentals,
            symbolName: "wind",
            keywords: [
                "standard gas flow",
                "actual flow",
                "normal cubic meter",
                "pressure correction",
                "temperature correction"
            ]
        ),
        destination: {
            StandardGasFlowConverterView()
        }
    )
}
