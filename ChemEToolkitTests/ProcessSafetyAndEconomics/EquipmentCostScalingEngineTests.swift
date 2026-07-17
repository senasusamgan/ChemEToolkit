import Testing
@testable import ChemEToolkit

@Suite("Equipment Cost Scaling Engine")
struct EquipmentCostScalingEngineTests {
    private let engine =
        EquipmentCostScalingEngine()

    @Test("Scales equipment cost by capacity exponent")
    func capacityScaling() throws {
        let result = try engine.calculate(
            .init(
                referenceEquipmentCost:
                    1_000_000,
                referenceCapacity: 100,
                targetCapacity: 200,
                scalingExponent: 0.6
            )
        )

        #expect(result.capacityRatio == 2)

        #expect(
            abs(
                result.scaledEquipmentCost
                - 1515716.5665103979
            ) < 1e-8
        )

        #expect(
            abs(
                result.targetUnitCapacityCost
                - 7578.5828325519897
            ) < 1e-10
        )

        #expect(
            abs(
                result.costSavingFractionVersusLinear
                - 0.24214171674480103
            ) < 1e-12
        )
    }

    @Test("Same capacity reproduces reference cost")
    func sameCapacity() throws {
        let result = try engine.calculate(
            .init(
                referenceEquipmentCost:
                    1_000_000,
                referenceCapacity: 100,
                targetCapacity: 100,
                scalingExponent: 0.6
            )
        )

        #expect(result.capacityRatio == 1)
        #expect(result.costRatio == 1)

        #expect(
            result.scaledEquipmentCost
            == 1_000_000
        )

        #expect(
            result.costSavingFractionVersusLinear
            == 0
        )
    }

    @Test("Rejects invalid scaling exponent")
    func validation() {
        #expect(
            throws:
                EquipmentCostScalingError
                    .scalingExponentOutOfRange
        ) {
            try engine.calculate(
                .init(
                    referenceEquipmentCost:
                        1_000_000,
                    referenceCapacity: 100,
                    targetCapacity: 200,
                    scalingExponent: 0
                )
            )
        }
    }
}
