struct TankDrainResult:
    Equatable,
    Sendable {

    let drainTime: Double

    let initialExitVelocity: Double
    let finalExitVelocity: Double

    let initialFlowRate: Double
    let finalFlowRate: Double

    let tankCrossSectionalArea: Double
    let orificeArea: Double
    let dischargeCoefficient: Double

    var drainTimeMinutes: Double {
        drainTime / 60
    }

    var drainTimeHours: Double {
        drainTime / 3_600
    }

    var initialFlowRateLitresPerSecond:
        Double {
        initialFlowRate * 1_000
    }

    var finalFlowRateLitresPerSecond:
        Double {
        finalFlowRate * 1_000
    }

    var areaRatio: Double {
        tankCrossSectionalArea
        / orificeArea
    }
}
