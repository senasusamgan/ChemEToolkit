import Foundation

struct MembraneGasSeparationEngine:
    Sendable {

    private let gpuToSI =
        3.348e-10

    private let barToPascal =
        100_000.0

    private let maximumStageCut =
        0.20

    private let tolerance =
        1.0e-12

    private let maximumIterations =
        200

    func calculate(
        _ input:
            MembraneGasSeparationInput
    ) throws
        -> MembraneGasSeparationResult {

        let values = [
            input.feedMolarFlowRate,
            input.membraneArea,
            input.feedPressureBar,
            input.permeatePressureBar,
            input.feedFastComponentMoleFraction,
            input.fastComponentPermeanceGPU,
            input.slowComponentPermeanceGPU
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw
                MembraneGasSeparationError
                    .nonFiniteInput
        }

        guard
            input.feedMolarFlowRate > 0,
            input.membraneArea > 0,
            input.feedPressureBar > 0,
            input.fastComponentPermeanceGPU > 0,
            input.slowComponentPermeanceGPU > 0
        else {
            throw
                MembraneGasSeparationError
                    .nonPositiveProperty
        }

        guard input.permeatePressureBar >= 0 else {
            throw
                MembraneGasSeparationError
                    .negativePermeatePressure
        }

        guard
            input.feedPressureBar
            > input.permeatePressureBar
        else {
            throw
                MembraneGasSeparationError
                    .invalidPressureOrdering
        }

        guard
            input.feedFastComponentMoleFraction > 0,
            input.feedFastComponentMoleFraction < 1
        else {
            throw
                MembraneGasSeparationError
                    .feedCompositionOutOfRange
        }

        guard
            input.fastComponentPermeanceGPU
            > input.slowComponentPermeanceGPU
        else {
            throw
                MembraneGasSeparationError
                    .invalidPermeanceOrdering
        }

        let feedPressure =
            input.feedPressureBar
            * barToPascal

        let permeatePressure =
            input.permeatePressureBar
            * barToPascal

        let fastPermeance =
            input.fastComponentPermeanceGPU
            * gpuToSI

        let slowPermeance =
            input.slowComponentPermeanceGPU
            * gpuToSI

        let permeateComposition =
            try solvePermeateComposition(
                feedFastFraction:
                    input.feedFastComponentMoleFraction,
                feedPressure:
                    feedPressure,
                permeatePressure:
                    permeatePressure,
                fastPermeance:
                    fastPermeance,
                slowPermeance:
                    slowPermeance
            )

        let fluxes =
            componentFluxes(
                permeateFastFraction:
                    permeateComposition,
                feedFastFraction:
                    input.feedFastComponentMoleFraction,
                feedPressure:
                    feedPressure,
                permeatePressure:
                    permeatePressure,
                fastPermeance:
                    fastPermeance,
                slowPermeance:
                    slowPermeance
            )

        guard
            fluxes.fast > 0,
            fluxes.slow > 0,
            fluxes.total > 0
        else {
            throw
                MembraneGasSeparationError
                    .noPhysicalPermeateComposition
        }

        let permeateFlow =
            fluxes.total
            * input.membraneArea

        let stageCut =
            permeateFlow
            / input.feedMolarFlowRate

        guard
            stageCut
            <= maximumStageCut
            + tolerance
        else {
            throw
                MembraneGasSeparationError
                    .stageCutOutsideLowStageCutApproximation
        }

        let retentateFlow =
            input.feedMolarFlowRate
            - permeateFlow

        guard retentateFlow > 0 else {
            throw
                MembraneGasSeparationError
                    .numericalFailure
        }

        let retentateFastFraction =
            (
                input.feedMolarFlowRate
                * input.feedFastComponentMoleFraction
                - permeateFlow
                * permeateComposition
            )
            / retentateFlow

        let fastRecovery =
            permeateFlow
            * permeateComposition
            / (
                input.feedMolarFlowRate
                * input.feedFastComponentMoleFraction
            )

        let idealSelectivity =
            input.fastComponentPermeanceGPU
            / input.slowComponentPermeanceGPU

        let results = [
            permeateComposition,
            fluxes.fast,
            fluxes.slow,
            fluxes.total,
            permeateFlow,
            retentateFlow,
            stageCut,
            retentateFastFraction,
            fastRecovery,
            idealSelectivity
        ]

        guard
            results.allSatisfy(\.isFinite),
            (0...1).contains(
                permeateComposition
            ),
            (0...1).contains(
                retentateFastFraction
            ),
            (0...1).contains(
                fastRecovery
            ),
            stageCut >= 0
        else {
            throw
                MembraneGasSeparationError
                    .numericalFailure
        }

        return
            MembraneGasSeparationResult(
                idealSelectivity:
                    idealSelectivity,
                pressureRatio:
                    input.permeatePressureBar
                    / input.feedPressureBar,
                permeateFastComponentMoleFraction:
                    permeateComposition,
                retentateFastComponentMoleFraction:
                    retentateFastFraction,
                fastComponentFlux:
                    fluxes.fast,
                slowComponentFlux:
                    fluxes.slow,
                totalMolarFlux:
                    fluxes.total,
                permeateMolarFlowRate:
                    permeateFlow,
                retentateMolarFlowRate:
                    retentateFlow,
                stageCut:
                    stageCut,
                fastComponentRecovery:
                    fastRecovery,
                purityIncrease:
                    permeateComposition
                    - input.feedFastComponentMoleFraction,
                validityDescription:
                    "Feed-side composition is treated as constant and the result is restricted to stage cut ≤ 0.20.",
                modelName:
                    "Binary solution–diffusion permeation with constant component permeances"
            )
    }

    private func solvePermeateComposition(
        feedFastFraction: Double,
        feedPressure: Double,
        permeatePressure: Double,
        fastPermeance: Double,
        slowPermeance: Double
    ) throws -> Double {
        var lower = 0.0
        var upper = 1.0

        if permeatePressure > 0 {
            lower =
                max(
                    0,
                    1
                    - (
                        1 - feedFastFraction
                    )
                    * feedPressure
                    / permeatePressure
                )

            upper =
                min(
                    1,
                    feedFastFraction
                    * feedPressure
                    / permeatePressure
                )
        }

        let epsilon =
            1.0e-12

        lower =
            min(
                1 - epsilon,
                max(0, lower) + epsilon
            )

        upper =
            max(
                epsilon,
                min(1, upper) - epsilon
            )

        guard lower < upper else {
            throw
                MembraneGasSeparationError
                    .noPhysicalPermeateComposition
        }

        var lowerResidual =
            compositionResidual(
                permeateFastFraction:
                    lower,
                feedFastFraction:
                    feedFastFraction,
                feedPressure:
                    feedPressure,
                permeatePressure:
                    permeatePressure,
                fastPermeance:
                    fastPermeance,
                slowPermeance:
                    slowPermeance
            )

        let upperResidual =
            compositionResidual(
                permeateFastFraction:
                    upper,
                feedFastFraction:
                    feedFastFraction,
                feedPressure:
                    feedPressure,
                permeatePressure:
                    permeatePressure,
                fastPermeance:
                    fastPermeance,
                slowPermeance:
                    slowPermeance
            )

        guard
            lowerResidual.isFinite,
            upperResidual.isFinite,
            lowerResidual
            * upperResidual <= 0
        else {
            throw
                MembraneGasSeparationError
                    .noPhysicalPermeateComposition
        }

        var left = lower
        var right = upper

        for _ in 0..<maximumIterations {
            let midpoint =
                0.5 * (left + right)

            let midpointResidual =
                compositionResidual(
                    permeateFastFraction:
                        midpoint,
                    feedFastFraction:
                        feedFastFraction,
                    feedPressure:
                        feedPressure,
                    permeatePressure:
                        permeatePressure,
                    fastPermeance:
                        fastPermeance,
                    slowPermeance:
                        slowPermeance
                )

            guard midpointResidual.isFinite else {
                throw
                    MembraneGasSeparationError
                        .noPhysicalPermeateComposition
            }

            if abs(midpointResidual)
                <= tolerance {

                return midpoint
            }

            if lowerResidual
                * midpointResidual <= 0 {

                right = midpoint
            } else {
                left = midpoint
                lowerResidual =
                    midpointResidual
            }
        }

        let solution =
            0.5 * (left + right)

        guard
            abs(
                compositionResidual(
                    permeateFastFraction:
                        solution,
                    feedFastFraction:
                        feedFastFraction,
                    feedPressure:
                        feedPressure,
                    permeatePressure:
                        permeatePressure,
                    fastPermeance:
                        fastPermeance,
                    slowPermeance:
                        slowPermeance
                )
            ) <= 1.0e-9
        else {
            throw
                MembraneGasSeparationError
                    .noPhysicalPermeateComposition
        }

        return solution
    }

    private func compositionResidual(
        permeateFastFraction: Double,
        feedFastFraction: Double,
        feedPressure: Double,
        permeatePressure: Double,
        fastPermeance: Double,
        slowPermeance: Double
    ) -> Double {
        let fluxes =
            componentFluxes(
                permeateFastFraction:
                    permeateFastFraction,
                feedFastFraction:
                    feedFastFraction,
                feedPressure:
                    feedPressure,
                permeatePressure:
                    permeatePressure,
                fastPermeance:
                    fastPermeance,
                slowPermeance:
                    slowPermeance
            )

        guard fluxes.total > 0 else {
            return .nan
        }

        return
            permeateFastFraction
            - fluxes.fast / fluxes.total
    }

    private func componentFluxes(
        permeateFastFraction: Double,
        feedFastFraction: Double,
        feedPressure: Double,
        permeatePressure: Double,
        fastPermeance: Double,
        slowPermeance: Double
    ) -> (
        fast: Double,
        slow: Double,
        total: Double
    ) {
        let fastFlux =
            fastPermeance
            * (
                feedFastFraction
                * feedPressure
                - permeateFastFraction
                * permeatePressure
            )

        let slowFlux =
            slowPermeance
            * (
                (
                    1 - feedFastFraction
                )
                * feedPressure
                - (
                    1 - permeateFastFraction
                )
                * permeatePressure
            )

        return (
            fastFlux,
            slowFlux,
            fastFlux + slowFlux
        )
    }
}
