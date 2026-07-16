struct ProportionalControllerEngine: Sendable {
    func calculate(_ input: ProportionalControllerInput) throws -> ProportionalControllerResult {
        let values = [input.controllerBias, input.controllerGain, input.currentError, input.minimumOutput, input.maximumOutput]
        guard values.allSatisfy(\.isFinite) else { throw ProportionalControllerError.nonFiniteInput }
        guard input.minimumOutput < input.maximumOutput else { throw ProportionalControllerError.invalidOutputLimits }

        let p = input.controllerGain * input.currentError
        let raw = input.controllerBias + p
        let limited = min(input.maximumOutput, max(input.minimumOutput, raw))
        let action = input.controllerGain > 0
            ? "Positive gain: positive error increases controller output."
            : (input.controllerGain < 0
               ? "Negative gain: positive error decreases controller output."
               : "Zero gain: output remains at the bias unless limited.")

        guard [p, raw, limited, limited - raw].allSatisfy(\.isFinite) else {
            throw ProportionalControllerError.numericalFailure
        }

        return .init(
            proportionalContribution: p,
            unconstrainedOutput: raw,
            constrainedOutput: limited,
            saturationAmount: limited - raw,
            isSaturatedLow: raw < input.minimumOutput,
            isSaturatedHigh: raw > input.maximumOutput,
            controllerActionDescription: action,
            modelName: "Proportional controller: u = u_bias + K_c e",
            limitationDescription: "Evaluates one controller instant. Process dynamics, actuator rate limits and steady-state offset correction are not simulated."
        )
    }
}
