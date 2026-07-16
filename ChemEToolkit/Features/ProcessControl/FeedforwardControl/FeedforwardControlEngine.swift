struct FeedforwardControlEngine: Sendable {
    private let zeroTolerance = 1e-14

    func calculate(
        _ input: FeedforwardControlInput
    ) throws -> FeedforwardControlResult {

        let values = [
            input.manipulatedPathGain,
            input.disturbancePathGain,
            input.measuredDisturbanceChange,
            input.controllerBias,
            input.minimumControllerOutput,
            input.maximumControllerOutput
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw FeedforwardControlError.nonFiniteInput
        }

        guard input.manipulatedPathGain != 0 else {
            throw FeedforwardControlError.zeroManipulatedPathGain
        }

        guard
            input.minimumControllerOutput
            < input.maximumControllerOutput
        else {
            throw FeedforwardControlError.invalidControllerLimits
        }

        let uncompensated =
            input.disturbancePathGain
            * input.measuredDisturbanceChange

        let idealChange =
            -uncompensated
            / input.manipulatedPathGain

        let requested =
            input.controllerBias
            + idealChange

        let applied =
            min(
                input.maximumControllerOutput,
                max(
                    input.minimumControllerOutput,
                    requested
                )
            )

        let actualChange =
            applied
            - input.controllerBias

        let residual =
            input.manipulatedPathGain
            * actualChange
            + uncompensated

        let cancellation: Double

        if abs(uncompensated) <= zeroTolerance {
            cancellation = 1
        } else {
            cancellation =
                1
                - abs(residual)
                / abs(uncompensated)
        }

        let results = [
            idealChange,
            requested,
            applied,
            actualChange,
            uncompensated,
            residual,
            cancellation
        ]

        guard
            results.allSatisfy(\.isFinite),
            applied >= input.minimumControllerOutput,
            applied <= input.maximumControllerOutput
        else {
            throw FeedforwardControlError.numericalFailure
        }

        return .init(
            idealManipulatedVariableChange: idealChange,
            requestedControllerOutput: requested,
            appliedControllerOutput: applied,
            appliedManipulatedVariableChange: actualChange,
            uncompensatedOutputChange: uncompensated,
            residualOutputChange: residual,
            cancellationFraction: cancellation,
            controllerIsSaturated:
                requested != applied,
            modelName:
                "Steady-state feedforward compensation: Δu_ff = −(K_d/K_u)Δd",
            limitationDescription:
                "Assumes measured disturbance, known steady-state path gains and matched dynamics. Pure feedforward action cannot correct unmeasured disturbances or model error."
        )
    }
}
