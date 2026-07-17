import Testing
@testable import ChemEToolkit

@Suite("Dalton Partial Pressure Engine")
struct DaltonPartialPressureEngineTests {
    private let engine =
        DaltonPartialPressureEngine()

    @Test("Calculates partial pressures")
    func partialPressures() throws {
        let result = try engine.calculate(
            .init(
                totalAbsolutePressure: 500,
                amountFraction1: 0.7,
                amountFraction2: 0.2,
                amountFraction3: 0.1
            )
        )

        #expect(
            abs(
                result.enteredFractionSum - 1
            ) < 1e-12
        )

        #expect(
            abs(
                result.partialPressure1
                - 350
            ) < 1e-10
        )
        #expect(
            abs(
                result.partialPressure2
                - 100
            ) < 1e-10
        )
        #expect(
            abs(
                result.partialPressure3
                - 50
            ) < 1e-10
        )
        #expect(
            abs(
                result.partialPressureSum
                - 500
            ) < 1e-10
        )
    }

    @Test("Normalizes nonunit fractions")
    func normalization() throws {
        let result = try engine.calculate(
            .init(
                totalAbsolutePressure: 100,
                amountFraction1: 7,
                amountFraction2: 2,
                amountFraction3: 1
            )
        )

        #expect(result.partialPressure1 == 70)
        #expect(result.partialPressure2 == 20)
        #expect(result.partialPressure3 == 10)
    }

    @Test("Rejects zero fraction sum")
    func validation() {
        #expect(
            throws:
                DaltonPartialPressureError
                    .zeroFractionSum
        ) {
            try engine.calculate(
                .init(
                    totalAbsolutePressure: 100,
                    amountFraction1: 0,
                    amountFraction2: 0,
                    amountFraction3: 0
                )
            )
        }
    }
}
