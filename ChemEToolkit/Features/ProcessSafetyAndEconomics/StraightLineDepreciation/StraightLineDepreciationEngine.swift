struct StraightLineDepreciationEngine:
    Sendable {

    func calculate(
        _ input:
            StraightLineDepreciationInput
    ) throws
        -> StraightLineDepreciationResult {

        let values = [
            input.depreciableAssetCost,
            input.salvageValue,
            input.serviceLifeYears,
            input.evaluationAgeYears
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw StraightLineDepreciationError
                .nonFiniteInput
        }

        guard input.depreciableAssetCost > 0 else {
            throw StraightLineDepreciationError
                .nonPositiveAssetCost
        }

        guard
            input.salvageValue >= 0,
            input.salvageValue
                <= input.depreciableAssetCost
        else {
            throw StraightLineDepreciationError
                .invalidSalvageValue
        }

        let roundedLife =
            input.serviceLifeYears.rounded()

        guard
            abs(
                input.serviceLifeYears
                - roundedLife
            ) < 1e-12,
            roundedLife >= 1,
            roundedLife <= 100
        else {
            throw StraightLineDepreciationError
                .invalidServiceLife
        }

        let roundedAge =
            input.evaluationAgeYears.rounded()

        guard
            abs(
                input.evaluationAgeYears
                - roundedAge
            ) < 1e-12,
            roundedAge >= 0,
            roundedAge <= roundedLife
        else {
            throw StraightLineDepreciationError
                .invalidEvaluationAge
        }

        let life =
            Int(roundedLife)

        let age =
            Int(roundedAge)

        let basis =
            input.depreciableAssetCost
            - input.salvageValue

        let annualDepreciation =
            basis
            / Double(life)

        let accumulated =
            annualDepreciation
            * Double(age)

        let bookValue =
            input.depreciableAssetCost
            - accumulated

        let remainingBasis =
            basis
            - accumulated

        let elapsedFraction =
            Double(age)
            / Double(life)

        let results = [
            basis,
            annualDepreciation,
            accumulated,
            bookValue,
            remainingBasis,
            elapsedFraction
        ]

        guard
            results.allSatisfy(\.isFinite),
            basis >= 0,
            annualDepreciation >= 0,
            accumulated >= 0,
            bookValue >= input.salvageValue - 1e-10,
            remainingBasis >= -1e-10,
            elapsedFraction >= 0,
            elapsedFraction <= 1
        else {
            throw StraightLineDepreciationError
                .numericalFailure
        }

        return .init(
            serviceLifeYears:
                life,
            evaluationAgeYears:
                age,
            depreciableBasis:
                basis,
            annualDepreciation:
                annualDepreciation,
            accumulatedDepreciation:
                accumulated,
            bookValue:
                bookValue,
            remainingDepreciableBasis:
                max(
                    0,
                    remainingBasis
                ),
            elapsedLifeFraction:
                elapsedFraction,
            assetIsFullyDepreciated:
                age == life,
            modelName:
                "Straight-line depreciation: D = (P − S)/n",
            limitationDescription:
                "This accounting model allocates equal depreciation each year. Tax depreciation rules vary by jurisdiction and may require accelerated schedules, conventions and asset classes."
        )
    }
}
