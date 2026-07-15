import SwiftUI

enum CentrifugalSettlingTimeModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id:
                .centrifugalSettlingTime,
            title:
                "Centrifugal Settling Time",
            subtitle:
                "Calculate radial particle migration and centrifugal acceleration",
            category: .massTransfer,
            symbolName:
                "arrow.triangle.2.circlepath.circle.fill",
            keywords: [
                "centrifugation",
                "centrifugal settling",
                "Stokes settling",
                "relative centrifugal force",
                "particle migration",
                "centrifuge time"
            ]
        ),
        destination: {
            CentrifugalSettlingTimeView()
        }
    )
}
