import Foundation

struct ClausiusClapeyronEstimatorEngine:
    Sendable {

    private let gasConstant =
        0.00831446261815324

    func calculate(
        _ input:
            ClausiusClapeyronEstimatorInput
    ) throws
        -> ClausiusClapeyronEstimatorResult {

        let values = [
            input.referenceTemperatureKelvin,
            input.referencePressure,
            input.targetTemperatureKelvin,
            input.molarLatentHeat
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw ClausiusClapeyronEstimatorError
                .nonFiniteInput
        }

        guard
            input.referenceTemperatureKelvin > 0,
            input.targetTemperatureKelvin > 0
        else {
            throw ClausiusClapeyronEstimatorError
                .nonPositiveTemperature
        }

        guard input.referencePressure > 0 else {
            throw ClausiusClapeyronEstimatorError
                .nonPositivePressure
        }

        guard input.molarLatentHeat > 0 else {
            throw ClausiusClapeyronEstimatorError
                .nonPositiveLatentHeat
        }

        let inverseDifference =
            1 / input.targetTemperatureKelvin
            - 1 / input.referenceTemperatureKelvin

        let logPressureRatio =
            -input.molarLatentHeat
            / gasConstant
            * inverseDifference

        let pressureRatio =
            Foundation.exp(
                logPressureRatio
            )

        let targetPressure =
            input.referencePressure
            * pressureRatio

        let trend: String

        if input.targetTemperatureKelvin
            > input.referenceTemperatureKelvin
        {
            trend = "Pressure increases with temperature"
        } else if input.targetTemperatureKelvin
            < input.referenceTemperatureKelvin
        {
            trend = "Pressure decreases with temperature"
        } else {
            trend = "Reference state unchanged"
        }

        let outputs = [
            inverseDifference,
            logPressureRatio,
            pressureRatio,
            targetPressure
        ]

        guard
            outputs.allSatisfy(\.isFinite),
            pressureRatio > 0,
            targetPressure > 0
        else {
            throw ClausiusClapeyronEstimatorError
                .numericalFailure
        }

        return .init(
            inverseTemperatureDifference:
                inverseDifference,
            naturalLogPressureRatio:
                logPressureRatio,
            pressureRatio:
                pressureRatio,
            targetPressure:
                targetPressure,
            trendDescription:
                trend,
            modelName:
                "Integrated Clausius–Clapeyron estimator",
            limitationDescription:
                "Assumes constant molar latent heat, ideal vapor and negligible liquid molar volume. Latent heat must be in kJ/mol."
        )
    }
}
