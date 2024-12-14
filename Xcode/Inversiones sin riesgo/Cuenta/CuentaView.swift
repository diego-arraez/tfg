//
//  CuentaView.swift
//  Inversiones sin riesgo
//
//  Created by Diego on 12/11/24.
//

import SwiftUI

struct CuentaView: View {
    
    @State var tabIndex = 0
    @State var usuario = UserDefaults.standard.string(forKey: "usuario")
    
    var body: some View {
        ZStack{
            NavigationView {
                VStack{
                    Spacer()
                    BarraSuperior(tabIndex: $tabIndex)
                    
                    if tabIndex == 0 {
                        Tab1()
                    }
                    else if tabIndex == 1 {
                        Tab2()
                    }
                    else if tabIndex == 2 {
                        Tab3()
                    }

                    Spacer()
                }
                .frame(width: UIScreen.main.bounds.width, alignment: .center)
                .padding(.horizontal, 12)
                .navigationTitle("¡Hola \(usuario ?? "")! 😊")
                .navigationBarTitleDisplayMode(.inline)
                .background(Color("fondoLista"))
            }.onAppear{ tabIndex = 0 }
            
        }
    }
}

struct Tab1: View {
    var body: some View {
        AjustesView()
    }
}

struct Tab2: View {
    var body: some View {
        ComprasView()
    }
}

struct Tab3: View {
    var body: some View {
        VentasView()
    }
}

struct BarraSuperior: View {
    @Binding var tabIndex: Int
    var body: some View {
        HStack(spacing: 20) {
            TabBarButton(text: "Ajustes", isSelected: .constant(tabIndex == 0))
                .onTapGesture { onButtonTapped(index: 0) }
                .foregroundColor(Color("grisOscuro"))
            TabBarButton(text: "Compras", isSelected: .constant(tabIndex == 1))
                .onTapGesture { onButtonTapped(index: 1) }
                .foregroundColor(Color("grisOscuro"))
            TabBarButton(text: "Ventas", isSelected: .constant(tabIndex == 2))
                .onTapGesture { onButtonTapped(index: 2) }
                .foregroundColor(Color("grisOscuro"))
            
            Spacer()
        }
        .border(width: 1, edges: [.bottom], color: Color("grisClaro"))
        .frame(width: UIScreen.main.bounds.width - 36, alignment: .center)
    }
    
    private func onButtonTapped(index: Int) {
        
            tabIndex = index
    }
}

struct TabBarButton: View {
    let text: String
    @Binding var isSelected: Bool
    var body: some View {
        Text(text)
            .fontWeight(isSelected ? .heavy : .regular)
            .font(.system(size: 14))
            .padding(.bottom, 10)
            .border(width: isSelected ? 2 : 1, edges: [.bottom], color: Color("grisClaro"))
    }
}

struct EdgeBorder: Shape {

    var width: CGFloat
    var edges: [Edge]

    func path(in rect: CGRect) -> Path {
        var path = Path()
        for edge in edges {
            var x: CGFloat {
                switch edge {
                case .top, .bottom, .leading: return rect.minX
                case .trailing: return rect.maxX - width
                }
            }

            var y: CGFloat {
                switch edge {
                case .top, .leading, .trailing: return rect.minY
                case .bottom: return rect.maxY - width
                }
            }

            var w: CGFloat {
                switch edge {
                case .top, .bottom: return rect.width
                case .leading, .trailing: return self.width
                }
            }

            var h: CGFloat {
                switch edge {
                case .top, .bottom: return self.width
                case .leading, .trailing: return rect.height
                }
            }
            path.addPath(Path(CGRect(x: x, y: y, width: w, height: h)))
        }
        return path
    }
}

extension View {
    func border(width: CGFloat, edges: [Edge], color: SwiftUI.Color) -> some View {
        overlay(EdgeBorder(width: width, edges: edges).foregroundColor(color))
    }
}
