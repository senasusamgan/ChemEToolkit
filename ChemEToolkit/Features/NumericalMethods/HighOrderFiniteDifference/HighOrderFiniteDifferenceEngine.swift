import Foundation
struct HighOrderFiniteDifferenceEngine {
 func solve(_ input: HighOrderFiniteDifferenceInput) throws -> HighOrderFiniteDifferenceResult {
  guard input.point.isFinite, input.step.isFinite else { throw HighOrderFiniteDifferenceError.nonFiniteInput }
  guard input.step > 0 else { throw HighOrderFiniteDifferenceError.invalidStep }
  func f(_ x: Double) -> Double { switch input.function { case .cubic: return x*x*x - 2*x + 1; case .exponential: return exp(x); case .sine: return sin(x) } }
  let x=input.point, h=input.step, fm2=f(x-2*h), fm1=f(x-h), f0=f(x), fp1=f(x+h), fp2=f(x+2*h)
  let first=(fm2-8*fm1+8*fp1-fp2)/(12*h)
  let second=(-fp2+16*fp1-30*f0+16*fm1-fm2)/(12*h*h)
  guard first.isFinite, second.isFinite else { throw HighOrderFiniteDifferenceError.nonFiniteInput }
  return .init(firstDerivative:first, secondDerivative:second, step:h)
 }
}
