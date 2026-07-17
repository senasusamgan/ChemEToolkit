import SwiftUI

enum ALARPGrossDisproportionScreeningModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .alarpGrossDisproportionScreening,
            title: "ALARP Gross Disproportion",
            subtitle: "Screen safety cost against adjusted benefit",
            category: .processSafetyAndEconomics,
            symbolName: "scale.3d",
            keywords: [
                "ALARP",
                "gross disproportion",
                "cost benefit",
                "risk reduction measure",
                "reasonable practicability"
            ]
        ),
        destination: {
            ALARPGrossDisproportionScreeningView()
        }
    )
}
