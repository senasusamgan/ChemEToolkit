import Testing
@testable import ChemEToolkit

@Suite("Liquid-Phase Diffusivity Engine")
struct LiquidPhaseDiffusivityEngineTests {
    private let engine =
        LiquidPhaseDiffusivityEngine()

    @Test(
        "Scales diffusivity with temperature and viscosity"
    )
    func scalesDiffusivity() throws {
        let result = try engine.calculate(
            .init(
                referenceDiffusivity: 1e-9,
                referenceTemperature:
                    298.15,
                referenceViscosity:
                    0.001,
                targetTemperature: 310,
                targetViscosity:
                    0.0008
            )
        )

        #expect(
            abs(
                result.targetDiffusivity
                - 1.2996813684387056e-9
            ) < 1e-20
        )
    }

    @Test(
        "Returns the reference value at the same state"
    )
    func unchangedState() throws {
        let result = try engine.calculate(
            .init(
                referenceDiffusivity: 2e-9,
                referenceTemperature: 300,
                referenceViscosity:
                    0.001,
                targetTemperature: 300,
                targetViscosity: 0.001
            )
        )

        #expect(
            result.targetDiffusivity
            == 2e-9
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
                LiquidPhaseDiffusivityError
                    .nonPositiveProperty
        ) {
            try engine.calculate(
                .init(
                    referenceDiffusivity: 1,
                    referenceTemperature: 300,
                    referenceViscosity: 0,
                    targetTemperature: 300,
                    targetViscosity: 1
                )
            )
        }

        #expect(
            throws:
                LiquidPhaseDiffusivityError
                    .nonFiniteInput
        ) {
            try engine.calculate(
                .init(
                    referenceDiffusivity:
                        .nan,
                    referenceTemperature: 300,
                    referenceViscosity: 1,
                    targetTemperature: 300,
                    targetViscosity: 1
                )
            )
        }
    }
}
