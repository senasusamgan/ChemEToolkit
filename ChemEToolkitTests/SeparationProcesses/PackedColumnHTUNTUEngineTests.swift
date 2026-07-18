import Testing
@testable import ChemEToolkit

@Suite("Packed Column HTU NTU Engine")
struct PackedColumnHTUNTUEngineTests {
    private let engine = PackedColumnHTUNTUEngine()

    @Test("Calculates design packing height")
    func height() throws {
        let r = try engine.calculate(.init(heightOfTransferUnit: 0.8, numberOfTransferUnits: 6, packingSafetyFactor: 1.15))
        #expect(abs(r.theoreticalPackedHeight - 4.8) < 1e-12)
        #expect(abs(r.designPackedHeight - 5.52) < 1e-12)
    }

    @Test("More transfer units increase height")
    func trend() throws {
        let a = try engine.calculate(.init(heightOfTransferUnit: 0.8, numberOfTransferUnits: 4, packingSafetyFactor: 1))
        let b = try engine.calculate(.init(heightOfTransferUnit: 0.8, numberOfTransferUnits: 8, packingSafetyFactor: 1))
        #expect(b.designPackedHeight > a.designPackedHeight)
    }

    @Test("Rejects safety factor below one")
    func validation() {
        #expect(throws: PackedColumnHTUNTUError.invalidSafetyFactor) {
            try engine.calculate(.init(heightOfTransferUnit: 0.8, numberOfTransferUnits: 6, packingSafetyFactor: 0.9))
        }
    }
}
