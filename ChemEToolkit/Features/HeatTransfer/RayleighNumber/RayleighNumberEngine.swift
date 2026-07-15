import Foundation

struct RayleighNumberEngine {

    func calculate(
        input: RayleighNumberInput
    ) throws -> RayleighNumberResult {

        try validate(input)

        return RayleighNumberResult(
            rayleighNumber:
                input.grashofNumber
                * input.prandtlNumber,
            grashofNumber:
                input.grashofNumber,
            prandtlNumber:
                input.prandtlNumber
        )
    }

    private func validate(
        _ input: RayleighNumberInput
    ) throws {

        let values = [
            input.grashofNumber,
            input.prandtlNumber
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw RayleighNumberError.nonFiniteInput
        }

        guard input.grashofNumber >= 0 else {
            throw RayleighNumberError
                .negativeGrashofNumber
        }

        guard input.prandtlNumber > 0 else {
            throw RayleighNumberError
                .nonPositivePrandtlNumber
        }
    }
}
