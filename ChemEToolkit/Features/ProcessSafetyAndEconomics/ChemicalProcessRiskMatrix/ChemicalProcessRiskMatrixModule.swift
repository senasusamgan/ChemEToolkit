import SwiftUI

enum ChemicalProcessRiskMatrixModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .chemicalProcessRiskMatrix,
            title: "Chemical Process Risk Matrix",
            subtitle: "Screen likelihood, severity and residual risk",
            category: .processSafetyAndEconomics,
            symbolName: "exclamationmark.triangle.fill",
            keywords: [
                "risk matrix",
                "process safety",
                "likelihood",
                "severity",
                "residual risk"
            ]
        ),
        destination: {
            ChemicalProcessRiskMatrixView()
        }
    )
}
