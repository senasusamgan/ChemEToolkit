import Testing
@testable import ChemEToolkit

@Suite("FOPDT Process Engine")
struct FirstOrderPlusDeadTimeProcessEngineTests {
    private let engine =
        FirstOrderPlusDeadTimeProcessEngine()

    @Test("Calculates delayed first-order response")
    func response() throws {
        let result = try engine.calculate(
            .init(
                initialOutput: 20,
                processGain: 2,
                inputStepChange: 5,
                timeConstant: 4,
                deadTime: 2,
                evaluationTime: 6
            )
        )

        #expect(result.responseHasStarted)

        #expect(
            result.activeResponseTime
            == 4
        )

        #expect(
            abs(
                result.fractionOfFinalChange
                - 0.63212055882855767
            ) < 1e-12
        )

        #expect(
            result.twoPercentSettlingTime
            == 18
        )
    }

    @Test("Output remains unchanged before dead time")
    func beforeDeadTime() throws {
        let result = try engine.calculate(
            .init(
                initialOutput: 20,
                processGain: 2,
                inputStepChange: 5,
                timeConstant: 4,
                deadTime: 2,
                evaluationTime: 1
            )
        )

        #expect(!result.responseHasStarted)

        #expect(
            result.outputAtEvaluationTime
            == 20
        )

        #expect(
            result.fractionOfFinalChange
            == 0
        )
    }

    @Test("Rejects negative dead time")
    func validation() {
        #expect(
            throws:
                FirstOrderPlusDeadTimeProcessError
                    .negativeDeadTime
        ) {
            try engine.calculate(
                .init(
                    initialOutput: 0,
                    processGain: 1,
                    inputStepChange: 1,
                    timeConstant: 1,
                    deadTime: -1,
                    evaluationTime: 2
                )
            )
        }
    }
}
