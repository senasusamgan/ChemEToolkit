import Testing
@testable import ChemEToolkit

@Suite("Stripping Minimum Gas Rate Engine")
struct StrippingMinimumGasRateEngineTests {
    private let engine = StrippingMinimumGasRateEngine()

    @Test("Calculates minimum and design gas flow")
    func flow() throws {
        let r = try engine.calculate(.init(
            liquidMolarFlow: 100, inletLiquidSoluteFraction: 0.10, outletLiquidSoluteFraction: 0.02,
            enteringGasSoluteFraction: 0, equilibriumSlope: 1.5, designFactor: 1.5
        ))
        #expect(abs(r.soluteStrippedFlow - 8) < 1e-12)
        #expect(r.designGasFlow > r.minimumGasFlow)
    }

    @Test("Higher slope lowers minimum gas")
    func trend() throws {
        let a = try engine.calculate(.init(liquidMolarFlow: 100, inletLiquidSoluteFraction: 0.1, outletLiquidSoluteFraction: 0.02, enteringGasSoluteFraction: 0, equilibriumSlope: 1, designFactor: 1))
        let b = try engine.calculate(.init(liquidMolarFlow: 100, inletLiquidSoluteFraction: 0.1, outletLiquidSoluteFraction: 0.02, enteringGasSoluteFraction: 0, equilibriumSlope: 2, designFactor: 1))
        #expect(b.minimumGasFlow < a.minimumGasFlow)
    }

    @Test("Rejects reversed liquid compositions")
    func validation() {
        #expect(throws: StrippingMinimumGasRateError.invalidComposition) {
            try engine.calculate(.init(liquidMolarFlow: 100, inletLiquidSoluteFraction: 0.02, outletLiquidSoluteFraction: 0.1, enteringGasSoluteFraction: 0, equilibriumSlope: 1.5, designFactor: 1.5))
        }
    }
}
