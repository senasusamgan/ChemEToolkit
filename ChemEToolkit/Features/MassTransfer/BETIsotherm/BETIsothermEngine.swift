struct BETIsothermEngine:
    Sendable {

    private let avogadroConstant =
        6.02214076e23

    func calculate(
        _ input: BETIsothermInput
    ) throws -> BETIsothermResult {

        let values = [
            input.relativePressure,
            input.monolayerCapacity,
            input.betConstant,
            input.adsorbateMolarMass,
            input.molecularCrossSectionalArea
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw BETIsothermError
                .nonFiniteInput
        }

        guard
            input.relativePressure > 0,
            input.relativePressure < 1
        else {
            throw BETIsothermError
                .relativePressureOutOfRange
        }

        guard
            input.monolayerCapacity > 0,
            input.betConstant > 0,
            input.adsorbateMolarMass > 0,
            input.molecularCrossSectionalArea > 0
        else {
            throw BETIsothermError
                .nonPositiveModelParameter
        }

        let x =
            input.relativePressure

        let denominator =
            (1 - x)
            * (
                1
                + (
                    input.betConstant - 1
                )
                * x
            )

        let equilibriumLoading =
            input.monolayerCapacity
            * input.betConstant
            * x
            / denominator

        let monolayerFraction =
            equilibriumLoading
            / input.monolayerCapacity

        let adsorbedMass =
            equilibriumLoading
            * input.adsorbateMolarMass

        let transformOrdinate =
            x
            / (
                equilibriumLoading
                * (1 - x)
            )

        let theoreticalIntercept =
            1
            / (
                input.monolayerCapacity
                * input.betConstant
            )

        let theoreticalSlope =
            (
                input.betConstant - 1
            )
            / (
                input.monolayerCapacity
                * input.betConstant
            )

        let monolayerAdsorbedMass =
            input.monolayerCapacity
            * input.adsorbateMolarMass

        let specificSurfaceArea =
            input.monolayerCapacity
            * avogadroConstant
            * input.molecularCrossSectionalArea

        let pressureRegion:
            BETPressureRegion

        let regionDescription: String

        if x < 0.05 {
            pressureRegion =
                .belowRecommendedLinearRange

            regionDescription =
                "The BET equation is evaluated, but this point is below the commonly used 0.05–0.35 relative-pressure fitting region."
        } else if x <= 0.35 {
            pressureRegion =
                .recommendedLinearRange

            regionDescription =
                "The relative pressure lies within the commonly used 0.05–0.35 BET linear fitting region."
        } else {
            pressureRegion =
                .aboveRecommendedLinearRange

            regionDescription =
                "The BET equation is evaluated, but multilayer adsorption and capillary effects may make this point unsuitable for linear BET fitting."
        }

        let results = [
            equilibriumLoading,
            monolayerFraction,
            adsorbedMass,
            transformOrdinate,
            theoreticalIntercept,
            theoreticalSlope,
            monolayerAdsorbedMass,
            specificSurfaceArea
        ]

        guard
            results.allSatisfy(\.isFinite),
            equilibriumLoading > 0,
            monolayerFraction > 0,
            adsorbedMass > 0,
            transformOrdinate > 0,
            theoreticalIntercept > 0,
            theoreticalSlope > -theoreticalIntercept,
            monolayerAdsorbedMass > 0,
            specificSurfaceArea > 0
        else {
            throw BETIsothermError
                .numericalFailure
        }

        return BETIsothermResult(
            pressureRegion:
                pressureRegion,
            equilibriumLoading:
                equilibriumLoading,
            monolayerFraction:
                monolayerFraction,
            adsorbedMassPerAdsorbentMass:
                adsorbedMass,
            betTransformOrdinate:
                transformOrdinate,
            theoreticalBETIntercept:
                theoreticalIntercept,
            theoreticalBETSlope:
                theoreticalSlope,
            monolayerAdsorbedMass:
                monolayerAdsorbedMass,
            specificSurfaceArea:
                specificSurfaceArea,
            regionDescription:
                regionDescription,
            modelName:
                "Brunauer–Emmett–Teller multilayer adsorption isotherm",
            limitationDescription:
                "Assumes equivalent adsorption sites, no lateral adsorbate interactions and a constant heat of adsorption beyond the first layer. Surface-area fitting should use an experimentally linear relative-pressure region."
        )
    }
}
