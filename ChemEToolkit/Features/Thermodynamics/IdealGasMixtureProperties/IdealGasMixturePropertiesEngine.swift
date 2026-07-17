struct IdealGasMixturePropertiesEngine:
    Sendable {

    private let universalGasConstant =
        8.31446261815324

    func calculate(
        _ input:
            IdealGasMixturePropertiesInput
    ) throws
        -> IdealGasMixturePropertiesResult {

        let values = [
            input.fraction1,
            input.molecularWeight1,
            input.fraction2,
            input.molecularWeight2,
            input.fraction3,
            input.molecularWeight3
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw IdealGasMixturePropertiesError
                .nonFiniteInput
        }

        let fractions = [
            input.fraction1,
            input.fraction2,
            input.fraction3
        ]

        guard
            fractions.allSatisfy({
                $0 >= 0
            })
        else {
            throw IdealGasMixturePropertiesError
                .negativeFraction
        }

        let sum =
            fractions.reduce(0, +)

        guard sum > 0 else {
            throw IdealGasMixturePropertiesError
                .zeroFractionSum
        }

        let molecularWeights = [
            input.molecularWeight1,
            input.molecularWeight2,
            input.molecularWeight3
        ]

        guard
            molecularWeights.allSatisfy({
                $0 > 0
            })
        else {
            throw IdealGasMixturePropertiesError
                .nonPositiveMolecularWeight
        }

        let y1 =
            input.fraction1 / sum

        let y2 =
            input.fraction2 / sum

        let y3 =
            input.fraction3 / sum

        let mixtureMolecularWeight =
            y1 * input.molecularWeight1
            + y2 * input.molecularWeight2
            + y3 * input.molecularWeight3

        let specificGasConstant =
            universalGasConstant
            / mixtureMolecularWeight

        let reciprocal =
            1 / mixtureMolecularWeight

        let outputs = [
            sum,
            y1,
            y2,
            y3,
            mixtureMolecularWeight,
            specificGasConstant,
            reciprocal
        ]

        guard
            outputs.allSatisfy(\.isFinite),
            mixtureMolecularWeight > 0,
            specificGasConstant > 0
        else {
            throw IdealGasMixturePropertiesError
                .numericalFailure
        }

        return .init(
            enteredFractionSum:
                sum,
            normalizedFraction1:
                y1,
            normalizedFraction2:
                y2,
            normalizedFraction3:
                y3,
            mixtureMolecularWeight:
                mixtureMolecularWeight,
            mixtureSpecificGasConstant:
                specificGasConstant,
            reciprocalMolecularWeight:
                reciprocal,
            modelName:
                "Mole-fraction-weighted ideal-gas mixture properties",
            limitationDescription:
                "Uses mole fractions and molecular weights in kg/kmol. The specific gas constant is returned in kJ/(kg·K)."
        )
    }
}
