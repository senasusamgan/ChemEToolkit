struct SteadyFlowEnergyEquationEngine: Sendable {
    private let gravity = 9.80665
    func calculate(_ input: SteadyFlowEnergyEquationInput) throws -> SteadyFlowEnergyEquationResult {
        let values = [input.massFlowRate, input.shaftWorkRateByControlVolume, input.inletEnthalpy, input.outletEnthalpy, input.inletVelocity, input.outletVelocity, input.inletElevation, input.outletElevation]
        guard values.allSatisfy(\.isFinite) else { throw SteadyFlowEnergyEquationError.nonFiniteInput }
        guard input.massFlowRate > 0 else { throw SteadyFlowEnergyEquationError.nonPositiveMassFlow }
        guard input.inletVelocity >= 0, input.outletVelocity >= 0 else { throw SteadyFlowEnergyEquationError.negativeVelocity }
        let dh = input.outletEnthalpy - input.inletEnthalpy
        let dke = (input.outletVelocity * input.outletVelocity - input.inletVelocity * input.inletVelocity) / 2000
        let dpe = gravity * (input.outletElevation - input.inletElevation) / 1000
        let specific = dh + dke + dpe
        let heat = input.shaftWorkRateByControlVolume + input.massFlowRate * specific
        guard [dh,dke,dpe,specific,heat].allSatisfy(\.isFinite) else { throw SteadyFlowEnergyEquationError.numericalFailure }
        let direction = heat > 0 ? "Heat input required" : (heat < 0 ? "Heat rejection required" : "Adiabatic balance")
        return .init(specificEnthalpyChange: dh, specificKineticEnergyChange: dke, specificPotentialEnergyChange: dpe, totalSpecificEnergyChange: specific, requiredHeatTransferRate: heat, directionDescription: direction, modelName: "Single-inlet single-outlet steady-flow energy equation", limitationDescription: "Uses Q̇ − Ẇ = ṁ[Δh + Δ(V²/2) + gΔz], with enthalpy in kJ/kg, velocity in m/s and elevation in m.")
    }
}
