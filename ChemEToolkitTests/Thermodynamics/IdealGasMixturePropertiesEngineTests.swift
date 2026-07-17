import Testing
@testable import ChemEToolkit

@Suite("Ideal-Gas Mixture Properties Engine")
struct IdealGasMixturePropertiesEngineTests {
    private let engine =
        IdealGasMixturePropertiesEngine()

    @Test("Calculates mixture molecular weight")
    func mixtureProperties() throws {
        let result = try engine.calculate(
            .init(
                fraction1: 0.7,
                molecularWeight1: 28,
                fraction2: 0.2,
                molecularWeight2: 32,
                fraction3: 0.1,
                molecularWeight3: 44
            )
        )

        #expect(
            abs(
                result.mixtureMolecularWeight
                - 30.4
            ) < 1e-12
        )

        #expect(
            abs(
                result.mixtureSpecificGasConstant
                - 8.31446261815324 / 30.4
            ) < 1e-12
        )
    }

    @Test("Normalizes composition")
    func normalization() throws {
        let result = try engine.calculate(
            .init(
                fraction1: 7,
                molecularWeight1: 28,
                fraction2: 2,
                molecularWeight2: 32,
                fraction3: 1,
                molecularWeight3: 44
            )
        )

        #expect(result.enteredFractionSum == 10)
        #expect(result.normalizedFraction1 == 0.7)
    }

    @Test("Rejects zero molecular weight")
    func validation() {
        #expect(
            throws:
                IdealGasMixturePropertiesError
                    .nonPositiveMolecularWeight
        ) {
            try engine.calculate(
                .init(
                    fraction1: 1,
                    molecularWeight1: 0,
                    fraction2: 0,
                    molecularWeight2: 32,
                    fraction3: 0,
                    molecularWeight3: 44
                )
            )
        }
    }
}
