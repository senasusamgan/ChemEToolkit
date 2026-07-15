struct RelativeVolatilityBinaryVLEEngine: Sendable {
    private let tolerance = 1.0e-12

    func calculate(_ input: RelativeVolatilityBinaryVLEInput) throws -> RelativeVolatilityBinaryVLEResult {
        guard input.relativeVolatility.isFinite, input.specifiedMoleFraction.isFinite else {
            throw RelativeVolatilityBinaryVLEError.nonFiniteInput
        }
        guard input.relativeVolatility > 1 else {
            throw RelativeVolatilityBinaryVLEError.relativeVolatilityNotGreaterThanOne
        }
        guard (0...1).contains(input.specifiedMoleFraction) else {
            throw RelativeVolatilityBinaryVLEError.moleFractionOutOfRange
        }

        let x: Double
        let y: Double

        switch input.mode {
        case .liquidToVapor:
            x = input.specifiedMoleFraction
            y = input.relativeVolatility * x / (1 + (input.relativeVolatility - 1) * x)
        case .vaporToLiquid:
            y = input.specifiedMoleFraction
            x = y / (input.relativeVolatility - (input.relativeVolatility - 1) * y)
        }

        guard x.isFinite, y.isFinite, (0...1).contains(x), (0...1).contains(y) else {
            throw RelativeVolatilityBinaryVLEError.numericalFailure
        }

        let enrichment = x > tolerance ? y / x : input.relativeVolatility
        let interpretation = abs(y - x) <= tolerance
            ? "The equilibrium compositions meet at a pure-component boundary."
            : "The vapor phase is enriched in the more volatile component."

        return .init(
            liquidMoleFraction: x,
            vaporMoleFraction: y,
            equilibriumGap: y - x,
            vaporEnrichmentFactor: enrichment,
            interpretation: interpretation,
            modelName: "Constant-relative-volatility binary VLE"
        )
    }
}
