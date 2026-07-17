struct BLEVEFireballScreeningInput:
    Equatable,
    Sendable {

    let flammableMass: Double
    let heatOfCombustion: Double
    let radiantFraction: Double
    let atmosphericTransmissivity:
        Double
    let receptorDistance: Double
}
