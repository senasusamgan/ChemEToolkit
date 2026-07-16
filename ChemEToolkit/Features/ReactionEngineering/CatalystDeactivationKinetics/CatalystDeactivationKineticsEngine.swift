import Foundation

struct CatalystDeactivationKineticsEngine:
    Sendable {

    private let firstOrderTolerance =
        1.0e-10

    func calculate(
        _ input:
            CatalystDeactivationKineticsInput
    ) throws
        -> CatalystDeactivationKineticsResult {

        let values = [
            input.initialActivity,
            input.deactivationRateConstant,
            input.deactivationOrder,
            input.elapsedTime,
            input.targetActivity
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw CatalystDeactivationKineticsError
                .nonFiniteInput
        }

        guard
            input.initialActivity > 0,
            input.initialActivity <= 1
        else {
            throw CatalystDeactivationKineticsError
                .initialActivityOutOfRange
        }

        guard
            input.deactivationRateConstant > 0
        else {
            throw CatalystDeactivationKineticsError
                .nonPositiveRateConstant
        }

        guard
            input.deactivationOrder >= 0,
            input.deactivationOrder <= 2
        else {
            throw CatalystDeactivationKineticsError
                .deactivationOrderOutOfRange
        }

        guard input.elapsedTime >= 0 else {
            throw CatalystDeactivationKineticsError
                .negativeElapsedTime
        }

        guard
            input.targetActivity > 0,
            input.targetActivity
                < input.initialActivity
        else {
            throw CatalystDeactivationKineticsError
                .targetActivityOutOfRange
        }

        func activity(
            at time: Double
        ) -> Double {
            if abs(
                input.deactivationOrder - 1
            ) <= firstOrderTolerance {
                return input.initialActivity
                * exp(
                    -input.deactivationRateConstant
                    * time
                )
            }

            let transformed =
                pow(
                    input.initialActivity,
                    1 - input.deactivationOrder
                )
                - (
                    1 - input.deactivationOrder
                )
                * input.deactivationRateConstant
                * time

            if transformed <= 0 {
                return 0
            }

            return pow(
                transformed,
                1
                / (
                    1 - input.deactivationOrder
                )
            )
        }

        func time(
            to target: Double
        ) -> Double {
            if abs(
                input.deactivationOrder - 1
            ) <= firstOrderTolerance {
                return log(
                    input.initialActivity
                    / target
                )
                / input.deactivationRateConstant
            }

            return (
                pow(
                    input.initialActivity,
                    1 - input.deactivationOrder
                )
                - pow(
                    target,
                    1 - input.deactivationOrder
                )
            )
            / (
                (
                    1 - input.deactivationOrder
                )
                * input.deactivationRateConstant
            )
        }

        let currentActivity =
            activity(
                at: input.elapsedTime
            )

        let targetTime =
            time(
                to: input.targetActivity
            )

        let halfTime =
            time(
                to:
                    0.5
                    * input.initialActivity
            )

        let extinctionTime: Double?

        if input.deactivationOrder < 1
            - firstOrderTolerance {
            extinctionTime =
                pow(
                    input.initialActivity,
                    1 - input.deactivationOrder
                )
                / (
                    (
                        1 - input.deactivationOrder
                    )
                    * input.deactivationRateConstant
                )
        } else {
            extinctionTime = nil
        }

        let retainedPercent =
            100
            * currentActivity
            / input.initialActivity

        let lostFraction =
            1
            - currentActivity
            / input.initialActivity

        let results = [
            currentActivity,
            retainedPercent,
            lostFraction,
            targetTime,
            halfTime
        ]

        guard
            results.allSatisfy(\.isFinite),
            currentActivity >= 0,
            currentActivity
                <= input.initialActivity,
            retainedPercent >= 0,
            retainedPercent <= 100,
            lostFraction >= 0,
            lostFraction <= 1,
            targetTime > 0,
            halfTime > 0
        else {
            throw CatalystDeactivationKineticsError
                .numericalFailure
        }

        if let extinctionTime {
            guard
                extinctionTime.isFinite,
                extinctionTime > 0
            else {
                throw CatalystDeactivationKineticsError
                    .numericalFailure
            }
        }

        return .init(
            currentActivity:
                currentActivity,
            retainedActivityPercent:
                retainedPercent,
            lostActivityFraction:
                lostFraction,
            timeToTargetActivity:
                targetTime,
            timeToHalfInitialActivity:
                halfTime,
            targetAlreadyPassed:
                input.elapsedTime >= targetTime,
            finiteExtinctionTime:
                extinctionTime,
            modelName:
                "Power-law catalyst deactivation: −da/dt = k_d aᵐ",
            limitationDescription:
                "Supports constant deactivation order from zero through two at constant temperature. It does not distinguish poisoning, fouling, sintering or coke deposition mechanisms."
        )
    }
}
