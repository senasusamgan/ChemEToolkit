import SwiftUI

enum TNTEquivalentExplosionScreeningModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .tntEquivalentExplosionScreening,
            title: "TNT Equivalent Explosion",
            subtitle: "Screen explosion energy and scaled distance",
            category: .processSafetyAndEconomics,
            symbolName: "aqi.medium",
            keywords: [
                "TNT equivalent",
                "vapor cloud explosion",
                "scaled distance",
                "explosion energy",
                "blast screening"
            ]
        ),
        destination: {
            TNTEquivalentExplosionScreeningView()
        }
    )
}
