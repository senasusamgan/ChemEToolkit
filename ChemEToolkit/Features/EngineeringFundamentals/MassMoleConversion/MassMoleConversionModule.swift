import SwiftUI

enum MassMoleConversionModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .massMoleConversion,
            title: "Mass–Mole Conversion",
            subtitle: "Convert between mass and chemical amount",
            category: .engineeringFundamentals,
            symbolName: "arrow.left.arrow.right",
            keywords: [
                "mass mole conversion",
                "molecular weight",
                "kmol",
                "mol",
                "stoichiometry"
            ]
        ),
        destination: {
            MassMoleConversionView()
        }
    )
}
