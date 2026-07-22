import Foundation
import SwiftUI
struct NumericalJacobianView: View {
 @State private var output:String?
 @State private var errorText:String?
 var body:some View { ScrollView { VStack(alignment:.leading,spacing:16) {
  Text("Numerical Jacobian").font(.largeTitle.bold())
  Text("Central-difference Jacobian of a supported two-equation system.").foregroundStyle(.secondary)
  Button("Calculate Example"){calculate()}.buttonStyle(.borderedProminent)
  if let output{Text("Result: \(output)").font(.headline)}
  if let errorText{Text(errorText).foregroundStyle(.red)}
 }.padding() } }
 private func calculate(){do{let r=try NumericalJacobianEngine().solve(.init(system:.nonlinear,point:[1,2]));output=r.jacobian.map{$0.map{String(format:"%.6g",$0)}.joined(separator:", ")}.joined(separator:"; ");errorText=nil}catch{output=nil;errorText=error.localizedDescription}}
}
