import SwiftUI

enum ConstantVolumeStoichiometryModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .constantVolumeStoichiometry,
            title: "Constant-Volume Stoichiometry",
            subtitle: "Calculate final concentrations from conversion and stoichiometry",
            category: .reactionEngineering,
            symbolName: "tablecells.fill",
            keywords: [
                "stoichiometric table",
                "constant volume",
                "conversion",
                "limiting reactant",
                "reaction extent",
                "concentration"
            ]
        ),
        destination: {
            ConstantVolumeStoichiometryView()
        }
    )
}
