import Foundation

struct GrashofNumberEngine {

    func calculate(
        input: GrashofNumberInput
    ) throws -> GrashofNumberResult {

        try validate(input)

        let signedTemperatureDifference =
            input.surfaceTemperature
            - input.fluidTemperature

        let temperatureDifferenceMagnitude =
            abs(signedTemperatureDifference)

        let grashofNumber =
            input.gravitationalAcceleration
            * input.thermalExpansionCoefficient
            * temperatureDifferenceMagnitude
            * pow(input.characteristicLength, 3)
            / pow(input.kinematicViscosity, 2)

        return GrashofNumberResult(
            grashofNumber: grashofNumber,
            temperatureDifferenceMagnitude:
                temperatureDifferenceMagnitude,
            buoyancyDirection:
                direction(
                    for:
                        signedTemperatureDifference
                )
        )
    }

    private func direction(
        for temperatureDifference: Double
    ) -> NaturalConvectionBuoyancyDirection {

        if temperatureDifference > 0 {
            return .heatedSurface
        }

        if temperatureDifference < 0 {
            return .cooledSurface
        }

        return .noTemperatureDifference
    }

    private func validate(
        _ input: GrashofNumberInput
    ) throws {

        let values = [
            input.gravitationalAcceleration,
            input.thermalExpansionCoefficient,
            input.surfaceTemperature,
            input.fluidTemperature,
            input.characteristicLength,
            input.kinematicViscosity
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw GrashofNumberError.nonFiniteInput
        }

        guard input.gravitationalAcceleration > 0 else {
            throw GrashofNumberError
                .nonPositiveGravity
        }

        guard input.thermalExpansionCoefficient > 0 else {
            throw GrashofNumberError
                .nonPositiveThermalExpansionCoefficient
        }

        guard input.characteristicLength > 0 else {
            throw GrashofNumberError
                .nonPositiveCharacteristicLength
        }

        guard input.kinematicViscosity > 0 else {
            throw GrashofNumberError
                .nonPositiveKinematicViscosity
        }
    }
}
