import SwiftUI

enum SignificantFiguresRoundingModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .significantFiguresRounding,
            title: "Significant Figures & Rounding",
            subtitle: "Round values to selected significant digits",
            category: .engineeringFundamentals,
            symbolName: "textformat.123",
            keywords: [
                "significant figures",
                "rounding",
                "precision",
                "decimal places",
                "measurement reporting"
            ]
        ),
        destination: {
            SignificantFiguresRoundingView()
        }
    )
}
