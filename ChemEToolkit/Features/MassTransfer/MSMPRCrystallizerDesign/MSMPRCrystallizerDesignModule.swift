import SwiftUI

enum MSMPRCrystallizerDesignModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .msmprCrystallizerDesign,
            title:
                "MSMPR Crystallizer Design",
            subtitle:
                "Calculate ideal crystal-size distribution, loading and production",
            category: .massTransfer,
            symbolName:
                "chart.bar.xaxis",
            keywords: [
                "MSMPR",
                "crystallizer design",
                "population balance",
                "crystal size distribution",
                "growth rate",
                "crystal production"
            ]
        ),
        destination: {
            MSMPRCrystallizerDesignView()
        }
    )
}
