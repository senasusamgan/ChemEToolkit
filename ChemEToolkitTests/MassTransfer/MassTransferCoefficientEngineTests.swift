import Testing
@testable import ChemEToolkit

@Suite("Mass-Transfer Coefficient Engine")
struct MassTransferCoefficientEngineTests {
    private let engine = MassTransferCoefficientEngine()

    @Test("Calculates flux and molar rate")
    func calculatesTransport() throws {
        let result = try engine.calculate(.init(
            massTransferCoefficient: 0.01,
            bulkConcentration: 2,
            interfaceConcentration: 0.5,
            area: 3
        ))
        #expect(abs(result.molarFlux - 0.015) < 1e-12)
        #expect(abs(result.molarRate - 0.045) < 1e-12)
        #expect(result.drivingForce == 1.5)
    }

    @Test("Preserves reverse transport direction")
    func reverseDirection() throws {
        let result = try engine.calculate(.init(
            massTransferCoefficient: 2,
            bulkConcentration: 1,
            interfaceConcentration: 3,
            area: 1
        ))
        #expect(result.molarFlux == -4)
        #expect(result.molarRate == -4)
    }

    @Test("Validates coefficient, area, concentration, and finite values")
    func validation() {
        #expect(throws: MassTransferCoefficientError.nonPositiveCoefficientOrArea) {
            try engine.calculate(.init(
                massTransferCoefficient: 0, bulkConcentration: 1,
                interfaceConcentration: 0, area: 1
            ))
        }
        #expect(throws: MassTransferCoefficientError.negativeConcentration) {
            try engine.calculate(.init(
                massTransferCoefficient: 1, bulkConcentration: -1,
                interfaceConcentration: 0, area: 1
            ))
        }
        #expect(throws: MassTransferCoefficientError.nonFiniteInput) {
            try engine.calculate(.init(
                massTransferCoefficient: 1, bulkConcentration: .nan,
                interfaceConcentration: 0, area: 1
            ))
        }
    }
}
