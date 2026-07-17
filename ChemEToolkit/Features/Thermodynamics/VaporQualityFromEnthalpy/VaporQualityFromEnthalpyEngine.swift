struct VaporQualityFromEnthalpyEngine:
    Sendable {

    func calculate(
        _ input:
            VaporQualityFromEnthalpyInput
    ) throws
        -> VaporQualityFromEnthalpyResult {

        let values = [
            input.saturatedLiquidEnthalpy,
            input.saturatedVaporEnthalpy,
            input.mixtureEnthalpy
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw VaporQualityFromEnthalpyError
                .nonFiniteInput
        }

        guard
            input.saturatedVaporEnthalpy
            > input.saturatedLiquidEnthalpy
        else {
            throw VaporQualityFromEnthalpyError
                .invalidSaturationProperties
        }

        let tolerance =
            max(
                1e-12,
                abs(input.saturatedVaporEnthalpy)
                * 1e-12
            )

        guard
            input.mixtureEnthalpy
                >= input.saturatedLiquidEnthalpy
                    - tolerance,
            input.mixtureEnthalpy
                <= input.saturatedVaporEnthalpy
                    + tolerance
        else {
            throw VaporQualityFromEnthalpyError
                .mixtureOutsideSaturationRange
        }

        let latentEnthalpy =
            input.saturatedVaporEnthalpy
            - input.saturatedLiquidEnthalpy

        let rawQuality =
            (
                input.mixtureEnthalpy
                - input.saturatedLiquidEnthalpy
            )
            / latentEnthalpy

        let quality =
            min(
                1,
                max(
                    0,
                    rawQuality
                )
            )

        let liquidFraction =
            1 - quality

        let region: String

        if quality == 0 {
            region = "Saturated liquid"
        } else if quality == 1 {
            region = "Saturated vapor"
        } else {
            region = "Two-phase saturated mixture"
        }

        let outputs = [
            latentEnthalpy,
            quality,
            liquidFraction
        ]

        guard
            outputs.allSatisfy(\.isFinite),
            quality >= 0,
            quality <= 1,
            liquidFraction >= 0,
            liquidFraction <= 1
        else {
            throw VaporQualityFromEnthalpyError
                .numericalFailure
        }

        return .init(
            latentEnthalpy:
                latentEnthalpy,
            vaporQuality:
                quality,
            liquidMassFraction:
                liquidFraction,
            vaporMassFraction:
                quality,
            regionDescription:
                region,
            modelName:
                "Saturated-mixture enthalpy lever rule",
            limitationDescription:
                "Uses x = (h − hf)/(hg − hf). Vapor quality is defined only inside the two-phase saturation region."
        )
    }
}
