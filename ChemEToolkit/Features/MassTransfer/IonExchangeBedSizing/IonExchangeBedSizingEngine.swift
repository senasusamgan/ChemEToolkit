struct IonExchangeBedSizingEngine:
    Sendable {

    private let integerTolerance =
        1.0e-9

    func calculate(
        _ input:
            IonExchangeBedSizingInput
    ) throws
        -> IonExchangeBedSizingResult {

        let values = [
            input.liquidVolumetricFlowRate,
            input.influentIonConcentration,
            input.ionChargeMagnitude,
            input.targetRemovalFraction,
            input.serviceTime,
            input.resinCapacity,
            input.capacityUtilizationFraction
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw
                IonExchangeBedSizingError
                    .nonFiniteInput
        }

        guard
            input.liquidVolumetricFlowRate > 0,
            input.influentIonConcentration > 0,
            input.serviceTime > 0,
            input.resinCapacity > 0
        else {
            throw
                IonExchangeBedSizingError
                    .nonPositiveProperty
        }

        let roundedCharge =
            input.ionChargeMagnitude.rounded()

        guard
            abs(
                input.ionChargeMagnitude
                - roundedCharge
            ) <= integerTolerance,
            roundedCharge >= 1,
            roundedCharge <= 6
        else {
            throw
                IonExchangeBedSizingError
                    .invalidIonCharge
        }

        guard
            input.targetRemovalFraction > 0,
            input.targetRemovalFraction <= 1
        else {
            throw
                IonExchangeBedSizingError
                    .removalFractionOutOfRange
        }

        guard
            input.capacityUtilizationFraction > 0,
            input.capacityUtilizationFraction <= 1
        else {
            throw
                IonExchangeBedSizingError
                    .utilizationFractionOutOfRange
        }

        let charge =
            Int(roundedCharge)

        let treatedVolume =
            input.liquidVolumetricFlowRate
            * input.serviceTime

        let totalEquivalentLoad =
            treatedVolume
            * input.influentIonConcentration
            * Double(charge)

        let removedEquivalentLoad =
            totalEquivalentLoad
            * input.targetRemovalFraction

        let residualEquivalentLoad =
            totalEquivalentLoad
            - removedEquivalentLoad

        let usableCapacity =
            input.resinCapacity
            * input.capacityUtilizationFraction

        let requiredResinVolumeLiters =
            removedEquivalentLoad
            / usableCapacity

        let requiredResinVolumeCubicMeters =
            requiredResinVolumeLiters
            / 1000

        let outletConcentration =
            input.influentIonConcentration
            * (
                1
                - input.targetRemovalFraction
            )

        let emptyBedContactTimeMinutes =
            requiredResinVolumeCubicMeters
            / input.liquidVolumetricFlowRate
            * 60

        let processedBedVolumes =
            treatedVolume
            / requiredResinVolumeCubicMeters

        let results = [
            treatedVolume,
            totalEquivalentLoad,
            removedEquivalentLoad,
            residualEquivalentLoad,
            usableCapacity,
            requiredResinVolumeLiters,
            requiredResinVolumeCubicMeters,
            outletConcentration,
            emptyBedContactTimeMinutes,
            processedBedVolumes
        ]

        guard
            results.allSatisfy(\.isFinite),
            treatedVolume > 0,
            totalEquivalentLoad > 0,
            removedEquivalentLoad > 0,
            residualEquivalentLoad >= 0,
            usableCapacity > 0,
            requiredResinVolumeLiters > 0,
            requiredResinVolumeCubicMeters > 0,
            outletConcentration >= 0,
            emptyBedContactTimeMinutes > 0,
            processedBedVolumes > 0
        else {
            throw
                IonExchangeBedSizingError
                    .numericalFailure
        }

        return
            IonExchangeBedSizingResult(
                ionChargeMagnitude: charge,
                treatedLiquidVolume:
                    treatedVolume,
                totalEquivalentLoad:
                    totalEquivalentLoad,
                removedEquivalentLoad:
                    removedEquivalentLoad,
                residualEquivalentLoad:
                    residualEquivalentLoad,
                usableResinCapacity:
                    usableCapacity,
                requiredResinVolumeLiters:
                    requiredResinVolumeLiters,
                requiredResinVolumeCubicMeters:
                    requiredResinVolumeCubicMeters,
                outletIonConcentration:
                    outletConcentration,
                emptyBedContactTimeMinutes:
                    emptyBedContactTimeMinutes,
                processedBedVolumes:
                    processedBedVolumes,
                modelName:
                    "Stoichiometric ion-exchange capacity sizing on an equivalent basis",
                limitationDescription:
                    "This is a capacity balance, not a breakthrough-curve model. Selectivity, film resistance, intraparticle diffusion, pressure drop and regeneration inefficiency require separate design data."
            )
    }
}
