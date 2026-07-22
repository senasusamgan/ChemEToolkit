import Testing
@testable import ChemEToolkit

@Suite("Ion Exchange Bed Sizing Engine")
struct IonExchangeBedSizingEngineTests {
    private let engine =
        IonExchangeBedSizingEngine()

    @Test(
        "Calculates equivalent load and required resin volume"
    )
    func calculatesSizing() throws {
        let result = try engine.calculate(
            .init(
                liquidVolumetricFlowRate: 2,
                influentIonConcentration: 5,
                ionChargeMagnitude: 2,
                targetRemovalFraction: 0.9,
                serviceTime: 8,
                resinCapacity: 1.8,
                capacityUtilizationFraction:
                    0.75
            )
        )

        #expect(
            result.ionChargeMagnitude == 2
        )
        #expect(
            abs(
                result.totalEquivalentLoad
                - 160
            ) < 1e-12
        )
        #expect(
            abs(
                result.removedEquivalentLoad
                - 144
            ) < 1e-12
        )
        #expect(
            abs(
                result.requiredResinVolumeLiters
                - 106.66666666666667
            ) < 1e-12
        )
        #expect(
            abs(
                result.emptyBedContactTimeMinutes
                - 3.2
            ) < 1e-12
        )
        #expect(
            abs(
                result.processedBedVolumes
                - 150
            ) < 1e-12
        )
    }

    @Test(
        "Handles complete removal at full capacity utilization"
    )
    func completeRemovalBoundary() throws {
        let result = try engine.calculate(
            .init(
                liquidVolumetricFlowRate: 1,
                influentIonConcentration: 1,
                ionChargeMagnitude: 1,
                targetRemovalFraction: 1,
                serviceTime: 1,
                resinCapacity: 1,
                capacityUtilizationFraction:
                    1
            )
        )

        #expect(
            result.outletIonConcentration
            == 0
        )
        #expect(
            result.residualEquivalentLoad
            == 0
        )
        #expect(
            result.requiredResinVolumeLiters
            == 1
        )
    }

    @Test(
        "Rejects invalid charge, fractions and nonfinite input"
    )
    func validation() {
        #expect(
            throws:
                IonExchangeBedSizingError
                    .invalidIonCharge
        ) {
            try engine.calculate(
                .init(
                    liquidVolumetricFlowRate:
                        2,
                    influentIonConcentration:
                        5,
                    ionChargeMagnitude: 1.5,
                    targetRemovalFraction:
                        0.9,
                    serviceTime: 8,
                    resinCapacity: 1.8,
                    capacityUtilizationFraction:
                        0.75
                )
            )
        }

        #expect(
            throws:
                IonExchangeBedSizingError
                    .removalFractionOutOfRange
        ) {
            try engine.calculate(
                .init(
                    liquidVolumetricFlowRate:
                        2,
                    influentIonConcentration:
                        5,
                    ionChargeMagnitude: 2,
                    targetRemovalFraction:
                        0,
                    serviceTime: 8,
                    resinCapacity: 1.8,
                    capacityUtilizationFraction:
                        0.75
                )
            )
        }

        #expect(
            throws:
                IonExchangeBedSizingError
                    .utilizationFractionOutOfRange
        ) {
            try engine.calculate(
                .init(
                    liquidVolumetricFlowRate:
                        2,
                    influentIonConcentration:
                        5,
                    ionChargeMagnitude: 2,
                    targetRemovalFraction:
                        0.9,
                    serviceTime: 8,
                    resinCapacity: 1.8,
                    capacityUtilizationFraction:
                        1.1
                )
            )
        }

        #expect(
            throws:
                IonExchangeBedSizingError
                    .nonFiniteInput
        ) {
            try engine.calculate(
                .init(
                    liquidVolumetricFlowRate:
                        .nan,
                    influentIonConcentration:
                        5,
                    ionChargeMagnitude: 2,
                    targetRemovalFraction:
                        0.9,
                    serviceTime: 8,
                    resinCapacity: 1.8,
                    capacityUtilizationFraction:
                        0.75
                )
            )
        }
    }
}
