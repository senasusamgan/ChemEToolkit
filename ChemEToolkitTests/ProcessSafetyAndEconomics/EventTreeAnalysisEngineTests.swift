import Testing
@testable import ChemEToolkit

@Suite("Event Tree Analysis Engine")
struct EventTreeAnalysisEngineTests {
    private let engine =
        EventTreeAnalysisEngine()

    @Test("Partitions initiating frequency into outcomes")
    func outcomeFrequencies() throws {
        let result = try engine.calculate(
            .init(
                initiatingEventFrequency: 0.1,
                barrier1SuccessProbability: 0.9,
                barrier2SuccessProbability: 0.8,
                barrier3SuccessProbability: 0.95
            )
        )

        #expect(
            abs(
                result.barrier1FailureOutcomeFrequency
                - 0.0099999999999999985
            ) < 1e-14
        )

        #expect(
            abs(
                result.barrier2FailureOutcomeFrequency
                - 0.017999999999999999
            ) < 1e-14
        )

        #expect(
            abs(
                result.barrier3FailureOutcomeFrequency
                - 0.0036000000000000038
            ) < 1e-14
        )

        #expect(
            abs(
                result.allBarriersSuccessfulFrequency
                - 0.068400000000000002
            ) < 1e-14
        )

        #expect(
            abs(
                result.totalOutcomeFrequency
                - 0.1
            ) < 1e-14
        )

        #expect(
            abs(
                result.probabilityConservationError
            ) < 1e-14
        )

        #expect(
            result.dominantOutcome
            == "All barriers successful"
        )
    }

    @Test("A failed first barrier owns the full outcome frequency")
    func firstBarrierFailure() throws {
        let result = try engine.calculate(
            .init(
                initiatingEventFrequency: 0.2,
                barrier1SuccessProbability: 0,
                barrier2SuccessProbability: 1,
                barrier3SuccessProbability: 1
            )
        )

        #expect(
            result.barrier1FailureOutcomeFrequency
            == 0.2
        )

        #expect(
            result.allBarriersSuccessfulFrequency
            == 0
        )
    }

    @Test("Rejects probability above one")
    func validation() {
        #expect(
            throws:
                EventTreeAnalysisError
                    .probabilityOutsideRange
        ) {
            try engine.calculate(
                .init(
                    initiatingEventFrequency: 0.1,
                    barrier1SuccessProbability: 1.1,
                    barrier2SuccessProbability: 0.8,
                    barrier3SuccessProbability: 0.95
                )
            )
        }
    }
}
