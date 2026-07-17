struct LiquidControlValveSizingInput: Equatable, Sendable {
    let liquidFlowRate: Double
    let pressureDrop: Double
    let liquidDensity: Double
    let installedValveKv: Double
    let designSafetyFactor: Double
}
