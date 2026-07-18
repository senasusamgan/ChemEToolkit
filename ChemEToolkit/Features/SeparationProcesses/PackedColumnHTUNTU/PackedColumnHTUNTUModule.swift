import SwiftUI

enum PackedColumnHTUNTUModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .packedColumnHTUNTU,
            title: "Packed-Column HTU/NTU",
            subtitle: "Estimate packed height from transfer units",
            category: .separationProcesses,
            symbolName: "square.stack.3d.up.fill",
            keywords: [
                "packed column",
            "HTU",
            "NTU",
            "packed height",
            "mass transfer"
            ]
        ),
        destination: { PackedColumnHTUNTUView() }
    )
}
