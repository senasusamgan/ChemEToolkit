import SwiftUI

enum TwoFilmTheoryModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .twoFilmTheory,
            title: "Two-Film Theory",
            subtitle:
                "Solve interface compositions, transfer flux and film resistances",
            category: .massTransfer,
            symbolName:
                "square.3.layers.3d",
            keywords: [
                "two film theory",
                "interface composition",
                "gas film",
                "liquid film",
                "resistance",
                "interphase transfer"
            ]
        ),
        destination: {
            TwoFilmTheoryView()
        }
    )
}
