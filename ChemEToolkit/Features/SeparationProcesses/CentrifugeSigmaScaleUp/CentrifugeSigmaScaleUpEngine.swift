struct CentrifugeSigmaScaleUpEngine: Sendable {
    func calculate(_ input: CentrifugeSigmaScaleUpInput) throws -> CentrifugeSigmaScaleUpResult {
        let values = [input.referenceThroughput, input.referenceSigmaFactor, input.targetSigmaFactor, input.efficiencyCorrection]
        guard values.allSatisfy(\.isFinite) else { throw CentrifugeSigmaScaleUpError.nonFiniteInput }
        guard input.referenceThroughput > 0, input.referenceSigmaFactor > 0, input.targetSigmaFactor > 0 else {
            throw CentrifugeSigmaScaleUpError.nonPositiveThroughputOrSigma
        }
        guard input.efficiencyCorrection > 0, input.efficiencyCorrection <= 1 else {
            throw CentrifugeSigmaScaleUpError.invalidCorrection
        }

        let ratio = input.targetSigmaFactor / input.referenceSigmaFactor
        let ideal = input.referenceThroughput * ratio
        let corrected = ideal * input.efficiencyCorrection
        let increase = corrected - input.referenceThroughput
        let gain = corrected / input.referenceThroughput

        guard [ratio, ideal, corrected, increase, gain].allSatisfy(\.isFinite), corrected > 0 else {
            throw CentrifugeSigmaScaleUpError.numericalFailure
        }

        return .init(
            sigmaRatio: ratio,
            idealTargetThroughput: ideal,
            correctedTargetThroughput: corrected,
            throughputIncrease: increase,
            relativeCapacityGain: gain,
            modelName: "Centrifuge sigma-theory scale-up",
            limitationDescription: "Assumes equal particle-settling behavior and scales throughput linearly with sigma factor."
        )
    }
}
