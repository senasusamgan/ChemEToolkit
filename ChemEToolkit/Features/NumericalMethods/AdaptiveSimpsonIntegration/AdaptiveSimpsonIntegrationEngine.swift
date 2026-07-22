import Foundation
struct AdaptiveSimpsonIntegrationEngine {
 func solve(_ input: AdaptiveSimpsonIntegrationInput) throws -> AdaptiveSimpsonIntegrationResult {
  guard input.lowerBound.isFinite, input.upperBound.isFinite, input.lowerBound != input.upperBound else { throw AdaptiveSimpsonIntegrationError.invalidBounds }
  guard input.tolerance.isFinite, input.tolerance > 0, input.maximumDepth > 0 else { throw AdaptiveSimpsonIntegrationError.invalidControls }
  func f(_ x: Double) -> Double { switch input.function { case .square: return x*x; case .exponentialDecay: return exp(-x); case .gaussian: return exp(-x*x) } }
  func simpson(_ a: Double,_ b: Double,_ fa: Double,_ fm: Double,_ fb: Double) -> Double { (b-a)*(fa+4*fm+fb)/6 }
  let a=input.lowerBound, b=input.upperBound, m=(a+b)/2, fa=f(a), fm=f(m), fb=f(b), whole=simpson(a,b,fa,fm,fb)
  var evaluations=3
  func recurse(_ a: Double,_ b: Double,_ fa: Double,_ fm: Double,_ fb: Double,_ whole: Double,_ tolerance: Double,_ depth: Int) throws -> (Double,Double) {
   let m=(a+b)/2, lm=(a+m)/2, rm=(m+b)/2, fl=f(lm), fr=f(rm); evaluations += 2
   let left=simpson(a,m,fa,fl,fm), right=simpson(m,b,fm,fr,fb), delta=left+right-whole
   if abs(delta) <= 15*tolerance { return (left+right+delta/15, abs(delta)/15) }
   guard depth < input.maximumDepth else { throw AdaptiveSimpsonIntegrationError.maximumDepthReached }
   let l=try recurse(a,m,fa,fl,fm,left,tolerance/2,depth+1), r=try recurse(m,b,fm,fr,fb,right,tolerance/2,depth+1)
   return (l.0+r.0,l.1+r.1)
  }
  let answer=try recurse(a,b,fa,fm,fb,whole,input.tolerance,0)
  return .init(integral: answer.0, estimatedError: answer.1, functionEvaluations: evaluations)
 }
}
