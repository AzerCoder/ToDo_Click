//
//  ContentView.swift
//  ToDo_Click
//
//  Created by A'zamjon Abdumuxtorov on 12/12/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = TodoViewModel()
    var body: some View {
        NavigationStack{
            ZStack{
                if viewModel.items.isEmpty{
                    VStack{
                        Image(systemName: "swift")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200,height: 200)
                            .foregroundStyle(.orange)
                        
                        Text("No Plans Yet.\n Tap the + button to add a new plan.")
                            .padding(.horizontal,40)
                            .multilineTextAlignment(.center)
                            .font(.title)
                            .fontWeight(.bold)
                            .padding(.top,8)
                        
                    }
                }else{
                    List {
                        if viewModel.items.contains(where: { !$0.isCompleted }) {
                            Section(header: Text("Pending")){
                                ForEach(viewModel.items.filter{$0.isCompleted == false}) { item in
                                    ListRow(item: item,viewModel: viewModel)
                                }
                                .onDelete { offsets in
                                    viewModel.remove(at: offsets)
                                }
                            }
                        }
                        
                        if viewModel.items.contains(where: { $0.isCompleted }) {
                            Section(header: Text("Completed")){
                                ForEach(viewModel.items.filter{$0.isCompleted == true}) { item in
                                    ListRow(item: item,viewModel: viewModel)
                                }
                                .onDelete { offsets in
                                    viewModel.remove(at: offsets)
                                }
                            }
                        }
                    }
                }
                
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink {
                        AddItemView(item: nil, viewModel: viewModel)
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .navigationTitle("ToDo App")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    NavigationStack{
        ContentView()
    }
}


