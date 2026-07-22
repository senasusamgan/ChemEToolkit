struct MixtureDensityCalculatorEngine:
    Sendable {

    func calculate(
        _ input:
            MixtureDensityCalculatorInput
    ) throws
        -> MixtureDensityCalculatorResult {

        let values = [
            input.mass1,
            input.density1,
            input.mass2,
            input.density2,
            input.mass3,
            input.density3
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw MixtureDensityCalculatorError
                .nonFiniteInput
        }

        let masses = [
            input.mass1,
            input.mass2,
            input.mass3
        ]

        guard
            masses.allSatisfy({
                $0 >= 0
            })
        else {
            throw MixtureDensityCalculatorError
                .negativeMass
        }

        let densities = [
            input.density1,
            input.density2,
            input.density3
        ]

        guard
            densities.allSatisfy({
                $0 > 0
            })
        else {
            throw MixtureDensityCalculatorError
                .nonPositiveDensity
        }

        let totalMass =
            masses.reduce(0, +)

        guard totalMass > 0 else {
            throw MixtureDensityCalculatorError
                .zeroTotalMass
        }

        let totalVolume =
            input.mass1 / input.density1
            + input.mass2 / input.density2
            + input.mass3 / input.density3

        let mixtureDensity =
            totalMass
            / totalVolume

        let w1 =
            input.mass1
            / totalMass

        let w2 =
            input.mass2
            / totalMass

        let w3 =
            input.mass3
            / totalMass

        let results = [
            totalMass,
            totalVolume,
            mixtureDensity,
            w1,
            w2,
            w3
        ]

        guard
            results.allSatisfy(\.isFinite),
            totalVolume > 0,
            mixtureDensity > 0
        else {
            throw MixtureDensityCalculatorError
                .numericalFailure
        }

        return .init(
            totalMass:
                totalMass,
            totalAdditiveVolume:
                totalVolume,
            mixtureDensity:
                mixtureDensity,
            massFraction1:
                w1,
            massFraction2:
                w2,
            massFraction3:
                w3,
            modelName:
                "Additive-volume three-component mixture density",
            limitationDescription:
                "Assumes component volumes are additive. Real liquid mixing can involve volume contraction or expansion."
        )
    }
}
