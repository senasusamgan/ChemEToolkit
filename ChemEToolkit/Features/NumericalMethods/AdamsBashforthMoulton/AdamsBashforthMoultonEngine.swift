import Foundation
struct AdamsBashforthMoultonEngine{
 func solve(_ input:AdamsBashforthMoultonInput)throws->AdamsBashforthMoultonResult{let raw=[input.initialX,input.initialY,input.finalX,input.stepSize];guard raw.allSatisfy(\.isFinite)else{throw AdamsBashforthMoultonError.nonFiniteInput};guard input.finalX>input.initialX else{throw AdamsBashforthMoultonError.invalidInterval};guard input.stepSize>0 else{throw AdamsBashforthMoultonError.invalidStep};let steps=Int(ceil((input.finalX-input.initialX)/input.stepSize));guard steps>=4 else{throw AdamsBashforthMoultonError.insufficientSteps};let h=(input.finalX-input.initialX)/Double(steps)
  func f(_ x:Double,_ y:Double)->Double{switch input.equation{case .exponentialGrowth:return y;case .linearForcing:return x-y}}
  func rk4(_ x:Double,_ y:Double)->Double{let k1=f(x,y),k2=f(x+h/2,y+h*k1/2),k3=f(x+h/2,y+h*k2/2),k4=f(x+h,y+h*k3);return y+h*(k1+2*k2+2*k3+k4)/6}
  var xs=[input.initialX],ys=[input.initialY];for _ in 0..<3{ys.append(rk4(xs.last!,ys.last!));xs.append(xs.last!+h)}
  if steps>=4{for n in 3..<steps{let fn=f(xs[n],ys[n]),fn1=f(xs[n-1],ys[n-1]),fn2=f(xs[n-2],ys[n-2]),fn3=f(xs[n-3],ys[n-3]);let nextX=input.initialX+Double(n+1)*h;let predicted=ys[n]+h*(55*fn-59*fn1+37*fn2-9*fn3)/24;let corrected=ys[n]+h*(9*f(nextX,predicted)+19*fn-5*fn1+fn2)/24;xs.append(nextX);ys.append(corrected)}}
  return .init(xValues:xs,yValues:ys,stepSize:h,finalValue:ys.last!)
 }
}
