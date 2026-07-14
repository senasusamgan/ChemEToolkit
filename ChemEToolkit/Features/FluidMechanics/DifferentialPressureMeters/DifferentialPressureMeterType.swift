enum DifferentialPressureMeterType:
    String,
    CaseIterable,
    Identifiable,
    Equatable,
    Sendable {

    case venturi
    case orifice

    var id: Self {
        self
    }
}
