struct DiffusionThroughMembraneEngine:
    Sendable {

    private let zeroTolerance =
        1.0e-15

    func calculate(
        _ input:
            DiffusionThroughMembraneInput
    ) throws
        -> DiffusionThroughMembraneResult {

        let values = [
            input.diffusivityInMembrane,
            input.partitionCoefficient,
            input.membraneThickness,
            input.membraneArea,
            input.sideOneConcentration,
            input.sideTwoConcentration
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw DiffusionThroughMembraneError
                .nonFiniteInput
        }

        guard
            input.diffusivityInMembrane > 0,
            input.partitionCoefficient > 0,
            input.membraneThickness > 0,
            input.membraneArea > 0
        else {
            throw DiffusionThroughMembraneError
                .nonPositiveTransportProperty
        }

        guard
            input.sideOneConcentration >= 0,
            input.sideTwoConcentration >= 0
        else {
            throw DiffusionThroughMembraneError
                .negativeConcentration
        }

        let permeability =
            input.diffusivityInMembrane
            * input.partitionCoefficient

        let permeance =
            permeability
            / input.membraneThickness

        let resistance =
            1 / permeance

        let sideOneMembraneConcentration =
            input.partitionCoefficient
            * input.sideOneConcentration

        let sideTwoMembraneConcentration =
            input.partitionCoefficient
            * input.sideTwoConcentration

        let membraneConcentrationDifference =
            sideOneMembraneConcentration
            - sideTwoMembraneConcentration

        let signedFlux =
            input.diffusivityInMembrane
            * membraneConcentrationDifference
            / input.membraneThickness

        let transferRateMagnitude =
            abs(signedFlux)
            * input.membraneArea

        let results = [
            permeability,
            permeance,
            resistance,
            sideOneMembraneConcentration,
            sideTwoMembraneConcentration,
            membraneConcentrationDifference,
            signedFlux,
            transferRateMagnitude
        ]

        guard
            results.allSatisfy(\.isFinite),
            permeability > 0,
            permeance > 0,
            resistance > 0,
            sideOneMembraneConcentration >= 0,
            sideTwoMembraneConcentration >= 0,
            transferRateMagnitude >= 0
        else {
            throw DiffusionThroughMembraneError
                .numericalFailure
        }

        let directionDescription: String

        if abs(signedFlux) <= zeroTolerance {
            directionDescription =
                "Both sides have the same bulk concentration, so there is no net membrane transfer."
        } else if signedFlux > 0 {
            directionDescription =
                "Net diffusion proceeds from side one toward side two."
        } else {
            directionDescription =
                "Net diffusion proceeds from side two toward side one."
        }

        return DiffusionThroughMembraneResult(
            membranePermeability:
                permeability,
            membranePermeance:
                permeance,
            membraneResistance:
                resistance,
            sideOneMembraneConcentration:
                sideOneMembraneConcentration,
            sideTwoMembraneConcentration:
                sideTwoMembraneConcentration,
            membraneConcentrationDifference:
                membraneConcentrationDifference,
            signedMolarFlux:
                signedFlux,
            transferRateMagnitude:
                transferRateMagnitude,
            directionDescription:
                directionDescription,
            modelName:
                "Steady one-dimensional solution–diffusion through a homogeneous membrane",
            limitationDescription:
                "Assumes instantaneous partition equilibrium at both interfaces, constant diffusivity and partition coefficient, no external-film resistance, no reaction and no membrane swelling."
        )
    }
}
