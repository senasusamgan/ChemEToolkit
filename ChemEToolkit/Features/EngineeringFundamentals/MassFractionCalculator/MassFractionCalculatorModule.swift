import SwiftUI

enum MassFractionCalculatorModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .massFractionCalculator,
            title: "Mass Fraction",
            subtitle: "Calculate mixture mass fraction and percent",
            category: .engineeringFundamentals,
            symbolName: "chart.pie",
            keywords: [
                "mass fraction",
                "mass percent",
                "mixture composition",
                "component mass",
                "total mass"
            ]
        ),
        destination: {
            MassFractionCalculatorView()
        }
    )
}
