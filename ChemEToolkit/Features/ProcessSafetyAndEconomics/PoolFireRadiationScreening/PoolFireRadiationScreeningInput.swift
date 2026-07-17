struct PoolFireRadiationScreeningInput:
    Equatable,
    Sendable {

    let burningMassRate: Double
    let heatOfCombustion: Double
    let radiantFraction: Double
    let atmosphericTransmissivity:
        Double
    let receptorDistance: Double
}
