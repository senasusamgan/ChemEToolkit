import SwiftUI

enum CycloneCutDiameterModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .cycloneCutDiameter,
            title: "Cyclone Cut Diameter",
            subtitle: "Estimate the 50% collection particle size",
            category: .separationProcesses,
            symbolName: "tornado",
            keywords: [
                "cyclone separator",
            "cut diameter",
            "particle separation",
            "cyclone efficiency",
            "Stairmand"
            ]
        ),
        destination: { CycloneCutDiameterView() }
    )
}
