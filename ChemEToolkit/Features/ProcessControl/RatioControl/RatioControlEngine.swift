struct RatioControlEngine:
    Sendable {

    private let zeroTolerance =
        1e-14

    func calculate(
        _ input:
            RatioControlInput
    ) throws
        -> RatioControlResult {

        let values = [
            input.wildStreamFlow,
            input.desiredFlowRatio,
            input.trimBias,
            input.minimumControlledFlow,
            input.maximumControlledFlow,
            input.measuredControlledFlow
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw RatioControlError
                .nonFiniteInput
        }

        guard input.wildStreamFlow >= 0 else {
            throw RatioControlError
                .negativeWildStreamFlow
        }

        guard input.desiredFlowRatio >= 0 else {
            throw RatioControlError
                .negativeDesiredRatio
        }

        guard
            input.minimumControlledFlow >= 0,
            input.minimumControlledFlow
            < input.maximumControlledFlow
        else {
            throw RatioControlError
                .invalidFlowLimits
        }

        guard
            input.measuredControlledFlow >= 0
        else {
            throw RatioControlError
                .negativeMeasuredControlledFlow
        }

        let idealSetpoint =
            input.desiredFlowRatio
            * input.wildStreamFlow

        let requestedSetpoint =
            idealSetpoint
            + input.trimBias

        let appliedSetpoint =
            min(
                input.maximumControlledFlow,
                max(
                    input.minimumControlledFlow,
                    requestedSetpoint
                )
            )

        let measuredRatio: Double?
        let ratioError: Double?

        if input.wildStreamFlow
            > zeroTolerance {
            measuredRatio =
                input.measuredControlledFlow
                / input.wildStreamFlow

            ratioError =
                input.desiredFlowRatio
                - measuredRatio!
        } else {
            measuredRatio = nil
            ratioError = nil
        }

        let controlledFlowError =
            appliedSetpoint
            - input.measuredControlledFlow

        let limitingAmount =
            appliedSetpoint
            - requestedSetpoint

        let results = [
            idealSetpoint,
            requestedSetpoint,
            appliedSetpoint,
            controlledFlowError,
            limitingAmount
        ]

        guard
            results.allSatisfy(\.isFinite),
            appliedSetpoint
                >= input.minimumControlledFlow,
            appliedSetpoint
                <= input.maximumControlledFlow
        else {
            throw RatioControlError
                .numericalFailure
        }

        if let measuredRatio {
            guard measuredRatio.isFinite else {
                throw RatioControlError
                    .numericalFailure
            }
        }

        if let ratioError {
            guard ratioError.isFinite else {
                throw RatioControlError
                    .numericalFailure
            }
        }

        return .init(
            idealControlledFlowSetpoint:
                idealSetpoint,
            requestedControlledFlowSetpoint:
                requestedSetpoint,
            appliedControlledFlowSetpoint:
                appliedSetpoint,
            measuredFlowRatio:
                measuredRatio,
            ratioError:
                ratioError,
            controlledFlowError:
                controlledFlowError,
            setpointWasLimited:
                appliedSetpoint
                != requestedSetpoint,
            limitingAmount:
                limitingAmount,
            modelName:
                "Ratio station: F_controlled,SP = R·F_wild + trim",
            limitationDescription:
                "Assumes both flow measurements use compatible units and dynamics. A downstream flow controller is still required to make the controlled stream follow this calculated setpoint."
        )
    }
}
