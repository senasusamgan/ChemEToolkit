import Foundation

struct CatalystRegenerationCycleEngine:
    Sendable {

    private let wholeNumberTolerance =
        1.0e-10

    func calculate(
        _ input:
            CatalystRegenerationCycleInput
    ) throws
        -> CatalystRegenerationCycleResult {

        let values = [
            input.initialActivity,
            input.deactivationRateConstant,
            input.operatingTimePerCycle,
            input.regenerationRecoveryFraction,
            input.numberOfCycles
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw CatalystRegenerationCycleError
                .nonFiniteInput
        }

        guard
            input.initialActivity > 0,
            input.initialActivity <= 1
        else {
            throw CatalystRegenerationCycleError
                .initialActivityOutOfRange
        }

        guard
            input.deactivationRateConstant > 0
        else {
            throw CatalystRegenerationCycleError
                .nonPositiveRateConstant
        }

        guard
            input.operatingTimePerCycle > 0
        else {
            throw CatalystRegenerationCycleError
                .nonPositiveOperatingTime
        }

        guard
            input.regenerationRecoveryFraction >= 0,
            input.regenerationRecoveryFraction <= 1
        else {
            throw CatalystRegenerationCycleError
                .recoveryFractionOutOfRange
        }

        let roundedCycles =
            input.numberOfCycles.rounded()

        guard
            abs(
                input.numberOfCycles
                - roundedCycles
            ) <= wholeNumberTolerance,
            roundedCycles >= 1,
            roundedCycles <= 10_000
        else {
            throw CatalystRegenerationCycleError
                .invalidCycleCount
        }

        let cycles =
            Int(roundedCycles)

        let decayFactor =
            exp(
                -input.deactivationRateConstant
                * input.operatingTimePerCycle
            )

        var activity =
            input.initialActivity

        var startActivities: [Double] = []
        var endActivities: [Double] = []

        var minimumActivity =
            input.initialActivity

        var equivalentFullActivityTime =
            0.0

        for _ in 0..<cycles {
            startActivities.append(activity)

            let endActivity =
                activity
                * decayFactor

            endActivities.append(endActivity)

            minimumActivity =
                min(
                    minimumActivity,
                    endActivity
                )

            let activityIntegral =
                activity
                * (
                    1 - decayFactor
                )
                / input.deactivationRateConstant

            equivalentFullActivityTime +=
                activityIntegral

            activity =
                endActivity
                + input.regenerationRecoveryFraction
                * (
                    1 - endActivity
                )
        }

        let totalOperatingTime =
            Double(cycles)
            * input.operatingTimePerCycle

        let averageActivity =
            equivalentFullActivityTime
            / totalOperatingTime

        guard
            let finalBefore =
                endActivities.last
        else {
            throw CatalystRegenerationCycleError
                .numericalFailure
        }

        let finalAfter =
            activity

        let scalarResults = [
            finalBefore,
            finalAfter,
            minimumActivity,
            averageActivity,
            equivalentFullActivityTime,
            totalOperatingTime
        ]

        guard
            scalarResults
                .allSatisfy(\.isFinite),
            startActivities
                .allSatisfy(\.isFinite),
            endActivities
                .allSatisfy(\.isFinite),
            finalBefore >= 0,
            finalBefore <= 1,
            finalAfter >= 0,
            finalAfter <= 1,
            minimumActivity >= 0,
            averageActivity >= 0,
            averageActivity <= 1,
            equivalentFullActivityTime >= 0,
            totalOperatingTime > 0
        else {
            throw CatalystRegenerationCycleError
                .numericalFailure
        }

        return .init(
            numberOfCycles:
                cycles,
            finalActivityBeforeRegeneration:
                finalBefore,
            finalActivityAfterRegeneration:
                finalAfter,
            minimumActivityObserved:
                minimumActivity,
            averageOperatingActivity:
                averageActivity,
            equivalentFullActivityOperatingTime:
                equivalentFullActivityTime,
            totalCalendarOperatingTime:
                totalOperatingTime,
            activityAtStartOfEachCycle:
                startActivities,
            activityBeforeEachRegeneration:
                endActivities,
            modelName:
                "Repeated first-order deactivation with fractional regeneration toward fresh activity",
            limitationDescription:
                "Each operating period follows a = a_start exp(−k_d t). Regeneration restores a fixed fraction of the lost activity toward one and has no modeled downtime, cost or irreversible capacity loss."
        )
    }
}
