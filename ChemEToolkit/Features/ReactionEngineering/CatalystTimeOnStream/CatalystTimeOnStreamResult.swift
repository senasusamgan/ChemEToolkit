struct CatalystTimeOnStreamResult:
    Equatable,
    Sendable {

    let freshPFRConversion: Double
    let freshCSTRConversion: Double

    let requiredPFRActivity:
        Double
    let requiredCSTRActivity:
        Double

    let pfrTimeOnStreamLimit:
        Double
    let cstrTimeOnStreamLimit:
        Double

    let catalystActivityHalfLife:
        Double
    let limitingReactorDescription:
        String

    let modelName: String
    let limitationDescription: String
}
