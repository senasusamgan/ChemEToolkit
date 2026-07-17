struct VolumetricMassFlowConversionEngine:
    Sendable {

    func calculate(
        _ input:
            VolumetricMassFlowConversionInput
    ) throws
        -> VolumetricMassFlowConversionResult {

        let values = [
            input
                .volumetricFlowRateCubicMetersPerHour,
            input
                .densityKilogramsPerCubicMeter
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw VolumetricMassFlowConversionError
                .nonFiniteInput
        }

        guard
            input
                .volumetricFlowRateCubicMetersPerHour
            >= 0
        else {
            throw VolumetricMassFlowConversionError
                .negativeVolumetricFlow
        }

        guard
            input
                .densityKilogramsPerCubicMeter
            > 0
        else {
            throw VolumetricMassFlowConversionError
                .nonPositiveDensity
        }

        let massFlowPerHour =
            input
                .volumetricFlowRateCubicMetersPerHour
            * input
                .densityKilogramsPerCubicMeter

        let massFlowPerSecond =
            massFlowPerHour
            / 3_600

        let volumetricFlowPerSecond =
            input
                .volumetricFlowRateCubicMetersPerHour
            / 3_600

        let litersPerSecond =
            volumetricFlowPerSecond
            * 1_000

        let results = [
            massFlowPerHour,
            massFlowPerSecond,
            volumetricFlowPerSecond,
            litersPerSecond
        ]

        guard
            results.allSatisfy(\.isFinite),
            results.allSatisfy({ $0 >= 0 })
        else {
            throw VolumetricMassFlowConversionError
                .numericalFailure
        }

        return .init(
            massFlowRateKilogramsPerHour:
                massFlowPerHour,
            massFlowRateKilogramsPerSecond:
                massFlowPerSecond,
            volumetricFlowRateCubicMetersPerSecond:
                volumetricFlowPerSecond,
            volumetricFlowRateLitersPerSecond:
                litersPerSecond,
            modelName:
                "Mass flow equals density multiplied by volumetric flow",
            limitationDescription:
                "Density must correspond to the pressure, temperature and composition of the entered volumetric flow."
        )
    }
}
