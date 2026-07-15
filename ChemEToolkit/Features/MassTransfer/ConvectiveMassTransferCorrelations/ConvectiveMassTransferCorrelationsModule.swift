import SwiftUI

enum ConvectiveMassTransferCorrelationsModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id:
                .convectiveMassTransferCorrelations,
            title:
                "Convective Mass-Transfer Correlations",
            subtitle:
                "Calculate Sherwood number and average convective coefficients",
            category: .massTransfer,
            symbolName:
                "wind.circle.fill",
            keywords: [
                "convective mass transfer",
                "sherwood",
                "reynolds",
                "schmidt",
                "flat plate",
                "correlation"
            ]
        ),
        destination: {
            ConvectiveMassTransferCorrelationsView()
        }
    )
}
