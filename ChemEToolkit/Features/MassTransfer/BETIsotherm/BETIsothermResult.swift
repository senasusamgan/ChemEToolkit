enum BETPressureRegion:
    String,
    Equatable,
    Sendable {

    case belowRecommendedLinearRange
    case recommendedLinearRange
    case aboveRecommendedLinearRange

    var title: String {
        switch self {
        case .belowRecommendedLinearRange:
            return "Below recommended BET linear range"

        case .recommendedLinearRange:
            return "Within recommended BET linear range"

        case .aboveRecommendedLinearRange:
            return "Above recommended BET linear range"
        }
    }
}

struct BETIsothermResult:
    Equatable,
    Sendable {

    let pressureRegion: BETPressureRegion

    let equilibriumLoading: Double
    let monolayerFraction: Double
    let adsorbedMassPerAdsorbentMass:
        Double

    let betTransformOrdinate: Double
    let theoreticalBETIntercept: Double
    let theoreticalBETSlope: Double

    let monolayerAdsorbedMass:
        Double
    let specificSurfaceArea: Double

    let regionDescription: String
    let modelName: String
    let limitationDescription: String
}
