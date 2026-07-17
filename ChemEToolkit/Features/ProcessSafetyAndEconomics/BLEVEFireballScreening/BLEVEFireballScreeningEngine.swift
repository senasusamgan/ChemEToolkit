import Foundation

struct BLEVEFireballScreeningEngine:
    Sendable {

    func calculate(
        _ input:
            BLEVEFireballScreeningInput
    ) throws
        -> BLEVEFireballScreeningResult {

        let values = [
            input.flammableMass,
            input.heatOfCombustion,
            input.radiantFraction,
            input.atmosphericTransmissivity,
            input.receptorDistance
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw BLEVEFireballScreeningError
                .nonFiniteInput
        }

        guard input.flammableMass > 0 else {
            throw BLEVEFireballScreeningError
                .nonPositiveMass
        }

        guard input.heatOfCombustion > 0 else {
            throw BLEVEFireballScreeningError
                .nonPositiveHeatOfCombustion
        }

        let fractions = [
            input.radiantFraction,
            input.atmosphericTransmissivity
        ]

        guard
            fractions.allSatisfy({
                $0 > 0 && $0 <= 1
            })
        else {
            throw BLEVEFireballScreeningError
                .fractionOutsideRange
        }

        guard input.receptorDistance > 0 else {
            throw BLEVEFireballScreeningError
                .nonPositiveDistance
        }

        let fireballDiameter =
            6.48
            * pow(
                input.flammableMass,
                0.325
            )

        let fireballDuration =
            0.852
            * pow(
                input.flammableMass,
                0.26
            )

        let combustionEnergy =
            input.flammableMass
            * input.heatOfCombustion

        let radiatedEnergy =
            combustionEnergy
            * input.radiantFraction

        let averageFlux =
            input.atmosphericTransmissivity
            * radiatedEnergy
            / (
                4
                * Double.pi
                * input.receptorDistance
                * input.receptorDistance
                * fireballDuration
            )

        let hazardBand: String
        let description: String

        switch averageFlux {
        case ..<4_700:
            hazardBand = "Moderate screening flux"
            description =
                "Average thermal radiation is below 4.7 kW/m²."

        case ..<12_500:
            hazardBand = "High screening flux"
            description =
                "Average thermal radiation lies between 4.7 and 12.5 kW/m²."

        case ..<37_500:
            hazardBand = "Severe screening flux"
            description =
                "Average thermal radiation lies between 12.5 and 37.5 kW/m²."

        default:
            hazardBand = "Extreme screening flux"
            description =
                "Average thermal radiation is at or above 37.5 kW/m²."
        }

        let results = [
            fireballDiameter,
            fireballDuration,
            combustionEnergy,
            radiatedEnergy,
            averageFlux
        ]

        guard
            results.allSatisfy(\.isFinite),
            fireballDiameter > 0,
            fireballDuration > 0,
            combustionEnergy > 0,
            radiatedEnergy > 0,
            averageFlux > 0
        else {
            throw BLEVEFireballScreeningError
                .numericalFailure
        }

        return .init(
            fireballDiameter:
                fireballDiameter,
            fireballDuration:
                fireballDuration,
            totalCombustionEnergy:
                combustionEnergy,
            radiatedEnergy:
                radiatedEnergy,
            averageRadiationFlux:
                averageFlux,
            hazardBand:
                hazardBand,
            screeningDescription:
                description,
            modelName:
                "Empirical BLEVE fireball diameter-duration and point-source radiation screening",
            limitationDescription:
                "The empirical correlations and point-source flux are screening approximations. Vessel geometry, fill level, fuel participation, fireball elevation, view factor, shielding and atmospheric effects require specialist consequence analysis."
        )
    }
}
