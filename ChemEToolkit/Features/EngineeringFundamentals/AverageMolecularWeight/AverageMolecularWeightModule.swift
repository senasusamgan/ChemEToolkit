import SwiftUI

enum AverageMolecularWeightModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .averageMolecularWeight,
            title: "Average Molecular Weight",
            subtitle: "Calculate a normalized mixture average",
            category: .engineeringFundamentals,
            symbolName: "sum",
            keywords: [
                "average molecular weight",
                "mixture molecular weight",
                "mole fraction",
                "gas mixture",
                "composition average"
            ]
        ),
        destination: {
            AverageMolecularWeightView()
        }
    )
}
