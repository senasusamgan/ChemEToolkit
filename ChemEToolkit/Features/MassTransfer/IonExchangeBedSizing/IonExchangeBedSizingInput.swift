struct IonExchangeBedSizingInput:
    Equatable,
    Sendable {

    let liquidVolumetricFlowRate: Double
    let influentIonConcentration: Double
    let ionChargeMagnitude: Double

    let targetRemovalFraction: Double
    let serviceTime: Double

    let resinCapacity: Double
    let capacityUtilizationFraction: Double
}
