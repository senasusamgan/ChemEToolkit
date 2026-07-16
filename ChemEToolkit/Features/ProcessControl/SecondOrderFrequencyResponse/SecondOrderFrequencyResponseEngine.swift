import Foundation

struct SecondOrderFrequencyResponseEngine: Sendable {
    func calculate(_ input: SecondOrderFrequencyResponseInput) throws -> SecondOrderFrequencyResponseResult {
        let values = [input.processGain, input.naturalFrequency, input.dampingRatio, input.angularFrequency]
        guard values.allSatisfy(\.isFinite) else { throw SecondOrderFrequencyResponseError.nonFiniteInput }
        guard input.processGain != 0 else { throw SecondOrderFrequencyResponseError.zeroProcessGain }
        guard input.naturalFrequency > 0 else { throw SecondOrderFrequencyResponseError.nonPositiveNaturalFrequency }
        guard input.dampingRatio > 0 else { throw SecondOrderFrequencyResponseError.nonPositiveDampingRatio }
        guard input.angularFrequency >= 0 else { throw SecondOrderFrequencyResponseError.negativeAngularFrequency }

        let ratio = input.angularFrequency / input.naturalFrequency
        let denominatorReal = 1 - ratio * ratio
        let denominatorImaginary = 2 * input.dampingRatio * ratio
        let denominatorMagnitudeSquared = denominatorReal * denominatorReal + denominatorImaginary * denominatorImaginary
        guard denominatorMagnitudeSquared > 0 else { throw SecondOrderFrequencyResponseError.numericalFailure }

        let realPart = input.processGain * denominatorReal / denominatorMagnitudeSquared
        let imaginaryPart = -input.processGain * denominatorImaginary / denominatorMagnitudeSquared
        let magnitude = abs(input.processGain) / denominatorMagnitudeSquared.squareRoot()
        let magnitudeDecibels = 20 * log10(magnitude)
        let phase = atan2(imaginaryPart, realPart) * 180 / Double.pi
        let resonanceExists = input.dampingRatio < 1 / sqrt(2.0)
        let resonanceFrequency: Double?
        let resonantPeak: Double?

        if resonanceExists {
            resonanceFrequency = input.naturalFrequency * sqrt(1 - 2 * input.dampingRatio * input.dampingRatio)
            resonantPeak = abs(input.processGain) / (2 * input.dampingRatio * sqrt(1 - input.dampingRatio * input.dampingRatio))
        } else {
            resonanceFrequency = nil
            resonantPeak = nil
        }

        let results = [realPart, imaginaryPart, magnitude, magnitudeDecibels, phase, ratio]
        guard results.allSatisfy(\.isFinite), magnitude > 0, ratio >= 0 else {
            throw SecondOrderFrequencyResponseError.numericalFailure
        }

        return .init(
            realPart: realPart,
            imaginaryPart: imaginaryPart,
            magnitude: magnitude,
            magnitudeDecibels: magnitudeDecibels,
            phaseDegrees: phase,
            normalizedFrequency: ratio,
            resonanceExists: resonanceExists,
            resonanceAngularFrequency: resonanceFrequency,
            resonantPeakMagnitude: resonantPeak,
            modelName: "Standard second-order frequency response: G(jω)=K/[1−(ω/ωₙ)²+j2ζ(ω/ωₙ)]",
            limitationDescription: "Evaluates one frequency for a linear standard second-order system. Zeros, dead time, nonlinearities and additional poles are excluded."
        )
    }
}
