struct BinaryCompositionBasisConversionEngine:
    Sendable {

    func calculate(
        _ input:
            BinaryCompositionBasisConversionInput
    ) throws
        -> BinaryCompositionBasisConversionResult {

        let values = [
            input.component1MassFraction,
            input.component1MolecularWeight,
            input.component2MolecularWeight
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw BinaryCompositionBasisConversionError
                .nonFiniteInput
        }

        guard
            input.component1MassFraction >= 0,
            input.component1MassFraction <= 1
        else {
            throw BinaryCompositionBasisConversionError
                .massFractionOutsideRange
        }

        guard
            input.component1MolecularWeight > 0,
            input.component2MolecularWeight > 0
        else {
            throw BinaryCompositionBasisConversionError
                .nonPositiveMolecularWeight
        }

        let w1 =
            input.component1MassFraction

        let w2 =
            1 - w1

        let relativeMoles1 =
            w1
            / input.component1MolecularWeight

        let relativeMoles2 =
            w2
            / input.component2MolecularWeight

        let totalRelativeMoles =
            relativeMoles1
            + relativeMoles2

        let x1 =
            relativeMoles1
            / totalRelativeMoles

        let x2 =
            relativeMoles2
            / totalRelativeMoles

        let mixtureMolecularWeight =
            1
            / (
                w1
                / input.component1MolecularWeight
                + w2
                / input.component2MolecularWeight
            )

        let recoveredW1 =
            x1
            * input.component1MolecularWeight
            / mixtureMolecularWeight

        let results = [
            w1,
            w2,
            x1,
            x2,
            mixtureMolecularWeight,
            recoveredW1
        ]

        guard
            results.allSatisfy(\.isFinite),
            x1 >= 0,
            x1 <= 1,
            x2 >= 0,
            x2 <= 1,
            mixtureMolecularWeight > 0
        else {
            throw BinaryCompositionBasisConversionError
                .numericalFailure
        }

        return .init(
            component1MassFraction:
                w1,
            component2MassFraction:
                w2,
            component1MoleFraction:
                x1,
            component2MoleFraction:
                x2,
            mixtureMolecularWeight:
                mixtureMolecularWeight,
            recoveredMassFraction1:
                recoveredW1,
            modelName:
                "Binary mass-fraction to mole-fraction conversion",
            limitationDescription:
                "The mixture is assumed to contain exactly two components. Molecular weights must use the same units."
        )
    }
}
