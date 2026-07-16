struct PDControllerEngine: Sendable {
    func calculate(_ input: PDControllerInput) throws -> PDControllerResult {
        let values = [input.controllerBias, input.controllerGain, input.currentError, input.errorRateOfChange, input.derivativeTime, input.minimumOutput, input.maximumOutput]
        guard values.allSatisfy(\.isFinite) else { throw PDControllerError.nonFiniteInput }
        guard input.derivativeTime >= 0 else { throw PDControllerError.negativeDerivativeTime }
        guard input.minimumOutput < input.maximumOutput else { throw PDControllerError.invalidOutputLimits }

        let p = input.controllerGain * input.currentError
        let d = input.controllerGain * input.derivativeTime * input.errorRateOfChange
        let raw = input.controllerBias + p + d
        let limited = min(input.maximumOutput, max(input.minimumOutput, raw))
        let kd = input.controllerGain * input.derivativeTime

        guard [p, d, raw, limited, limited - raw, kd].allSatisfy(\.isFinite) else {
            throw PDControllerError.numericalFailure
        }

        return .init(
            proportionalContribution: p,
            derivativeContribution: d,
            unconstrainedOutput: raw,
            constrainedOutput: limited,
            saturationAmount: limited - raw,
            isSaturatedLow: raw < input.minimumOutput,
            isSaturatedHigh: raw > input.maximumOutput,
            equivalentDerivativeGain: kd,
            modelName: "Ideal PD controller: u = u_bias + K_c[e + T_d(de/dt)]",
            limitationDescription: "Uses an ideal unfiltered derivative of error. Practical controllers normally filter derivative action and may differentiate the measurement."
        )
    }
}
