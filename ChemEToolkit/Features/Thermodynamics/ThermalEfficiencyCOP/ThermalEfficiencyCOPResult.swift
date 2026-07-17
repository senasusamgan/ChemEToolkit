struct ThermalEfficiencyCOPResult: Equatable, Sendable {
    let netWork: Double
    let heatEngineEfficiency: Double
    let refrigeratorCOP: Double
    let heatPumpCOP: Double
    let rejectedHeatFraction: Double
    let performanceDescription: String
    let modelName: String
    let limitationDescription: String
}
