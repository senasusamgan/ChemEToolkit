import SwiftUI

enum SIFAveragePFDModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .sifAveragePFD,
            title: "SIF Average PFD",
            subtitle: "Estimate simplified low-demand protection performance",
            category: .processSafetyAndEconomics,
            symbolName: "shield.checkered",
            keywords: [
                "SIF PFD average",
                "proof test interval",
                "diagnostic coverage",
                "risk reduction factor",
                "SIL verification"
            ]
        ),
        destination: {
            SIFAveragePFDView()
        }
    )
}
