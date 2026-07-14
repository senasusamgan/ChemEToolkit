import Foundation

struct FroudeNumberEngine {

    func solve(
        input: FroudeNumberInput
    ) throws -> FroudeNumberResult {

        try validate(input)

        let gravityWaveCelerity =
            sqrt(
                input.gravity
                * input.hydraulicDepth
            )

        let froudeNumber =
            input.averageVelocity
            / gravityWaveCelerity

        guard
            gravityWaveCelerity.isFinite,
            froudeNumber.isFinite
        else {
            throw FroudeNumberError
                .nonFiniteResult
        }

        return FroudeNumberResult(
            froudeNumber:
                froudeNumber,
            flowRegime:
                OpenChannelFlowRegime
                    .classify(
                        froudeNumber:
                            froudeNumber
                    ),
            averageVelocity:
                input.averageVelocity,
            hydraulicDepth:
                input.hydraulicDepth,
            gravityWaveCelerity:
                gravityWaveCelerity
        )
    }

    private func validate(
        _ input: FroudeNumberInput
    ) throws {

        guard
            input.averageVelocity.isFinite,
            input.averageVelocity >= 0
        else {
            throw FroudeNumberError
                .invalidVelocity
        }

        guard
            input.hydraulicDepth.isFinite,
            input.hydraulicDepth > 0
        else {
            throw FroudeNumberError
                .invalidHydraulicDepth
        }

        guard
            input.gravity.isFinite,
            input.gravity > 0
        else {
            throw FroudeNumberError
                .invalidGravity
        }
    }
}
