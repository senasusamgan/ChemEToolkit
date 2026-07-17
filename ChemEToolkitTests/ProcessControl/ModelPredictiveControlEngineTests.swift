import Testing
@testable import ChemEToolkit

@Suite("Model Predictive Control Engine")
struct ModelPredictiveControlEngineTests {
    private let engine = ModelPredictiveControlEngine()

    @Test("Calculates unconstrained finite-horizon move")
    func finiteHorizonMove() throws {
        let result = try engine.calculate(.init(
            currentProcessOutput: 20, referenceSetpoint: 30, processGain: 2,
            processTimeConstant: 5, sampleTime: 1, predictionHorizonSteps: 8,
            moveSuppressionWeight: 1, previousManipulatedInput: 10,
            minimumManipulatedInput: 0, maximumManipulatedInput: 100
        ))
        #expect(result.predictionHorizonSteps == 8)
        #expect(abs(result.unconstrainedInputMove - 7.3478177580684694) < 1e-12)
        #expect(abs(result.appliedInputMove - 7.3478177580684694) < 1e-12)
        #expect(abs(result.predictedFirstStepOutput - 22.663866783050608) < 1e-12)
        #expect(abs(result.predictedHorizonOutput - 31.728637875710302) < 1e-12)
        #expect(!result.inputConstraintIsActive)
    }

    @Test("Projects manipulated input onto constraints")
    func inputConstraint() throws {
        let result = try engine.calculate(.init(
            currentProcessOutput: 0, referenceSetpoint: 1000, processGain: 1,
            processTimeConstant: 5, sampleTime: 1, predictionHorizonSteps: 8,
            moveSuppressionWeight: 0, previousManipulatedInput: 10,
            minimumManipulatedInput: 0, maximumManipulatedInput: 20
        ))
        #expect(result.appliedManipulatedInput == 20)
        #expect(result.appliedInputMove == 10)
        #expect(result.inputConstraintIsActive)
    }

    @Test("Rejects noninteger prediction horizon")
    func validation() {
        #expect(throws: ModelPredictiveControlError.invalidPredictionHorizon) {
            try engine.calculate(.init(
                currentProcessOutput: 20, referenceSetpoint: 30, processGain: 2,
                processTimeConstant: 5, sampleTime: 1, predictionHorizonSteps: 8.5,
                moveSuppressionWeight: 1, previousManipulatedInput: 10,
                minimumManipulatedInput: 0, maximumManipulatedInput: 100
            ))
        }
    }
}
