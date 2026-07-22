struct NumericalJacobianResult: Equatable, Sendable { let values: [Double]; let jacobian: [[Double]]; let step: Double }
