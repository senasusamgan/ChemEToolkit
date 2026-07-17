import SwiftUI

enum ExpectedMonetaryValueDecisionModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .expectedMonetaryValueDecision,
            title: "Expected Monetary Value Decision",
            subtitle: "Compare two uncertain economic options",
            category: .processSafetyAndEconomics,
            symbolName: "arrow.triangle.2.circlepath.circle.fill",
            keywords: [
                "expected monetary value",
                "decision analysis",
                "probability",
                "uncertain investment",
                "option comparison"
            ]
        ),
        destination: {
            ExpectedMonetaryValueDecisionView()
        }
    )
}
