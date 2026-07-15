struct DistributionCoefficientSelectivityEngine:
    Sendable {

    private let unityTolerance =
        1.0e-12

    func calculate(
        _ input:
            DistributionCoefficientSelectivityInput
    ) throws
        -> DistributionCoefficientSelectivityResult {

        let values = [
            input.raffinateSoluteConcentration,
            input.extractSoluteConcentration,
            input.raffinateImpurityConcentration,
            input.extractImpurityConcentration
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw
                DistributionCoefficientSelectivityError
                    .nonFiniteInput
        }

        guard values.allSatisfy({ $0 > 0 }) else {
            throw
                DistributionCoefficientSelectivityError
                    .nonPositiveConcentration
        }

        let soluteDistributionCoefficient =
            input.extractSoluteConcentration
            / input.raffinateSoluteConcentration

        let impurityDistributionCoefficient =
            input.extractImpurityConcentration
            / input.raffinateImpurityConcentration

        let separationFactor =
            soluteDistributionCoefficient
            / impurityDistributionCoefficient

        guard
            soluteDistributionCoefficient.isFinite,
            impurityDistributionCoefficient.isFinite,
            separationFactor.isFinite,
            separationFactor > 0
        else {
            throw
                DistributionCoefficientSelectivityError
                    .numericalFailure
        }

        let solutePreferenceDescription: String

        if abs(
            soluteDistributionCoefficient - 1
        ) <= unityTolerance {
            solutePreferenceDescription =
                "The solute has no phase preference on the selected concentration basis."
        } else if soluteDistributionCoefficient > 1 {
            solutePreferenceDescription =
                "The solute preferentially partitions into the extract phase."
        } else {
            solutePreferenceDescription =
                "The solute preferentially remains in the raffinate phase."
        }

        let selectivityDescription: String

        if abs(separationFactor - 1)
            <= unityTolerance {

            selectivityDescription =
                "The solvent does not selectively separate the solute from the impurity."
        } else if separationFactor > 1 {
            selectivityDescription =
                "The solvent is selective for the target solute over the impurity."
        } else {
            selectivityDescription =
                "The solvent favors the impurity over the target solute."
        }

        return
            DistributionCoefficientSelectivityResult(
                soluteDistributionCoefficient:
                    soluteDistributionCoefficient,
                impurityDistributionCoefficient:
                    impurityDistributionCoefficient,
                separationFactor:
                    separationFactor,
                solutePreferenceDescription:
                    solutePreferenceDescription,
                selectivityDescription:
                    selectivityDescription,
                modelName:
                    "Equilibrium distribution coefficients and separation factor"
            )
    }
}
