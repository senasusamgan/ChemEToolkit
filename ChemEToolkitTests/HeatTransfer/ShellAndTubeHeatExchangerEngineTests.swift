import Foundation
import Testing
@testable import ChemEToolkit

@Suite("Shell-and-Tube Heat Exchanger Engine")
struct ShellAndTubeHeatExchangerEngineTests {

    private let engine =
        ShellAndTubeHeatExchangerEngine()

    private let tolerance =
        0.000001

    @Test(
        "Rounds tube count to a complete pass arrangement"
    )
    func calculatesRoundedTubeCount()
        throws {

        let input =
            ShellAndTubeHeatExchangerInput(
                hotInletTemperature: 100,
                hotOutletTemperature: 80,
                coldInletTemperature: 20,
                coldOutletTemperature: 40,
                requiredHeatTransferRate: 12_000,
                overallHeatTransferCoefficient: 100,
                correctionFactor: 1,
                tubeOuterDiameter: 0.05,
                tubeLength: 2,
                numberOfTubePasses: 2
            )

        let result =
            try engine.calculate(input: input)

        #expect(
            abs(
                result.requiredHeatTransferArea
                - 2
            ) < tolerance
        )

        #expect(
            abs(
                result.heatTransferAreaPerTube
                - 0.3141592653589793
            ) < tolerance
        )

        #expect(
            abs(
                result.exactTubeCount
                - 6.366197723675814
            ) < tolerance
        )

        #expect(result.selectedTubeCount == 8)
        #expect(result.tubesPerPass == 4)

        #expect(
            abs(
                result.providedHeatTransferArea
                - 2.5132741228718345
            ) < tolerance
        )
    }

    @Test(
        "Calculates preliminary industrial tube bundle"
    )
    func calculatesIndustrialBundle()
        throws {

        let input =
            ShellAndTubeHeatExchangerInput(
                hotInletTemperature: 150,
                hotOutletTemperature: 90,
                coldInletTemperature: 30,
                coldOutletTemperature: 70,
                requiredHeatTransferRate: 500_000,
                overallHeatTransferCoefficient: 500,
                correctionFactor: 0.95,
                tubeOuterDiameter: 0.025,
                tubeLength: 5,
                numberOfTubePasses: 4
            )

        let result =
            try engine.calculate(input: input)

        #expect(
            abs(
                result.requiredHeatTransferArea
                - 15.141161707988466
            ) < tolerance
        )

        #expect(result.selectedTubeCount == 40)
        #expect(result.tubesPerPass == 10)

        #expect(
            abs(
                result.providedHeatTransferArea
                - 15.707963267948966
            ) < tolerance
        )

        #expect(
            result.providedHeatTransferRate
                >= 500_000
        )
    }

    @Test(
        "Rejects invalid shell-and-tube design inputs"
    )
    func rejectsInvalidInputs() {

        #expect(
            throws:
                ShellAndTubeHeatExchangerError
                    .nonPositiveTubeLength
        ) {
            try engine.calculate(
                input:
                    ShellAndTubeHeatExchangerInput(
                        hotInletTemperature: 100,
                        hotOutletTemperature: 80,
                        coldInletTemperature: 20,
                        coldOutletTemperature: 40,
                        requiredHeatTransferRate: 12_000,
                        overallHeatTransferCoefficient: 100,
                        correctionFactor: 1,
                        tubeOuterDiameter: 0.05,
                        tubeLength: 0,
                        numberOfTubePasses: 2
                    )
            )
        }

        #expect(
            throws:
                ShellAndTubeHeatExchangerError
                    .nonPositiveTubePassCount
        ) {
            try engine.calculate(
                input:
                    ShellAndTubeHeatExchangerInput(
                        hotInletTemperature: 100,
                        hotOutletTemperature: 80,
                        coldInletTemperature: 20,
                        coldOutletTemperature: 40,
                        requiredHeatTransferRate: 12_000,
                        overallHeatTransferCoefficient: 100,
                        correctionFactor: 1,
                        tubeOuterDiameter: 0.05,
                        tubeLength: 2,
                        numberOfTubePasses: 0
                    )
            )
        }

        #expect(
            throws:
                ShellAndTubeHeatExchangerError
                    .invalidCorrectionFactor
        ) {
            try engine.calculate(
                input:
                    ShellAndTubeHeatExchangerInput(
                        hotInletTemperature: 100,
                        hotOutletTemperature: 80,
                        coldInletTemperature: 20,
                        coldOutletTemperature: 40,
                        requiredHeatTransferRate: 12_000,
                        overallHeatTransferCoefficient: 100,
                        correctionFactor: 1.2,
                        tubeOuterDiameter: 0.05,
                        tubeLength: 2,
                        numberOfTubePasses: 2
                    )
            )
        }
    }
}
