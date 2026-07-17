struct TurbineIsentropicEfficiencyResult: Equatable, Sendable {
    let isentropicEfficiency: Double
    let idealSpecificWork: Double
    let actualSpecificWork: Double
    let idealPower: Double
    let actualPower: Double
    let lostPowerPotential: Double
    let modelName: String
    let limitationDescription: String
}
