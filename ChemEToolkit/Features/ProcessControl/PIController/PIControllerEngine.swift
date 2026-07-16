struct PIControllerEngine: Sendable {
    func calculate(_ input: PIControllerInput) throws -> PIControllerResult {
        let values = [input.controllerBias, input.controllerGain, input.currentError, input.accumulatedErrorIntegral, input.integralTime, input.minimumOutput, input.maximumOutput]
        guard values.allSatisfy(\.isFinite) else { throw PIControllerError.nonFiniteInput }
        guard input.integralTime > 0 else { throw PIControllerError.nonPositiveIntegralTime }
        guard input.minimumOutput < input.maximumOutput else { throw PIControllerError.invalidOutputLimits }

        let p = input.controllerGain * input.currentError
        let i = input.controllerGain / input.integralTime * input.accumulatedErrorIntegral
        let raw = input.controllerBias + p + i
        let limited = min(input.maximumOutput, max(input.minimumOutput, raw))
        let ki = input.controllerGain / input.integralTime

        guard [p, i, raw, limited, limited - raw, ki].allSatisfy(\.isFinite) else {
            throw PIControllerError.numericalFailure
        }

        return .init(
            proportionalContribution: p,
            integralContribution: i,
            unconstrainedOutput: raw,
            constrainedOutput: limited,
            saturationAmount: limited - raw,
            isSaturatedLow: raw < input.minimumOutput,
            isSaturatedHigh: raw > input.maximumOutput,
            equivalentIntegralGain: ki,
            modelName: "Ideal PI controller: u = u_bias + K_c[e + (1/T_i)∫e dt]",
            limitationDescription: "The supplied error integral is treated as known. Output limiting is included, but automatic anti-windup correction is not."
        )
    }
}
