struct ConcentrationScaleConverterEngine:
    Sendable {

    func calculate(
        _ input:
            ConcentrationScaleConverterInput
    ) throws
        -> ConcentrationScaleConverterResult {

        let values = [
            input.enteredValue,
            input.inputScaleCode
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw ConcentrationScaleConverterError
                .nonFiniteInput
        }

        guard input.enteredValue >= 0 else {
            throw ConcentrationScaleConverterError
                .negativeValue
        }

        let roundedCode =
            input.inputScaleCode.rounded()

        guard
            abs(
                input.inputScaleCode
                - roundedCode
            ) < 1e-12,
            roundedCode >= 1,
            roundedCode <= 3
        else {
            throw ConcentrationScaleConverterError
                .invalidScaleCode
        }

        let fraction: Double
        let inputScaleName: String

        switch Int(roundedCode) {
        case 1:
            fraction =
                input.enteredValue
                / 100

            inputScaleName =
                "Percent"

        case 2:
            fraction =
                input.enteredValue
                / 1_000_000

            inputScaleName =
                "ppm"

        default:
            fraction =
                input.enteredValue
                / 1_000_000_000

            inputScaleName =
                "ppb"
        }

        guard fraction <= 1 else {
            throw ConcentrationScaleConverterError
                .fractionAboveOne
        }

        let percent =
            fraction
            * 100

        let ppm =
            fraction
            * 1_000_000

        let ppb =
            fraction
            * 1_000_000_000

        let results = [
            fraction,
            percent,
            ppm,
            ppb
        ]

        guard
            results.allSatisfy(\.isFinite),
            results.allSatisfy({ $0 >= 0 })
        else {
            throw ConcentrationScaleConverterError
                .numericalFailure
        }

        return .init(
            inputScaleName:
                inputScaleName,
            dimensionlessFraction:
                fraction,
            percent:
                percent,
            partsPerMillion:
                ppm,
            partsPerBillion:
                ppb,
            modelName:
                "Dimensionless fraction concentration-scale conversion",
            limitationDescription:
                "The conversion assumes all scales refer to the same basis, such as mass fraction or mole fraction."
        )
    }
}
