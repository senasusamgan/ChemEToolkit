enum ManometerSide:
    String,
    CaseIterable,
    Identifiable,
    Equatable,
    Sendable {

    case left
    case right

    var id: Self {
        self
    }

    var title: String {
        switch self {
        case .left:
            return "Left"

        case .right:
            return "Right"
        }
    }

    var opposite: ManometerSide {
        switch self {
        case .left:
            return .right

        case .right:
            return .left
        }
    }
}
