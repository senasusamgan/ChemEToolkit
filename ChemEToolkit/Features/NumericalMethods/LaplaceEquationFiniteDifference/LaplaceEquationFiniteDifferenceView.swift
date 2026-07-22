import Foundation
import SwiftUI
struct LaplaceEquationFiniteDifferenceView: View {
 @State private var output:String?
 @State private var errorText:String?
 var body:some View { ScrollView { VStack(alignment:.leading,spacing:16) {
  Text("Laplace Equation Finite Difference").font(.largeTitle.bold())
  Text("Steady source-free rectangular field with constant edge values.").foregroundStyle(.secondary)
  Button("Calculate Example"){calculate()}.buttonStyle(.borderedProminent)
  if let output{Text("Result: \(output)").font(.headline)}
  if let errorText{Text(errorText).foregroundStyle(.red)}
 }.padding() } }
 private func calculate(){do{let r=try LaplaceEquationFiniteDifferenceEngine().solve(.init(rows:11,columns:11,topBoundary:100,bottomBoundary:0,leftBoundary:0,rightBoundary:0));output=String(format:"Center %.6g",r.field[5][5]);errorText=nil}catch{output=nil;errorText=error.localizedDescription}}
}
