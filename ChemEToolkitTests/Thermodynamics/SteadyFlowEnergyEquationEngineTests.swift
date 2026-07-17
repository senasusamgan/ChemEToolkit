import Testing
@testable import ChemEToolkit

@Suite("Steady-Flow Energy Equation Engine")
struct SteadyFlowEnergyEquationEngineTests {
    private let engine = SteadyFlowEnergyEquationEngine()
    @Test("Calculates required heat") func balance() throws {
        let r = try engine.calculate(.init(massFlowRate: 2, shaftWorkRateByControlVolume: 100, inletEnthalpy: 300, outletEnthalpy: 250, inletVelocity: 20, outletVelocity: 80, inletElevation: 0, outletElevation: 10))
        let expected = 100 + 2 * (-50 + (80.0*80.0-20.0*20.0)/2000 + 9.80665*10/1000)
        #expect(abs(r.requiredHeatTransferRate - expected) < 1e-12)
    }
    @Test("Zero state change makes heat equal work") func zeroChange() throws {
        let r = try engine.calculate(.init(massFlowRate: 2, shaftWorkRateByControlVolume: 100, inletEnthalpy: 300, outletEnthalpy: 300, inletVelocity: 20, outletVelocity: 20, inletElevation: 0, outletElevation: 0))
        #expect(r.requiredHeatTransferRate == 100)
    }
    @Test("Rejects zero flow") func validation() {
        #expect(throws: SteadyFlowEnergyEquationError.nonPositiveMassFlow) { try engine.calculate(.init(massFlowRate: 0, shaftWorkRateByControlVolume: 0, inletEnthalpy: 0, outletEnthalpy: 0, inletVelocity: 0, outletVelocity: 0, inletElevation: 0, outletElevation: 0)) }
    }
}
