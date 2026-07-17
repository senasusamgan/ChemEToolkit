import SwiftUI

enum ProofTestIntervalCalculatorModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .proofTestIntervalCalculator,
            title: "Proof-Test Interval Calculator",
            subtitle: "Solve a simplified interval from target PFD",
            category: .processSafetyAndEconomics,
            symbolName: "calendar.badge.exclamationmark",
            keywords: [
                "proof test interval",
                "target PFD",
                "SIF maintenance",
                "diagnostic coverage",
                "functional safety"
            ]
        ),
        destination: {
            ProofTestIntervalCalculatorView()
        }
    )
}
