struct DifferentialPressureFlowResult:
    Equatable,
    Sendable {

    let meterType:
        DifferentialPressureMeterType

    let upstreamArea: Double
    let restrictionArea: Double

    let betaRatio: Double
    let areaRatio: Double

    let pressureDifference: Double

    let idealVolumetricFlowRate: Double
    let volumetricFlowRate: Double
    let massFlowRate: Double

    let upstreamVelocity: Double
    let restrictionVelocity: Double

    let dischargeCoefficient: Double

    var volumetricFlowRateLitresPerSecond:
        Double {
        volumetricFlowRate * 1_000
    }

    var volumetricFlowRatePerHour:
        Double {
        volumetricFlowRate * 3_600
    }

    var pressureDifferenceKilopascals:
        Double {
        pressureDifference / 1_000
    }
}
