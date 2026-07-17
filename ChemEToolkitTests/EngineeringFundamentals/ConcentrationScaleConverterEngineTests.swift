import Testing
@testable import ChemEToolkit

@Suite("Concentration Scale Converter Engine")
struct ConcentrationScaleConverterEngineTests {
    private let engine =
        ConcentrationScaleConverterEngine()

    @Test("Converts ppm to percent and ppb")
    func ppmConversion() throws {
        let result = try engine.calculate(
            .init(
                enteredValue: 2500,
                inputScaleCode: 2
            )
        )

        #expect(result.inputScaleName == "ppm")
        #expect(result.dimensionlessFraction == 0.0025)
        #expect(result.percent == 0.25)
        #expect(result.partsPerMillion == 2500)
        #expect(result.partsPerBillion == 2_500_000)
    }

    @Test("Converts percent to ppm")
    func percentConversion() throws {
        let result = try engine.calculate(
            .init(
                enteredValue: 1,
                inputScaleCode: 1
            )
        )

        #expect(result.dimensionlessFraction == 0.01)
        #expect(result.partsPerMillion == 10_000)
    }

    @Test("Rejects invalid scale code")
    func validation() {
        #expect(
            throws:
                ConcentrationScaleConverterError
                    .invalidScaleCode
        ) {
            try engine.calculate(
                .init(
                    enteredValue: 1,
                    inputScaleCode: 4
                )
            )
        }
    }
}
