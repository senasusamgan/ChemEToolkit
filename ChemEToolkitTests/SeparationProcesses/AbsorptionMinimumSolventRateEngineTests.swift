import Testing
@testable import ChemEToolkit

@Suite("Absorption Minimum Solvent Rate Engine")
struct AbsorptionMinimumSolventRateEngineTests {
    private let engine = AbsorptionMinimumSolventRateEngine()

    @Test("Calculates minimum and design solvent flow")
    func flow() throws {
        let r = try engine.calculate(.init(
            gasMolarFlow: 100, inletGasSoluteFraction: 0.10, outletGasSoluteFraction: 0.02,
            inletLiquidSoluteFraction: 0, equilibriumSlope: 1.5, designFactor: 1.5
        ))
        #expect(abs(r.soluteAbsorbedFlow - 8) < 1e-12)
        #expect(r.designSolventFlow > r.minimumSolventFlow)
    }

    @Test("Higher design factor increases solvent flow")
    func trend() throws {
        let a = try engine.calculate(.init(gasMolarFlow: 100, inletGasSoluteFraction: 0.1, outletGasSoluteFraction: 0.02, inletLiquidSoluteFraction: 0, equilibriumSlope: 1.5, designFactor: 1.2))
        let b = try engine.calculate(.init(gasMolarFlow: 100, inletGasSoluteFraction: 0.1, outletGasSoluteFraction: 0.02, inletLiquidSoluteFraction: 0, equilibriumSlope: 1.5, designFactor: 1.8))
        #expect(b.designSolventFlow > a.designSolventFlow)
    }

    @Test("Rejects reversed gas compositions")
    func validation() {
        #expect(throws: AbsorptionMinimumSolventRateError.invalidComposition) {
            try engine.calculate(.init(gasMolarFlow: 100, inletGasSoluteFraction: 0.02, outletGasSoluteFraction: 0.1, inletLiquidSoluteFraction: 0, equilibriumSlope: 1.5, designFactor: 1.5))
        }
    }
}
