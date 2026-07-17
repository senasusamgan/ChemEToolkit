import Foundation
import Testing
@testable import ChemEToolkit

@Suite("Clausius Clapeyron Estimator Engine")
struct ClausiusClapeyronEstimatorEngineTests {
    private let engine =
        ClausiusClapeyronEstimatorEngine()

    @Test("Estimates lower pressure at lower temperature")
    func lowerTemperature() throws {
        let result = try engine.calculate(
            .init(
                referenceTemperatureKelvin: 373.15,
                referencePressure: 101.325,
                targetTemperatureKelvin: 353.15,
                molarLatentHeat: 40.65
            )
        )

        let expectedLog =
            -40.65
            / 0.00831446261815324
            * (
                1 / 353.15
                - 1 / 373.15
            )

        let expectedPressure =
            101.325 * exp(expectedLog)

        #expect(
            abs(
                result.targetPressure
                - expectedPressure
            ) < 1e-10
        )

        #expect(result.targetPressure < 101.325)
    }

    @Test("Equal temperatures preserve pressure")
    func noChange() throws {
        let result = try engine.calculate(
            .init(
                referenceTemperatureKelvin: 373.15,
                referencePressure: 101.325,
                targetTemperatureKelvin: 373.15,
                molarLatentHeat: 40.65
            )
        )

        #expect(
            abs(
                result.targetPressure
                - 101.325
            ) < 1e-12
        )

        #expect(result.pressureRatio == 1)
    }

    @Test("Rejects zero latent heat")
    func validation() {
        #expect(
            throws:
                ClausiusClapeyronEstimatorError
                    .nonPositiveLatentHeat
        ) {
            try engine.calculate(
                .init(
                    referenceTemperatureKelvin: 373.15,
                    referencePressure: 101.325,
                    targetTemperatureKelvin: 353.15,
                    molarLatentHeat: 0
                )
            )
        }
    }
}
