struct IonExchangeBedSizingResult:
    Equatable,
    Sendable {

    let ionChargeMagnitude: Int
    let treatedLiquidVolume: Double

    let totalEquivalentLoad: Double
    let removedEquivalentLoad: Double
    let residualEquivalentLoad: Double

    let usableResinCapacity: Double
    let requiredResinVolumeLiters: Double
    let requiredResinVolumeCubicMeters: Double

    let outletIonConcentration: Double
    let emptyBedContactTimeMinutes: Double
    let processedBedVolumes: Double

    let modelName: String
    let limitationDescription: String
}
