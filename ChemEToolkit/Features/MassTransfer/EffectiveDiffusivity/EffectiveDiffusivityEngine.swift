struct EffectiveDiffusivityEngine:
    Sendable {

    func calculate(
        _ input:
            EffectiveDiffusivityInput
    ) throws
        -> EffectiveDiffusivityResult {

        let values = [
            input.molecularDiffusivity,
            input.knudsenDiffusivity,
            input.porosity,
            input.tortuosity,
            input.constrictivity
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw EffectiveDiffusivityError
                .nonFiniteInput
        }

        guard
            input.molecularDiffusivity > 0,
            input.knudsenDiffusivity > 0
        else {
            throw EffectiveDiffusivityError
                .nonPositiveDiffusivity
        }

        guard
            input.porosity > 0,
            input.porosity < 1
        else {
            throw EffectiveDiffusivityError
                .porosityOutOfRange
        }

        guard input.tortuosity >= 1 else {
            throw EffectiveDiffusivityError
                .tortuosityBelowUnity
        }

        guard
            input.constrictivity > 0,
            input.constrictivity <= 1
        else {
            throw EffectiveDiffusivityError
                .constrictivityOutOfRange
        }

        let correctionFactor =
            input.porosity
            * input.constrictivity
            / input.tortuosity

        let effectiveMolecular =
            correctionFactor
            * input.molecularDiffusivity

        let molecularResistance =
            1 / input.molecularDiffusivity

        let knudsenResistance =
            1 / input.knudsenDiffusivity

        let totalPoreResistance =
            molecularResistance
            + knudsenResistance

        let bosanquetDiffusivity =
            1 / totalPoreResistance

        let effectiveCombined =
            correctionFactor
            * bosanquetDiffusivity

        let molecularResistanceFraction =
            molecularResistance
            / totalPoreResistance

        let knudsenResistanceFraction =
            knudsenResistance
            / totalPoreResistance

        let reduction =
            1
            - effectiveCombined
            / input.molecularDiffusivity

        let results = [
            correctionFactor,
            effectiveMolecular,
            bosanquetDiffusivity,
            effectiveCombined,
            molecularResistanceFraction,
            knudsenResistanceFraction,
            reduction
        ]

        guard
            results.allSatisfy(\.isFinite),
            correctionFactor > 0,
            correctionFactor < 1,
            effectiveMolecular > 0,
            bosanquetDiffusivity > 0,
            effectiveCombined > 0,
            molecularResistanceFraction > 0,
            molecularResistanceFraction < 1,
            knudsenResistanceFraction > 0,
            knudsenResistanceFraction < 1,
            reduction > 0,
            reduction < 1
        else {
            throw EffectiveDiffusivityError
                .numericalFailure
        }

        return EffectiveDiffusivityResult(
            porousMediumCorrectionFactor:
                correctionFactor,
            effectiveMolecularDiffusivity:
                effectiveMolecular,
            bosanquetPoreDiffusivity:
                bosanquetDiffusivity,
            effectiveCombinedDiffusivity:
                effectiveCombined,
            molecularResistanceFraction:
                molecularResistanceFraction,
            knudsenResistanceFraction:
                knudsenResistanceFraction,
            reductionRelativeToMolecularDiffusivity:
                reduction,
            modelName:
                "Porosity–tortuosity–constrictivity correction with Bosanquet molecular/Knudsen combination",
            limitationDescription:
                "Assumes independent molecular and Knudsen resistances in series, uniform pore structure and no surface diffusion, adsorption or reaction."
        )
    }
}
