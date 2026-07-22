struct BETIsothermInput:
    Equatable,
    Sendable {

    let relativePressure: Double
    let monolayerCapacity: Double
    let betConstant: Double

    let adsorbateMolarMass: Double
    let molecularCrossSectionalArea:
        Double
}
