struct PackedColumnHTUNTUDesignInput: Equatable, Sendable {
    let soluteFreeGasFlowRate: Double
    let soluteFreeLiquidFlowRate: Double
    let equilibriumSlope: Double
    let gasInletSoluteRatio: Double
    let gasOutletSoluteRatio: Double
    let liquidInletSoluteRatio: Double
    let overallGasHeightOfTransferUnit: Double
}
