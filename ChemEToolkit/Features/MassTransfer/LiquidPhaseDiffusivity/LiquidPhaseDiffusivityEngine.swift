struct LiquidPhaseDiffusivityEngine:
    Sendable {

    func calculate(
        _ input: LiquidPhaseDiffusivityInput
    ) throws -> LiquidPhaseDiffusivityResult {

        let values = [
            input.referenceDiffusivity,
            input.referenceTemperature,
            input.referenceViscosity,
            input.targetTemperature,
            input.targetViscosity
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw LiquidPhaseDiffusivityError
                .nonFiniteInput
        }

        guard values.allSatisfy({ $0 > 0 }) else {
            throw LiquidPhaseDiffusivityError
                .nonPositiveProperty
        }

        let temperatureFactor =
            input.targetTemperature
            / input.referenceTemperature

        let viscosityFactor =
            input.referenceViscosity
            / input.targetViscosity

        let totalFactor =
            temperatureFactor
            * viscosityFactor

        let targetDiffusivity =
            input.referenceDiffusivity
            * totalFactor

        guard targetDiffusivity.isFinite else {
            throw LiquidPhaseDiffusivityError
                .nonFiniteInput
        }

        return LiquidPhaseDiffusivityResult(
            targetDiffusivity:
                targetDiffusivity,
            temperatureCorrectionFactor:
                temperatureFactor,
            viscosityCorrectionFactor:
                viscosityFactor,
            totalCorrectionFactor:
                totalFactor,
            modelName:
                "Stokes–Einstein temperature–viscosity scaling"
        )
    }
}
