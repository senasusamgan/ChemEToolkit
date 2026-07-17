struct FlammabilityMixtureLimitsEngine:
    Sendable {

    func calculate(
        _ input:
            FlammabilityMixtureLimitsInput
    ) throws
        -> FlammabilityMixtureLimitsResult {

        let values = [
            input.component1Fraction,
            input.component1LowerLimit,
            input.component1UpperLimit,
            input.component2Fraction,
            input.component2LowerLimit,
            input.component2UpperLimit,
            input.component3Fraction,
            input.component3LowerLimit,
            input.component3UpperLimit
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw FlammabilityMixtureLimitsError
                .nonFiniteInput
        }

        let fractions = [
            input.component1Fraction,
            input.component2Fraction,
            input.component3Fraction
        ]

        guard
            fractions.allSatisfy({
                $0 >= 0
            })
        else {
            throw FlammabilityMixtureLimitsError
                .negativeComponentFraction
        }

        let fractionSum =
            fractions.reduce(
                0,
                +
            )

        guard fractionSum > 0 else {
            throw FlammabilityMixtureLimitsError
                .zeroCombustibleFraction
        }

        let components = [
            (
                name: "Component 1",
                fraction:
                    input.component1Fraction,
                lower:
                    input.component1LowerLimit,
                upper:
                    input.component1UpperLimit
            ),
            (
                name: "Component 2",
                fraction:
                    input.component2Fraction,
                lower:
                    input.component2LowerLimit,
                upper:
                    input.component2UpperLimit
            ),
            (
                name: "Component 3",
                fraction:
                    input.component3Fraction,
                lower:
                    input.component3LowerLimit,
                upper:
                    input.component3UpperLimit
            )
        ]

        for component in components
        where component.fraction > 0 {
            guard
                component.lower > 0,
                component.upper
                    > component.lower
            else {
                throw FlammabilityMixtureLimitsError
                    .invalidFlammabilityLimit
            }
        }

        let normalized = components.map {
            $0.fraction
            / fractionSum
        }

        var lowerDenominator =
            0.0

        var upperDenominator =
            0.0

        for index in components.indices {
            let component =
                components[index]

            guard component.fraction > 0 else {
                continue
            }

            lowerDenominator +=
                normalized[index]
                / component.lower

            upperDenominator +=
                normalized[index]
                / component.upper
        }

        let mixtureLower =
            1 / lowerDenominator

        let mixtureUpper =
            1 / upperDenominator

        let rangeWidth =
            mixtureUpper
            - mixtureLower

        let dominant =
            zip(
                components,
                normalized
            )
            .max {
                $0.1 < $1.1
            }?.0.name
            ?? "None"

        let results = [
            fractionSum,
            normalized[0],
            normalized[1],
            normalized[2],
            mixtureLower,
            mixtureUpper,
            rangeWidth
        ]

        guard
            results.allSatisfy(\.isFinite),
            mixtureLower > 0,
            mixtureUpper > mixtureLower,
            rangeWidth > 0
        else {
            throw FlammabilityMixtureLimitsError
                .numericalFailure
        }

        return .init(
            combustibleFractionSum:
                fractionSum,
            normalizedComponent1Fraction:
                normalized[0],
            normalizedComponent2Fraction:
                normalized[1],
            normalizedComponent3Fraction:
                normalized[2],
            mixtureLowerFlammabilityLimit:
                mixtureLower,
            mixtureUpperFlammabilityLimit:
                mixtureUpper,
            flammableRangeWidth:
                rangeWidth,
            dominantFuelComponent:
                dominant,
            modelName:
                "Le Chatelier reciprocal mixing rule for fuel flammability limits",
            limitationDescription:
                "Use only as a screening estimate for compatible fuel mixtures at comparable temperature and pressure. Inerts, oxygen enrichment, chemical interaction and experimental uncertainty are not represented."
        )
    }
}
