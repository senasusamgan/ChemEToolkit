import Testing
@testable import ChemEToolkit

@Suite("Arrhenius Three-Point Fit Engine")
struct ArrheniusThreePointFitEngineTests {
    private let engine =
        ArrheniusThreePointFitEngine()

    @Test("Recovers exact Arrhenius parameters")
    func exactFit() throws {
        let result = try engine.calculate(
            .init(
                temperatureOne: 300,
                rateConstantOne:
                    0.019696844058205553,
                temperatureTwo: 350,
                rateConstantTwo:
                    0.3451868704390958,
                temperatureThree: 400,
                rateConstantThree:
                    2.956633442684111
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
                result.preExponentialFactor
                - 1e7
            ) < 1e-4
        )
        #expect(
            abs(
                result.coefficientOfDetermination
                - 1
            ) < 1e-12
        )
        #expect(
            result.maximumRelativeResidual
            < 1e-12
        )
    }

    @Test("Accepts unsorted temperatures")
    func unsortedTemperatures() throws {
        let result = try engine.calculate(
            .init(
                temperatureOne: 400,
                rateConstantOne:
                    2.956633442684111,
                temperatureTwo: 300,
                rateConstantTwo:
                    0.019696844058205553,
                temperatureThree: 350,
                rateConstantThree:
                    0.3451868704390958
            )
        )

        #expect(
            abs(
                result.activationEnergy
                - 50_000
            ) < 1e-8
        )
    }

    @Test("Rejects invalid fit data")
    func validation() {
        #expect(
            throws:
                ArrheniusThreePointFitError
                    .duplicateTemperatures
        ) {
            try engine.calculate(
                .init(
                    temperatureOne: 300,
                    rateConstantOne: 0.1,
                    temperatureTwo: 300,
                    rateConstantTwo: 0.2,
                    temperatureThree: 400,
                    rateConstantThree: 1
                )
            )
        }

        #expect(
            throws:
                ArrheniusThreePointFitError
                    .nonPositiveActivationEnergy
        ) {
            try engine.calculate(
                .init(
                    temperatureOne: 300,
                    rateConstantOne: 3,
                    temperatureTwo: 350,
                    rateConstantTwo: 2,
                    temperatureThree: 400,
                    rateConstantThree: 1
                )
            )
        }

        #expect(
            throws:
                ArrheniusThreePointFitError
                    .nonFiniteInput
        ) {
            try engine.calculate(
                .init(
                    temperatureOne: .nan,
                    rateConstantOne: 0.1,
                    temperatureTwo: 350,
                    rateConstantTwo: 1,
                    temperatureThree: 400,
                    rateConstantThree: 2
                )
            )
        }
    }
}
