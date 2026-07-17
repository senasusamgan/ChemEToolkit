struct SoluteDilutionCalculatorEngine:
    Sendable {

    func calculate(
        _ input:
            SoluteDilutionCalculatorInput
    ) throws
        -> SoluteDilutionCalculatorResult {

        let values = [
            input.initialSolutionMass,
            input.initialSoluteMassFraction,
            input.targetSoluteMassFraction
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw SoluteDilutionCalculatorError
                .nonFiniteInput
        }

        guard input.initialSolutionMass > 0 else {
            throw SoluteDilutionCalculatorError
                .nonPositiveInitialMass
        }

        let fractions = [
            input.initialSoluteMassFraction,
            input.targetSoluteMassFraction
        ]

        guard
            fractions.allSatisfy({
                $0 >= 0 && $0 <= 1
            })
        else {
            throw SoluteDilutionCalculatorError
                .fractionOutsideRange
        }

        guard
            input.targetSoluteMassFraction > 0,
            input.targetSoluteMassFraction
                <= input.initialSoluteMassFraction
        else {
            throw SoluteDilutionCalculatorError
                .invalidDilutionTarget
        }

        let soluteMass =
            input.initialSolutionMass
            * input.initialSoluteMassFraction

        let initialSolvent =
            input.initialSolutionMass
            - soluteMass

        let finalMass =
            soluteMass
            / input.targetSoluteMassFraction

        let addedSolvent =
            finalMass
            - input.initialSolutionMass

        let finalSolvent =
            finalMass
            - soluteMass

        let dilutionRatio =
            finalMass
            / input.initialSolutionMass

        let additionRatio =
            addedSolvent
            / input.initialSolutionMass

        let outputs = [
            soluteMass,
            initialSolvent,
            finalMass,
            addedSolvent,
            finalSolvent,
            dilutionRatio,
            additionRatio
        ]

        guard
            outputs.allSatisfy(\.isFinite),
            outputs.allSatisfy({ $0 >= 0 })
        else {
            throw SoluteDilutionCalculatorError
                .numericalFailure
        }

        return .init(
            soluteMass:
                soluteMass,
            initialSolventMass:
                initialSolvent,
            finalSolutionMass:
                finalMass,
            addedSolventMass:
                addedSolvent,
            finalSolventMass:
                finalSolvent,
            dilutionRatio:
                dilutionRatio,
            addedSolventToInitialSolutionRatio:
                additionRatio,
            modelName:
                "Conserved-solute dilution mass balance",
            limitationDescription:
                "Assumes the added stream is pure solvent and no solute is lost, generated or consumed."
        )
    }
}
