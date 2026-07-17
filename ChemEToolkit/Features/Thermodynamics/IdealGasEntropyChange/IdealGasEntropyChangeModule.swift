import SwiftUI

enum IdealGasEntropyChangeModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .idealGasEntropyChange,
            title: "Ideal-Gas Entropy Change",
            subtitle: "Calculate ideal-gas entropy change between two states",
            category: .thermodynamics,
            symbolName: "waveform.path.ecg.rectangle.fill",
            keywords: [
                "ideal gas entropy",
                "entropy change",
                "temperature ratio",
                "pressure ratio",
                "second law"
            ]
        ),
        destination: {
            IdealGasEntropyChangeView()
        }
    )
}
