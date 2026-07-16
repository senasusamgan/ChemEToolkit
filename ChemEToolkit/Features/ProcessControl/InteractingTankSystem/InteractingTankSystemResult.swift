struct InteractingTankSystemResult:
    Equatable,
    Sendable {

    let denominatorQuadraticCoefficient:
        Double
    let denominatorLinearCoefficient:
        Double

    let naturalFrequency: Double
    let dampingRatio: Double
    let dampingRegime: String

    let normalizedOutletResponse:
        Double
    let outletLevelChange: Double
    let finalOutletLevelChange:
        Double
    let finalFirstTankLevelChange:
        Double

    let slowPole: Double
    let fastPole: Double

    let modelName: String
    let limitationDescription: String
}
