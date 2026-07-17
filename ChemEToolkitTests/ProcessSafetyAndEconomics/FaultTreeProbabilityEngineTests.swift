import Testing
@testable import ChemEToolkit

@Suite("Fault Tree Probability Engine")
struct FaultTreeProbabilityEngineTests {
    private let engine =
        FaultTreeProbabilityEngine()

    @Test("Calculates independent OR-gate probability")
    func orGate() throws {
        let result = try engine.calculate(
            .init(
                basicEvent1Probability: 0.01,
                basicEvent2Probability: 0.02,
                basicEvent3Probability: 0.03,
                gateCode: 1
            )
        )

        #expect(result.gateName == "OR")

        #expect(
            abs(
                result.topEventProbability
                - 0.058906000000000125
            ) < 1e-14
        )

        #expect(
            abs(
                result.approximationError
                - 0.0010939999999998729
            ) < 1e-14
        )

        #expect(
            result.dominantBasicEvent
            == "Basic Event 3"
        )
    }

    @Test("Calculates independent AND-gate probability")
    func andGate() throws {
        let result = try engine.calculate(
            .init(
                basicEvent1Probability: 0.01,
                basicEvent2Probability: 0.02,
                basicEvent3Probability: 0.03,
                gateCode: 2
            )
        )

        #expect(result.gateName == "AND")

        #expect(
            abs(
                result.topEventProbability
                - 6.0000000000000002e-06
            ) < 1e-16
        )

        #expect(
            result.approximationError == 0
        )
    }

    @Test("Rejects invalid gate code")
    func validation() {
        #expect(
            throws:
                FaultTreeProbabilityError
                    .invalidGateCode
        ) {
            try engine.calculate(
                .init(
                    basicEvent1Probability: 0.01,
                    basicEvent2Probability: 0.02,
                    basicEvent3Probability: 0.03,
                    gateCode: 3
                )
            )
        }
    }
}
