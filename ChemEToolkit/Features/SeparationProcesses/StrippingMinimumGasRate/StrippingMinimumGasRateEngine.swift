struct StrippingMinimumGasRateEngine: Sendable {
    func calculate(_ input: StrippingMinimumGasRateInput) throws -> StrippingMinimumGasRateResult {
        let values = [
            input.liquidMolarFlow, input.inletLiquidSoluteFraction, input.outletLiquidSoluteFraction,
            input.enteringGasSoluteFraction, input.equilibriumSlope, input.designFactor
        ]
        guard values.allSatisfy(\.isFinite) else { throw StrippingMinimumGasRateError.nonFiniteInput }
        guard input.liquidMolarFlow > 0 else { throw StrippingMinimumGasRateError.nonPositiveLiquidFlow }
        guard input.inletLiquidSoluteFraction > input.outletLiquidSoluteFraction,
              input.outletLiquidSoluteFraction >= 0,
              input.inletLiquidSoluteFraction < 1,
              input.enteringGasSoluteFraction >= 0,
              input.enteringGasSoluteFraction < 1 else {
            throw StrippingMinimumGasRateError.invalidComposition
        }
        guard input.equilibriumSlope > 0 else { throw StrippingMinimumGasRateError.invalidEquilibriumSlope }
        guard input.designFactor >= 1 else { throw StrippingMinimumGasRateError.invalidDesignFactor }

        let pinchY = input.equilibriumSlope * input.inletLiquidSoluteFraction
        guard pinchY > input.enteringGasSoluteFraction else {
            throw StrippingMinimumGasRateError.infeasiblePinch
        }

        let stripped = input.liquidMolarFlow * (input.inletLiquidSoluteFraction - input.outletLiquidSoluteFraction)
        let minimum = stripped / (pinchY - input.enteringGasSoluteFraction)
        let design = minimum * input.designFactor
        let ratio = design / input.liquidMolarFlow

        guard [pinchY, stripped, minimum, design, ratio].allSatisfy(\.isFinite), minimum > 0 else {
            throw StrippingMinimumGasRateError.numericalFailure
        }

        return .init(
            minimumGasFlow: minimum,
            designGasFlow: design,
            pinchGasComposition: pinchY,
            soluteStrippedFlow: stripped,
            gasToLiquidRatio: ratio,
            modelName: "Minimum-gas stripper pinch balance",
            limitationDescription: "Uses linear equilibrium y = mx and constant dilute-solute gas and liquid flow rates."
        )
    }
}
