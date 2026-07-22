struct GainSchedulingEngine:
    Sendable {

    func calculate(
        _ input:
            GainSchedulingInput
    ) throws
        -> GainSchedulingResult {

        let values = [
            input.operatingPoint,
            input.lowerOperatingPoint,
            input.upperOperatingPoint,
            input.lowerControllerGain,
            input.upperControllerGain,
            input.lowerIntegralTime,
            input.upperIntegralTime,
            input.lowerDerivativeTime,
            input.upperDerivativeTime
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw GainSchedulingError
                .nonFiniteInput
        }

        guard
            input.lowerOperatingPoint
            < input.upperOperatingPoint
        else {
            throw GainSchedulingError
                .invalidOperatingRange
        }

        guard
            input.operatingPoint
                >= input.lowerOperatingPoint,
            input.operatingPoint
                <= input.upperOperatingPoint
        else {
            throw GainSchedulingError
                .operatingPointOutsideSchedule
        }

        guard
            input.lowerIntegralTime > 0,
            input.upperIntegralTime > 0
        else {
            throw GainSchedulingError
                .nonPositiveIntegralTime
        }

        guard
            input.lowerDerivativeTime >= 0,
            input.upperDerivativeTime >= 0
        else {
            throw GainSchedulingError
                .negativeDerivativeTime
        }

        let span =
            input.upperOperatingPoint
            - input.lowerOperatingPoint

        let fraction =
            (
                input.operatingPoint
                - input.lowerOperatingPoint
            )
            / span

        let scheduledGain =
            input.lowerControllerGain
            + fraction
            * (
                input.upperControllerGain
                - input.lowerControllerGain
            )

        let scheduledIntegral =
            input.lowerIntegralTime
            + fraction
            * (
                input.upperIntegralTime
                - input.lowerIntegralTime
            )

        let scheduledDerivative =
            input.lowerDerivativeTime
            + fraction
            * (
                input.upperDerivativeTime
                - input.lowerDerivativeTime
            )

        let gainSlope =
            (
                input.upperControllerGain
                - input.lowerControllerGain
            )
            / span

        let integralSlope =
            (
                input.upperIntegralTime
                - input.lowerIntegralTime
            )
            / span

        let derivativeSlope =
            (
                input.upperDerivativeTime
                - input.lowerDerivativeTime
            )
            / span

        let nearest: String

        if fraction < 0.5 {
            nearest =
                "Closer to the lower operating-region tuning."
        } else if fraction > 0.5 {
            nearest =
                "Closer to the upper operating-region tuning."
        } else {
            nearest =
                "Exactly midway between both tuning regions."
        }

        let transition: String

        if fraction < 0.1
            || fraction > 0.9 {
            transition =
                "Operating near a schedule endpoint."
        } else {
            transition =
                "Operating within the interpolation region."
        }

        let results = [
            fraction,
            scheduledGain,
            scheduledIntegral,
            scheduledDerivative,
            gainSlope,
            integralSlope,
            derivativeSlope
        ]

        guard
            results.allSatisfy(\.isFinite),
            fraction >= 0,
            fraction <= 1,
            scheduledIntegral > 0,
            scheduledDerivative >= 0
        else {
            throw GainSchedulingError
                .numericalFailure
        }

        return .init(
            interpolationFraction:
                fraction,
            scheduledControllerGain:
                scheduledGain,
            scheduledIntegralTime:
                scheduledIntegral,
            scheduledDerivativeTime:
                scheduledDerivative,
            controllerGainSlope:
                gainSlope,
            integralTimeSlope:
                integralSlope,
            derivativeTimeSlope:
                derivativeSlope,
            nearestScheduleRegion:
                nearest,
            transitionDescription:
                transition,
            modelName:
                "Linear interpolation between two PID tuning schedules",
            limitationDescription:
                "Assumes smooth parameter variation between two validated operating points. Real gain scheduling must also manage mode switching, bumpless transfer, hysteresis and stability across the full operating envelope."
        )
    }
}
