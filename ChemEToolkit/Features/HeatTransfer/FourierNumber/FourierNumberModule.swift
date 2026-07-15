import SwiftUI

enum FourierNumberModule {

    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .fourierNumber,
            title: "Fourier Number",
            subtitle:
                "Compare elapsed time with the thermal-diffusion time scale",
            category: .heatTransfer,
            symbolName: "clock.arrow.circlepath",
            keywords: [
                "Fourier number",
                "thermal diffusivity",
                "transient conduction",
                "diffusion time",
                "characteristic length",
                "elapsed time",
                "dimensionless number",
                "heat equation"
            ]
        ),
        destination: {
            FourierNumberView()
        }
    )
}
