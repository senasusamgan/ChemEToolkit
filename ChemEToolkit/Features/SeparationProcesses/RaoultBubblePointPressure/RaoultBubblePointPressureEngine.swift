struct RaoultBubblePointPressureEngine:
    Sendable {

    func calculate(
        _ input:
            RaoultBubblePointPressureInput
    ) throws
        -> RaoultBubblePointPressureResult {

        let values = [
            input.liquidMoleFraction1,
            input.saturationPressure1,
            input.saturationPressure2
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw RaoultBubblePointPressureError
                .nonFiniteInput
        }

        guard
            input.liquidMoleFraction1 >= 0,
            input.liquidMoleFraction1 <= 1
        else {
            throw RaoultBubblePointPressureError
                .fractionOutsideRange
        }

        guard
            input.saturationPressure1 > 0,
            input.saturationPressure2 > 0
        else {
            throw RaoultBubblePointPressureError
                .nonPositiveSaturationPressure
        }

        let x1 =
            input.liquidMoleFraction1

        let x2 =
            1 - x1

        let p1 =
            x1 * input.saturationPressure1

        let p2 =
            x2 * input.saturationPressure2

        let pressure =
            p1 + p2

        let y1 =
            p1 / pressure

        let y2 =
            p2 / pressure

        let alpha =
            input.saturationPressure1
            / input.saturationPressure2

        let outputs = [
            p1,
            p2,
            pressure,
            y1,
            y2,
            alpha
        ]

        guard
            outputs.allSatisfy(\.isFinite),
            pressure > 0,
            y1 >= 0,
            y1 <= 1,
            y2 >= 0,
            y2 <= 1
        else {
            throw RaoultBubblePointPressureError
                .numericalFailure
        }

        return .init(
            bubblePointPressure:
                pressure,
            vaporMoleFraction1:
                y1,
            vaporMoleFraction2:
                y2,
            partialPressure1:
                p1,
            partialPressure2:
                p2,
            relativeVolatility:
                alpha,
            modelName:
                "Ideal binary Raoult-law bubble point",
            limitationDescription:
                "Assumes an ideal liquid solution, ideal vapor phase and saturation pressures evaluated at one common temperature."
        )
    }
}
