import SwiftUI

enum OverallMassTransferCoefficientModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id:
                .overallMassTransferCoefficient,
            title:
                "Overall Mass-Transfer Coefficient",
            subtitle:
                "Combine individual film coefficients and quantify resistance shares",
            category: .massTransfer,
            symbolName:
                "rectangle.2.swap",
            keywords: [
                "overall mass transfer coefficient",
                "gas side coefficient",
                "liquid side coefficient",
                "film resistance",
                "two film",
                "driving force"
            ]
        ),
        destination: {
            OverallMassTransferCoefficientView()
        }
    )
}
