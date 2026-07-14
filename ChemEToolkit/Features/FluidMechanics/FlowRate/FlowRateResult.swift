struct FlowRateResult:
    Equatable,
    Sendable {

    let diameter: Double
    let averageVelocity: Double
    let density: Double

    let crossSectionalArea: Double
    let volumetricFlowRate: Double
    let massFlowRate: Double

    var litresPerSecond: Double {
        volumetricFlowRate * 1_000
    }

    var cubicMetresPerHour: Double {
        volumetricFlowRate * 3_600
    }
}
