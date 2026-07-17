import SwiftUI

enum BinaryIsothermalFlashModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .binaryIsothermalFlash,
            title: "Binary Isothermal Flash",
            subtitle: "Solve Rachford–Rice vapor fraction and compositions",
            category: .separationProcesses,
            symbolName: "arrow.triangle.branch",
            keywords: [
                "flash calculation",
                "Rachford Rice",
                "vapor fraction",
                "K value",
                "phase split"
            ]
        ),
        destination: {
            BinaryIsothermalFlashView()
        }
    )
}
