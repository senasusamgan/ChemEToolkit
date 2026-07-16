struct OverrideSelectiveControlResult:
    Equatable,
    Sendable {

    let selectedRawOutput: Double
    let finalOutput: Double

    let selectedControllerDescription:
        String
    let constraintHasOverride:
        Bool

    let controllerSeparation:
        Double
    let finalOutputWasLimited:
        Bool

    let modelName: String
    let limitationDescription: String
}
