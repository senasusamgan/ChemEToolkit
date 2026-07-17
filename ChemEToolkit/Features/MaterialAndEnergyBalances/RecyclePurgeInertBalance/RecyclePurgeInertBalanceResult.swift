struct RecyclePurgeInertBalanceResult:
    Equatable,
    Sendable {

    let freshReactantFlow: Double
    let freshInertFlow: Double

    let recycleReactantFlow: Double
    let recycleInertFlow: Double
    let totalRecycleFlow: Double

    let reactorFeedFlow: Double
    let reactorFeedInertMassFraction:
        Double

    let purgeFlow: Double
    let purgeReactantFlow: Double
    let purgeInertFlow: Double

    let overallReactantConversion:
        Double

    let modelName: String
    let limitationDescription: String
}
