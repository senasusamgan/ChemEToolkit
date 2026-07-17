import SwiftUI

enum StraightLineDepreciationModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .straightLineDepreciation,
            title: "Straight-Line Depreciation",
            subtitle: "Calculate depreciation and book value",
            category: .processSafetyAndEconomics,
            symbolName: "minus.circle.fill",
            keywords: [
                "straight line depreciation",
                "book value",
                "salvage value",
                "depreciable basis",
                "asset life"
            ]
        ),
        destination: {
            StraightLineDepreciationView()
        }
    )
}
