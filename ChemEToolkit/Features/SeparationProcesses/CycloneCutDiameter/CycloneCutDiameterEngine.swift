import Foundation

struct CycloneCutDiameterEngine: Sendable {
    func calculate(_ input: CycloneCutDiameterInput) throws -> CycloneCutDiameterResult {
        let values = [
            input.gasViscosity, input.inletWidth, input.effectiveTurns,
            input.particleDensity, input.gasDensity, input.inletVelocity
        ]
        guard values.allSatisfy(\.isFinite) else { throw CycloneCutDiameterError.nonFiniteInput }
        guard input.gasViscosity > 0, input.inletWidth > 0, input.effectiveTurns > 0, input.inletVelocity > 0 else {
            throw CycloneCutDiameterError.nonPositiveOperatingInput
        }

        let densityDifference = input.particleDensity - input.gasDensity
        guard densityDifference > 0 else { throw CycloneCutDiameterError.invalidDensityDifference }

        let denominator =
            2 * Double.pi * input.effectiveTurns * input.inletVelocity * densityDifference

        let cut = Foundation.sqrt(9 * input.gasViscosity * input.inletWidth / denominator)
        let exposure = input.effectiveTurns * input.inletVelocity / input.inletWidth
        let relaxation = input.particleDensity * cut * cut / (18 * input.gasViscosity)

        guard [densityDifference, cut, exposure, relaxation].allSatisfy(\.isFinite), cut > 0 else {
            throw CycloneCutDiameterError.numericalFailure
        }

        return .init(
            cutDiameter: cut,
            densityDifference: densityDifference,
            centrifugalExposure: exposure,
            particleRelaxationTime: relaxation,
            modelName: "Lapple-type cyclone cut-diameter estimate",
            limitationDescription: "Assumes Stokes-regime particle motion and idealized cyclone geometry; report the diameter in the length unit consistent with inputs."
        )
    }
}
