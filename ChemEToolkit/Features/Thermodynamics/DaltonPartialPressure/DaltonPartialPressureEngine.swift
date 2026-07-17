struct DaltonPartialPressureEngine:
    Sendable {

    func calculate(
        _ input:
            DaltonPartialPressureInput
    ) throws
        -> DaltonPartialPressureResult {

        let values = [
            input.totalAbsolutePressure,
            input.amountFraction1,
            input.amountFraction2,
            input.amountFraction3
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw DaltonPartialPressureError
                .nonFiniteInput
        }

        guard input.totalAbsolutePressure > 0 else {
            throw DaltonPartialPressureError
                .nonPositivePressure
        }

        let fractions = [
            input.amountFraction1,
            input.amountFraction2,
            input.amountFraction3
        ]

        guard
            fractions.allSatisfy({
                $0 >= 0
            })
        else {
            throw DaltonPartialPressureError
                .negativeFraction
        }

        let sum =
            fractions.reduce(0, +)

        guard sum > 0 else {
            throw DaltonPartialPressureError
                .zeroFractionSum
        }

        let y1 =
            input.amountFraction1 / sum

        let y2 =
            input.amountFraction2 / sum

        let y3 =
            input.amountFraction3 / sum

        let p1 =
            y1 * input.totalAbsolutePressure

        let p2 =
            y2 * input.totalAbsolutePressure

        let p3 =
            y3 * input.totalAbsolutePressure

        let pressureSum =
            p1 + p2 + p3

        let outputs = [
            sum,
            y1,
            y2,
            y3,
            p1,
            p2,
            p3,
            pressureSum
        ]

        guard outputs.allSatisfy(\.isFinite) else {
            throw DaltonPartialPressureError
                .numericalFailure
        }

        return .init(
            enteredFractionSum:
                sum,
            normalizedFraction1:
                y1,
            normalizedFraction2:
                y2,
            normalizedFraction3:
                y3,
            partialPressure1:
                p1,
            partialPressure2:
                p2,
            partialPressure3:
                p3,
            partialPressureSum:
                pressureSum,
            modelName:
                "Dalton ideal-gas partial-pressure law",
            limitationDescription:
                "Fractions are normalized automatically. Dalton's law is exact for ideal-gas mixtures and approximate for real gases."
        )
    }
}
