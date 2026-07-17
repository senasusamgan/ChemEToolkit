struct PumpIsentropicEfficiencyInput: Equatable, Sendable {
    let massFlowRate: Double
    let inletAbsolutePressure: Double
    let outletAbsolutePressure: Double
    let specificVolume: Double
    let isentropicEfficiency: Double
}
