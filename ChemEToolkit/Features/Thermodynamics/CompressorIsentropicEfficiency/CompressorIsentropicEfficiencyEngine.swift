struct CompressorIsentropicEfficiencyEngine: Sendable {
    func calculate(_ input: CompressorIsentropicEfficiencyInput) throws -> CompressorIsentropicEfficiencyResult {
        let v=[input.massFlowRate,input.inletEnthalpy,input.isentropicOutletEnthalpy,input.actualOutletEnthalpy]
        guard v.allSatisfy(\.isFinite) else { throw CompressorIsentropicEfficiencyError.nonFiniteInput }
        guard input.massFlowRate > 0 else { throw CompressorIsentropicEfficiencyError.nonPositiveMassFlow }
        guard input.isentropicOutletEnthalpy > input.inletEnthalpy else { throw CompressorIsentropicEfficiencyError.invalidIsentropicRise }
        guard input.actualOutletEnthalpy >= input.isentropicOutletEnthalpy else { throw CompressorIsentropicEfficiencyError.invalidActualOutlet }
        let ideal=input.isentropicOutletEnthalpy-input.inletEnthalpy, actual=input.actualOutletEnthalpy-input.inletEnthalpy, eta=ideal/actual
        let idealPower=input.massFlowRate*ideal, actualPower=input.massFlowRate*actual, excess=actualPower-idealPower
        guard [ideal,actual,eta,idealPower,actualPower,excess].allSatisfy(\.isFinite), eta > 0, eta <= 1 else { throw CompressorIsentropicEfficiencyError.numericalFailure }
        return .init(isentropicEfficiency: eta, idealSpecificWorkInput: ideal, actualSpecificWorkInput: actual, idealPowerInput: idealPower, actualPowerInput: actualPower, excessPowerInput: excess, modelName: "Adiabatic compressor isentropic efficiency", limitationDescription: "Uses ηc = (h₂,s − h₁)/(h₂,a − h₁), neglecting kinetic and potential energy changes.")
    }
}
