import Foundation

struct EmergencyVentilationDilutionEngine:
    Sendable {

    func calculate(
        _ input:
            EmergencyVentilationDilutionInput
    ) throws
        -> EmergencyVentilationDilutionResult {

        let values = [
            input.enclosureVolume,
            input.ventilationFlowRate,
            input.initialConcentration,
            input.targetConcentration,
            input.elapsedTime
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw EmergencyVentilationDilutionError
                .nonFiniteInput
        }

        guard input.enclosureVolume > 0 else {
            throw EmergencyVentilationDilutionError
                .nonPositiveVolume
        }

        guard input.ventilationFlowRate > 0 else {
            throw EmergencyVentilationDilutionError
                .nonPositiveVentilationFlow
        }

        guard
            input.initialConcentration > 0,
            input.targetConcentration > 0,
            input.targetConcentration
                < input.initialConcentration
        else {
            throw EmergencyVentilationDilutionError
                .invalidConcentration
        }

        guard input.elapsedTime >= 0 else {
            throw EmergencyVentilationDilutionError
                .negativeElapsedTime
        }

        let airChangesPerSecond =
            input.ventilationFlowRate
            / input.enclosureVolume

        let airChangesPerHour =
            airChangesPerSecond
            * 3_600

        let timeConstant =
            1 / airChangesPerSecond

        let concentrationAfterTime =
            input.initialConcentration
            * exp(
                -airChangesPerSecond
                * input.elapsedTime
            )

        let timeToTarget =
            log(
                input.initialConcentration
                / input.targetConcentration
            )
            / airChangesPerSecond

        let removalFraction =
            1
            - concentrationAfterTime
                / input.initialConcentration

        let results = [
            airChangesPerHour,
            timeConstant,
            concentrationAfterTime,
            timeToTarget,
            removalFraction
        ]

        guard
            results.allSatisfy(\.isFinite),
            airChangesPerHour > 0,
            timeConstant > 0,
            concentrationAfterTime >= 0,
            timeToTarget > 0,
            removalFraction >= 0,
            removalFraction <= 1
        else {
            throw EmergencyVentilationDilutionError
                .numericalFailure
        }

        return .init(
            airChangesPerHour:
                airChangesPerHour,
            dilutionTimeConstant:
                timeConstant,
            concentrationAfterElapsedTime:
                concentrationAfterTime,
            timeToTargetConcentration:
                timeToTarget,
            removalFractionAfterElapsedTime:
                removalFraction,
            targetReachedWithinElapsedTime:
                input.elapsedTime
                >= timeToTarget,
            modelName:
                "Well-mixed exponential ventilation dilution",
            limitationDescription:
                "Assumes perfect mixing, constant clean-air flow and no continuing release, adsorption, reaction, stratification or dead zones. Real emergency ventilation performance should be verified by engineering analysis."
        )
    }
}
