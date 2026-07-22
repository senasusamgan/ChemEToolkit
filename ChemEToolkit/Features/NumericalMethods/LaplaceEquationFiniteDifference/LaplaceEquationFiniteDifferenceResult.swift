struct LaplaceEquationFiniteDifferenceResult:Equatable,Sendable{let field:[[Double]];let iterations:Int;let maximumChange:Double;let converged:Bool}
