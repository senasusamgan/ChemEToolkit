import Testing
@testable import ChemEToolkit

@Suite("Smith Predictor Engine")
struct SmithPredictorEngineTests {
    private let engine =
        SmithPredictorEngine()

    @Test("Builds Smith predictor estimate")
    func predictorEstimate() throws {
        let result = try engine.calculate(
            .init(
                initialOutput: 20,
                manipulatedVariableStep: 5,
                actualProcessGain: 2,
                actualTimeConstant: 4,
                actualDeadTime: 3,
                modelProcessGain: 1.9,
                modelTimeConstant: 4.2,
                modelDeadTime: 2.8,
                evaluationTime: 6
            )
        )

        #expect(
            abs(
                result.actualDelayedOutput
                - 25.276334472589852
            ) < 1e-12
        )

        #expect(
            abs(
                result.modelDelayedOutput
                - 25.065623424309027
            ) < 1e-12
        )

        #expect(
            abs(
                result.modelDeadTimeFreeOutput
                - 27.223315153803131
            ) < 1e-12
        )

        #expect(
            abs(
                result.modelMismatchCorrection
                - 0.21071104828082454
            ) < 1e-12
        )

        #expect(
            abs(
                result.smithPredictedOutput
                - 27.434026202083956
            ) < 1e-12
        )

        #expect(
            abs(
                result.predictionError
                - -2.157691729494104
            ) < 1e-12
        )
    }

    @Test("Perfect model gives zero mismatch correction")
    func perfectModel() throws {
        let result = try engine.calculate(
            .init(
                initialOutput: 20,
                manipulatedVariableStep: 5,
                actualProcessGain: 2,
                actualTimeConstant: 4,
                actualDeadTime: 3,
                modelProcessGain: 2,
                modelTimeConstant: 4,
                modelDeadTime: 3,
                evaluationTime: 6
            )
        )

        #expect(
            abs(
                result.modelMismatchCorrection
            ) < 1e-12
        )
    }

    @Test("Rejects invalid model time constant")
    func validation() {
        #expect(
            throws:
                SmithPredictorError
                    .nonPositiveTimeConstant
        ) {
            try engine.calculate(
                .init(
                    initialOutput: 20,
                    manipulatedVariableStep: 5,
                    actualProcessGain: 2,
                    actualTimeConstant: 4,
                    actualDeadTime: 3,
                    modelProcessGain: 2,
                    modelTimeConstant: 0,
                    modelDeadTime: 3,
                    evaluationTime: 6
                )
            )
        }
    }
}
