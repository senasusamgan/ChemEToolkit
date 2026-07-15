import Foundation

struct UltrafiltrationConcentrationPolarizationEngine:
    Sendable {

    private let maximumRecovery =
        0.30

    private let tolerance =
        1.0e-12

    func calculate(
        _ input:
            UltrafiltrationConcentrationPolarizationInput
    ) throws
        -> UltrafiltrationConcentrationPolarizationResult {

        let values = [
            input.feedVolumetricFlowRate,
            input.membraneArea,
            input.liquidSideMassTransferCoefficient,
            input.bulkSoluteConcentration,
            input.gelConcentration,
            input.observedSievingCoefficient
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw UltrafiltrationConcentrationPolarizationError
                .nonFiniteInput
        }

        guard
            input.feedVolumetricFlowRate > 0,
            input.membraneArea > 0,
            input.liquidSideMassTransferCoefficient > 0,
            input.bulkSoluteConcentration > 0
        else {
            throw UltrafiltrationConcentrationPolarizationError
                .nonPositiveProperty
        }

        guard
            input.gelConcentration
            > input.bulkSoluteConcentration
        else {
            throw UltrafiltrationConcentrationPolarizationError
                .gelConcentrationNotAboveBulk
        }

        guard
            input.observedSievingCoefficient >= 0,
            input.observedSievingCoefficient <= 1
        else {
            throw UltrafiltrationConcentrationPolarizationError
                .sievingCoefficientOutOfRange
        }

        let polarizationModulus =
            input.gelConcentration
            / input.bulkSoluteConcentration

        let limitingFlux =
            input.liquidSideMassTransferCoefficient
            * log(polarizationModulus)

        let permeateFlow =
            limitingFlux
            * input.membraneArea

        let recovery =
            permeateFlow
            / input.feedVolumetricFlowRate

        guard
            recovery <= maximumRecovery
            + tolerance
        else {
            throw UltrafiltrationConcentrationPolarizationError
                .recoveryOutsideLowRecoveryModel
        }

        let retentateFlow =
            input.feedVolumetricFlowRate
            - permeateFlow

        guard retentateFlow > 0 else {
            throw UltrafiltrationConcentrationPolarizationError
                .numericalFailure
        }

        let permeateConcentration =
            input.observedSievingCoefficient
            * input.bulkSoluteConcentration

        let retentateConcentration =
            (
                input.feedVolumetricFlowRate
                * input.bulkSoluteConcentration
                - permeateFlow
                * permeateConcentration
            )
            / retentateFlow

        let rejection =
            1 - input.observedSievingCoefficient

        let concentrationFactor =
            retentateConcentration
            / input.bulkSoluteConcentration

        let retainedSoluteRate =
            input.feedVolumetricFlowRate
            * input.bulkSoluteConcentration
            - permeateFlow
            * permeateConcentration

        let balanceResidual =
            input.feedVolumetricFlowRate
            * input.bulkSoluteConcentration
            - permeateFlow
            * permeateConcentration
            - retentateFlow
            * retentateConcentration

        let results = [
            limitingFlux,
            polarizationModulus,
            permeateFlow,
            retentateFlow,
            recovery,
            permeateConcentration,
            retentateConcentration,
            rejection,
            concentrationFactor,
            retainedSoluteRate,
            balanceResidual
        ]

        guard
            results.allSatisfy(\.isFinite),
            limitingFlux > 0,
            polarizationModulus > 1,
            permeateFlow > 0,
            recovery > 0,
            permeateConcentration >= 0,
            retentateConcentration > 0,
            rejection >= 0,
            rejection <= 1,
            concentrationFactor >= 1,
            retainedSoluteRate > 0
        else {
            throw UltrafiltrationConcentrationPolarizationError
                .numericalFailure
        }

        return UltrafiltrationConcentrationPolarizationResult(
            limitingFluxMetersPerHour:
                limitingFlux,
            limitingFluxLMH:
                1000 * limitingFlux,
            polarizationModulus:
                polarizationModulus,
            permeateFlowRate:
                permeateFlow,
            retentateFlowRate:
                retentateFlow,
            volumetricRecoveryFraction:
                recovery,
            permeateSoluteConcentration:
                permeateConcentration,
            retentateSoluteConcentration:
                retentateConcentration,
            observedRejection:
                rejection,
            concentrationFactor:
                concentrationFactor,
            retainedSoluteRate:
                retainedSoluteRate,
            soluteBalanceResidual:
                balanceResidual,
            modelName:
                "Gel-polarization limiting-flux ultrafiltration model",
            limitationDescription:
                "Assumes a specified gel concentration, constant mass-transfer coefficient and observed sieving coefficient, no osmotic-pressure coupling and low module recovery."
        )
    }
}
