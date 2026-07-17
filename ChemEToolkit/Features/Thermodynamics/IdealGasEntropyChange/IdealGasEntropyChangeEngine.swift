import Foundation

struct IdealGasEntropyChangeEngine:
    Sendable {

    func calculate(
        _ input:
            IdealGasEntropyChangeInput
    ) throws
        -> IdealGasEntropyChangeResult {

        let values = [
            input.mass,
            input.specificHeatAtConstantPressure,
            input.specificGasConstant,
            input.initialTemperatureKelvin,
            input.finalTemperatureKelvin,
            input.initialAbsolutePressure,
            input.finalAbsolutePressure
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw IdealGasEntropyChangeError
                .nonFiniteInput
        }

        guard input.mass >= 0 else {
            throw IdealGasEntropyChangeError
                .negativeMass
        }

        guard
            input.specificHeatAtConstantPressure > 0,
            input.specificGasConstant > 0
        else {
            throw IdealGasEntropyChangeError
                .nonPositiveProperty
        }

        guard
            input.specificHeatAtConstantPressure
            > input.specificGasConstant
        else {
            throw IdealGasEntropyChangeError
                .invalidHeatCapacityRelation
        }

        guard
            input.initialTemperatureKelvin > 0,
            input.finalTemperatureKelvin > 0
        else {
            throw IdealGasEntropyChangeError
                .nonPositiveTemperature
        }

        guard
            input.initialAbsolutePressure > 0,
            input.finalAbsolutePressure > 0
        else {
            throw IdealGasEntropyChangeError
                .nonPositivePressure
        }

        let temperatureContribution =
            input.specificHeatAtConstantPressure
            * Foundation.log(
                input.finalTemperatureKelvin
                / input.initialTemperatureKelvin
            )

        let pressureContribution =
            -input.specificGasConstant
            * Foundation.log(
                input.finalAbsolutePressure
                / input.initialAbsolutePressure
            )

        let specificEntropy =
            temperatureContribution
            + pressureContribution

        let totalEntropy =
            input.mass
            * specificEntropy

        let cv =
            input.specificHeatAtConstantPressure
            - input.specificGasConstant

        let direction: String

        if totalEntropy > 0 {
            direction = "Entropy increases"
        } else if totalEntropy < 0 {
            direction = "Entropy decreases"
        } else {
            direction = "No entropy change"
        }

        let outputs = [
            temperatureContribution,
            pressureContribution,
            specificEntropy,
            totalEntropy,
            cv
        ]

        guard outputs.allSatisfy(\.isFinite) else {
            throw IdealGasEntropyChangeError
                .numericalFailure
        }

        return .init(
            temperatureContribution:
                temperatureContribution,
            pressureContribution:
                pressureContribution,
            specificEntropyChange:
                specificEntropy,
            totalEntropyChange:
                totalEntropy,
            specificHeatAtConstantVolume:
                cv,
            directionDescription:
                direction,
            modelName:
                "Constant-Cp ideal-gas entropy relation",
            limitationDescription:
                "Uses Δs = Cp ln(T₂/T₁) − R ln(P₂/P₁), constant ideal-gas properties and absolute temperature and pressure."
        )
    }
}
