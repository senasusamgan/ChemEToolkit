struct ClosedLoopFeedbackAnalysisEngine: Sendable {
    private let singularTolerance = 1e-12

    func calculate(_ input: ClosedLoopFeedbackAnalysisInput) throws -> ClosedLoopFeedbackAnalysisResult {
        let values = [input.forwardPathGain, input.feedbackPathGain, input.referenceInput, input.outputDisturbance]
        guard values.allSatisfy(\.isFinite) else { throw ClosedLoopFeedbackAnalysisError.nonFiniteInput }

        let loopGain = input.forwardPathGain * input.feedbackPathGain
        let denominator = 1 + loopGain
        guard abs(denominator) > singularTolerance else { throw ClosedLoopFeedbackAnalysisError.singularClosedLoop }

        let closedLoopGain = input.forwardPathGain / denominator
        let sensitivity = 1 / denominator
        let complementary = loopGain / denominator
        let outputFromReference = closedLoopGain * input.referenceInput
        let outputFromDisturbance = sensitivity * input.outputDisturbance
        let totalOutput = outputFromReference + outputFromDisturbance
        let trackingError = input.referenceInput - input.feedbackPathGain * totalOutput
        let warning = denominator > 0
            ? "The static negative-feedback denominator is positive; dynamic stability still depends on poles and phase."
            : "The static denominator is negative. Verify feedback sign and dynamic stability before implementation."

        let results = [loopGain, denominator, closedLoopGain, sensitivity, complementary, outputFromReference, outputFromDisturbance, totalOutput, trackingError]
        guard results.allSatisfy(\.isFinite) else { throw ClosedLoopFeedbackAnalysisError.numericalFailure }

        return .init(
            loopGain: loopGain,
            characteristicDenominator: denominator,
            closedLoopReferenceGain: closedLoopGain,
            sensitivityFunction: sensitivity,
            complementarySensitivity: complementary,
            outputFromReference: outputFromReference,
            outputFromDisturbance: outputFromDisturbance,
            totalOutput: totalOutput,
            referenceTrackingError: trackingError,
            stabilityWarningDescription: warning,
            modelName: "Static negative-feedback relations with loop gain L=GH",
            limitationDescription: "This module evaluates algebraic gains only. A positive static denominator does not prove dynamic stability; poles, delays and frequency-dependent phase must be analyzed separately."
        )
    }
}
