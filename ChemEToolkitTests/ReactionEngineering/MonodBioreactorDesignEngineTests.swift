import Testing
@testable import ChemEToolkit

@Suite("Monod Bioreactor Design Engine")
struct MonodBioreactorDesignEngineTests {
    private let engine = MonodBioreactorDesignEngine()

    @Test("Sizes a chemostat") func design() throws {
        let r = try engine.calculate(.init(
            feedSubstrateConcentration: 20, targetEffluentSubstrate: 2,
            maximumSpecificGrowthRate: 0.5, monodHalfSaturationConstant: 1,
            biomassYieldCoefficient: 0.6, biomassDecayRate: 0.05,
            volumetricFlowRate: 10
        ))
        #expect(abs(r.specificGrowthRate - 0.33333333333333331) < 1e-12)
        #expect(abs(r.dilutionRate - 0.28333333333333333) < 1e-12)
        #expect(abs(r.requiredReactorVolume - 35.294117647058826) < 1e-12)
        #expect(abs(r.biomassConcentration - 9.1799999999999997) < 1e-12)
        #expect(abs(r.washoutSafetyRatio - 0.66480446927374304) < 1e-12)
    }

    @Test("Zero decay recovers yield relation") func zeroDecay() throws {
        let r = try engine.calculate(.init(
            feedSubstrateConcentration: 20, targetEffluentSubstrate: 2,
            maximumSpecificGrowthRate: 0.5, monodHalfSaturationConstant: 1,
            biomassYieldCoefficient: 0.6, biomassDecayRate: 0,
            volumetricFlowRate: 10
        ))
        #expect(abs(r.biomassConcentration - 10.8) < 1e-12)
    }

    @Test("Rejects nonpositive net growth") func validation() {
        #expect(throws: MonodBioreactorDesignError.noPositiveNetGrowth) {
            try engine.calculate(.init(
                feedSubstrateConcentration: 20, targetEffluentSubstrate: 2,
                maximumSpecificGrowthRate: 0.5, monodHalfSaturationConstant: 1,
                biomassYieldCoefficient: 0.6, biomassDecayRate: 0.4,
                volumetricFlowRate: 10
            ))
        }
    }
}
