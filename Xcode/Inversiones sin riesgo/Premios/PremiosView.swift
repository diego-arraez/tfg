//
//  PremiosView.swift
//  Inversiones sin riesgo
//
//  Created by Diego on 21/10/24.
//

import SwiftUI

struct PremiosView: View {
      
    @State var tabIndex = 0
    
    //JSON LOCAL
    let menu = Bundle.main.decode([PremiosMenuSection].self, from: "premios.json")
    
    @State private var premiosDisponibles = ""
    @State private var premiosCanjeados = ""
    
    @State private var valorId = ""
    @State private var cobreCanjeado = ""
    @State private var plataCanjeado = ""
    @State private var oroCanjeado = ""
    @State private var diamanteCanjeado = ""
    
    @State private var mostrarLoading1 = true
    @State private var mostrarLoading2 = true
    @State private var mostrarLoading3 = true
    
    @State private var sinPremios = "Sin premios"
        
    @State private var charPremiosDisp = [Character]()
    @State private var charPremiosCanj = [Character]()
    
    @State private var canjeado = false
    @State private var disponible = false
    
    
    //JOSN REMOTO
    @StateObject var viewModel: PremiosViewModel = PremiosViewModel()
    @State var usuario = UserDefaults.standard.string(forKey: "usuario")
        
    @State private var mostrarAviso = false
    
    var body: some View {
        
        ZStack{
            NavigationView {
                VStack{
                    Spacer()
                    PremiosTopTabBar(tabIndex: $tabIndex)
                    
                    if tabIndex == 0 { //Disponibles
                        
                        NavigationStack {
                            Form {
                                
                                if mostrarLoading1 {
                                    ProgressView()
                                        .progressViewStyle(.circular)
                                }
                                
                                
                                if menu.flatMap(\.premios).contains(where: { item in
                                    charPremiosDisp.contains(item.id) && !charPremiosCanj.contains(item.id)
                                }) {
                                    
                                    ForEach(menu) { section in
                                        
                                        ForEach(section.premios.filter { item in
                                            return charPremiosDisp.contains(item.id) && !charPremiosCanj.contains(item.id)
                                        }) { item in
                                            
                                            HStack {
                                                
                                                Text("")
                                                //CREADO PARA AUMENTAR EL TAMAÑO DE LA FILA
                                                    .frame(width: 0.0, height: 40.0)
                                                
                                                HStack {
                                                    
                                                    Button {
                                                        if charPremiosDisp.contains(item.id) {
                                                            valorId = item.id
                                                            
                                                            if item.premioCobre > 0 {
                                                                cobreCanjeado = "🟤 \(item.premioCobre) unidades de cobre\n"
                                                                
                                                            } else { cobreCanjeado = "" }
                                                            
                                                            if item.premioPlata > 0 {
                                                                plataCanjeado = "\n⚪️ \(item.premioPlata) unidades de plata\n"
                                                            } else { plataCanjeado = "" }
                                                            
                                                            if item.premioOro > 0 {
                                                                oroCanjeado = "\n🟡 \(item.premioOro) unidades de oro\n"
                                                            } else { oroCanjeado = "" }
                                                            
                                                            if item.premioDiamante > 0 {
                                                                diamanteCanjeado = "\n💎 \(item.premioDiamante) unidades de diamante\n"
                                                            } else { diamanteCanjeado = "" }
                                                            
                                                            if item.id == "A" {
                                                                UserDefaults.standard.set(false, forKey: "bienvenida")
                                                            }
                                                            
                                                            
                                                            viewModel.getPremios(username: usuario ?? "", tipoPremio: "c", premioCanjeado: valorId) { premiosDisp, premiosCanj in
                                                                
                                                                
                                                                premiosDisponibles = premiosDisp
                                                                charPremiosDisp = Array(premiosDisponibles)
                                                                
                                                                premiosCanjeados = premiosCanj
                                                                charPremiosCanj = Array(premiosCanjeados)
                                                                
                                                            }
                                                            
                                                            
                                                            mostrarAviso = true
                                                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                                                mostrarAviso = false
                                                            }
                                                        }
                                                        
                                                    } label: {
                                                        
                                                        HStack {
                                                            
                                                            
                                                            
                                                            Text(item.descripcion)
                                                            //.font(.headline)
                                                                .foregroundStyle(Color.black)
                                                            
                                                            
                                                            Spacer()
                                                            
                                                            
                                                            
                                                            HStack{
                                                                
                                                                if item.premioCobre != 0 {
                                                                    Text("\(item.premioCobre)")
                                                                        .font(.caption)
                                                                        .fontWeight(.black)
                                                                        .frame(width: 20.0, height: 20.0)
                                                                        .padding(2)
                                                                        .background(
                                                                            AngularGradient(
                                                                                colors: [Color("cobre1"), Color("cobre2"), Color("cobre1"), Color("cobre2"), Color("cobre1")], // Color marrón-naranja
                                                                                center: .center,
                                                                                startAngle: .degrees(90),
                                                                                endAngle: .degrees(360)
                                                                            )
                                                                        )
                                                                        .clipShape(RoundedRectangle(cornerRadius: 25))
                                                                        .foregroundColor(Color.white)
                                                                        .opacity(1.0)
                                                                }
                                                                
                                                                if item.premioPlata != 0 {
                                                                    Text("\(item.premioPlata)")
                                                                        .font(.caption)
                                                                        .fontWeight(.black)
                                                                        .frame(width: 20.0, height: 20.0)
                                                                        .padding(2)
                                                                        .background(AngularGradient(colors: [.gray, Color("plata"), .gray, Color("plata"), .gray],
                                                                                                    center: .center,
                                                                                                    startAngle: .degrees(90),
                                                                                                    endAngle: .degrees(360)))
                                                                        .clipShape(RoundedRectangle(cornerRadius: 25))
                                                                        .foregroundColor(Color.white)
                                                                        .opacity(1.0)
                                                                }
                                                                
                                                                if item.premioOro != 0 {
                                                                    Text("\(item.premioOro)")
                                                                        .font(.caption)
                                                                        .fontWeight(.black)
                                                                        .frame(width: 20.0, height: 20.0)
                                                                        .padding(2)
                                                                        .background(AngularGradient(colors: [.yellow, .brown, .yellow, .brown, .yellow],
                                                                                                    center: .center,
                                                                                                    startAngle: .degrees(90),
                                                                                                    endAngle: .degrees(360)))
                                                                        .clipShape(RoundedRectangle(cornerRadius: 25))
                                                                        .foregroundColor(Color.white)
                                                                        .opacity(1.0)
                                                                }
                                                                
                                                                if item.premioDiamante != 0 {
                                                                    Text("\(item.premioDiamante)")
                                                                        .font(.caption)
                                                                        .fontWeight(.black)
                                                                        .frame(width: 20.0, height: 20.0)
                                                                        .padding(1)
                                                                        .background(AngularGradient(colors: [Color("diamante"), .blue, Color("diamante"), .blue, Color("diamante")],
                                                                                                    center: .center,
                                                                                                    startAngle: .degrees(90),
                                                                                                    endAngle: .degrees(360)))
                                                                        .clipShape(RoundedRectangle(cornerRadius: 25))
                                                                        .foregroundColor(Color.white)
                                                                        .opacity(1.0)
                                                                }
                                                                
                                                                
                                                                
                                                            }
                                                            
                                                            
                                                            
                                                            
                                                            
                                                        }
                                                        
                                                    }
                                                }
                                                
                                            }//HSTACK
                                            
                                            
                                        }
                                        
                                        
                                    }
                                } else {
                                    
                                    Text("Sin premios disponibles")
                                    
                                }
                            }.onAppear { mostrarLoading1 = false }
                                .background(Color("fondoLista"))

                            
                        }.onAppear {
                            viewModel.getPremios(username: usuario ?? "", tipoPremio: "", premioCanjeado: "") { premiosDisp, premiosCanj in
                                premiosDisponibles = premiosDisp
                                charPremiosDisp = Array(premiosDisponibles)
                                
                                premiosCanjeados = premiosCanj
                                charPremiosCanj = Array(premiosCanjeados)
                            }
                        }
                        .refreshable { // Esto se ejecutará cuando el usuario realice un gesto de "pull to refresh"
                            viewModel.getPremios(username: usuario ?? "", tipoPremio: "", premioCanjeado: "") { premiosDisp, premiosCanj in
                                premiosDisponibles = premiosDisp
                                charPremiosDisp = Array(premiosDisponibles)
                                
                                premiosCanjeados = premiosCanj
                                charPremiosCanj = Array(premiosCanjeados)
                            }
                        }
                    } else if tabIndex == 1 { //Canjeados
                        
                        NavigationStack {
                            Form {
                                
                                if mostrarLoading2 {
                                    ProgressView()
                                        .progressViewStyle(.circular)
                                }
                                
                                if menu.flatMap(\.premios).contains(where: { item in
                                    !charPremiosDisp.contains(item.id) && charPremiosCanj.contains(item.id)
                                }) {
                                    
                                    ForEach(menu) { section in
                                        
                                        ForEach(section.premios.filter { item in
                                            // Agrega aquí tu condición de filtro
                                            return !charPremiosDisp.contains(item.id) && charPremiosCanj.contains(item.id)
                                        }) { item in
                                            
                                            
                                            
                                            HStack {
                                                
                                                Text("")
                                                //CREADO PARA AUMENTAR EL TAMAÑO DE LA FILA
                                                    .frame(width: 0.0, height: 40.0)
                                                
                                                HStack {
                                                    
                                                    HStack {
                                                        
                                                        Text(item.descripcion)
                                                        //.font(.headline)
                                                            .foregroundStyle(Color("verde"))
                                                        
                                                        
                                                        Spacer()
                                                        
                                                        
                                                        if charPremiosCanj.contains(item.id) {
                                                            Text("✓")
                                                                .foregroundStyle(Color("verde"))
                                                                .font(.title)
                                                        } else {
                                                            
                                                            HStack{
                                                                
                                                                if item.premioCobre != 0 {
                                                                    Text("\(item.premioCobre)")
                                                                        .font(.caption)
                                                                        .fontWeight(.black)
                                                                        .frame(width: 20.0, height: 20.0)
                                                                        .padding(2)
                                                                        .background(
                                                                            AngularGradient(
                                                                                colors: [Color("cobre1"), Color("cobre2"), Color("cobre1"), Color("cobre2"), Color("cobre1")], // Color marrón-naranja
                                                                                center: .center,
                                                                                startAngle: .degrees(90),
                                                                                endAngle: .degrees(360)
                                                                            )
                                                                        )
                                                                        .clipShape(RoundedRectangle(cornerRadius: 25))
                                                                        .foregroundColor(Color.white)
                                                                        .opacity(1.0)
                                                                }
                                                                
                                                                if item.premioPlata != 0 {
                                                                    Text("\(item.premioPlata)")
                                                                        .font(.caption)
                                                                        .fontWeight(.black)
                                                                        .frame(width: 20.0, height: 20.0)
                                                                        .padding(2)
                                                                        .background(AngularGradient(colors: [.gray, Color("plata"), .gray, Color("plata"), .gray],
                                                                                                    center: .center,
                                                                                                    startAngle: .degrees(90),
                                                                                                    endAngle: .degrees(360)))
                                                                        .clipShape(RoundedRectangle(cornerRadius: 25))
                                                                        .foregroundColor(Color.white)
                                                                        .opacity(1.0)
                                                                }
                                                                
                                                                if item.premioOro != 0 {
                                                                    Text("\(item.premioOro)")
                                                                        .font(.caption)
                                                                        .fontWeight(.black)
                                                                        .frame(width: 20.0, height: 20.0)
                                                                        .padding(2)
                                                                        .background(AngularGradient(colors: [.yellow, .brown, .yellow, .brown, .yellow],
                                                                                                    center: .center,
                                                                                                    startAngle: .degrees(90),
                                                                                                    endAngle: .degrees(360)))
                                                                        .clipShape(RoundedRectangle(cornerRadius: 25))
                                                                        .foregroundColor(Color.white)
                                                                        .opacity(1.0)
                                                                }
                                                                
                                                                if item.premioDiamante != 0 {
                                                                    Text("\(item.premioDiamante)")
                                                                        .font(.caption)
                                                                        .fontWeight(.black)
                                                                        .frame(width: 20.0, height: 20.0)
                                                                        .padding(1)
                                                                        .background(AngularGradient(colors: [Color("diamante"), .blue, Color("diamante"), .blue, Color("diamante")],
                                                                                                    center: .center,
                                                                                                    startAngle: .degrees(90),
                                                                                                    endAngle: .degrees(360)))
                                                                        .clipShape(RoundedRectangle(cornerRadius: 25))
                                                                        .foregroundColor(Color.white)
                                                                        .opacity(1.0)
                                                                }
                                                                
                                                                
                                                                
                                                            }
                                                            
                                                        }
                                                        
                                                        
                                                        
                                                    }
                                                    
                                                    
                                                }
                                                
                                            } //HSTACK
                                            
                                            
                                        }
                                        
                                        
                                    }
                                } else {
                                    
                                    Text("Sin premios canjeados")
                                    
                                }
                            }.onAppear { mostrarLoading2 = false }
                            
                        }.onAppear {
                            viewModel.getPremios(username: usuario ?? "", tipoPremio: "", premioCanjeado: "") { premiosDisp, premiosCanj in
                                premiosDisponibles = premiosDisp
                                charPremiosDisp = Array(premiosDisponibles)
                                
                                premiosCanjeados = premiosCanj
                                charPremiosCanj = Array(premiosCanjeados)
                            }
                        }
                        
                    } else { //Por conseguir
                        
                        NavigationStack {
                            Form {
                                
                                if mostrarLoading3 {
                                    ProgressView()
                                        .progressViewStyle(.circular)
                                }
                                
                                if menu.flatMap(\.premios).contains(where: { item in
                                    !charPremiosDisp.contains(item.id) && !charPremiosCanj.contains(item.id)
                                }) {
                                    
                                    ForEach(menu) { section in
                                        
                                        Section(section.name) {
                                            
                                            ForEach(section.premios.filter { item in
                                                // Agrega aquí tu condición de filtro
                                                return !charPremiosDisp.contains(item.id) && !charPremiosCanj.contains(item.id)
                                            }) { item in
                                                
                                                
                                                HStack {
                                                    
                                                    Text("")
                                                    //CREADO PARA AUMENTAR EL TAMAÑO DE LA FILA
                                                        .frame(width: 0.0, height: 40.0)
                                                    
                                                    HStack {
                                                        
                                                        HStack {
                                                            
                                                            
                                                            
                                                            Text(item.descripcion)
                                                            //.font(.headline)
                                                            //.foregroundStyle(Color("grisClaro"))
                                                            
                                                            
                                                            Spacer()
                                                            
                                                            
                                                            
                                                            HStack{
                                                                
                                                                if item.premioCobre != 0 {
                                                                    Text("\(item.premioCobre)")
                                                                        .font(.caption)
                                                                        .fontWeight(.black)
                                                                        .frame(width: 20.0, height: 20.0)
                                                                        .padding(2)
                                                                        .background(
                                                                            AngularGradient(
                                                                                colors: [Color("cobre1"), Color("cobre2"), Color("cobre1"), Color("cobre2"), Color("cobre1")], // Color marrón-naranja
                                                                                center: .center,
                                                                                startAngle: .degrees(90),
                                                                                endAngle: .degrees(360)
                                                                            )
                                                                        )
                                                                        .clipShape(RoundedRectangle(cornerRadius: 25))
                                                                        .foregroundColor(Color.white)
                                                                    
                                                                }
                                                                
                                                                if item.premioPlata != 0 {
                                                                    Text("\(item.premioPlata)")
                                                                        .font(.caption)
                                                                        .fontWeight(.black)
                                                                        .frame(width: 20.0, height: 20.0)
                                                                        .padding(2)
                                                                        .background(AngularGradient(colors: [.gray, Color("plata"), .gray, Color("plata"), .gray],
                                                                                                    center: .center,
                                                                                                    startAngle: .degrees(90),
                                                                                                    endAngle: .degrees(360)))
                                                                        .clipShape(RoundedRectangle(cornerRadius: 25))
                                                                        .foregroundColor(Color.white)
                                                                    
                                                                }
                                                                
                                                                if item.premioOro != 0 {
                                                                    Text("\(item.premioOro)")
                                                                        .font(.caption)
                                                                        .fontWeight(.black)
                                                                        .frame(width: 20.0, height: 20.0)
                                                                        .padding(2)
                                                                        .background(AngularGradient(colors: [.yellow, .brown, .yellow, .brown, .yellow],
                                                                                                    center: .center,
                                                                                                    startAngle: .degrees(90),
                                                                                                    endAngle: .degrees(360)))
                                                                        .clipShape(RoundedRectangle(cornerRadius: 25))
                                                                        .foregroundColor(Color.white)
                                                                    
                                                                }
                                                                
                                                                if item.premioDiamante != 0 {
                                                                    Text("\(item.premioDiamante)")
                                                                        .font(.caption)
                                                                        .fontWeight(.black)
                                                                        .frame(width: 20.0, height: 20.0)
                                                                        .padding(1)
                                                                        .background(AngularGradient(colors: [Color("diamante"), .blue, Color("diamante"), .blue, Color("diamante")],
                                                                                                    center: .center,
                                                                                                    startAngle: .degrees(90),
                                                                                                    endAngle: .degrees(360)))
                                                                        .clipShape(RoundedRectangle(cornerRadius: 25))
                                                                        .foregroundColor(Color.white)
                                                                    
                                                                }
                                                                
                                                                
                                                                
                                                            }
                                                            
                                                            
                                                            
                                                            
                                                            
                                                        }
                                                        
                                                        
                                                    }
                                                    
                                                }
                                                
                                                
                                            }
                                        }
                                        
                                    }
                                } else {
                                    
                                    Text("Sin premios por conseguir")
                                    
                                }
                                
                            }.onAppear { mostrarLoading3 = false }
                            
                        }.onAppear {
                            viewModel.getPremios(username: usuario ?? "", tipoPremio: "", premioCanjeado: "") { premiosDisp, premiosCanj in
                                premiosDisponibles = premiosDisp
                                charPremiosDisp = Array(premiosDisponibles)
                                
                                premiosCanjeados = premiosCanj
                                charPremiosCanj = Array(premiosCanjeados)
                            }
                        }
                        
                    }
                    Spacer()
                }
                .frame(width: UIScreen.main.bounds.width, alignment: .center)
                .padding(.horizontal, 12)
                .navigationTitle("Premios 🎁")
                .background(Color("fondoLista"))
            }.onAppear{ tabIndex = 0 }
            
            
            if mostrarAviso {
                GeometryReader { geometry in
                    Text("🎉 Premio canjeado\nHas añadido a tu cuenta:\n\n\(cobreCanjeado)\(plataCanjeado)\(oroCanjeado)\(diamanteCanjeado)")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: geometry.size.width)
                        .background(Color("verdepastel"))
                        .offset(y: -geometry.safeAreaInsets.top + 40) // Posición en la parte superior
                    
                }
                
            }
            
        }
    }
}


struct PremiosTopTabBar: View {
    @Binding var tabIndex: Int
    var body: some View {
        HStack(spacing: 20) {
            PremiosTabBarButton(text: "Disponibles", isSelected: .constant(tabIndex == 0))
                .onTapGesture { onButtonTapped(index: 0) }
                .foregroundColor(Color("grisOscuro"))
            PremiosTabBarButton(text: "Canjeados", isSelected: .constant(tabIndex == 1))
                .onTapGesture { onButtonTapped(index: 1) }
                .foregroundColor(Color("grisOscuro"))
            PremiosTabBarButton(text: "Por conseguir", isSelected: .constant(tabIndex == 2))
                .onTapGesture { onButtonTapped(index: 2) }
                .foregroundColor(Color("grisOscuro"))
            Spacer()
        }
        .borderPremios(width: 1, edges: [.bottom], color: Color("grisClaro"))
        .frame(width: UIScreen.main.bounds.width - 36, alignment: .center)
    }
    
    private func onButtonTapped(index: Int) {
        
            tabIndex = index
    }
}

struct PremiosTabBarButton: View {
    let text: String
    @Binding var isSelected: Bool
    var body: some View {
        Text(text)
            .fontWeight(isSelected ? .heavy : .regular)
            .font(.system(size: 14))
            .padding(.bottom, 10)
            .borderPremios(width: isSelected ? 2 : 1, edges: [.bottom], color: Color("grisClaro"))
    }
}

struct PremiosEdgeBorder: Shape {

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
    func borderPremios(width: CGFloat, edges: [Edge], color: SwiftUI.Color) -> some View {
        overlay(PremiosEdgeBorder(width: width, edges: edges).foregroundColor(color))
    }
}
