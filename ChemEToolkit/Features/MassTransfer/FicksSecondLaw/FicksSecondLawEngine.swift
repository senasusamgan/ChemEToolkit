import Foundation

struct FicksSecondLawEngine:
    Sendable {

    func calculate(
        _ input: FicksSecondLawInput
    ) throws -> FicksSecondLawResult {

        let values = [
            input.initialConcentration,
            input.surfaceConcentration,
            input.diffusivity,
            input.depth,
            input.diffusionTime
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw FicksSecondLawError
                .nonFiniteInput
        }

        guard
            input.initialConcentration
            != input.surfaceConcentration
        else {
            throw FicksSecondLawError
                .equalInitialAndSurfaceConcentrations
        }

        guard input.diffusivity > 0 else {
            throw FicksSecondLawError
                .nonPositiveDiffusivity
        }

        guard input.depth >= 0 else {
            throw FicksSecondLawError
                .negativeDepth
        }

        guard input.diffusionTime > 0 else {
            throw FicksSecondLawError
                .nonPositiveTime
        }

        let rootDiffusionTime =
            sqrt(
                input.diffusivity
                * input.diffusionTime
            )

        let similarityVariable =
            input.depth
            / (
                2
                * rootDiffusionTime
            )

        let dimensionlessRatio =
            erf(similarityVariable)

        let fractionalApproach =
            erfc(similarityVariable)

        let concentration =
            input.surfaceConcentration
            + (
                input.initialConcentration
                - input.surfaceConcentration
            )
            * dimensionlessRatio

        let diffusionLength =
            2 * rootDiffusionTime

        let gradientScale =
            (
                input.initialConcentration
                - input.surfaceConcentration
            )
            / (
                sqrt(.pi)
                * rootDiffusionTime
            )

        let signedSurfaceFlux =
            input.diffusivity
            * gradientScale

        let results = [
            similarityVariable,
            dimensionlessRatio,
            fractionalApproach,
            concentration,
            diffusionLength,
            gradientScale,
            signedSurfaceFlux
        ]

        guard
            results.allSatisfy(\.isFinite),
            similarityVariable >= 0,
            dimensionlessRatio >= 0,
            dimensionlessRatio <= 1,
            fractionalApproach >= 0,
            fractionalApproach <= 1,
            diffusionLength > 0
        else {
            throw FicksSecondLawError
                .numericalFailure
        }

        let directionDescription =
            signedSurfaceFlux > 0
            ? "The initial medium concentration exceeds the imposed surface concentration; diffusion proceeds toward the surface."
            : "The imposed surface concentration exceeds the initial medium concentration; diffusion proceeds into the medium."

        return FicksSecondLawResult(
            similarityVariable:
                similarityVariable,
            dimensionlessConcentrationRatio:
                dimensionlessRatio,
            fractionalApproachToSurface:
                fractionalApproach,
            concentrationAtDepthAndTime:
                concentration,
            diffusionLength:
                diffusionLength,
            initialConcentrationGradientScale:
                gradientScale,
            signedSurfaceFlux:
                signedSurfaceFlux,
            directionDescription:
                directionDescription,
            modelName:
                "Semi-infinite medium with a suddenly imposed constant surface concentration",
            limitationDescription:
                "Assumes constant diffusivity, one-dimensional transport, a semi-infinite medium, no reaction and an unchanged surface concentration for t > 0."
        )
    }
}
