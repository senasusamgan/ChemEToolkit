struct EventTreeAnalysisEngine:
    Sendable {

    func calculate(
        _ input:
            EventTreeAnalysisInput
    ) throws
        -> EventTreeAnalysisResult {

        let values = [
            input.initiatingEventFrequency,
            input.barrier1SuccessProbability,
            input.barrier2SuccessProbability,
            input.barrier3SuccessProbability
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw EventTreeAnalysisError
                .nonFiniteInput
        }

        guard
            input.initiatingEventFrequency > 0
        else {
            throw EventTreeAnalysisError
                .nonPositiveInitiatingFrequency
        }

        let probabilities = [
            input.barrier1SuccessProbability,
            input.barrier2SuccessProbability,
            input.barrier3SuccessProbability
        ]

        guard
            probabilities.allSatisfy({
                $0 >= 0 && $0 <= 1
            })
        else {
            throw EventTreeAnalysisError
                .probabilityOutsideRange
        }

        let frequency =
            input.initiatingEventFrequency

        let firstFailure =
            frequency
            * (
                1
                - input.barrier1SuccessProbability
            )

        let secondFailure =
            frequency
            * input.barrier1SuccessProbability
            * (
                1
                - input.barrier2SuccessProbability
            )

        let thirdFailure =
            frequency
            * input.barrier1SuccessProbability
            * input.barrier2SuccessProbability
            * (
                1
                - input.barrier3SuccessProbability
            )

        let allSuccessful =
            frequency
            * input.barrier1SuccessProbability
            * input.barrier2SuccessProbability
            * input.barrier3SuccessProbability

        let outcomes = [
            (
                name:
                    "Barrier 1 failure",
                frequency:
                    firstFailure
            ),
            (
                name:
                    "Barrier 2 failure after Barrier 1 success",
                frequency:
                    secondFailure
            ),
            (
                name:
                    "Barrier 3 failure after Barriers 1 and 2 success",
                frequency:
                    thirdFailure
            ),
            (
                name:
                    "All barriers successful",
                frequency:
                    allSuccessful
            )
        ]

        let totalOutcomeFrequency =
            outcomes.reduce(0) {
                $0 + $1.frequency
            }

        let conservationError =
            totalOutcomeFrequency
            - frequency

        let dominantOutcome =
            outcomes.max {
                $0.frequency
                < $1.frequency
            }?.name
            ?? "None"

        let fullSuccessProbability =
            input.barrier1SuccessProbability
            * input.barrier2SuccessProbability
            * input.barrier3SuccessProbability

        let results = [
            firstFailure,
            secondFailure,
            thirdFailure,
            allSuccessful,
            totalOutcomeFrequency,
            conservationError,
            fullSuccessProbability
        ]

        guard
            results.allSatisfy(\.isFinite),
            firstFailure >= 0,
            secondFailure >= 0,
            thirdFailure >= 0,
            allSuccessful >= 0,
            totalOutcomeFrequency > 0,
            fullSuccessProbability >= 0,
            fullSuccessProbability <= 1
        else {
            throw EventTreeAnalysisError
                .numericalFailure
        }

        return .init(
            initiatingEventFrequency:
                frequency,
            barrier1FailureOutcomeFrequency:
                firstFailure,
            barrier2FailureOutcomeFrequency:
                secondFailure,
            barrier3FailureOutcomeFrequency:
                thirdFailure,
            allBarriersSuccessfulFrequency:
                allSuccessful,
            totalOutcomeFrequency:
                totalOutcomeFrequency,
            probabilityConservationError:
                conservationError,
            dominantOutcome:
                dominantOutcome,
            fullSuccessProbability:
                fullSuccessProbability,
            modelName:
                "Sequential three-barrier event tree",
            limitationDescription:
                "Assumes each branch probability is constant and conditionally independent as entered. Common-cause failure, dependency, timing and uncertainty require a documented event-tree study."
        )
    }
}
