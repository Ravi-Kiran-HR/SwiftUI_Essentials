//
//  MenuDetailView.swift
//  Pizza
//
//  Created by Steven Lipton on 9/2/19.
//  Copyright © 2019 Steven Lipton. All rights reserved.
//

import SwiftUI
///A `View`for entering in an order. Takes basic information about the order from `menuItem`
struct MenuDetailView: View {
    let sizes: [Size] = [.small, .medium, .large]
    @ObservedObject var orderModel: OrderModel
    @EnvironmentObject var userPreferences: UserPreferences
    @State var didOrder: Bool = false
    @State var quantity: Int = 1
    
    var menuItem:MenuItem
    var formattedPrice:String{
        String(format:"%3.2f",menuItem.price * Double(quantity) * userPreferences.size.rawValue)
    }
    func addItem(){
        //  orderModel.add(menuID: menuItem.id)
        didOrder = true
    }
    
    var body: some View {
        VStack {
            ScrollView {
                PageTitleView(title: menuItem.name)
                SelectedImageView(image: "\(menuItem.id)_250w")
                    .padding(5)
                    .layoutPriority(3)
                
                Text(menuItem.description)
                    .lineLimit(5)
                    .padding()
                    .layoutPriority(3)
                
                Spacer()
          
                Picker(selection: $userPreferences.size, content: {
                    ForEach(sizes, id: \.self) { size in
                        Text(size.formatted()).tag(size)
                    }
                }, label: {
                    Text("Pizza size")
                })
                    .pickerStyle(SegmentedPickerStyle())
                    .font(.headline)
         
                Stepper(value: $quantity, in: 1...10) {
                    Text("Quantity: \(quantity)")
                        .bold()
                }
                .padding()
                HStack{
                    Text("Order:  \(formattedPrice)")
                        .font(.headline)
                    Spacer()
                    Text("Order total: " + orderModel.formattedTotal )
                        .font(.headline)
                }
                .padding()
                HStack{
                    Spacer()
                    Button(action: addItem) {
                        Text("Add to order")
                            .font(.title)
                            .fontWeight(.bold)
                            .padding()
                            .background(Color("G4"))
                            .foregroundColor(Color("IP"))
                            .cornerRadius(5)
                    }
                    // uncomment below to get system default alert view
                    //        .alert("You have ordered:'\(menuItem.name)' pizza", isPresented: $didOrder) {}
                    .sheet(isPresented: $didOrder) {
                        ConfirmView(menuID: menuItem.id, orderModel: orderModel, isPresented: $didOrder, quantity: $quantity)
                    }
                    
                    Spacer()
                }
                .padding(.top)
                Spacer()
            }
        }
    }
}

struct MenuDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MenuDetailView(orderModel: OrderModel(),  menuItem: testMenuItem)
            .environmentObject(UserPreferences())
    }
}
