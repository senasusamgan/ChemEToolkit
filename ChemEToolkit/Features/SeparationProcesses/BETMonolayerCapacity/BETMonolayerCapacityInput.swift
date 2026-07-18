struct BETMonolayerCapacityInput:
    Equatable,
    Sendable {

    let relativePressure:
        Double
    let monolayerCapacity:
        Double
    let betConstant:
        Double
}
