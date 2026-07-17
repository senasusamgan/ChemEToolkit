import Foundation

struct IsothermalIdealGasProcessEngine:
    Sendable {

    private let universalGasConstant =
        8.31446261815324

    func calculate(
        _ input:
            IsothermalIdealGasProcessInput
    ) throws
        -> IsothermalIdealGasProcessResult {

        let values = [
            input.amountKilomoles,
            input.temperatureKelvin,
            input.initialAbsolutePressure,
            input.finalAbsolutePressure
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw IsothermalIdealGasProcessError
                .nonFiniteInput
        }

        guard input.amountKilomoles >= 0 else {
            throw IsothermalIdealGasProcessError
                .negativeAmount
        }

        guard input.temperatureKelvin > 0 else {
            throw IsothermalIdealGasProcessError
                .nonPositiveTemperature
        }

        guard
            input.initialAbsolutePressure > 0,
            input.finalAbsolutePressure > 0
        else {
            throw IsothermalIdealGasProcessError
                .nonPositivePressure
        }

        let pressureRatio =
            input.finalAbsolutePressure
            / input.initialAbsolutePressure

        let volumeRatio =
            input.initialAbsolutePressure
            / input.finalAbsolutePressure

        let work =
            input.amountKilomoles
            * universalGasConstant
            * input.temperatureKelvin
            * Foundation.log(
                input.initialAbsolutePressure
                / input.finalAbsolutePressure
            )

        let direction: String

        if work > 0 {
            direction = "Expansion"
        } else if work < 0 {
            direction = "Compression"
        } else {
            direction = "No pressure change"
        }

        let outputs = [
            pressureRatio,
            volumeRatio,
            work
        ]

        guard outputs.allSatisfy(\.isFinite) else {
            throw IsothermalIdealGasProcessError
                .numericalFailure
        }

        return .init(
            pressureRatio:
                pressureRatio,
            volumeRatio:
                volumeRatio,
            workBySystem:
                work,
            heatToSystem:
                work,
            internalEnergyChange:
                0,
            processDirection:
                direction,
            modelName:
                "Reversible isothermal ideal-gas process",
            limitationDescription:
                "Uses W = nRT ln(P₁/P₂), assumes ideal-gas behavior and a reversible path, with positive work defined as work done by the system."
        )
    }
}
