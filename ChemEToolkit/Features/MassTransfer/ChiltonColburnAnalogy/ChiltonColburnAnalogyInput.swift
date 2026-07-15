struct ChiltonColburnAnalogyInput:
    Equatable,
    Sendable {

    let fanningFrictionFactor: Double
    let reynoldsNumber: Double
    let schmidtNumber: Double
    let averageVelocity: Double
}
