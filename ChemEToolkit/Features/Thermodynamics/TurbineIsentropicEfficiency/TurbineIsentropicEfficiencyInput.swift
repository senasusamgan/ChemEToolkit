struct TurbineIsentropicEfficiencyInput: Equatable, Sendable {
    let massFlowRate: Double
    let inletEnthalpy: Double
    let isentropicOutletEnthalpy: Double
    let actualOutletEnthalpy: Double
}
