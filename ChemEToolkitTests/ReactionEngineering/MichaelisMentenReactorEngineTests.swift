import Testing
@testable import ChemEToolkit

@Suite("Michaelis-Menten Reactor Engine")
struct MichaelisMentenReactorEngineTests {
    private let engine = MichaelisMentenReactorEngine()

    @Test("Compares PFR and CSTR") func comparison() throws {
        let r = try engine.calculate(.init(
            inletSubstrateConcentration: 10, volumetricFlowRate: 1,
            maximumVolumetricRate: 2, michaelisConstant: 3,
            targetSubstrateConversion: 0.8
        ))
        #expect(abs(r.outletSubstrateConcentration - 2) < 1e-12)
        #expect(abs(r.pfrSpaceTime - 6.4141568686511503) < 1e-12)
        #expect(abs(r.cstrSpaceTime - 10) < 1e-12)
        #expect(r.cstrVolume > r.pfrVolume)
    }

    @Test("Zero Km gives equal sizes") func zeroKm() throws {
        let r = try engine.calculate(.init(
            inletSubstrateConcentration: 10, volumetricFlowRate: 1,
            maximumVolumetricRate: 2, michaelisConstant: 0,
            targetSubstrateConversion: 0.8
        ))
        #expect(abs(r.pfrVolume - r.cstrVolume) < 1e-12)
    }

    @Test("Rejects invalid inputs") func validation() {
        #expect(throws: MichaelisMentenReactorError.conversionOutOfRange) {
            try engine.calculate(.init(
                inletSubstrateConcentration: 10, volumetricFlowRate: 1,
                maximumVolumetricRate: 2, michaelisConstant: 3,
                targetSubstrateConversion: 1
            ))
        }
    }
}
