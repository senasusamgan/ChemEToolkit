import Testing
@testable import ChemEToolkit

@Suite("Liquid Control Valve Sizing Engine")
struct LiquidControlValveSizingEngineTests {
    private let engine = LiquidControlValveSizingEngine()

    @Test("Calculates required Kv and equivalent Cv")
    func valveSizing() throws {
        let result = try engine.calculate(.init(
            liquidFlowRate: 50, pressureDrop: 2, liquidDensity: 800,
            installedValveKv: 40, designSafetyFactor: 1.2
        ))
        #expect(abs(result.specificGravity - 0.80000000000000004) < 1e-12)
        #expect(abs(result.requiredKvWithoutMargin - 31.622776601683793) < 1e-12)
        #expect(abs(result.designKv - 37.947331922020552) < 1e-12)
        #expect(abs(result.equivalentCv - 43.870881139707713) < 1e-12)
        #expect(result.installedValveIsAdequate)
    }

    @Test("Detects undersized installed valve")
    func inadequateValve() throws {
        let result = try engine.calculate(.init(
            liquidFlowRate: 50, pressureDrop: 2, liquidDensity: 800,
            installedValveKv: 20, designSafetyFactor: 1.2
        ))
        #expect(!result.installedValveIsAdequate)
        #expect(result.installedCapacityFraction > 1)
        #expect(result.estimatedLinearOpening == 1)
    }

    @Test("Rejects invalid pressure drop")
    func validation() {
        #expect(throws: LiquidControlValveSizingError.nonPositivePressureDrop) {
            try engine.calculate(.init(
                liquidFlowRate: 50, pressureDrop: 0, liquidDensity: 800,
                installedValveKv: 40, designSafetyFactor: 1.2
            ))
        }
    }
}
