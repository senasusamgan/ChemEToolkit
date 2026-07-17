import SwiftUI

enum NetPresentValueAnalysisModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .netPresentValueAnalysis,
            title: "Net Present Value Analysis",
            subtitle: "Discount project cash flows",
            category: .processSafetyAndEconomics,
            symbolName: "sum",
            keywords: [
                "net present value",
                "NPV",
                "discounted cash flow",
                "profitability index",
                "discounted payback"
            ]
        ),
        destination: {
            NetPresentValueAnalysisView()
        }
    )
}
