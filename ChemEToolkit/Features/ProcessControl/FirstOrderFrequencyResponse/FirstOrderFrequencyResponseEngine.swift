import Foundation

struct FirstOrderFrequencyResponseEngine: Sendable {
    func calculate(_ input: FirstOrderFrequencyResponseInput) throws -> FirstOrderFrequencyResponseResult {
        let values = [input.processGain, input.timeConstant, input.angularFrequency]
        guard values.allSatisfy(\.isFinite) else { throw FirstOrderFrequencyResponseError.nonFiniteInput }
        guard input.processGain != 0 else { throw FirstOrderFrequencyResponseError.zeroProcessGain }
        guard input.timeConstant > 0 else { throw FirstOrderFrequencyResponseError.nonPositiveTimeConstant }
        guard input.angularFrequency >= 0 else { throw FirstOrderFrequencyResponseError.negativeAngularFrequency }

        let normalized = input.angularFrequency * input.timeConstant
        let denominator = 1 + normalized * normalized
        let realPart = input.processGain / denominator
        let imaginaryPart = -input.processGain * normalized / denominator
        let magnitude = abs(input.processGain) / denominator.squareRoot()
        let magnitudeDecibels = 20 * log10(magnitude)
        let phaseRadians = atan2(imaginaryPart, realPart)
        let phaseDegrees = phaseRadians * 180 / Double.pi
        let cutoff = 1 / input.timeConstant

        let results = [realPart, imaginaryPart, magnitude, magnitudeDecibels, phaseRadians, phaseDegrees, cutoff, normalized]
        guard results.allSatisfy(\.isFinite), magnitude > 0, cutoff > 0, normalized >= 0 else {
            throw FirstOrderFrequencyResponseError.numericalFailure
        }

        return .init(
            realPart: realPart,
            imaginaryPart: imaginaryPart,
            magnitude: magnitude,
            magnitudeDecibels: magnitudeDecibels,
            phaseRadians: phaseRadians,
            phaseDegrees: phaseDegrees,
            cutoffAngularFrequency: cutoff,
            normalizedFrequency: normalized,
            modelName: "First-order frequency response: G(jω)=K/(1+jωτ)",
            limitationDescription: "Evaluates one frequency for a linear first-order transfer function. Dead time, zeros, nonlinear behavior and uncertainty are not included."
        )
    }
}
