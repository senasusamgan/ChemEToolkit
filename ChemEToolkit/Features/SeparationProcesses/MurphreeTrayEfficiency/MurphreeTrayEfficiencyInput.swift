struct MurphreeTrayEfficiencyInput: Equatable, Sendable {
    let idealStageCount: Double
    let murphreeEfficiency: Double
    let traySpacing: Double
    let columnHeightSafetyFactor: Double
}
