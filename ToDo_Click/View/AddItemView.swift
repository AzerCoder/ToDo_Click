//
//  AddItemView.swift
//  ToDo_Click
//
//  Created by A'zamjon Abdumuxtorov on 12/12/25.
//

import SwiftUI

struct AddItemView: View {
    var item: TodoItem?
    @ObservedObject var viewModel = TodoViewModel()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ScrollView{
            VStack(spacing: 24) {
                Text(item == nil ? "What are you planning?" : "Update Plan")
                    .font(.title)
                    .fontWeight(.bold)
                
                TextField("Plan title", text: $viewModel.title)
                    .padding()
                    .background(Color(uiColor: .systemBackground))
                    .cornerRadius(20)
                
                Text("Settings")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                VStack(spacing:16){
                    HStack{
                        Image(systemName: "calendar")
                            .foregroundStyle(.blue)
                            .padding(8)
                            .background(.blue.opacity(0.1))
                            .clipShape(Circle())
                        Text("Due Date")
                        Spacer()
                        
                        DatePicker("", selection: $viewModel.dueDate, displayedComponents: .date)
                            .labelsHidden()
                        
                    }
                    
                    .frame(height: 40)
                    
                    HStack{
                        Image(systemName: "clock.fill")
                            .foregroundStyle(.orange)
                            .padding(8)
                            .background(.orange.opacity(0.1))
                            .clipShape(Circle())
                        Text("Due Time")
                        Spacer()
                        
                        DatePicker("", selection: $viewModel.dueDate, displayedComponents: .hourAndMinute)
                            .labelsHidden()
                        
                    }
                    .frame(height: 40)
                    
                    HStack{
                        Image(systemName: "flag.fill")
                            .foregroundStyle(.red)
                            .padding(8)
                            .background(.red.opacity(0.1))
                            .clipShape(Circle())
                        Text("Priority")
                        Spacer()
                        
                    }
                    .frame(height: 40)
                    
                    HStack{
                        ForEach(TodoPriority.allCases, id: \.self) { prio in
                            Text(prio.title)
                                .font(.subheadline)
                                .frame(maxWidth: .infinity)
                                .frame(height: 30)
                                .opacity(viewModel.priority == prio ? 1.0 : 0.6)
                                .onTapGesture{
                                    withAnimation {
                                        viewModel.priority = prio
                                    }
                                }
                                .background{
                                    if viewModel.priority == prio {
                                        RoundedRectangle(cornerRadius: 15)
                                            .foregroundStyle(viewModel.priority.color.opacity(0.7))
                                            .animation(.bouncy, value: viewModel.priority)
                                    }
                                }
                            
                            
                        }
                    }
                    .padding(4)
                    .background(Color(uiColor: .systemGray6))
                    .cornerRadius(20)
                    .frame(height: 40)
                    
                }
                .padding()
                .background(Color(uiColor: .systemBackground))
                .cornerRadius(20)
                
                
                Text("Category")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                
                HStack{
                    ForEach(TodoCategory.allCases, id: \.self) { category in
                        VStack{
                            Image(systemName: category.imageName)
                                .imageScale(.large)
                                .foregroundStyle(viewModel.selectedCategory == category ? .white : .gray)
                                .frame(width: 60, height: 60)
                                .background(viewModel.selectedCategory == category ?  viewModel.selectedCategory.color : .white)
                                .cornerRadius(20)
                            
                            Text(String(describing: category).capitalized)
                                .font(.caption)
                        }
                        .frame(maxWidth: .infinity)
                        .onTapGesture{
                            withAnimation {
                                viewModel.selectedCategory = category
                            }
                        }
                    }
                }
                
                
                TextEditor(text: $viewModel.infoText)
                    .frame(height: 150)
                    .padding()
                    .background(Color(uiColor: .systemBackground))
                    .cornerRadius(20)
                    .overlay(alignment: .topLeading, content: {
                        if viewModel.infoText.isEmpty {
                            Text("Additional information?")
                                .foregroundColor(.gray)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 24)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                             
                    )
                
            }
            .padding()
            .onAppear{
                viewModel.viewAppear(item: item)
            }
        }
        .background(Color(uiColor: .systemGray6))
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    viewModel.pressToButton(item: item)
                    dismiss()
                } label: {
                    Text(item == nil ? "Add Item" : "Update Item")
                }
                .buttonStyle(.borderedProminent)
                .tint(.blue)
                .clipShape(.capsule)
                .disabled(viewModel.title.isEmpty)
            }
        }
    }
}

#Preview {
    NavigationStack{
        AddItemView()
    }
}
