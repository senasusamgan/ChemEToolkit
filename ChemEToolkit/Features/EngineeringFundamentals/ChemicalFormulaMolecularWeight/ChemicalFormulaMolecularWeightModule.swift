import SwiftUI

enum ChemicalFormulaMolecularWeightModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .chemicalFormulaMolecularWeight,
            title: "Chemical Formula Molecular Weight",
            subtitle: "Calculate molecular weight from a simple formula",
            category: .engineeringFundamentals,
            symbolName: "atom",
            keywords: [
                "chemical formula",
                "molecular weight",
                "atomic weight",
                "molar mass",
                "formula parser"
            ]
        ),
        destination: {
            ChemicalFormulaMolecularWeightView()
        }
    )
}
