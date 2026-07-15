import Foundation

struct DryingRateTimeEngine:
    Sendable {

    private let tolerance =
        1.0e-12

    func calculate(
        _ input: DryingRateTimeInput
    ) throws -> DryingRateTimeResult {

        let values = [
            input.drySolidMass,
            input.dryingArea,
            input.constantDryingFlux,
            input.initialMoistureContent,
            input.criticalMoistureContent,
            input.equilibriumMoistureContent,
            input.finalMoistureContent
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw DryingRateTimeError
                .nonFiniteInput
        }

        guard
            input.drySolidMass > 0,
            input.dryingArea > 0,
            input.constantDryingFlux > 0
        else {
            throw DryingRateTimeError
                .nonPositiveProperty
        }

        guard
            input.initialMoistureContent >= 0,
            input.criticalMoistureContent >= 0,
            input.equilibriumMoistureContent >= 0,
            input.finalMoistureContent >= 0
        else {
            throw DryingRateTimeError
                .negativeMoistureContent
        }

        guard
            input.initialMoistureContent
            > input.finalMoistureContent,
            input.criticalMoistureContent
            > input.equilibriumMoistureContent
        else {
            throw DryingRateTimeError
                .invalidMoistureOrdering
        }

        guard
            input.finalMoistureContent
            > input.equilibriumMoistureContent
            + tolerance
        else {
            throw DryingRateTimeError
                .finalAtOrBelowEquilibrium
        }

        let timeFactor =
            input.drySolidMass
            / (
                input.dryingArea
                * input.constantDryingFlux
            )

        let constantStart =
            max(
                input.initialMoistureContent,
                input.criticalMoistureContent
            )

        let constantEnd =
            max(
                input.finalMoistureContent,
                input.criticalMoistureContent
            )

        let constantMoistureRemoved =
            max(
                0,
                constantStart - constantEnd
            )

        let constantRateTime =
            timeFactor
            * constantMoistureRemoved

        let fallingStart =
            min(
                input.initialMoistureContent,
                input.criticalMoistureContent
            )

        let fallingEnd =
            min(
                input.finalMoistureContent,
                input.criticalMoistureContent
            )

        let fallingMoistureRemoved =
            max(
                0,
                fallingStart - fallingEnd
            )

        let fallingRateTime: Double

        if fallingMoistureRemoved
            <= tolerance {

            fallingRateTime = 0
        } else {
            let numerator =
                fallingStart
                - input.equilibriumMoistureContent

            let denominator =
                fallingEnd
                - input.equilibriumMoistureContent

            guard
                numerator > 0,
                denominator > 0,
                numerator >= denominator
            else {
                throw DryingRateTimeError
                    .numericalFailure
            }

            fallingRateTime =
                timeFactor
                * (
                    input.criticalMoistureContent
                    - input.equilibriumMoistureContent
                )
                * log(numerator / denominator)
        }

        let totalDryingTime =
            constantRateTime
            + fallingRateTime

        let removedMoistureMass =
            input.drySolidMass
            * (
                input.initialMoistureContent
                - input.finalMoistureContent
            )

        let averageDryingFlux =
            removedMoistureMass
            / (
                input.dryingArea
                * totalDryingTime
            )

        let finalDryingFlux: Double

        if input.finalMoistureContent
            >= input.criticalMoistureContent {

            finalDryingFlux =
                input.constantDryingFlux
        } else {
            finalDryingFlux =
                input.constantDryingFlux
                * (
                    input.finalMoistureContent
                    - input.equilibriumMoistureContent
                )
                / (
                    input.criticalMoistureContent
                    - input.equilibriumMoistureContent
                )
        }

        let results = [
            constantRateTime,
            fallingRateTime,
            totalDryingTime,
            removedMoistureMass,
            averageDryingFlux,
            finalDryingFlux,
            constantMoistureRemoved,
            fallingMoistureRemoved
        ]

        guard
            results.allSatisfy(\.isFinite),
            totalDryingTime > 0,
            removedMoistureMass > 0,
            averageDryingFlux > 0,
            finalDryingFlux > 0
        else {
            throw DryingRateTimeError
                .numericalFailure
        }

        let periodDescription: String

        if constantRateTime > tolerance,
           fallingRateTime > tolerance {

            periodDescription =
                "Drying includes both a constant-rate period and a linear falling-rate period."
        } else if constantRateTime > tolerance {
            periodDescription =
                "The specified moisture range remains entirely in the constant-rate period."
        } else {
            periodDescription =
                "Drying starts below the critical moisture content and occurs entirely in the falling-rate period."
        }

        return DryingRateTimeResult(
            constantRateTime:
                constantRateTime,
            fallingRateTime:
                fallingRateTime,
            totalDryingTime:
                totalDryingTime,
            removedMoistureMass:
                removedMoistureMass,
            averageDryingFlux:
                averageDryingFlux,
            finalDryingFlux:
                finalDryingFlux,
            constantRateMoistureRemoved:
                constantMoistureRemoved,
            fallingRateMoistureRemoved:
                fallingMoistureRemoved,
            periodDescription:
                periodDescription,
            modelName:
                "Constant-rate plus linear falling-rate drying on a dry-solid moisture basis"
        )
    }
}
