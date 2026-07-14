import Foundation

struct TankDrainEngine {

    func solve(
        input: TankDrainInput
    ) throws -> TankDrainResult {

        try validate(input)

        let initialExitVelocity =
            sqrt(
                2
                * input.gravity
                * input.initialLiquidHeight
            )

        let finalExitVelocity =
            sqrt(
                2
                * input.gravity
                * input.finalLiquidHeight
            )

        let initialFlowRate =
            input.dischargeCoefficient
            * input.orificeArea
            * initialExitVelocity

        let finalFlowRate =
            input.dischargeCoefficient
            * input.orificeArea
            * finalExitVelocity

        let denominator =
            input.dischargeCoefficient
            * input.orificeArea
            * sqrt(2 * input.gravity)

        let drainTime =
            2
            * input.tankCrossSectionalArea
            / denominator
            * (
                sqrt(
                    input.initialLiquidHeight
                )
                - sqrt(
                    input.finalLiquidHeight
                )
            )

        guard
            initialExitVelocity.isFinite,
            finalExitVelocity.isFinite,
            initialFlowRate.isFinite,
            finalFlowRate.isFinite,
            drainTime.isFinite,
            drainTime >= 0
        else {
            throw TankDrainError
                .nonFiniteResult
        }

        return TankDrainResult(
            drainTime: drainTime,
            initialExitVelocity:
                initialExitVelocity,
            finalExitVelocity:
                finalExitVelocity,
            initialFlowRate:
                initialFlowRate,
            finalFlowRate:
                finalFlowRate,
            tankCrossSectionalArea:
                input.tankCrossSectionalArea,
            orificeArea:
                input.orificeArea,
            dischargeCoefficient:
                input.dischargeCoefficient
        )
    }

    private func validate(
        _ input: TankDrainInput
    ) throws {

        guard
            input.tankCrossSectionalArea
                .isFinite,
            input.tankCrossSectionalArea > 0
        else {
            throw TankDrainError
                .invalidTankArea
        }

        guard
            input.orificeArea.isFinite,
            input.orificeArea > 0
        else {
            throw TankDrainError
                .invalidOrificeArea
        }

        guard
            input.orificeArea
                < input.tankCrossSectionalArea
        else {
            throw TankDrainError
                .orificeAreaExceedsTankArea
        }

        guard
            input.dischargeCoefficient
                .isFinite,
            input.dischargeCoefficient > 0,
            input.dischargeCoefficient <= 1
        else {
            throw TankDrainError
                .invalidDischargeCoefficient
        }

        guard
            input.initialLiquidHeight
                .isFinite,
            input.initialLiquidHeight >= 0
        else {
            throw TankDrainError
                .invalidInitialHeight
        }

        guard
            input.finalLiquidHeight
                .isFinite,
            input.finalLiquidHeight >= 0
        else {
            throw TankDrainError
                .invalidFinalHeight
        }

        guard
            input.finalLiquidHeight
                <= input.initialLiquidHeight
        else {
            throw TankDrainError
                .finalHeightExceedsInitialHeight
        }

        guard
            input.gravity.isFinite,
            input.gravity > 0
        else {
            throw TankDrainError
                .invalidGravity
        }
    }
}
