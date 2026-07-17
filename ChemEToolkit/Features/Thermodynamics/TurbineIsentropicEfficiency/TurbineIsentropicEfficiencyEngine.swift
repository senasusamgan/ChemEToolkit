struct TurbineIsentropicEfficiencyEngine: Sendable {
    func calculate(_ input: TurbineIsentropicEfficiencyInput) throws -> TurbineIsentropicEfficiencyResult {
        let v=[input.massFlowRate,input.inletEnthalpy,input.isentropicOutletEnthalpy,input.actualOutletEnthalpy]
        guard v.allSatisfy(\.isFinite) else { throw TurbineIsentropicEfficiencyError.nonFiniteInput }
        guard input.massFlowRate > 0 else { throw TurbineIsentropicEfficiencyError.nonPositiveMassFlow }
        guard input.isentropicOutletEnthalpy < input.inletEnthalpy else { throw TurbineIsentropicEfficiencyError.invalidIsentropicDrop }
        guard input.actualOutletEnthalpy >= input.isentropicOutletEnthalpy, input.actualOutletEnthalpy <= input.inletEnthalpy else { throw TurbineIsentropicEfficiencyError.invalidActualOutlet }
        let ideal=input.inletEnthalpy-input.isentropicOutletEnthalpy, actual=input.inletEnthalpy-input.actualOutletEnthalpy, eta=actual/ideal
        let idealPower=input.massFlowRate*ideal, actualPower=input.massFlowRate*actual, lost=idealPower-actualPower
        guard [ideal,actual,eta,idealPower,actualPower,lost].allSatisfy(\.isFinite), eta >= 0, eta <= 1 else { throw TurbineIsentropicEfficiencyError.numericalFailure }
        return .init(isentropicEfficiency: eta, idealSpecificWork: ideal, actualSpecificWork: actual, idealPower: idealPower, actualPower: actualPower, lostPowerPotential: lost, modelName: "Adiabatic turbine isentropic efficiency", limitationDescription: "Uses ηt = (h₁ − h₂,a)/(h₁ − h₂,s), neglecting kinetic and potential energy changes.")
    }
}
