import Foundation

struct GaussianPlumeDispersionEngine:
    Sendable {

    func calculate(
        _ input:
            GaussianPlumeDispersionInput
    ) throws
        -> GaussianPlumeDispersionResult {

        let values = [
            input.sourceEmissionRate,
            input.windSpeed,
            input.crosswindDistance,
            input.receptorHeight,
            input.effectiveReleaseHeight,
            input.horizontalDispersionCoefficient,
            input.verticalDispersionCoefficient
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw GaussianPlumeDispersionError
                .nonFiniteInput
        }

        guard input.sourceEmissionRate > 0 else {
            throw GaussianPlumeDispersionError
                .nonPositiveEmissionRate
        }

        guard input.windSpeed > 0 else {
            throw GaussianPlumeDispersionError
                .nonPositiveWindSpeed
        }

        guard
            input.crosswindDistance >= 0,
            input.receptorHeight >= 0,
            input.effectiveReleaseHeight >= 0
        else {
            throw GaussianPlumeDispersionError
                .negativeDistanceOrHeight
        }

        guard
            input.horizontalDispersionCoefficient > 0,
            input.verticalDispersionCoefficient > 0
        else {
            throw GaussianPlumeDispersionError
                .nonPositiveDispersionCoefficient
        }

        let sigmaY =
            input.horizontalDispersionCoefficient

        let sigmaZ =
            input.verticalDispersionCoefficient

        let crosswindTerm =
            exp(
                -input.crosswindDistance
                * input.crosswindDistance
                / (
                    2
                    * sigmaY
                    * sigmaY
                )
            )

        let directVerticalTerm =
            exp(
                -pow(
                    input.receptorHeight
                    - input.effectiveReleaseHeight,
                    2
                )
                / (
                    2
                    * sigmaZ
                    * sigmaZ
                )
            )

        let reflectedVerticalTerm =
            exp(
                -pow(
                    input.receptorHeight
                    + input.effectiveReleaseHeight,
                    2
                )
                / (
                    2
                    * sigmaZ
                    * sigmaZ
                )
            )

        let denominator =
            2
            * Double.pi
            * input.windSpeed
            * sigmaY
            * sigmaZ

        let concentration =
            input.sourceEmissionRate
            / denominator
            * crosswindTerm
            * (
                directVerticalTerm
                + reflectedVerticalTerm
            )

        let groundVerticalTerm =
            2
            * exp(
                -input.effectiveReleaseHeight
                * input.effectiveReleaseHeight
                / (
                    2
                    * sigmaZ
                    * sigmaZ
                )
            )

        let groundCenterline =
            input.sourceEmissionRate
            / denominator
            * groundVerticalTerm

        let relativeConcentration =
            groundCenterline > 0
            ? concentration / groundCenterline
            : 0

        let concentrationMg =
            concentration
            * 1_000_000

        let results = [
            crosswindTerm,
            directVerticalTerm,
            reflectedVerticalTerm,
            concentration,
            concentrationMg,
            groundCenterline,
            relativeConcentration
        ]

        guard
            results.allSatisfy(\.isFinite),
            crosswindTerm >= 0,
            crosswindTerm <= 1,
            directVerticalTerm >= 0,
            directVerticalTerm <= 1,
            reflectedVerticalTerm >= 0,
            reflectedVerticalTerm <= 1,
            concentration >= 0,
            groundCenterline > 0,
            relativeConcentration >= 0
        else {
            throw GaussianPlumeDispersionError
                .numericalFailure
        }

        return .init(
            crosswindAttenuation:
                crosswindTerm,
            directVerticalTerm:
                directVerticalTerm,
            reflectedVerticalTerm:
                reflectedVerticalTerm,
            receptorConcentration:
                concentration,
            receptorConcentrationMilligramsPerCubicMeter:
                concentrationMg,
            groundCenterlineConcentration:
                groundCenterline,
            relativeToGroundCenterline:
                relativeConcentration,
            modelName:
                "Steady Gaussian plume with ground reflection",
            limitationDescription:
                "Requires externally selected dispersion coefficients. Assumes steady wind, flat terrain, continuous passive release and no deposition, chemistry, building wake, buoyancy transition or dense-gas behavior."
        )
    }
}
