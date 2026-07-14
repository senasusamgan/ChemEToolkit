import SwiftUI

enum UnitConverterModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .unitConverter,
            title: "Unit Converter",
            subtitle: "Convert common engineering units",
            category: .engineeringFundamentals,
            symbolName: "arrow.left.arrow.right",
            keywords: [
                "unit",
                "conversion",
                "temperature",
                "pressure",
                "length",
                "mass",
                "volume",
                "energy"
            ],
            isFeatured: true
        ),
        destination: {
            UnitConverterView()
        }
    )
}
