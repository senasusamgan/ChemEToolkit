import SwiftUI

enum PackedColumnHydraulicsModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .packedColumnHydraulics,
            title: "Packed-Column Hydraulics",
            subtitle: "Size diameter and estimate dry packed-bed pressure drop",
            category: .massTransfer,
            symbolName: "gauge.with.dots.needle.50percent",
            keywords: [
                "packed column", "hydraulics", "flooding",
                "column diameter", "pressure drop", "ergun",
                "superficial velocity"
            ]
        ),
        destination: { PackedColumnHydraulicsView() }
    )
}
