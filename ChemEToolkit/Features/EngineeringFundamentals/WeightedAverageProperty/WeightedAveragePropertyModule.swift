import SwiftUI

enum WeightedAveragePropertyModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .weightedAverageProperty,
            title: "Weighted Average Property",
            subtitle: "Calculate a normalized mixture property",
            category: .engineeringFundamentals,
            symbolName: "sum",
            keywords: [
                "weighted average",
                "mixture property",
                "normalized fractions",
                "linear mixing",
                "composition average"
            ]
        ),
        destination: {
            WeightedAveragePropertyView()
        }
    )
}
