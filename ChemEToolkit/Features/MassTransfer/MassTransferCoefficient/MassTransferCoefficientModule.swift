import SwiftUI

enum MassTransferCoefficientModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .massTransferCoefficient,
            title: "Mass-Transfer Coefficient",
            subtitle: "Calculate flux and rate from a concentration driving force",
            category: .massTransfer,
            symbolName: "gauge.with.dots.needle.50percent",
            keywords: ["mass transfer coefficient", "driving force", "flux", "rate", "film"]
        ),
        destination: { MassTransferCoefficientView() }
    )
}
