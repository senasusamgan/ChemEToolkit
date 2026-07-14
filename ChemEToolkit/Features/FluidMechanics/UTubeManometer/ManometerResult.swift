struct ManometerResult:
    Equatable,
    Sendable {

    let pressureDifference: Double
    let densityDifference: Double
    let heightDifference: Double
    let higherPressureSide:
        ManometerSide?

    var pressureDifferenceKilopascals:
        Double {
        pressureDifference / 1_000
    }

    var lowerPressureSide:
        ManometerSide? {

        higherPressureSide?.opposite
    }

    var pressuresAreEqual: Bool {
        higherPressureSide == nil
    }
}
