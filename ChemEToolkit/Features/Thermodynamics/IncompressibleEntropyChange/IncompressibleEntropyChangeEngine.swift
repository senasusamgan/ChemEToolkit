import Foundation

struct IncompressibleEntropyChangeEngine:
    Sendable {

    func calculate(
        _ input:
            IncompressibleEntropyChangeInput
    ) throws
        -> IncompressibleEntropyChangeResult {

        let values = [
            input.mass,
            input.specificHeatCapacity,
            input.initialTemperatureKelvin,
            input.finalTemperatureKelvin
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw IncompressibleEntropyChangeError
                .nonFiniteInput
        }

        guard input.mass >= 0 else {
            throw IncompressibleEntropyChangeError
                .negativeMass
        }

        guard input.specificHeatCapacity > 0 else {
            throw IncompressibleEntropyChangeError
                .nonPositiveHeatCapacity
        }

        guard
            input.initialTemperatureKelvin > 0,
            input.finalTemperatureKelvin > 0
        else {
            throw IncompressibleEntropyChangeError
                .nonPositiveTemperature
        }

        let temperatureRatio =
            input.finalTemperatureKelvin
            / input.initialTemperatureKelvin

        let specificEntropy =
            input.specificHeatCapacity
            * Foundation.log(
                temperatureRatio
            )

        let totalEntropy =
            input.mass
            * specificEntropy

        let direction: String

        if totalEntropy > 0 {
            direction = "Entropy increases"
        } else if totalEntropy < 0 {
            direction = "Entropy decreases"
        } else {
            direction = "No entropy change"
        }

        let outputs = [
            temperatureRatio,
            specificEntropy,
            totalEntropy
        ]

        guard outputs.allSatisfy(\.isFinite) else {
            throw IncompressibleEntropyChangeError
                .numericalFailure
        }

        return .init(
            temperatureRatio:
                temperatureRatio,
            specificEntropyChange:
                specificEntropy,
            totalEntropyChange:
                totalEntropy,
            directionDescription:
                direction,
            modelName:
                "Constant-c incompressible entropy relation",
            limitationDescription:
                "Uses Δs = c ln(T₂/T₁) with constant heat capacity and negligible pressure contribution."
        )
    }
}
