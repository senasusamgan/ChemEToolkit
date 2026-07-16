import Testing
@testable import ChemEToolkit

@Suite("Enzyme Batch Reactor Engine")
struct EnzymeBatchReactorEngineTests {
    private let engine = EnzymeBatchReactorEngine()

    @Test("Calculates batch time") func batch() throws {
        let r = try engine.calculate(.init(
            liquidVolume: 2, initialSubstrateConcentration: 10,
            maximumVolumetricRate: 2, michaelisConstant: 3,
            targetSubstrateConversion: 0.8
        ))
        #expect(abs(r.timeToTargetConversion - 6.4141568686511503) < 1e-12)
        #expect(abs(r.productMoles - 16) < 1e-12)
        #expect(abs(r.finalReactionRate - 0.8) < 1e-12)
    }

    @Test("Zero Km gives constant rate") func zeroKm() throws {
        let r = try engine.calculate(.init(
            liquidVolume: 2, initialSubstrateConcentration: 10,
            maximumVolumetricRate: 2, michaelisConstant: 0,
            targetSubstrateConversion: 0.8
        ))
        #expect(abs(r.timeToTargetConversion - 4) < 1e-12)
        #expect(r.initialReactionRate == 2)
        #expect(r.finalReactionRate == 2)
    }

    @Test("Rejects invalid volume") func validation() {
        #expect(throws: EnzymeBatchReactorError.nonPositiveVolumeOrConcentration) {
            try engine.calculate(.init(
                liquidVolume: 0, initialSubstrateConcentration: 10,
                maximumVolumetricRate: 2, michaelisConstant: 3,
                targetSubstrateConversion: 0.8
            ))
        }
    }
}
