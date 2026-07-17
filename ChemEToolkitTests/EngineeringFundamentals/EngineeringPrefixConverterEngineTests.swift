import Testing
@testable import ChemEToolkit

@Suite("Engineering Prefix Converter Engine")
struct EngineeringPrefixConverterEngineTests {
    private let engine =
        EngineeringPrefixConverterEngine()

    @Test("Converts mega units to kilo units")
    func megaToKilo() throws {
        let result = try engine.calculate(
            .init(
                enteredValue: 2.5,
                inputPowerOfTen: 6,
                outputPowerOfTen: 3
            )
        )

        #expect(result.convertedValue == 2500)
        #expect(result.conversionFactor == 1000)
        #expect(result.inputPrefixName == "mega")
        #expect(result.outputPrefixName == "kilo")
    }

    @Test("Converts milli units to base units")
    func milliToBase() throws {
        let result = try engine.calculate(
            .init(
                enteredValue: 500,
                inputPowerOfTen: -3,
                outputPowerOfTen: 0
            )
        )

        #expect(result.convertedValue == 0.5)
    }

    @Test("Rejects nonengineering exponent")
    func validation() {
        #expect(
            throws:
                EngineeringPrefixConverterError
                    .invalidPowerOfTen
        ) {
            try engine.calculate(
                .init(
                    enteredValue: 1,
                    inputPowerOfTen: 2,
                    outputPowerOfTen: 0
                )
            )
        }
    }
}
