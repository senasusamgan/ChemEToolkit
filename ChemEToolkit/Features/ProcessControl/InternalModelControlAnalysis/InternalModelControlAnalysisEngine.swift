import Foundation

struct InternalModelControlAnalysisEngine:
    Sendable {

    func calculate(
        _ input:
            InternalModelControlAnalysisInput
    ) throws
        -> InternalModelControlAnalysisResult {

        let values = [
            input.actualProcessGain,
            input.actualTimeConstant,
            input.modelProcessGain,
            input.modelTimeConstant,
            input.modelDeadTime,
            input.filterTimeConstant,
            input.angularFrequency
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw InternalModelControlAnalysisError
                .nonFiniteInput
        }

        guard
            input.actualProcessGain != 0,
            input.modelProcessGain != 0
        else {
            throw InternalModelControlAnalysisError
                .zeroProcessGain
        }

        guard
            input.actualTimeConstant > 0,
            input.modelTimeConstant > 0,
            input.filterTimeConstant > 0
        else {
            throw InternalModelControlAnalysisError
                .nonPositiveTimeConstant
        }

        guard input.modelDeadTime >= 0 else {
            throw InternalModelControlAnalysisError
                .negativeDeadTime
        }

        guard input.angularFrequency >= 0 else {
            throw InternalModelControlAnalysisError
                .negativeAngularFrequency
        }

        let equivalentGain =
            input.modelTimeConstant
            / (
                input.modelProcessGain
                * (
                    input.filterTimeConstant
                    + input.modelDeadTime
                )
            )

        let equivalentIntegralTime =
            input.modelTimeConstant

        let numeratorMagnitude =
            (
                1
                + pow(
                    input.angularFrequency
                    * input.modelTimeConstant,
                    2
                )
            ).squareRoot()

        let denominatorMagnitude =
            abs(input.modelProcessGain)
            * (
                1
                + pow(
                    input.angularFrequency
                    * input.filterTimeConstant,
                    2
                )
            ).squareRoot()

        let controllerMagnitude =
            numeratorMagnitude
            / denominatorMagnitude

        let controllerPhase =
            (
                atan(
                    input.angularFrequency
                    * input.modelTimeConstant
                )
                - atan(
                    input.angularFrequency
                    * input.filterTimeConstant
                )
            )
            * 180
            / Double.pi

        let nominalMagnitude =
            1
            / (
                1
                + pow(
                    input.angularFrequency
                    * input.filterTimeConstant,
                    2
                )
            ).squareRoot()

        let nominalPhase =
            (
                -input.angularFrequency
                * input.modelDeadTime
                - atan(
                    input.angularFrequency
                    * input.filterTimeConstant
                )
            )
            * 180
            / Double.pi

        let gainMismatch =
            abs(
                (
                    input.modelProcessGain
                    - input.actualProcessGain
                )
                / input.actualProcessGain
            )

        let timeMismatch =
            abs(
                (
                    input.modelTimeConstant
                    - input.actualTimeConstant
                )
                / input.actualTimeConstant
            )

        let largestMismatch =
            max(
                gainMismatch,
                timeMismatch
            )

        let robustness: String

        if largestMismatch < 0.05 {
            robustness =
                "Close model match: nominal IMC behavior should be representative."
        } else if largestMismatch < 0.20 {
            robustness =
                "Moderate model mismatch: use a larger filter time constant for additional robustness."
        } else {
            robustness =
                "Large model mismatch: retune conservatively or update the internal process model."
        }

        let results = [
            equivalentGain,
            equivalentIntegralTime,
            controllerMagnitude,
            controllerPhase,
            nominalMagnitude,
            nominalPhase,
            gainMismatch,
            timeMismatch
        ]

        guard
            results.allSatisfy(\.isFinite),
            equivalentIntegralTime > 0,
            controllerMagnitude > 0,
            nominalMagnitude > 0,
            gainMismatch >= 0,
            timeMismatch >= 0
        else {
            throw InternalModelControlAnalysisError
                .numericalFailure
        }

        return .init(
            equivalentPIControllerGain:
                equivalentGain,
            equivalentPIIntegralTime:
                equivalentIntegralTime,
            imcControllerMagnitude:
                controllerMagnitude,
            imcControllerPhaseDegrees:
                controllerPhase,
            nominalClosedLoopMagnitude:
                nominalMagnitude,
            nominalClosedLoopPhaseDegrees:
                nominalPhase,
            gainMismatchFraction:
                gainMismatch,
            timeConstantMismatchFraction:
                timeMismatch,
            robustnessDescription:
                robustness,
            modelName:
                "First-order Internal Model Control with inverse model and first-order robustness filter",
            limitationDescription:
                "Uses an invertible first-order model and a first-order IMC filter. Nonminimum-phase zeros, unstable dynamics, actuator limits and full closed-loop simulation are not included."
        )
    }
}
