import SwiftUI

enum CSTRsInSeriesModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .cstrsInSeries,
            title: "CSTRs in Series",
            subtitle: "Compare an equal CSTR cascade with one CSTR and a PFR",
            category: .reactionEngineering,
            symbolName: "square.stack.3d.up.fill",
            keywords: [
                "CSTRs in series",
                "tank cascade",
                "first order",
                "PFR comparison"
            ]
        ),
        destination: {
            CSTRsInSeriesView()
        }
    )
}
