import Foundation
struct RiddersRootFinderEngine{
 func solve(_ input:RiddersRootFinderInput)throws->RiddersRootFinderResult{guard input.lowerBound.isFinite,input.upperBound.isFinite,input.lowerBound<input.upperBound else{throw RiddersRootFinderError.invalidBounds};guard input.tolerance.isFinite,input.tolerance>0,input.maximumIterations>0 else{throw RiddersRootFinderError.invalidControls}
  func f(_ x:Double)->Double{switch input.function{case .cubic:return x*x*x-x-2;case .exponentialBalance:return exp(-x)-x}}
  var a=input.lowerBound,b=input.upperBound,fa=f(a),fb=f(b);if fa==0{return .init(root:a,functionValue:fa,iterations:0,finalBracketWidth:b-a)};if fb==0{return .init(root:b,functionValue:fb,iterations:0,finalBracketWidth:b-a)};guard fa*fb<0 else{throw RiddersRootFinderError.rootNotBracketed}
  for iteration in 1...input.maximumIterations{let m=(a+b)/2,fm=f(m),disc=fm*fm-fa*fb;guard disc>0 else{throw RiddersRootFinderError.numericalBreakdown};let sign=fa>=fb ? 1.0:-1.0;let x=m+(m-a)*sign*fm/sqrt(disc),fx=f(x);if abs(fx)<=input.tolerance{return .init(root:x,functionValue:fx,iterations:iteration,finalBracketWidth:abs(b-a))}
   if fm*fx<0{a=m;fa=fm;b=x;fb=fx}else if fa*fx<0{b=x;fb=fx}else{a=x;fa=fx};if a>b{swap(&a,&b);swap(&fa,&fb)};if abs(b-a)<=input.tolerance{return .init(root:(a+b)/2,functionValue:f((a+b)/2),iterations:iteration,finalBracketWidth:abs(b-a))}
  };throw RiddersRootFinderError.didNotConverge
 }
}
