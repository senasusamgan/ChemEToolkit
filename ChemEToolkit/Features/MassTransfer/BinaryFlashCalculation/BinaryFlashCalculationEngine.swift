import Foundation

struct BinaryFlashCalculationEngine: Sendable {
    private let tolerance = 1.0e-12

    func calculate(_ input: BinaryFlashCalculationInput) throws -> BinaryFlashCalculationResult {
        let values = [input.feedFlowRate, input.feedLightMoleFraction, input.lightComponentKValue, input.heavyComponentKValue]
        guard values.allSatisfy(\.isFinite) else { throw BinaryFlashCalculationError.nonFiniteInput }
        guard input.feedFlowRate > 0 else { throw BinaryFlashCalculationError.nonPositiveFeedFlow }
        guard (0...1).contains(input.feedLightMoleFraction) else { throw BinaryFlashCalculationError.feedCompositionOutOfRange }
        guard input.lightComponentKValue > 0, input.heavyComponentKValue > 0 else { throw BinaryFlashCalculationError.nonPositiveKValue }
        guard input.lightComponentKValue > input.heavyComponentKValue else { throw BinaryFlashCalculationError.invalidKValueOrdering }

        let f0 = residual(beta: 0, input: input)
        let f1 = residual(beta: 1, input: input)

        let state: BinaryFlashPhaseState
        let beta: Double
        let xLight: Double
        let yLight: Double
        let rrResidual: Double

        if abs(f0) <= tolerance {
            state = .bubblePoint; beta = 0
            xLight = input.feedLightMoleFraction
            yLight = incipientVaporLight(input)
            rrResidual = f0
        } else if f0 < 0 {
            state = .allLiquid; beta = 0
            xLight = input.feedLightMoleFraction
            yLight = incipientVaporLight(input)
            rrResidual = f0
        } else if abs(f1) <= tolerance {
            state = .dewPoint; beta = 1
            yLight = input.feedLightMoleFraction
            xLight = incipientLiquidLight(input)
            rrResidual = f1
        } else if f1 > 0 {
            state = .allVapor; beta = 1
            yLight = input.feedLightMoleFraction
            xLight = incipientLiquidLight(input)
            rrResidual = f1
        } else {
            state = .twoPhase
            beta = try solveBeta(input)

            let rawXL = input.feedLightMoleFraction / (1 + beta * (input.lightComponentKValue - 1))
            let rawXH = (1 - input.feedLightMoleFraction) / (1 + beta * (input.heavyComponentKValue - 1))
            let xTotal = rawXL + rawXH
            let rawYL = input.lightComponentKValue * rawXL
            let rawYH = input.heavyComponentKValue * rawXH
            let yTotal = rawYL + rawYH
            guard xTotal > 0, yTotal > 0 else { throw BinaryFlashCalculationError.numericalFailure }
            xLight = rawXL / xTotal
            yLight = rawYL / yTotal
            rrResidual = residual(beta: beta, input: input)
        }

        let liquidFraction = 1 - beta
        let resultValues = [beta, liquidFraction, xLight, yLight, rrResidual]
        guard resultValues.allSatisfy(\.isFinite), (0...1).contains(beta), (0...1).contains(xLight), (0...1).contains(yLight) else {
            throw BinaryFlashCalculationError.numericalFailure
        }

        return .init(
            phaseState: state,
            vaporFraction: beta,
            liquidFraction: liquidFraction,
            vaporFlowRate: input.feedFlowRate * beta,
            liquidFlowRate: input.feedFlowRate * liquidFraction,
            vaporLightMoleFraction: yLight,
            liquidLightMoleFraction: xLight,
            rachfordRiceResidual: rrResidual,
            modelName: "Isothermal binary flash using constant K-values and Rachford–Rice"
        )
    }

    private func residual(beta: Double, input: BinaryFlashCalculationInput) -> Double {
        let z = input.feedLightMoleFraction
        return z * (input.lightComponentKValue - 1) / (1 + beta * (input.lightComponentKValue - 1))
            + (1 - z) * (input.heavyComponentKValue - 1) / (1 + beta * (input.heavyComponentKValue - 1))
    }

    private func solveBeta(_ input: BinaryFlashCalculationInput) throws -> Double {
        var lower = 0.0
        var upper = 1.0
        for _ in 0..<200 {
            let midpoint = 0.5 * (lower + upper)
            let value = residual(beta: midpoint, input: input)
            if abs(value) <= tolerance { return midpoint }
            if value > 0 { lower = midpoint } else { upper = midpoint }
        }
        let midpoint = 0.5 * (lower + upper)
        guard abs(residual(beta: midpoint, input: input)) <= 1e-9 else { throw BinaryFlashCalculationError.numericalFailure }
        return midpoint
    }

    private func incipientVaporLight(_ input: BinaryFlashCalculationInput) -> Double {
        let light = input.lightComponentKValue * input.feedLightMoleFraction
        let heavy = input.heavyComponentKValue * (1 - input.feedLightMoleFraction)
        return light / (light + heavy)
    }

    private func incipientLiquidLight(_ input: BinaryFlashCalculationInput) -> Double {
        let light = input.feedLightMoleFraction / input.lightComponentKValue
        let heavy = (1 - input.feedLightMoleFraction) / input.heavyComponentKValue
        return light / (light + heavy)
    }
}
