import SwiftUI

enum BLEVEFireballScreeningModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .bleveFireballScreening,
            title: "BLEVE Fireball Screening",
            subtitle: "Estimate fireball size and radiation",
            category: .processSafetyAndEconomics,
            symbolName: "burst.fill",
            keywords: [
                "BLEVE",
                "fireball",
                "thermal radiation",
                "fireball duration",
                "fire consequence"
            ]
        ),
        destination: {
            BLEVEFireballScreeningView()
        }
    )
}
