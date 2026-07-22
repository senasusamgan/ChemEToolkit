import Foundation
struct NaturalCubicSplineInterpolationEngine {
 func solve(_ input:NaturalCubicSplineInterpolationInput)throws->NaturalCubicSplineInterpolationResult {
  let x=input.xValues,y=input.yValues,n=x.count; guard n>=2,y.count==n else{throw NaturalCubicSplineInterpolationError.invalidData}
  guard (x+y+[input.query]).allSatisfy(\.isFinite) else{throw NaturalCubicSplineInterpolationError.nonFiniteInput}
  for i in 1..<n where x[i]<=x[i-1]{throw NaturalCubicSplineInterpolationError.nonIncreasingX}; guard input.query>=x[0],input.query<=x[n-1] else{throw NaturalCubicSplineInterpolationError.queryOutOfRange}
  var second=Array(repeating:0.0,count:n)
  if n>2 { let count=n-2; var lower=Array(repeating:0.0,count:max(0,count-1)),diag=Array(repeating:0.0,count:count),upper=lower,rhs=diag
   for k in 0..<count { let i=k+1,h0=x[i]-x[i-1],h1=x[i+1]-x[i]; diag[k]=2*(h0+h1); rhs[k]=6*((y[i+1]-y[i])/h1-(y[i]-y[i-1])/h0); if k>0{lower[k-1]=h0}; if k+1<count{upper[k]=h1} }
   for i in 1..<count { let m=lower[i-1]/diag[i-1]; diag[i]-=m*upper[i-1]; rhs[i]-=m*rhs[i-1] }
   var sol=Array(repeating:0.0,count:count); sol[count-1]=rhs[count-1]/diag[count-1]; if count>1{for i in stride(from:count-2,through:0,by:-1){sol[i]=(rhs[i]-upper[i]*sol[i+1])/diag[i]}}
   for k in 0..<count{second[k+1]=sol[k]}
  }
  var i=n-2; for candidate in 0..<(n-1) where input.query<=x[candidate+1]{i=candidate;break}; let h=x[i+1]-x[i],a=(x[i+1]-input.query)/h,b=(input.query-x[i])/h
  let value=a*y[i]+b*y[i+1]+((a*a*a-a)*second[i]+(b*b*b-b)*second[i+1])*h*h/6
  let derivative=(y[i+1]-y[i])/h+h*((-3*a*a+1)*second[i]+(3*b*b-1)*second[i+1])/6
  return .init(value:value,firstDerivative:derivative,segmentIndex:i)
 }
}
