struct ClosedSystemFirstLawResult: Equatable, Sendable {
    let netEnergyTransfer: Double
    let internalEnergyChange: Double
    let mechanicalEnergyChange: Double
    let totalStoredEnergyChange: Double
    let directionDescription: String
    let modelName: String
    let limitationDescription: String
}
