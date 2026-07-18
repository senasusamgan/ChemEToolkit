struct AbsorptionMinimumSolventRateEngine: Sendable {
    func calculate(_ input: AbsorptionMinimumSolventRateInput) throws -> AbsorptionMinimumSolventRateResult {
        let values = [
            input.gasMolarFlow, input.inletGasSoluteFraction, input.outletGasSoluteFraction,
            input.inletLiquidSoluteFraction, input.equilibriumSlope, input.designFactor
        ]
        guard values.allSatisfy(\.isFinite) else { throw AbsorptionMinimumSolventRateError.nonFiniteInput }
        guard input.gasMolarFlow > 0 else { throw AbsorptionMinimumSolventRateError.nonPositiveGasFlow }
        guard input.inletGasSoluteFraction > input.outletGasSoluteFraction,
              input.outletGasSoluteFraction >= 0,
              input.inletGasSoluteFraction < 1,
              input.inletLiquidSoluteFraction >= 0,
              input.inletLiquidSoluteFraction < 1 else {
            throw AbsorptionMinimumSolventRateError.invalidComposition
        }
        guard input.equilibriumSlope > 0 else { throw AbsorptionMinimumSolventRateError.invalidEquilibriumSlope }
        guard input.designFactor >= 1 else { throw AbsorptionMinimumSolventRateError.invalidDesignFactor }

        let pinchX = input.inletGasSoluteFraction / input.equilibriumSlope
        guard pinchX > input.inletLiquidSoluteFraction else {
            throw AbsorptionMinimumSolventRateError.infeasiblePinch
        }

        let absorbed = input.gasMolarFlow * (input.inletGasSoluteFraction - input.outletGasSoluteFraction)
        let minimum = absorbed / (pinchX - input.inletLiquidSoluteFraction)
        let design = minimum * input.designFactor
        let ratio = design / input.gasMolarFlow

        guard [pinchX, absorbed, minimum, design, ratio].allSatisfy(\.isFinite), minimum > 0 else {
            throw AbsorptionMinimumSolventRateError.numericalFailure
        }

        return .init(
            minimumSolventFlow: minimum,
            designSolventFlow: design,
            pinchLiquidComposition: pinchX,
            soluteAbsorbedFlow: absorbed,
            liquidToGasRatio: ratio,
            modelName: "Minimum-solvent absorber pinch balance",
            limitationDescription: "Uses a linear equilibrium relation y = mx and constant dilute-solute gas and liquid flow rates."
        )
    }
}
