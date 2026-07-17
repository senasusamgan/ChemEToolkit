struct LiquidReliefValveSizingInput:
    Equatable,
    Sendable {

    let requiredMassFlowRate:
        Double
    let liquidDensity: Double

    let inletAbsolutePressure:
        Double
    let backAbsolutePressure:
        Double

    let dischargeCoefficient:
        Double
}
