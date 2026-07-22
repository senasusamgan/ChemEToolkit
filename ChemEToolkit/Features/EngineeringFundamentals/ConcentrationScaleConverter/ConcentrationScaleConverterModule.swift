import SwiftUI

enum ConcentrationScaleConverterModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .concentrationScaleConverter,
            title: "Percent–ppm–ppb Converter",
            subtitle: "Convert common concentration scales",
            category: .engineeringFundamentals,
            symbolName: "percent",
            keywords: [
                "percent",
                "ppm",
                "ppb",
                "concentration conversion",
                "dimensionless fraction"
            ]
        ),
        destination: {
            ConcentrationScaleConverterView()
        }
    )
}
