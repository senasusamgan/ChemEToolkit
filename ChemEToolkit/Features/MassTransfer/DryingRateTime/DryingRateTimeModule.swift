import SwiftUI

enum DryingRateTimeModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .dryingRateTime,
            title: "Drying Rate & Time",
            subtitle:
                "Calculate constant-rate and falling-rate drying periods",
            category: .massTransfer,
            symbolName: "wind",
            keywords: [
                "drying",
                "drying time",
                "constant rate",
                "falling rate",
                "critical moisture",
                "equilibrium moisture"
            ]
        ),
        destination: {
            DryingRateTimeView()
        }
    )
}
