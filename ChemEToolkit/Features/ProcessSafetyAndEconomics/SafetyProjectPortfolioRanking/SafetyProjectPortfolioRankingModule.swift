import SwiftUI

enum SafetyProjectPortfolioRankingModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .safetyProjectPortfolioRanking,
            title: "Safety Project Portfolio Ranking",
            subtitle: "Rank projects by urgency-adjusted efficiency",
            category: .processSafetyAndEconomics,
            symbolName: "list.number",
            keywords: [
                "safety project ranking",
                "risk reduction per cost",
                "portfolio priority",
                "urgency rating",
                "capital allocation"
            ]
        ),
        destination: {
            SafetyProjectPortfolioRankingView()
        }
    )
}
