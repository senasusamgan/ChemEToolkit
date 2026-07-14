import Foundation

struct DifferentialPressureFlowEngine {

    func solve(
        input:
            DifferentialPressureFlowInput
    ) throws
        -> DifferentialPressureFlowResult {

        try validate(input)

        let upstreamArea =
            Double.pi
            * input.upstreamDiameter
            * input.upstreamDiameter
            / 4

        let restrictionArea =
            Double.pi
            * input.restrictionDiameter
            * input.restrictionDiameter
            / 4

        let betaRatio =
            input.restrictionDiameter
            / input.upstreamDiameter

        let areaRatio =
            restrictionArea
            / upstreamArea

        let denominator =
            input.fluidDensity
            * (
                1
                - pow(betaRatio, 4)
            )

        let idealVolumetricFlowRate =
            restrictionArea
            * sqrt(
                2
                * input.pressureDifference
                / denominator
            )

        let volumetricFlowRate =
            input.dischargeCoefficient
            * idealVolumetricFlowRate

        let massFlowRate =
            input.fluidDensity
            * volumetricFlowRate

        let upstreamVelocity =
            volumetricFlowRate
            / upstreamArea

        let restrictionVelocity =
            volumetricFlowRate
            / restrictionArea

        guard
            upstreamArea.isFinite,
            restrictionArea.isFinite,
            betaRatio.isFinite,
            areaRatio.isFinite,
            denominator.isFinite,
            denominator > 0,
            idealVolumetricFlowRate.isFinite,
            volumetricFlowRate.isFinite,
            massFlowRate.isFinite,
            upstreamVelocity.isFinite,
            restrictionVelocity.isFinite
        else {
            throw DifferentialPressureFlowError
                .nonFiniteResult
        }

        return DifferentialPressureFlowResult(
            meterType:
                input.meterType,
            upstreamArea:
                upstreamArea,
            restrictionArea:
                restrictionArea,
            betaRatio:
                betaRatio,
            areaRatio:
                areaRatio,
            pressureDifference:
                input.pressureDifference,
            idealVolumetricFlowRate:
                idealVolumetricFlowRate,
            volumetricFlowRate:
                volumetricFlowRate,
            massFlowRate:
                massFlowRate,
            upstreamVelocity:
                upstreamVelocity,
            restrictionVelocity:
                restrictionVelocity,
            dischargeCoefficient:
                input.dischargeCoefficient
        )
    }

    private func validate(
        _ input:
            DifferentialPressureFlowInput
    ) throws {

        guard
            input.fluidDensity.isFinite,
            input.fluidDensity > 0
        else {
            throw DifferentialPressureFlowError
                .invalidFluidDensity
        }

        guard
            input.upstreamDiameter.isFinite,
            input.upstreamDiameter > 0
        else {
            throw DifferentialPressureFlowError
                .invalidUpstreamDiameter
        }

        guard
            input.restrictionDiameter
                .isFinite,
            input.restrictionDiameter > 0
        else {
            throw DifferentialPressureFlowError
                .invalidRestrictionDiameter
        }

        guard
            input.restrictionDiameter
                < input.upstreamDiameter
        else {
            throw DifferentialPressureFlowError
                .restrictionMustBeSmaller
        }

        guard
            input.pressureDifference.isFinite,
            input.pressureDifference >= 0
        else {
            throw DifferentialPressureFlowError
                .invalidPressureDifference
        }

        guard
            input.dischargeCoefficient
                .isFinite,
            input.dischargeCoefficient > 0,
            input.dischargeCoefficient <= 1
        else {
            throw DifferentialPressureFlowError
                .invalidDischargeCoefficient
        }
    }
}
