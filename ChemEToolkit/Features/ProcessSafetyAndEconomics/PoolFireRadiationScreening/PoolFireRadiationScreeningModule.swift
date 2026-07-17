import SwiftUI

enum PoolFireRadiationScreeningModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .poolFireRadiationScreening,
            title: "Pool Fire Radiation",
            subtitle: "Screen thermal radiation at a receptor",
            category: .processSafetyAndEconomics,
            symbolName: "flame.circle.fill",
            keywords: [
                "pool fire",
                "thermal radiation",
                "heat flux",
                "radiant fraction",
                "fire consequence"
            ]
        ),
        destination: {
            PoolFireRadiationScreeningView()
        }
    )
}
