import Foundation

struct FiniteVolumeDialysisEngine:
    Sendable {

    private let zeroTolerance =
        1.0e-12

    func calculate(
        _ input:
            FiniteVolumeDialysisInput
    ) throws
        -> FiniteVolumeDialysisResult {

        let values = [
            input.donorVolume,
            input.receiverVolume,
            input.membraneArea,
            input.overallMassTransferCoefficient,
            input.contactTime,
            input.donorInitialConcentration,
            input.receiverInitialConcentration
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw
                FiniteVolumeDialysisError
                    .nonFiniteInput
        }

        guard
            input.donorVolume > 0,
            input.receiverVolume > 0,
            input.membraneArea > 0,
            input.overallMassTransferCoefficient
            > 0
        else {
            throw
                FiniteVolumeDialysisError
                    .nonPositiveProperty
        }

        guard input.contactTime >= 0 else {
            throw
                FiniteVolumeDialysisError
                    .negativeContactTime
        }

        guard
            input.donorInitialConcentration
            >= 0,
            input.receiverInitialConcentration
            >= 0
        else {
            throw
                FiniteVolumeDialysisError
                    .negativeConcentration
        }

        let totalVolume =
            input.donorVolume
            + input.receiverVolume

        let equilibriumConcentration =
            (
                input.donorVolume
                * input.donorInitialConcentration
                + input.receiverVolume
                * input.receiverInitialConcentration
            )
            / totalVolume

        let initialDifference =
            input.donorInitialConcentration
            - input.receiverInitialConcentration

        let systemRateConstant =
            input.overallMassTransferCoefficient
            * input.membraneArea
            * (
                1 / input.donorVolume
                + 1 / input.receiverVolume
            )

        let decayFactor =
            exp(
                -systemRateConstant
                * input.contactTime
            )

        let finalDifference =
            initialDifference
            * decayFactor

        let donorFinal =
            equilibriumConcentration
            + input.receiverVolume
            / totalVolume
            * finalDifference

        let receiverFinal =
            equilibriumConcentration
            - input.donorVolume
            / totalVolume
            * finalDifference

        let signedTransferredAmount =
            input.donorVolume
            * (
                input.donorInitialConcentration
                - donorFinal
            )

        let initialFlux =
            input.overallMassTransferCoefficient
            * initialDifference

        let finalFlux =
            input.overallMassTransferCoefficient
            * finalDifference

        let fractionApproach =
            1 - decayFactor

        let halfTime =
            log(2)
            / systemRateConstant

        let initialTotalAmount =
            input.donorVolume
            * input.donorInitialConcentration
            + input.receiverVolume
            * input.receiverInitialConcentration

        let finalTotalAmount =
            input.donorVolume
            * donorFinal
            + input.receiverVolume
            * receiverFinal

        let balanceResidual =
            initialTotalAmount
            - finalTotalAmount

        let results = [
            equilibriumConcentration,
            decayFactor,
            fractionApproach,
            donorFinal,
            receiverFinal,
            signedTransferredAmount,
            initialFlux,
            finalFlux,
            systemRateConstant,
            halfTime,
            balanceResidual
        ]

        guard
            results.allSatisfy(\.isFinite),
            equilibriumConcentration >= 0,
            decayFactor >= 0,
            decayFactor <= 1,
            fractionApproach >= 0,
            fractionApproach <= 1,
            donorFinal >= 0,
            receiverFinal >= 0,
            systemRateConstant > 0,
            halfTime > 0
        else {
            throw
                FiniteVolumeDialysisError
                    .numericalFailure
        }

        let directionDescription: String

        if abs(initialDifference)
            <= zeroTolerance {

            directionDescription =
                "Both compartments begin at the same concentration, so no net transfer occurs."
        } else if initialDifference > 0 {
            directionDescription =
                "Net solute transfer proceeds from the donor compartment to the receiver compartment."
        } else {
            directionDescription =
                "The concentration gradient is reversed; net solute transfer proceeds from receiver to donor."
        }

        return
            FiniteVolumeDialysisResult(
                equilibriumConcentration:
                    equilibriumConcentration,
                concentrationDifferenceDecayFactor:
                    decayFactor,
                fractionOfEquilibriumApproach:
                    fractionApproach,
                donorFinalConcentration:
                    donorFinal,
                receiverFinalConcentration:
                    receiverFinal,
                signedTransferredAmountToReceiver:
                    signedTransferredAmount,
                transferMagnitude:
                    abs(signedTransferredAmount),
                initialSignedFlux:
                    initialFlux,
                finalSignedFlux:
                    finalFlux,
                systemRateConstant:
                    systemRateConstant,
                concentrationDifferenceHalfTime:
                    halfTime,
                totalAmountBalanceResidual:
                    balanceResidual,
                directionDescription:
                    directionDescription,
                modelName:
                    "Two well-mixed finite compartments with constant overall membrane mass-transfer coefficient"
            )
    }
}
