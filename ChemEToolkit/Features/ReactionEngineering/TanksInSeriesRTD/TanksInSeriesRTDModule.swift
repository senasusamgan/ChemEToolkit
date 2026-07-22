import SwiftUI
enum TanksInSeriesRTDModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .tanksInSeriesRTD,
            title: "Tanks-in-Series RTD",
            subtitle: "Evaluate the RTD curve for N ideal tanks",
            category: .reactionEngineering,
            symbolName: "square.stack.3d.up.fill",
            keywords: ["RTD", "residence time", "nonideal reactor"]
        ),
        destination: { TanksInSeriesRTDView() }
    )
}
