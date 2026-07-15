import SwiftUI

enum PFRSectionsModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .pfrSections,
            title: "PFR Sections",
            subtitle: "Calculate serial PFR zones with different first-order kinetics",
            category: .reactionEngineering,
            symbolName: "arrow.right.to.line.compact",
            keywords: [
                "PFR sections",
                "piecewise kinetics",
                "reactor zones",
                "first order"
            ]
        ),
        destination: {
            PFRSectionsView()
        }
    )
}
