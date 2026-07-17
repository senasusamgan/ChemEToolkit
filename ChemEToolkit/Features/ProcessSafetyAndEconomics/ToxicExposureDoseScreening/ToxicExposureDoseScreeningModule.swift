import SwiftUI

enum ToxicExposureDoseScreeningModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .toxicExposureDoseScreening,
            title: "Toxic Exposure Dose",
            subtitle: "Screen concentration-time dose",
            category: .processSafetyAndEconomics,
            symbolName: "lungs.fill",
            keywords: [
                "toxic dose",
                "concentration time",
                "exposure duration",
                "dose ratio",
                "toxic consequence"
            ]
        ),
        destination: {
            ToxicExposureDoseScreeningView()
        }
    )
}
