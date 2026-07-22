import SwiftUI
enum AxialDispersionRTDModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .axialDispersionRTD,
            title: "Axial-Dispersion RTD",
            subtitle: "Evaluate RTD broadening from the Peclet number",
            category: .reactionEngineering,
            symbolName: "arrow.left.and.right",
            keywords: ["RTD", "residence time", "nonideal reactor"]
        ),
        destination: { AxialDispersionRTDView() }
    )
}
