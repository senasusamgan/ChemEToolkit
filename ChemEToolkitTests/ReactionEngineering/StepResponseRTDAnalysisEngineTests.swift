import Testing
@testable import ChemEToolkit

@Suite("Step-Response RTD Analysis Engine")
struct StepResponseRTDAnalysisEngineTests {
    private let engine =
        StepResponseRTDAnalysisEngine()

    @Test("Calculates step-response statistics")
    func analyzesResponse() throws {
        let result = try engine.calculate(
            .init(
                times: [0, 2, 4, 6, 8, 10],
                normalizedOutletResponses:
                    [0.1, 0.2, 0.5, 0.8, 0.95, 1]
            )
        )

        #expect(
            abs(
                result.meanResidenceTime
                - 4
            ) < 1e-12
        )
        #expect(
            abs(
                result.medianResidenceTime
                - 4
            ) < 1e-12
        )
        #expect(
            abs(
                result.immediateBypassFraction
                - 0.1
            ) < 1e-12
        )
        #expect(
            result.intervalEValues.count
            == 5
        )
    }

    @Test("Zero initial response means no bypass")
    func noBypass() throws {
        let result = try engine.calculate(
            .init(
                times: [0, 1, 2],
                normalizedOutletResponses:
                    [0, 0.5, 1]
            )
        )

        #expect(
            result.immediateBypassFraction
            == 0
        )
        #expect(
            abs(
                result.meanResidenceTime
                - 1
            ) < 1e-12
        )
        #expect(
            abs(
                result.medianResidenceTime
                - 1
            ) < 1e-12
        )
    }

    @Test("Rejects incomplete and nonmonotonic responses")
    func validation() {
        #expect(
            throws:
                StepResponseRTDAnalysisError
                    .incompleteResponse
        ) {
            try engine.calculate(
                .init(
                    times: [0, 1, 2],
                    normalizedOutletResponses:
                        [0, 0.4, 0.8]
                )
            )
        }

        #expect(
            throws:
                StepResponseRTDAnalysisError
                    .nonMonotonicResponse
        ) {
            try engine.calculate(
                .init(
                    times: [0, 1, 2],
                    normalizedOutletResponses:
                        [0, 0.8, 0.7]
                )
            )
        }
    }
}
