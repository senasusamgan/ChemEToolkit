import SwiftUI

enum MoleFractionCalculatorModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .moleFractionCalculator,
            title: "Mole Fraction",
            subtitle: "Calculate mixture mole fraction and percent",
            category: .engineeringFundamentals,
            symbolName: "chart.pie.fill",
            keywords: [
                "mole fraction",
                "mole percent",
                "mixture composition",
                "component moles",
                "total moles"
            ]
        ),
        destination: {
            MoleFractionCalculatorView()
        }
    )
}
