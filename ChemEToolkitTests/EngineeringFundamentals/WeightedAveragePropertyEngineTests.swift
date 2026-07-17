import Testing
@testable import ChemEToolkit

@Suite("Weighted Average Property Engine")
struct WeightedAveragePropertyEngineTests {
    private let engine =
        WeightedAveragePropertyEngine()

    @Test("Calculates normalized weighted average")
    func average() throws {
        let result = try engine.calculate(
            .init(
                fraction1: 0.5,
                property1: 10,
                fraction2: 0.3,
                property2: 20,
                fraction3: 0.2,
                property3: 40
            )
        )

        #expect(
            abs(
                result.enteredFractionSum
                - 1
            ) < 1e-12
        )

        #expect(
            result.weightedAverageProperty
            == 19
        )

        #expect(result.minimumComponentProperty == 10)
        #expect(result.maximumComponentProperty == 40)
    }

    @Test("Normalizes fractions automatically")
    func normalization() throws {
        let result = try engine.calculate(
            .init(
                fraction1: 5,
                property1: 10,
                fraction2: 3,
                property2: 20,
                fraction3: 2,
                property3: 40
            )
        )

        #expect(result.enteredFractionSum == 10)
        #expect(result.weightedAverageProperty == 19)
    }

    @Test("Rejects zero fraction sum")
    func validation() {
        #expect(
            throws:
                WeightedAveragePropertyError
                    .zeroFractionSum
        ) {
            try engine.calculate(
                .init(
                    fraction1: 0,
                    property1: 10,
                    fraction2: 0,
                    property2: 20,
                    fraction3: 0,
                    property3: 40
                )
            )
        }
    }
}
