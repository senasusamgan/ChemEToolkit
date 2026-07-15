import Foundation

struct GasPhaseDiffusivityEngine:
    Sendable {

    private let temperatureExponent =
        1.75

    func calculate(
        _ input: GasPhaseDiffusivityInput
    ) throws -> GasPhaseDiffusivityResult {

        let values = [
            input.referenceDiffusivity,
            input.referenceTemperature,
            input.referencePressure,
            input.targetTemperature,
            input.targetPressure
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw GasPhaseDiffusivityError
                .nonFiniteInput
        }

        guard values.allSatisfy({ $0 > 0 }) else {
            throw GasPhaseDiffusivityError
                .nonPositiveProperty
        }

        let temperatureFactor =
            pow(
                input.targetTemperature
                / input.referenceTemperature,
                temperatureExponent
            )

        let pressureFactor =
            input.referencePressure
            / input.targetPressure

        let totalFactor =
            temperatureFactor
            * pressureFactor

        let targetDiffusivity =
            input.referenceDiffusivity
            * totalFactor

        guard targetDiffusivity.isFinite else {
            throw GasPhaseDiffusivityError
                .nonFiniteInput
        }

        return GasPhaseDiffusivityResult(
            targetDiffusivity:
                targetDiffusivity,
            temperatureCorrectionFactor:
                temperatureFactor,
            pressureCorrectionFactor:
                pressureFactor,
            totalCorrectionFactor:
                totalFactor,
            modelName:
                "Low-pressure gas diffusivity scaling"
        )
    }
}
