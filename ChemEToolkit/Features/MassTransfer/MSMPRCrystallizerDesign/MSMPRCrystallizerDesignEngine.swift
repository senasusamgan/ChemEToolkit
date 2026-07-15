import Foundation

struct MSMPRCrystallizerDesignEngine:
    Sendable {

    private let maximumSolidsVolumeFraction =
        0.20

    private let comparisonTolerance =
        1.0e-12

    func calculate(
        _ input:
            MSMPRCrystallizerDesignInput
    ) throws
        -> MSMPRCrystallizerDesignResult {

        let values = [
            input.residenceTime,
            input.linearCrystalGrowthRate,
            input.nucleiPopulationDensity,
            input.crystalDensity,
            input.crystalVolumeShapeFactor,
            input.slurryVolumetricFlowRate,
            input.evaluationCrystalSize
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw
                MSMPRCrystallizerDesignError
                    .nonFiniteInput
        }

        guard
            input.residenceTime > 0,
            input.linearCrystalGrowthRate > 0,
            input.nucleiPopulationDensity > 0,
            input.crystalDensity > 0,
            input.crystalVolumeShapeFactor > 0,
            input.slurryVolumetricFlowRate > 0
        else {
            throw
                MSMPRCrystallizerDesignError
                    .nonPositiveProperty
        }

        guard input.evaluationCrystalSize >= 0 else {
            throw
                MSMPRCrystallizerDesignError
                    .negativeEvaluationSize
        }

        let characteristicSize =
            input.linearCrystalGrowthRate
            * input.residenceTime

        let numberMeanSize =
            characteristicSize

        let surfaceWeightedMeanSize =
            3 * characteristicSize

        let volumeWeightedMeanSize =
            4 * characteristicSize

        let totalNumberConcentration =
            input.nucleiPopulationDensity
            * characteristicSize

        let thirdMoment =
            6
            * input.nucleiPopulationDensity
            * pow(characteristicSize, 4)

        let solidsVolumeFraction =
            input.crystalVolumeShapeFactor
            * thirdMoment

        guard
            solidsVolumeFraction
            <= maximumSolidsVolumeFraction
            + comparisonTolerance
        else {
            throw
                MSMPRCrystallizerDesignError
                    .solidsFractionOutsideDiluteModel
        }

        let massConcentration =
            input.crystalDensity
            * solidsVolumeFraction

        let productionRate =
            input.slurryVolumetricFlowRate
            * massConcentration

        let normalizedEvaluationSize =
            input.evaluationCrystalSize
            / characteristicSize

        let populationAtSize =
            input.nucleiPopulationDensity
            * exp(
                -normalizedEvaluationSize
            )

        let numberFractionAboveSize =
            exp(
                -normalizedEvaluationSize
            )

        let results = [
            characteristicSize,
            numberMeanSize,
            surfaceWeightedMeanSize,
            volumeWeightedMeanSize,
            totalNumberConcentration,
            thirdMoment,
            solidsVolumeFraction,
            massConcentration,
            productionRate,
            populationAtSize,
            numberFractionAboveSize
        ]

        guard
            results.allSatisfy(\.isFinite),
            characteristicSize > 0,
            totalNumberConcentration > 0,
            thirdMoment > 0,
            solidsVolumeFraction > 0,
            massConcentration > 0,
            productionRate > 0,
            populationAtSize > 0,
            numberFractionAboveSize > 0,
            numberFractionAboveSize <= 1
        else {
            throw
                MSMPRCrystallizerDesignError
                    .numericalFailure
        }

        return
            MSMPRCrystallizerDesignResult(
                characteristicCrystalSize:
                    characteristicSize,
                numberMeanCrystalSize:
                    numberMeanSize,
                surfaceWeightedMeanSize:
                    surfaceWeightedMeanSize,
                volumeWeightedMeanSize:
                    volumeWeightedMeanSize,
                totalCrystalNumberConcentration:
                    totalNumberConcentration,
                thirdPopulationMoment:
                    thirdMoment,
                solidsVolumeFraction:
                    solidsVolumeFraction,
                crystalMassConcentration:
                    massConcentration,
                crystalProductionRate:
                    productionRate,
                evaluationCrystalSize:
                    input.evaluationCrystalSize,
                populationDensityAtEvaluationSize:
                    populationAtSize,
                fractionByNumberAboveEvaluationSize:
                    numberFractionAboveSize,
                modelName:
                    "Ideal steady-state MSMPR population balance",
                limitationDescription:
                    "Assumes perfect mixing, size-independent growth, negligible agglomeration and breakage, no crystal growth dispersion and a dilute slurry."
            )
    }
}
