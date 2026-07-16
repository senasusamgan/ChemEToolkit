struct PIDControllerEngine: Sendable {
    private let zeroTolerance = 1e-14

    func calculate(_ input: PIDControllerInput) throws -> PIDControllerResult {
        let values = [input.controllerBias, input.controllerGain, input.currentError, input.accumulatedErrorIntegral, input.errorRateOfChange, input.integralTime, input.derivativeTime, input.minimumOutput, input.maximumOutput]
        guard values.allSatisfy(\.isFinite) else { throw PIDControllerError.nonFiniteInput }
        guard input.integralTime > 0 else { throw PIDControllerError.nonPositiveIntegralTime }
        guard input.derivativeTime >= 0 else { throw PIDControllerError.negativeDerivativeTime }
        guard input.minimumOutput < input.maximumOutput else { throw PIDControllerError.invalidOutputLimits }

        let p = input.controllerGain * input.currentError
        let i = input.controllerGain / input.integralTime * input.accumulatedErrorIntegral
        let d = input.controllerGain * input.derivativeTime * input.errorRateOfChange
        let raw = input.controllerBias + p + i + d
        let limited = min(input.maximumOutput, max(input.minimumOutput, raw))
        let totalMagnitude = abs(p) + abs(i) + abs(d)

        let ps = totalMagnitude > zeroTolerance ? abs(p) / totalMagnitude : nil
        let `is` = totalMagnitude > zeroTolerance ? abs(i) / totalMagnitude : nil
        let ds = totalMagnitude > zeroTolerance ? abs(d) / totalMagnitude : nil

        guard [p, i, d, raw, limited, limited - raw].allSatisfy(\.isFinite) else {
            throw PIDControllerError.numericalFailure
        }

        return .init(
            proportionalContribution: p,
            integralContribution: i,
            derivativeContribution: d,
            unconstrainedOutput: raw,
            constrainedOutput: limited,
            saturationAmount: limited - raw,
            isSaturatedLow: raw < input.minimumOutput,
            isSaturatedHigh: raw > input.maximumOutput,
            proportionalShareFraction: ps,
            integralShareFraction: `is`,
            derivativeShareFraction: ds,
            modelName: "Ideal PID controller: u = u_bias + K_c[e + (1/T_i)∫e dt + T_d(de/dt)]",
            limitationDescription: "The error integral is supplied directly. Output limiting is included, but derivative filtering, anti-windup and bumpless transfer are not modeled."
        )
    }
}
