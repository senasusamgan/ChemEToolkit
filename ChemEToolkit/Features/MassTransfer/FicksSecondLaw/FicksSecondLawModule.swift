import SwiftUI

enum FicksSecondLawModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .ficksSecondLaw,
            title: "Fick’s Second Law",
            subtitle:
                "Calculate transient diffusion in a semi-infinite medium",
            category: .massTransfer,
            symbolName:
                "waveform.path.ecg.rectangle",
            keywords: [
                "Fick second law",
                "transient diffusion",
                "error function",
                "semi infinite medium",
                "diffusion time",
                "concentration profile"
            ]
        ),
        destination: {
            FicksSecondLawView()
        }
    )
}
