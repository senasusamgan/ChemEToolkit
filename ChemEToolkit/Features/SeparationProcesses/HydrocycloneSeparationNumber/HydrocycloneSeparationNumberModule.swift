import SwiftUI

enum HydrocycloneSeparationNumberModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .hydrocycloneSeparationNumber,
            title: "Hydrocyclone Separation Number",
            subtitle: "Calculate a centrifugal settling performance index",
            category: .separationProcesses,
            symbolName: "drop.circle.fill",
            keywords: [
                "hydrocyclone",
            "separation number",
            "particle settling",
            "centrifugal separation",
            "slurry"
            ]
        ),
        destination: { HydrocycloneSeparationNumberView() }
    )
}
