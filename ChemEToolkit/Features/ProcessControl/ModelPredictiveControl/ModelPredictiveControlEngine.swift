import Foundation

struct ModelPredictiveControlEngine: Sendable {
    func calculate(_ input: ModelPredictiveControlInput) throws -> ModelPredictiveControlResult {
        let values = [
            input.currentProcessOutput, input.referenceSetpoint, input.processGain,
            input.processTimeConstant, input.sampleTime, input.predictionHorizonSteps,
            input.moveSuppressionWeight, input.previousManipulatedInput,
            input.minimumManipulatedInput, input.maximumManipulatedInput
        ]
        guard values.allSatisfy(\.isFinite) else { throw ModelPredictiveControlError.nonFiniteInput }
        guard input.processTimeConstant > 0, input.sampleTime > 0 else {
            throw ModelPredictiveControlError.nonPositiveTimeParameter
        }
        let roundedHorizon = input.predictionHorizonSteps.rounded()
        guard abs(input.predictionHorizonSteps - roundedHorizon) < 1e-12,
              roundedHorizon >= 1, roundedHorizon <= 100 else {
            throw ModelPredictiveControlError.invalidPredictionHorizon
        }
        guard input.moveSuppressionWeight >= 0 else {
            throw ModelPredictiveControlError.negativeMoveSuppression
        }
        guard input.minimumManipulatedInput < input.maximumManipulatedInput else {
            throw ModelPredictiveControlError.invalidInputLimits
        }

        let horizon = Int(roundedHorizon)
        let trackingError = input.referenceSetpoint - input.currentProcessOutput
        var coefficients: [Double] = []
        coefficients.reserveCapacity(horizon)
        for step in 1...horizon {
            let time = Double(step) * input.sampleTime
            coefficients.append(
                input.processGain * (1 - exp(-time / input.processTimeConstant))
            )
        }

        let numerator = coefficients.reduce(0) { $0 + $1 * trackingError }
        let denominator = coefficients.reduce(input.moveSuppressionWeight) { $0 + $1 * $1 }
        guard denominator > 0 else { throw ModelPredictiveControlError.numericalFailure }

        let unconstrainedMove = numerator / denominator
        let unconstrainedInput = input.previousManipulatedInput + unconstrainedMove
        let appliedInput = min(input.maximumManipulatedInput, max(input.minimumManipulatedInput, unconstrainedInput))
        let appliedMove = appliedInput - input.previousManipulatedInput
        let firstPrediction = input.currentProcessOutput + coefficients[0] * appliedMove
        let horizonPrediction = input.currentProcessOutput + coefficients[coefficients.count - 1] * appliedMove
        let horizonError = input.referenceSetpoint - horizonPrediction

        var objective = input.moveSuppressionWeight * appliedMove * appliedMove
        for coefficient in coefficients {
            let error = trackingError - coefficient * appliedMove
            objective += error * error
        }

        let results = [unconstrainedMove, appliedMove, unconstrainedInput, appliedInput,
                       firstPrediction, horizonPrediction, trackingError, horizonError, objective]
        guard results.allSatisfy(\.isFinite), objective >= 0,
              appliedInput >= input.minimumManipulatedInput,
              appliedInput <= input.maximumManipulatedInput else {
            throw ModelPredictiveControlError.numericalFailure
        }

        return .init(
            predictionHorizonSteps: horizon,
            unconstrainedInputMove: unconstrainedMove,
            appliedInputMove: appliedMove,
            unconstrainedManipulatedInput: unconstrainedInput,
            appliedManipulatedInput: appliedInput,
            predictedFirstStepOutput: firstPrediction,
            predictedHorizonOutput: horizonPrediction,
            initialTrackingError: trackingError,
            predictedHorizonError: horizonError,
            objectiveValue: objective,
            inputConstraintIsActive: appliedInput != unconstrainedInput,
            modelName: "Single-move finite-horizon MPC for a first-order process",
            limitationDescription: "Uses one optimized input move over a finite prediction horizon. It is an educational SISO approximation without state estimation, disturbance modeling, multivariable constraints or repeated receding-horizon simulation."
        )
    }
}
