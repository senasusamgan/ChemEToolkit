struct RaoultDewPointPressureEngine:
    Sendable {

    func calculate(
        _ input:
            RaoultDewPointPressureInput
    ) throws
        -> RaoultDewPointPressureResult {

        let values = [
            input.vaporMoleFraction1,
            input.saturationPressure1,
            input.saturationPressure2
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw RaoultDewPointPressureError
                .nonFiniteInput
        }

        guard
            input.vaporMoleFraction1 >= 0,
            input.vaporMoleFraction1 <= 1
        else {
            throw RaoultDewPointPressureError
                .fractionOutsideRange
        }

        guard
            input.saturationPressure1 > 0,
            input.saturationPressure2 > 0
        else {
            throw RaoultDewPointPressureError
                .nonPositiveSaturationPressure
        }

        let y1 =
            input.vaporMoleFraction1

        let y2 =
            1 - y1

        let term1 =
            y1 / input.saturationPressure1

        let term2 =
            y2 / input.saturationPressure2

        let pressure =
            1 / (term1 + term2)

        let x1 =
            y1 * pressure
            / input.saturationPressure1

        let x2 =
            y2 * pressure
            / input.saturationPressure2

        let alpha =
            input.saturationPressure1
            / input.saturationPressure2

        let outputs = [
            term1,
            term2,
            pressure,
            x1,
            x2,
            alpha
        ]

        guard
            outputs.allSatisfy(\.isFinite),
            pressure > 0,
            x1 >= 0,
            x1 <= 1,
            x2 >= 0,
            x2 <= 1
        else {
            throw RaoultDewPointPressureError
                .numericalFailure
        }

        return .init(
            dewPointPressure:
                pressure,
            liquidMoleFraction1:
                x1,
            liquidMoleFraction2:
                x2,
            inversePressureTerm1:
                term1,
            inversePressureTerm2:
                term2,
            relativeVolatility:
                alpha,
            modelName:
                "Ideal binary Raoult-law dew point",
            limitationDescription:
                "Assumes an ideal liquid solution, ideal vapor phase and saturation pressures evaluated at one common temperature."
        )
    }
}
