import Testing
@testable import ChemEToolkit

@Suite("Murphree Tray Efficiency Engine")
struct MurphreeTrayEfficiencyEngineTests {
    private let engine = MurphreeTrayEfficiencyEngine()

    @Test("Converts ideal stages to actual trays")
    func trays() throws {
        let r = try engine.calculate(.init(idealStageCount: 12, murphreeEfficiency: 0.65, traySpacing: 0.6, columnHeightSafetyFactor: 1.1))
        #expect(r.requiredActualTrays == 19)
        #expect(r.designTraySectionHeight > r.activeTrayHeight)
    }

    @Test("Higher efficiency reduces actual trays")
    func trend() throws {
        let a = try engine.calculate(.init(idealStageCount: 12, murphreeEfficiency: 0.5, traySpacing: 0.6, columnHeightSafetyFactor: 1))
        let b = try engine.calculate(.init(idealStageCount: 12, murphreeEfficiency: 0.8, traySpacing: 0.6, columnHeightSafetyFactor: 1))
        #expect(b.requiredActualTrays < a.requiredActualTrays)
    }

    @Test("Rejects efficiency above one")
    func validation() {
        #expect(throws: MurphreeTrayEfficiencyError.invalidEfficiency) {
            try engine.calculate(.init(idealStageCount: 12, murphreeEfficiency: 1.2, traySpacing: 0.6, columnHeightSafetyFactor: 1.1))
        }
    }
}
