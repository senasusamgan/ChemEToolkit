struct MassTransferCoefficientEngine: Sendable {
    func calculate(_ input: MassTransferCoefficientInput) throws -> MassTransferCoefficientResult {
        let values = [
            input.massTransferCoefficient,
            input.bulkConcentration,
            input.interfaceConcentration,
            input.area
        ]
        guard values.allSatisfy(\.isFinite) else {
            throw MassTransferCoefficientError.nonFiniteInput
        }
        guard input.massTransferCoefficient > 0, input.area > 0 else {
            throw MassTransferCoefficientError.nonPositiveCoefficientOrArea
        }
        guard input.bulkConcentration >= 0, input.interfaceConcentration >= 0 else {
            throw MassTransferCoefficientError.negativeConcentration
        }

        let drivingForce = input.bulkConcentration - input.interfaceConcentration
        let flux = input.massTransferCoefficient * drivingForce

        return MassTransferCoefficientResult(
            molarFlux: flux,
            molarRate: flux * input.area,
            drivingForce: drivingForce
        )
    }
}
