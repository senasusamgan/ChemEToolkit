import SwiftUI

enum TransferFunctionBuilderModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .transferFunctionBuilder,
            title: "Transfer Function Builder",
            subtitle: "Build and evaluate a low-order SISO transfer function",
            category: .processControl,
            symbolName: "waveform.path",
            keywords: [
                "transfer function",
                "polynomial coefficients",
                "frequency response",
                "DC gain",
                "stability"
            ]
        ),
        destination: { TransferFunctionBuilderView() }
    )
}
