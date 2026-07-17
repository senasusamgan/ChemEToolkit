import Foundation

struct SignificantFiguresRoundingEngine:
    Sendable {

    func calculate(
        _ input:
            SignificantFiguresRoundingInput
    ) throws
        -> SignificantFiguresRoundingResult {

        let values = [
            input.value,
            input.significantDigitCount
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw SignificantFiguresRoundingError
                .nonFiniteInput
        }

        let roundedDigitCount =
            input.significantDigitCount
                .rounded()

        guard
            abs(
                input.significantDigitCount
                - roundedDigitCount
            ) < 1e-12,
            roundedDigitCount >= 1,
            roundedDigitCount <= 15
        else {
            throw SignificantFiguresRoundingError
                .invalidSignificantDigitCount
        }

        let digits =
            Int(roundedDigitCount)

        let roundedValue: Double
        let decimalPlaces: Int

        if input.value == 0 {
            roundedValue = 0
            decimalPlaces = digits - 1
        } else {
            let magnitude =
                floor(
                    log10(
                        abs(input.value)
                    )
                )

            decimalPlaces =
                digits
                - 1
                - Int(magnitude)

            let scale =
                Foundation.pow(
                    10,
                    Double(decimalPlaces)
                )

            roundedValue =
                (
                    input.value
                    * scale
                )
                .rounded()
                / scale
        }

        let absoluteDifference =
            abs(
                roundedValue
                - input.value
            )

        let relativeDifference =
            input.value != 0
            ? absoluteDifference
                / abs(input.value)
                * 100
            : 0

        let results = [
            roundedValue,
            absoluteDifference,
            relativeDifference
        ]

        guard results.allSatisfy(\.isFinite) else {
            throw SignificantFiguresRoundingError
                .numericalFailure
        }

        return .init(
            significantDigitCount:
                digits,
            roundedValue:
                roundedValue,
            decimalPlacesApplied:
                decimalPlaces,
            absoluteRoundingDifference:
                absoluteDifference,
            relativeRoundingDifferencePercent:
                relativeDifference,
            modelName:
                "Base-10 significant-figure rounding",
            limitationDescription:
                "Binary floating-point representation can display tiny residual differences even after decimal rounding."
        )
    }
}
