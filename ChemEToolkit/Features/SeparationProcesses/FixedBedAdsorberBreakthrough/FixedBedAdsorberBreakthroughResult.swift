struct FixedBedAdsorberBreakthroughResult:
    Equatable,
    Sendable {

    let capacityTimeTerm:
        Double
    let kineticTimePenalty:
        Double
    let breakthroughTime:
        Double
    let breakthroughConcentration:
        Double
    let treatedBedVolumesIndex:
        Double

    let modelName: String
    let limitationDescription:
        String
}
