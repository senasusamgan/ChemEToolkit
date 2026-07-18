import SwiftUI

enum FixedBedAdsorberBreakthroughModule {
    static let module =
        AppModule(
            metadata:
                ModuleMetadata(
                    id:
                        .fixedBedAdsorberBreakthrough,
                    title:
                        "Fixed-Bed Adsorber Breakthrough",
                    subtitle:
                        "Estimate breakthrough time with the BDST model",
                    category: .separationProcesses,
                    symbolName:
                        "rectangle.3.group.bubble.left.fill",
                    keywords: [
                        "BDST",
                "breakthrough time",
                "fixed bed adsorption",
                "bed depth",
                "adsorber design"
                    ]
                ),
            destination: {
                FixedBedAdsorberBreakthroughView()
            }
        )
}
