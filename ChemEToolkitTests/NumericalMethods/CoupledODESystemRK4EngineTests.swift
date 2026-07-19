import Testing
@testable import ChemEToolkit

@Suite("Coupled ODE System RK4 Engine")
struct CoupledODESystemRK4EngineTests {
    private let engine = CoupledODESystemRK4Engine()

    @Test("Preserves oscillator magnitude")
    func oscillator() throws {
        let r = try engine.calculate(.init(a11: 0, a12: 1, a21: -1, a22: 0, initialX: 1, initialY: 0, finalTime: 6.283185307179586, stepSize: 0.01))
        #expect(abs(r.finalMagnitude - 1) < 1e-6)
        #expect(abs(r.finalX - 1) < 1e-5)
    }

    @Test("Smaller step improves one-cycle return")
    func trend() throws {
        let a = try engine.calculate(.init(a11: 0, a12: 1, a21: -1, a22: 0, initialX: 1, initialY: 0, finalTime: 6.283185307179586, stepSize: 0.2))
        let b = try engine.calculate(.init(a11: 0, a12: 1, a21: -1, a22: 0, initialX: 1, initialY: 0, finalTime: 6.283185307179586, stepSize: 0.02))
        #expect(abs(b.finalX-1) < abs(a.finalX-1))
    }

    @Test("Rejects oversized step")
    func validation() {
        #expect(throws: CoupledODESystemRK4Error.invalidStep) {
            try engine.calculate(.init(a11: 0, a12: 1, a21: -1, a22: 0, initialX: 1, initialY: 0, finalTime: 1, stepSize: 2))
        }
    }
}
