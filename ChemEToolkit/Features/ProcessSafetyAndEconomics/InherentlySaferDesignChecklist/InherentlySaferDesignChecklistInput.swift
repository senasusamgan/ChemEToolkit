struct InherentlySaferDesignChecklistInput:
    Equatable,
    Sendable {

    let minimizeRating: Double
    let substituteRating: Double
    let moderateRating: Double
    let simplifyRating: Double

    let implementationConfidence:
        Double
}
