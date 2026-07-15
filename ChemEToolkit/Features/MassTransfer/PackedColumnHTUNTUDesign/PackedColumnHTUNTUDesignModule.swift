import SwiftUI

enum PackedColumnHTUNTUDesignModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .packedColumnHTUNTUDesign,
            title: "Packed-Column HTU–NTU Design",
            subtitle: "Calculate transfer units and packed height for dilute absorption",
            category: .massTransfer,
            symbolName: "ruler",
            keywords: [
                "packed column", "HTU", "NTU", "packed height",
                "absorption", "pinch", "overall gas phase"
            ]
        ),
        destination: { PackedColumnHTUNTUDesignView() }
    )
}
