struct MIMODecouplingControlInput:
    Equatable,
    Sendable {

    let gain11: Double
    let gain12: Double
    let gain21: Double
    let gain22: Double
}
