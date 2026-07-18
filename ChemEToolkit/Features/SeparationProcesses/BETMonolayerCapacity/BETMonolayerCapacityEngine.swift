struct BETMonolayerCapacityEngine:
    Sendable {

    func calculate(
        _ input:
            BETMonolayerCapacityInput
    ) throws
        -> BETMonolayerCapacityResult {

        let values = [
            input.relativePressure,
            input.monolayerCapacity,
            input.betConstant
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw BETMonolayerCapacityError
                .nonFiniteInput
        }

        guard
            input.relativePressure > 0,
            input.relativePressure < 1
        else {
            throw BETMonolayerCapacityError
                .invalidRelativePressure
        }

        guard
            input.monolayerCapacity > 0,
            input.betConstant > 0
        else {
            throw BETMonolayerCapacityError
                .nonPositiveParameter
        }

        let denominator =
            (
                1 - input.relativePressure
            )
            * (
                1
                + (
                    input.betConstant - 1
                )
                * input.relativePressure
            )

        let loading =
            input.monolayerCapacity
            * input.betConstant
            * input.relativePressure
            / denominator

        let monolayerEquivalent =
            loading
            / input.monolayerCapacity

        let transformedOrdinate =
            input.relativePressure
            / (
                loading
                * (
                    1
                    - input.relativePressure
                )
            )

        let outputs = [
            denominator,
            loading,
            monolayerEquivalent,
            transformedOrdinate
        ]

        guard
            outputs.allSatisfy(\.isFinite),
            denominator > 0,
            loading > 0
        else {
            throw BETMonolayerCapacityError
                .numericalFailure
        }

        return .init(
            equilibriumLoading:
                loading,
            monolayerEquivalent:
                monolayerEquivalent,
            betDenominator:
                denominator,
            transformedBETOrdinate:
                transformedOrdinate,
            relativePressure:
                input.relativePressure,
            modelName:
                "Brunauer–Emmett–Teller multilayer isotherm",
            limitationDescription:
                "Uses q = qm Cx/[(1-x)(1+(C-1)x)] for relative pressure x between zero and one."
        )
    }
}
