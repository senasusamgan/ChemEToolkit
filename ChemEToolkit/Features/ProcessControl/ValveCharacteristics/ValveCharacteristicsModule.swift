import SwiftUI

enum ValveCharacteristicsModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .valveCharacteristics,
            title: "Valve Characteristics",
            subtitle: "Compare inherent valve trim responses",
            category: .processControl,
            symbolName: "slider.horizontal.3",
            keywords: [
                "valve characteristics",
                "equal percentage",
                "linear valve",
                "quick opening",
                "rangeability"
            ]
        ),
        destination: { ValveCharacteristicsView() }
    )
}
