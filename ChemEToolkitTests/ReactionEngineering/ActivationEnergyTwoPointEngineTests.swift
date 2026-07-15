import Testing
@testable import ChemEToolkit

@Suite("Activation Energy Two-Point Engine")
struct ActivationEnergyTwoPointEngineTests {
    private let engine =
        ActivationEnergyTwoPointEngine()

    @Test("Recovers activation energy and pre-exponential factor")
    func recoversParameters() throws {
        let result = try engine.calculate(
            .init(
                temperatureOne: 300,
                rateConstantOne:
                    0.019696844058205553,
                temperatureTwo: 350,
                rateConstantTwo:
                    0.3451868704390958
            )
        )

        #expect(
            abs(
                result.activationEnergy
                - 50_000
            ) < 1e-8
        )
        #expect(
            abs(
                result.averagePreExponentialFactor
                - 1e7
            ) < 1e-5
        )
        #expect(
            result.relativePreExponentialMismatch
            < 1e-12
        )
    }

    @Test("Works when points are entered in descending temperature order")
    func descendingTemperatureOrder() throws {
        let result = try engine.calculate(
            .init(
                temperatureOne: 350,
                rateConstantOne:
                    0.3451868704390958,
                temperatureTwo: 300,
                rateConstantTwo:
                    0.019696844058205553
            )
        )

        #expect(
            abs(
                result.activationEnergy
                - 50_000
            ) < 1e-8
        )
    }

    @Test("Rejects invalid data")
    func validation() {
        #expect(
            throws:
                ActivationEnergyTwoPointError
                    .equalTemperatures
        ) {
            try engine.calculate(
                .init(
                    temperatureOne: 300,
                    rateConstantOne: 0.1,
                    temperatureTwo: 300,
                    rateConstantTwo: 0.2
                )
            )
        }

        #expect(
            throws:
                ActivationEnergyTwoPointError
                    .nonPositiveActivationEnergy
        ) {
            try engine.calculate(
                .init(
                    temperatureOne: 300,
                    rateConstantOne: 1,
                    temperatureTwo: 350,
                    rateConstantTwo: 0.5
                )
            )
        }

        #expect(
            throws:
                ActivationEnergyTwoPointError
                    .nonFiniteInput
        ) {
            try engine.calculate(
                .init(
                    temperatureOne: .nan,
                    rateConstantOne: 0.1,
                    temperatureTwo: 350,
                    rateConstantTwo: 1
                )
            )
        }
    }
}
