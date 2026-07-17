import Testing
@testable import ChemEToolkit

@Suite("Closed-System First Law Engine")
struct ClosedSystemFirstLawEngineTests {
    private let engine = ClosedSystemFirstLawEngine()
    @Test("Calculates internal-energy change") func balance() throws {
        let r = try engine.calculate(.init(heatToSystem: 500, workBySystem: 120, kineticEnergyChange: 20, potentialEnergyChange: 10))
        #expect(r.netEnergyTransfer == 380)
        #expect(r.internalEnergyChange == 350)
        #expect(r.totalStoredEnergyChange == 380)
    }
    @Test("Handles energy decrease") func decrease() throws {
        let r = try engine.calculate(.init(heatToSystem: -100, workBySystem: 20, kineticEnergyChange: 0, potentialEnergyChange: 0))
        #expect(r.internalEnergyChange == -120)
    }
    @Test("Rejects nonfinite input") func validation() {
        #expect(throws: ClosedSystemFirstLawError.nonFiniteInput) { try engine.calculate(.init(heatToSystem: .infinity, workBySystem: 0, kineticEnergyChange: 0, potentialEnergyChange: 0)) }
    }
}
