enum GasAbsorptionStrippingOperation: String, CaseIterable, Identifiable, Equatable, Sendable {
    case absorption
    case stripping

    var id: Self { self }

    var title: String {
        switch self {
        case .absorption: "Absorption"
        case .stripping: "Stripping"
        }
    }
}

struct GasAbsorptionStrippingFundamentalsInput: Equatable, Sendable {
    let operation: GasAbsorptionStrippingOperation
    let soluteFreeGasFlowRate: Double
    let soluteFreeLiquidFlowRate: Double
    let gasInletSoluteRatio: Double
    let gasOutletSoluteRatio: Double
    let liquidInletSoluteRatio: Double
    let equilibriumSlope: Double
}
