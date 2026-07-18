struct IdealGasMembraneStageCutInput:
    Equatable,
    Sendable {

    let feedMolarFlow: Double
    let feedFastComponentFraction: Double
    let stageCut: Double
    let idealSelectivity: Double
}
