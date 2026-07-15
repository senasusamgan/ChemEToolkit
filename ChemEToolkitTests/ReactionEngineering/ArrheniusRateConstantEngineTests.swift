import Testing
@testable import ChemEToolkit

@Suite("Arrhenius Rate Constant Engine")
struct ArrheniusRateConstantEngineTests {
    private let engine =
        ArrheniusRateConstantEngine()

    @Test("Calculates Arrhenius rate constant")
    func calculatesRateConstant() throws {
        let result = try engine.calculate(
            .init(
                preExponentialFactor: 1e7,
                activationEnergy: 50_000,
                temperature: 350
            )
        )

        #expect(
            abs(
                result.rateConstant
                - 0.3451868704390958
            ) < 1e-12
        )
        #expect(
            abs(
                result.activationEnergyOverRT
                - 17.18176500610372
            ) < 1e-12
        )
        #expect(result.exponentialFactor > 0)
        #expect(result.exponentialFactor < 1)
    }

    @Test("Handles zero activation energy")
    func zeroActivationEnergy() throws {
        let result = try engine.calculate(
            .init(
                preExponentialFactor: 10,
                activationEnergy: 0,
                temperature: 300
            )
        )

        #expect(result.rateConstant == 10)
        #expect(result.exponentialFactor == 1)
        #expect(result.temperatureSensitivity == 0)
        #expect(
            result
                .temperatureForDoubleRateApproximation
                .isInfinite
        )
    }

    @Test("Rejects invalid inputs")
    func validation() {
        #expect(
            throws:
                ArrheniusRateConstantError
                    .nonPositivePreExponentialFactor
        ) {
            try engine.calculate(
                .init(
                    preExponentialFactor: 0,
                    activationEnergy: 50_000,
                    temperature: 350
                )
            )
        }

        #expect(
            throws:
                ArrheniusRateConstantError
                    .negativeActivationEnergy
        ) {
            try engine.calculate(
                .init(
                    preExponentialFactor: 1e7,
                    activationEnergy: -1,
                    temperature: 350
                )
            )
        }

        #expect(
            throws:
                ArrheniusRateConstantError
                    .nonFiniteInput
        ) {
            try engine.calculate(
                .init(
                    preExponentialFactor: .nan,
                    activationEnergy: 50_000,
                    temperature: 350
                )
            )
        }
    }
}
