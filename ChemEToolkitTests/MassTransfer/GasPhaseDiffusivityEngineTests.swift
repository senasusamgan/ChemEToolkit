import Testing
@testable import ChemEToolkit

@Suite("Gas-Phase Diffusivity Engine")
struct GasPhaseDiffusivityEngineTests {
    private let engine =
        GasPhaseDiffusivityEngine()

    @Test(
        "Scales diffusivity with temperature and pressure"
    )
    func scalesDiffusivity() throws {
        let result = try engine.calculate(
            .init(
                referenceDiffusivity:
                    1.8e-5,
                referenceTemperature:
                    298.15,
                referencePressure:
                    101_325,
                targetTemperature:
                    350,
                targetPressure:
                    202_650
            )
        )

        #expect(
            abs(
                result.targetDiffusivity
                - 1.1915181525044877e-5
            ) < 1e-16
        )
    }

    @Test(
        "Returns the reference value at the same state"
    )
    func unchangedState() throws {
        let result = try engine.calculate(
            .init(
                referenceDiffusivity:
                    2e-5,
                referenceTemperature: 300,
                referencePressure: 100_000,
                targetTemperature: 300,
                targetPressure: 100_000
            )
        )

        #expect(
            result.targetDiffusivity
            == 2e-5
        )
        #expect(
            result.totalCorrectionFactor
            == 1
        )
    }

    @Test(
        "Rejects nonpositive and nonfinite values"
    )
    func validation() {
        #expect(
            throws:
                GasPhaseDiffusivityError
                    .nonPositiveProperty
        ) {
            try engine.calculate(
                .init(
                    referenceDiffusivity: 0,
                    referenceTemperature: 300,
                    referencePressure: 1,
                    targetTemperature: 300,
                    targetPressure: 1
                )
            )
        }

        #expect(
            throws:
                GasPhaseDiffusivityError
                    .nonFiniteInput
        ) {
            try engine.calculate(
                .init(
                    referenceDiffusivity: 1,
                    referenceTemperature:
                        .infinity,
                    referencePressure: 1,
                    targetTemperature: 300,
                    targetPressure: 1
                )
            )
        }
    }
}
