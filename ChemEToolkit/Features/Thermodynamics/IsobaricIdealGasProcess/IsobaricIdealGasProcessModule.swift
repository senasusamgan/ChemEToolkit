import SwiftUI

enum IsobaricIdealGasProcessModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .isobaricIdealGasProcess,
            title: "Isobaric Ideal-Gas Process",
            subtitle: "Calculate constant-pressure heat and work",
            category: .thermodynamics,
            symbolName: "arrow.up.and.down.and.arrow.left.and.right",
            keywords: [
                "isobaric process",
                "constant pressure",
                "ideal gas",
                "boundary work",
                "enthalpy change"
            ]
        ),
        destination: {
            IsobaricIdealGasProcessView()
        }
    )
}
