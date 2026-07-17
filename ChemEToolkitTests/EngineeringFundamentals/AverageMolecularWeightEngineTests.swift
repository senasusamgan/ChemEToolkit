import Testing
@testable import ChemEToolkit

@Suite("Average Molecular Weight Engine")
struct AverageMolecularWeightEngineTests {
    private let engine =
        AverageMolecularWeightEngine()

    @Test("Calculates normalized average molecular weight")
    func average() throws {
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
                result.enteredFractionSum
                - 1
            ) < 1e-12
        )

        #expect(
            abs(
                result.averageMolecularWeight
                - 30.4
            ) < 1e-12
        )
    }

    @Test("Normalizes fractions that do not sum to one")
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

        #expect(
            abs(
                result.averageMolecularWeight
                - 30.4
            ) < 1e-12
        )
    }

    @Test("Rejects zero composition sum")
    func validation() {
        #expect(
            throws:
                AverageMolecularWeightError
                    .zeroFractionSum
        ) {
            try engine.calculate(
                .init(
                    fraction1: 0,
                    molecularWeight1: 28,
                    fraction2: 0,
                    molecularWeight2: 32,
                    fraction3: 0,
                    molecularWeight3: 44
                )
            )
        }
    }
}
