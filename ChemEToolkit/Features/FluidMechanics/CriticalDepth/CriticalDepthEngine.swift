import Foundation

struct CriticalDepthEngine {

    func solve(
        input: CriticalDepthInput
    ) throws -> CriticalDepthResult {

        try validate(input)

        let flowRate =
            input.volumetricFlowRate

        let width =
            input.channelWidth

        let gravity =
            input.gravity

        let criticalDepth =
            pow(
                flowRate * flowRate
                / (
                    gravity
                    * width
                    * width
                ),
                1.0 / 3.0
            )

        let criticalArea =
            width * criticalDepth

        let criticalVelocity =
            flowRate / criticalArea

        let minimumSpecificEnergy =
            criticalDepth
            + criticalVelocity
            * criticalVelocity
            / (2 * gravity)

        let currentArea =
            width
            * input.currentFlowDepth

        let currentVelocity =
            flowRate / currentArea

        let currentSpecificEnergy =
            input.currentFlowDepth
            + currentVelocity
            * currentVelocity
            / (2 * gravity)

        let currentFroudeNumber =
            currentVelocity
            / sqrt(
                gravity
                * input.currentFlowDepth
            )

        let flowRegime =
            OpenChannelFlowRegime
                .classify(
                    froudeNumber:
                        currentFroudeNumber
                )

        guard
            criticalDepth.isFinite,
            criticalVelocity.isFinite,
            minimumSpecificEnergy.isFinite,
            currentVelocity.isFinite,
            currentSpecificEnergy.isFinite,
            currentFroudeNumber.isFinite
        else {
            throw CriticalDepthError
                .nonFiniteResult
        }

        return CriticalDepthResult(
            criticalDepth:
                criticalDepth,
            criticalVelocity:
                criticalVelocity,
            minimumSpecificEnergy:
                minimumSpecificEnergy,
            currentDepth:
                input.currentFlowDepth,
            currentVelocity:
                currentVelocity,
            currentSpecificEnergy:
                currentSpecificEnergy,
            currentFroudeNumber:
                currentFroudeNumber,
            flowRegime:
                flowRegime,
            volumetricFlowRate:
                flowRate,
            channelWidth:
                width
        )
    }

    private func validate(
        _ input: CriticalDepthInput
    ) throws {

        guard
            input.volumetricFlowRate
                .isFinite,
            input.volumetricFlowRate > 0
        else {
            throw CriticalDepthError
                .invalidFlowRate
        }

        guard
            input.channelWidth.isFinite,
            input.channelWidth > 0
        else {
            throw CriticalDepthError
                .invalidChannelWidth
        }

        guard
            input.currentFlowDepth
                .isFinite,
            input.currentFlowDepth > 0
        else {
            throw CriticalDepthError
                .invalidCurrentDepth
        }

        guard
            input.gravity.isFinite,
            input.gravity > 0
        else {
            throw CriticalDepthError
                .invalidGravity
        }
    }
}
