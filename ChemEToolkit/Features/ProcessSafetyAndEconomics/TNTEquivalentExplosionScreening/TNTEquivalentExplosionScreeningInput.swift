struct TNTEquivalentExplosionScreeningInput:
    Equatable,
    Sendable {

    let flammableMass: Double
    let heatOfCombustion: Double
    let explosionEfficiency: Double
    let receptorDistance: Double
}
