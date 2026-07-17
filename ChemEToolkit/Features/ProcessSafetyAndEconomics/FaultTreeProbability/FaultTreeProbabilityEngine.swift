struct FaultTreeProbabilityEngine:
    Sendable {

    func calculate(
        _ input:
            FaultTreeProbabilityInput
    ) throws
        -> FaultTreeProbabilityResult {

        let values = [
            input.basicEvent1Probability,
            input.basicEvent2Probability,
            input.basicEvent3Probability,
            input.gateCode
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw FaultTreeProbabilityError
                .nonFiniteInput
        }

        let probabilities = [
            input.basicEvent1Probability,
            input.basicEvent2Probability,
            input.basicEvent3Probability
        ]

        guard
            probabilities.allSatisfy({
                $0 >= 0 && $0 <= 1
            })
        else {
            throw FaultTreeProbabilityError
                .probabilityOutsideRange
        }

        let roundedCode =
            input.gateCode.rounded()

        guard
            abs(
                input.gateCode
                - roundedCode
            ) < 1e-12,
            roundedCode == 1
                || roundedCode == 2
        else {
            throw FaultTreeProbabilityError
                .invalidGateCode
        }

        let sum =
            probabilities.reduce(0, +)

        let product =
            probabilities.reduce(1, *)

        let gateName: String
        let topProbability: Double
        let rareApproximation: Double
        let description: String

        if Int(roundedCode) == 1 {
            gateName = "OR"

            topProbability =
                1
                - probabilities.reduce(1) {
                    $0 * (1 - $1)
                }

            rareApproximation =
                min(
                    1,
                    sum
                )

            description =
                "The top event occurs when one or more independent basic events occur."
        } else {
            gateName = "AND"
            topProbability = product
            rareApproximation = product

            description =
                "The top event occurs only when all independent basic events occur."
        }

        let complement =
            1 - topProbability

        let approximationError =
            rareApproximation
            - topProbability

        let dominantBasicEvent =
            probabilities.enumerated().max {
                $0.element < $1.element
            }
            .map {
                "Basic Event \($0.offset + 1)"
            }
            ?? "None"

        let results = [
            topProbability,
            complement,
            sum,
            product,
            rareApproximation,
            approximationError
        ]

        guard
            results.allSatisfy(\.isFinite),
            topProbability >= 0,
            topProbability <= 1,
            complement >= 0,
            complement <= 1,
            sum >= 0,
            product >= 0,
            product <= 1
        else {
            throw FaultTreeProbabilityError
                .numericalFailure
        }

        return .init(
            gateName:
                gateName,
            topEventProbability:
                topProbability,
            topEventComplement:
                complement,
            sumOfBasicProbabilities:
                sum,
            productOfBasicProbabilities:
                product,
            rareEventApproximation:
                rareApproximation,
            approximationError:
                approximationError,
            dominantBasicEvent:
                dominantBasicEvent,
            gateDescription:
                description,
            modelName:
                "Independent three-basic-event OR/AND fault-tree gate",
            limitationDescription:
                "Assumes independent basic events with constant probabilities. Common-cause failure, repeated events, minimal cut sets and time-dependent reliability require a complete fault-tree model."
        )
    }
}
