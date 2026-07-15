import Testing
@testable import ChemEToolkit

@Suite("Gas Absorption and Stripping Fundamentals Engine")
struct GasAbsorptionStrippingFundamentalsEngineTests {
    private let engine = GasAbsorptionStrippingFundamentalsEngine()

    @Test("Solves absorption balance and minimum solvent flow")
    func absorption() throws {
        let result = try engine.calculate(
            .init(
                operation: .absorption,
                soluteFreeGasFlowRate: 1,
                soluteFreeLiquidFlowRate: 2,
                gasInletSoluteRatio: 0.2,
                gasOutletSoluteRatio: 0.05,
                liquidInletSoluteRatio: 0.02,
                equilibriumSlope: 1.5
            )
        )

        #expect(abs(result.liquidOutletSoluteRatio - 0.095) < 1e-12)
        #expect(abs(result.absorptionFactor - 1.3333333333333333) < 1e-12)
        #expect(abs(result.limitingCarrierFlowRate - 1.323529411764706) < 1e-12)
        #expect(abs(result.soluteRemovalFraction - 0.75) < 1e-12)
    }

    @Test("Solves stripping balance and limiting gas flow")
    func stripping() throws {
        let result = try engine.calculate(
            .init(
                operation: .stripping,
                soluteFreeGasFlowRate: 1,
                soluteFreeLiquidFlowRate: 2,
                gasInletSoluteRatio: 0.01,
                gasOutletSoluteRatio: 0.08,
                liquidInletSoluteRatio: 0.1,
                equilibriumSlope: 1.5
            )
        )

        #expect(abs(result.liquidOutletSoluteRatio - 0.065) < 1e-12)
        #expect(abs(result.limitingCarrierFlowRate - 0.5) < 1e-12)
        #expect(abs(result.actualToMinimumFlowRatio - 2) < 1e-12)
    }

    @Test("Rejects invalid direction, negative ratios, pinches and nonfinite values")
    func validation() {
        #expect(throws: GasAbsorptionStrippingFundamentalsError.invalidOperationDirection) {
            try engine.calculate(.init(
                operation: .absorption,
                soluteFreeGasFlowRate: 1,
                soluteFreeLiquidFlowRate: 2,
                gasInletSoluteRatio: 0.05,
                gasOutletSoluteRatio: 0.2,
                liquidInletSoluteRatio: 0.02,
                equilibriumSlope: 1.5
            ))
        }

        #expect(throws: GasAbsorptionStrippingFundamentalsError.negativeSoluteRatio) {
            try engine.calculate(.init(
                operation: .absorption,
                soluteFreeGasFlowRate: 1,
                soluteFreeLiquidFlowRate: 2,
                gasInletSoluteRatio: 0.2,
                gasOutletSoluteRatio: 0.05,
                liquidInletSoluteRatio: -0.01,
                equilibriumSlope: 1.5
            ))
        }

        #expect(throws: GasAbsorptionStrippingFundamentalsError.pinchOrInsufficientCarrierFlow) {
            try engine.calculate(.init(
                operation: .absorption,
                soluteFreeGasFlowRate: 1,
                soluteFreeLiquidFlowRate: 1,
                gasInletSoluteRatio: 0.2,
                gasOutletSoluteRatio: 0.05,
                liquidInletSoluteRatio: 0.02,
                equilibriumSlope: 1.5
            ))
        }

        #expect(throws: GasAbsorptionStrippingFundamentalsError.nonFiniteInput) {
            try engine.calculate(.init(
                operation: .absorption,
                soluteFreeGasFlowRate: .nan,
                soluteFreeLiquidFlowRate: 2,
                gasInletSoluteRatio: 0.2,
                gasOutletSoluteRatio: 0.05,
                liquidInletSoluteRatio: 0.02,
                equilibriumSlope: 1.5
            ))
        }
    }
}
