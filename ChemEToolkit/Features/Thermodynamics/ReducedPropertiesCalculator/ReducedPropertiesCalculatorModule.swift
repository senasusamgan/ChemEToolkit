import SwiftUI

enum ReducedPropertiesCalculatorModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .reducedPropertiesCalculator,
            title: "Reduced Properties",
            subtitle: "Calculate reduced temperature and pressure",
            category: .thermodynamics,
            symbolName: "scope",
            keywords: [
                "reduced temperature",
                "reduced pressure",
                "critical properties",
                "corresponding states",
                "thermodynamics"
            ]
        ),
        destination: {
            ReducedPropertiesCalculatorView()
        }
    )
}
