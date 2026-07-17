import SwiftUI

enum BinaryCompositionBasisConversionModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .binaryCompositionBasisConversion,
            title: "Binary Mass–Mole Fraction",
            subtitle: "Convert binary composition basis",
            category: .engineeringFundamentals,
            symbolName: "arrow.triangle.swap",
            keywords: [
                "mass fraction to mole fraction",
                "binary mixture",
                "composition basis",
                "mixture molecular weight",
                "mole fraction"
            ]
        ),
        destination: {
            BinaryCompositionBasisConversionView()
        }
    )
}
