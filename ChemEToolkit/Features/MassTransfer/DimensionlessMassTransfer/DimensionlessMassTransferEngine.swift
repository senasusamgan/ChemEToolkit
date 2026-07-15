struct DimensionlessMassTransferEngine: Sendable {
    func calculate(_ input: DimensionlessMassTransferInput) throws -> DimensionlessMassTransferResult {
        let values = [
            input.density,
            input.dynamicViscosity,
            input.diffusivity,
            input.thermalDiffusivity,
            input.massTransferCoefficient,
            input.characteristicLength
        ]
        guard values.allSatisfy(\.isFinite) else {
            throw DimensionlessMassTransferError.nonFiniteInput
        }
        guard values.allSatisfy({ $0 > 0 }) else {
            throw DimensionlessMassTransferError.nonPositiveProperty
        }

        let kinematicViscosity = input.dynamicViscosity / input.density
        return DimensionlessMassTransferResult(
            schmidtNumber: kinematicViscosity / input.diffusivity,
            lewisNumber: input.thermalDiffusivity / input.diffusivity,
            sherwoodNumber: input.massTransferCoefficient
                * input.characteristicLength
                / input.diffusivity
        )
    }
}
