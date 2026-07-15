import SwiftUI

enum DimensionlessMassTransferModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .dimensionlessMassTransfer,
            title: "Mass-Transfer Numbers",
            subtitle: "Calculate Schmidt, Lewis, and Sherwood numbers",
            category: .massTransfer,
            symbolName: "number",
            keywords: ["sherwood", "schmidt", "lewis", "dimensionless", "mass transfer"]
        ),
        destination: { DimensionlessMassTransferView() }
    )
}
