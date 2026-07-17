struct ClosedSystemFirstLawEngine: Sendable {
    func calculate(_ input: ClosedSystemFirstLawInput) throws -> ClosedSystemFirstLawResult {
        let values = [input.heatToSystem, input.workBySystem, input.kineticEnergyChange, input.potentialEnergyChange]
        guard values.allSatisfy(\.isFinite) else { throw ClosedSystemFirstLawError.nonFiniteInput }
        let net = input.heatToSystem - input.workBySystem
        let mechanical = input.kineticEnergyChange + input.potentialEnergyChange
        let deltaU = net - mechanical
        let total = deltaU + mechanical
        guard [net, mechanical, deltaU, total].allSatisfy(\.isFinite) else { throw ClosedSystemFirstLawError.numericalFailure }
        let direction = total > 0 ? "Stored energy increases" : (total < 0 ? "Stored energy decreases" : "No net stored-energy change")
        return .init(netEnergyTransfer: net, internalEnergyChange: deltaU, mechanicalEnergyChange: mechanical, totalStoredEnergyChange: total, directionDescription: direction, modelName: "Closed-system first-law balance", limitationDescription: "Uses ΔU + ΔKE + ΔPE = Q − W, with heat positive into the system and work positive when done by the system.")
    }
}
