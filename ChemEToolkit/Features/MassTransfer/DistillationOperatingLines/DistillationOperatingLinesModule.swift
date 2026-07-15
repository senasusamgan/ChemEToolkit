import SwiftUI

enum DistillationOperatingLinesModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .distillationOperatingLines,
            title: "Distillation Operating Lines",
            subtitle: "Calculate rectifying, q-line and stripping-line parameters",
            category: .massTransfer,
            symbolName: "chart.xyaxis.line",
            keywords: ["distillation", "operating line", "rectifying line", "stripping line", "q line", "minimum reflux"]
        ),
        destination: { DistillationOperatingLinesView() }
    )
}
