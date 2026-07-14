import Foundation

struct NumberFormatterService {
    let locale: Locale
    let minimumFractionDigits: Int
    let maximumFractionDigits: Int
    let scientificLowerThreshold: Double
    let scientificUpperThreshold: Double

    init(
        locale: Locale = .current,
        minimumFractionDigits: Int = 0,
        maximumFractionDigits: Int = 4,
        scientificLowerThreshold: Double = 0.0001,
        scientificUpperThreshold: Double = 1_000_000
    ) {
        self.locale = locale
        self.minimumFractionDigits =
            minimumFractionDigits
        self.maximumFractionDigits =
            maximumFractionDigits
        self.scientificLowerThreshold =
            scientificLowerThreshold
        self.scientificUpperThreshold =
            scientificUpperThreshold
    }

    static let standard =
        NumberFormatterService()

    static let precise =
        NumberFormatterService(
            maximumFractionDigits: 8
        )

    func format(
        _ value: Double,
        unit: String? = nil,
        forceScientificNotation: Bool = false
    ) -> String {
        guard value.isFinite else {
            return "Invalid result"
        }

        let absoluteValue = abs(value)

        let shouldUseScientificNotation =
            forceScientificNotation ||
            absoluteValue >= scientificUpperThreshold ||
            (
                absoluteValue > 0 &&
                absoluteValue < scientificLowerThreshold
            )

        let formattedValue: String

        if shouldUseScientificNotation {
            formattedValue = formatScientific(value)
        } else {
            formattedValue = formatDecimal(value)
        }

        guard
            let unit,
            !unit.isEmpty
        else {
            return formattedValue
        }

        return "\(formattedValue) \(unit)"
    }

    func formatPercentage(
        _ value: Double,
        maximumFractionDigits: Int = 2
    ) -> String {
        let formatter = NumberFormatter()
        formatter.locale = locale
        formatter.numberStyle = .percent
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits =
            maximumFractionDigits

        return formatter.string(
            from: NSNumber(value: value)
        ) ?? "\(value * 100)%"
    }

    private func formatDecimal(
        _ value: Double
    ) -> String {
        let formatter = NumberFormatter()
        formatter.locale = locale
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits =
            minimumFractionDigits
        formatter.maximumFractionDigits =
            maximumFractionDigits
        formatter.usesGroupingSeparator = true

        return formatter.string(
            from: NSNumber(value: value)
        ) ?? String(value)
    }

    private func formatScientific(
        _ value: Double
    ) -> String {
        let formatter = NumberFormatter()
        formatter.locale = locale
        formatter.numberStyle = .scientific
        formatter.exponentSymbol = "e"
        formatter.minimumFractionDigits =
            minimumFractionDigits
        formatter.maximumFractionDigits =
            maximumFractionDigits

        return formatter.string(
            from: NSNumber(value: value)
        ) ?? String(format: "%.4e", value)
    }
}
