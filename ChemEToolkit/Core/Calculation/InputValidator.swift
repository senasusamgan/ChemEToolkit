import Foundation

struct InputValidator {
    private init() {}

    static func parseNumber(
        _ text: String,
        fieldName: String,
        locale _: Locale = .current
    ) throws -> Double {
        let trimmedText = text.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        guard !trimmedText.isEmpty else {
            throw CalculationError.emptyField(
                fieldName: fieldName
            )
        }

        let normalizedText = normalizeDecimalInput(
            trimmedText
        )

        guard
            let value = Double(normalizedText),
            value.isFinite
        else {
            throw CalculationError.invalidNumber(
                fieldName: fieldName
            )
        }

        return value
    }

    static func requirePositive(
        _ value: Double,
        fieldName: String
    ) throws -> Double {
        guard value > 0 else {
            throw CalculationError.valueMustBePositive(
                fieldName: fieldName
            )
        }

        return value
    }

    static func requireNonNegative(
        _ value: Double,
        fieldName: String
    ) throws -> Double {
        guard value >= 0 else {
            throw CalculationError.valueCannotBeNegative(
                fieldName: fieldName
            )
        }

        return value
    }

    static func requireNonZero(
        _ value: Double,
        fieldName: String
    ) throws -> Double {
        guard value != 0 else {
            throw CalculationError.valueCannotBeZero(
                fieldName: fieldName
            )
        }

        return value
    }

    static func requireRange(
        _ value: Double,
        fieldName: String,
        minimum: Double,
        maximum: Double
    ) throws -> Double {
        guard minimum...maximum ~= value else {
            throw CalculationError.valueOutOfRange(
                fieldName: fieldName,
                minimum: minimum,
                maximum: maximum
            )
        }

        return value
    }

    static func requirePercentage(
        _ value: Double,
        fieldName: String
    ) throws -> Double {
        try requireRange(
            value,
            fieldName: fieldName,
            minimum: 0,
            maximum: 100
        )
    }

    static func requireFraction(
        _ value: Double,
        fieldName: String
    ) throws -> Double {
        try requireRange(
            value,
            fieldName: fieldName,
            minimum: 0,
            maximum: 1
        )
    }

    static func validateResult(
        _ value: Double
    ) throws -> Double {
        guard value.isFinite else {
            throw CalculationError.nonFiniteResult
        }

        return value
    }

    private static func normalizeDecimalInput(
        _ text: String
    ) -> String {
        var normalizedText = text
            .replacingOccurrences(
                of: "\u{00A0}",
                with: ""
            )
            .replacingOccurrences(
                of: "\u{202F}",
                with: ""
            )
            .replacingOccurrences(
                of: " ",
                with: ""
            )
            .replacingOccurrences(
                of: "_",
                with: ""
            )
            .replacingOccurrences(
                of: "'",
                with: ""
            )
            .replacingOccurrences(
                of: "’",
                with: ""
            )
            .replacingOccurrences(
                of: "−",
                with: "-"
            )

        let containsComma =
            normalizedText.contains(",")

        let containsPeriod =
            normalizedText.contains(".")

        if containsComma && containsPeriod {
            guard
                let lastCommaIndex =
                    normalizedText.lastIndex(of: ","),
                let lastPeriodIndex =
                    normalizedText.lastIndex(of: ".")
            else {
                return normalizedText
            }

            if lastCommaIndex > lastPeriodIndex {
                // European format:
                // 1.234,56 → 1234.56
                normalizedText =
                    normalizedText.replacingOccurrences(
                        of: ".",
                        with: ""
                    )

                normalizedText =
                    normalizedText.replacingOccurrences(
                        of: ",",
                        with: "."
                    )
            } else {
                // US/UK format:
                // 1,234.56 → 1234.56
                normalizedText =
                    normalizedText.replacingOccurrences(
                        of: ",",
                        with: ""
                    )
            }
        } else if containsComma {
            // Decimal comma:
            // 0,25 → 0.25
            normalizedText =
                normalizedText.replacingOccurrences(
                    of: ",",
                    with: "."
                )
        }

        return normalizedText
    }
}
