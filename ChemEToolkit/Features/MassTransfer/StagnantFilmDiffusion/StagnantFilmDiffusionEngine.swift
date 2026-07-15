import Foundation

struct StagnantFilmDiffusionEngine: Sendable {
    private let gasConstant = 8.314462618

    func calculate(_ input: StagnantFilmDiffusionInput) throws -> StagnantFilmDiffusionResult {
        let values = [
            input.diffusivity,
            input.totalPressure,
            input.temperature,
            input.thickness,
            input.moleFractionAAtSideOne,
            input.moleFractionAAtSideTwo
        ]
        guard values.allSatisfy(\.isFinite) else {
            throw StagnantFilmDiffusionError.nonFiniteInput
        }
        guard input.diffusivity > 0,
              input.totalPressure > 0,
              input.temperature > 0,
              input.thickness > 0 else {
            throw StagnantFilmDiffusionError.nonPositiveProperty
        }
        guard (0...1).contains(input.moleFractionAAtSideOne),
              (0...1).contains(input.moleFractionAAtSideTwo) else {
            throw StagnantFilmDiffusionError.invalidMoleFraction
        }

        let yB1 = 1 - input.moleFractionAAtSideOne
        let yB2 = 1 - input.moleFractionAAtSideTwo
        guard yB1 > 0, yB2 > 0 else {
            throw StagnantFilmDiffusionError.singularInertFraction
        }

        let concentration = input.totalPressure / (gasConstant * input.temperature)
        let logMeanYB: Double
        if abs(yB2 - yB1) < 1e-14 {
            logMeanYB = yB1
        } else {
            logMeanYB = (yB2 - yB1) / log(yB2 / yB1)
        }

        let flux = input.diffusivity
            * concentration
            * (input.moleFractionAAtSideOne - input.moleFractionAAtSideTwo)
            / (input.thickness * logMeanYB)

        return StagnantFilmDiffusionResult(
            fluxA: flux,
            logMeanInertFraction: logMeanYB,
            modelName: "Stefan diffusion through stagnant B"
        )
    }
}
