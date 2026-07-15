import Testing
@testable import ChemEToolkit

@Suite("Dimensionless Mass Transfer Engine")
struct DimensionlessMassTransferEngineTests {
    private let engine = DimensionlessMassTransferEngine()

    @Test("Calculates Sc, Le, and Sh")
    func calculatesNumbers() throws {
        let result = try engine.calculate(.init(
            density: 1.2,
            dynamicViscosity: 1.8e-5,
            diffusivity: 2.0e-5,
            thermalDiffusivity: 2.2e-5,
            massTransferCoefficient: 0.01,
            characteristicLength: 0.1
        ))
        #expect(abs(result.schmidtNumber - 0.75) < 1.0e-12)
        #expect(abs(result.lewisNumber - 1.1) < 1.0e-12)
        #expect(abs(result.sherwoodNumber - 50) < 1.0e-12)
    }

    @Test("Supports very small positive transport properties")
    func smallPositiveValues() throws {
        let result = try engine.calculate(.init(
            density: 1,
            dynamicViscosity: 1e-9,
            diffusivity: 1e-9,
            thermalDiffusivity: 1e-9,
            massTransferCoefficient: 1e-9,
            characteristicLength: 1
        ))
        #expect(result.schmidtNumber == 1)
        #expect(result.lewisNumber == 1)
        #expect(result.sherwoodNumber == 1)
    }

    @Test("Rejects nonpositive and nonfinite inputs")
    func validation() {
        #expect(throws: DimensionlessMassTransferError.nonPositiveProperty) {
            try engine.calculate(.init(
                density: 1, dynamicViscosity: 1, diffusivity: 0,
                thermalDiffusivity: 1, massTransferCoefficient: 1,
                characteristicLength: 1
            ))
        }
        #expect(throws: DimensionlessMassTransferError.nonFiniteInput) {
            try engine.calculate(.init(
                density: .nan, dynamicViscosity: 1, diffusivity: 1,
                thermalDiffusivity: 1, massTransferCoefficient: 1,
                characteristicLength: 1
            ))
        }
    }
}
