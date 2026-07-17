import Foundation

struct PolytropicIdealGasProcessEngine:
    Sendable {

    func calculate(
        _ input:
            PolytropicIdealGasProcessInput
    ) throws
        -> PolytropicIdealGasProcessResult {

        let values = [
            input.initialAbsolutePressure,
            input.initialVolume,
            input.finalAbsolutePressure,
            input.polytropicExponent
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw PolytropicIdealGasProcessError
                .nonFiniteInput
        }

        guard
            input.initialAbsolutePressure > 0,
            input.finalAbsolutePressure > 0
        else {
            throw PolytropicIdealGasProcessError
                .nonPositivePressure
        }

        guard input.initialVolume > 0 else {
            throw PolytropicIdealGasProcessError
                .nonPositiveVolume
        }

        guard input.polytropicExponent > 0 else {
            throw PolytropicIdealGasProcessError
                .nonPositiveExponent
        }

        guard
            abs(
                input.polytropicExponent - 1
            ) > 1e-12
        else {
            throw PolytropicIdealGasProcessError
                .isothermalExponentUnsupported
        }

        let pressureRatio =
            input.finalAbsolutePressure
            / input.initialAbsolutePressure

        let volumeRatio =
            Foundation.pow(
                input.initialAbsolutePressure
                / input.finalAbsolutePressure,
                1 / input.polytropicExponent
            )

        let finalVolume =
            input.initialVolume
            * volumeRatio

        let initialPV =
            input.initialAbsolutePressure
            * input.initialVolume

        let finalPV =
            input.finalAbsolutePressure
            * finalVolume

        let work =
            (
                finalPV
                - initialPV
            )
            / (
                1
                - input.polytropicExponent
            )

        let direction: String

        if finalVolume > input.initialVolume {
            direction = "Polytropic expansion"
        } else if finalVolume < input.initialVolume {
            direction = "Polytropic compression"
        } else {
            direction = "No volume change"
        }

        let outputs = [
            pressureRatio,
            volumeRatio,
            finalVolume,
            initialPV,
            finalPV,
            work
        ]

        guard
            outputs.allSatisfy(\.isFinite),
            finalVolume > 0,
            volumeRatio > 0
        else {
            throw PolytropicIdealGasProcessError
                .numericalFailure
        }

        return .init(
            finalVolume:
                finalVolume,
            pressureRatio:
                pressureRatio,
            volumeRatio:
                volumeRatio,
            workBySystem:
                work,
            initialPV:
                initialPV,
            finalPV:
                finalPV,
            processDirection:
                direction,
            modelName:
                "Polytropic process satisfying PVⁿ = constant",
            limitationDescription:
                "Pressures must be absolute. With pressure in kPa and volume in m³, work is returned in kJ. Use the isothermal module for n = 1."
        )
    }
}
