import Foundation
import Testing
@testable import ChemEToolkit

@Suite("First-Order Process Response Engine")
struct FirstOrderProcessResponseEngineTests {
    private let engine =
        FirstOrderProcessResponseEngine()

    @Test("Calculates first-order step response")
    func response() throws {
        let result = try engine.calculate(
            .init(
                initialOutput: 20,
                processGain: 2,
                inputStepChange: 5,
                timeConstant: 4,
                evaluationTime: 6
            )
        )

        #expect(
            abs(
                result.fractionOfFinalChange
                - 0.77686983985157021
            ) < 1e-12
        )

        #expect(
            abs(
                result.outputAtEvaluationTime
                - (
                    20
                    + 10
                    * 0.77686983985157021
                )
            ) < 1e-12
        )

        #expect(
            result.finalSteadyStateOutput
            == 30
        )

        #expect(
            result.initialResponseSlope
            == 2.5
        )
    }

    @Test("One time constant completes 63.2 percent")
    func oneTimeConstant() throws {
        let result = try engine.calculate(
            .init(
                initialOutput: 0,
                processGain: 1,
                inputStepChange: 1,
                timeConstant: 5,
                evaluationTime: 5
            )
        )

        #expect(
            abs(
                result.fractionOfFinalChange
                - (
                    1
                    - Foundation.exp(-1)
                )
            ) < 1e-12
        )
    }

    @Test("Rejects invalid time values")
    func validation() {
        #expect(
            throws:
                FirstOrderProcessResponseError
                    .nonPositiveTimeConstant
        ) {
            try engine.calculate(
                .init(
                    initialOutput: 0,
                    processGain: 1,
                    inputStepChange: 1,
                    timeConstant: 0,
                    evaluationTime: 1
                )
            )
        }
    }
}
