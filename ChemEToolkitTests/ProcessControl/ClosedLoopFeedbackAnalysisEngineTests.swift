import Testing
@testable import ChemEToolkit

@Suite("Closed-Loop Feedback Analysis Engine")
struct ClosedLoopFeedbackAnalysisEngineTests {
    private let engine = ClosedLoopFeedbackAnalysisEngine()

    @Test("Calculates tracking and disturbance response")
    func feedback() throws {
        let result = try engine.calculate(.init(forwardPathGain: 4, feedbackPathGain: 1, referenceInput: 10, outputDisturbance: 2))
        #expect(result.loopGain == 4)
        #expect(result.characteristicDenominator == 5)
        #expect(result.closedLoopReferenceGain == 0.8)
        #expect(result.sensitivityFunction == 0.2)
        #expect(result.complementarySensitivity == 0.8)
        #expect(result.outputFromReference == 8)
        #expect(result.outputFromDisturbance == 0.4)
        #expect(abs(result.totalOutput - 8.4) < 1e-12)
        #expect(abs(result.referenceTrackingError - 1.6) < 1e-12)
    }

    @Test("Zero feedback reduces to open-loop reference gain")
    func zeroFeedback() throws {
        let result = try engine.calculate(.init(forwardPathGain: 4, feedbackPathGain: 0, referenceInput: 10, outputDisturbance: 2))
        #expect(result.closedLoopReferenceGain == 4)
        #expect(result.sensitivityFunction == 1)
        #expect(result.complementarySensitivity == 0)
        #expect(result.totalOutput == 42)
    }

    @Test("Rejects singular denominator")
    func validation() {
        #expect(throws: ClosedLoopFeedbackAnalysisError.singularClosedLoop) {
            try engine.calculate(.init(forwardPathGain: 1, feedbackPathGain: -1, referenceInput: 10, outputDisturbance: 0))
        }
    }
}
