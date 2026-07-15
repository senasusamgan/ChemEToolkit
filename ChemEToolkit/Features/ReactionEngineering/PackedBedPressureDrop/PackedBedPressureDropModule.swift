import SwiftUI

enum PackedBedPressureDropModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .packedBedPressureDrop,
            title: "Packed-Bed Pressure Drop",
            subtitle: "Calculate viscous and inertial pressure loss with the Ergun equation",
            category: .reactionEngineering,
            symbolName: "arrow.down.to.line.compact",
            keywords: [
                "Ergun equation",
                "packed bed pressure drop",
                "particle Reynolds number",
                "void fraction",
                "superficial velocity"
            ]
        ),
        destination: {
            PackedBedPressureDropView()
        }
    )
}
