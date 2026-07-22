import SwiftUI

enum NumericalJacobianModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .numericalJacobian,
            title: "Numerical Jacobian",
            subtitle: "Central-difference Jacobian for supported nonlinear systems.",
            category: .numericalMethods,
            symbolName: "scope",
            keywords: ["numerical methods", "differential equations", "numerical jacobian"]
        ),
        destination: {
            NumericalJacobianView()
        }
    )
}
