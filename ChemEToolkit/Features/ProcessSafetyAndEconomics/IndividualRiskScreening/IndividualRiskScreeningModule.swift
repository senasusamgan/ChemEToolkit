import SwiftUI

enum IndividualRiskScreeningModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .individualRiskScreening,
            title: "Individual Risk Screening",
            subtitle: "Estimate single-scenario annual individual risk",
            category: .processSafetyAndEconomics,
            symbolName: "person.crop.circle.badge.exclamationmark",
            keywords: [
                "individual risk",
                "annual fatality risk",
                "occupancy",
                "presence probability",
                "risk screening"
            ]
        ),
        destination: {
            IndividualRiskScreeningView()
        }
    )
}
