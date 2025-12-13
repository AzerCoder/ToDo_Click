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
    @State private var title: String = ""
    @State private var infoText: String = ""
    @State private var selectedCategory: TodoCategory = .personal
    @State private var dueDate: Date = Date()
    @State private var priority: TodoPriority = .medium
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ScrollView{
            VStack(spacing: 24) {
                Text(item == nil ? "What are you planning?" : "Update Plan")
                    .font(.title)
                    .fontWeight(.bold)
                
                TextField("Plan title", text: $title)
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
                        
                        DatePicker("", selection: $dueDate, displayedComponents: .date)
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
                        
                        DatePicker("", selection: $dueDate, displayedComponents: .hourAndMinute)
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
                                .opacity(priority == prio ? 1.0 : 0.6)
                                .onTapGesture{
                                    withAnimation {
                                        priority = prio
                                    }
                                }
                                .background{
                                    if priority == prio {
                                        RoundedRectangle(cornerRadius: 15)
                                            .foregroundStyle(priority.color.opacity(0.7))
                                            .animation(.bouncy, value: priority)
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
                                .foregroundStyle(selectedCategory == category ? .white : .gray)
                                .frame(width: 60, height: 60)
                                .background(selectedCategory == category ?  selectedCategory.color : .white)
                                .cornerRadius(20)
                            
                            Text(String(describing: category).capitalized)
                                .font(.caption)
                        }
                        .frame(maxWidth: .infinity)
                        .onTapGesture{
                            withAnimation {
                                selectedCategory = category
                            }
                        }
                    }
                }
                
                
                TextEditor(text: $infoText)
                    .frame(height: 150)
                    .padding()
                    .background(Color(uiColor: .systemBackground))
                    .cornerRadius(20)
                    .overlay(alignment: .topLeading, content: {
                        if infoText.isEmpty {
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
                if let item = item {
                    title = item.title
                    infoText = item.notes ?? ""
                    selectedCategory = TodoCategory(rawValue: item.category) ?? .personal
                    priority = TodoPriority(rawValue: item.priority) ?? .medium
                    dueDate = item.dueDate ?? Date()
                }
            }
        }
        .background(Color(uiColor: .systemGray6))
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    if let item = item {
                        viewModel.update(item, title: title, notes: infoText, dueDate: dueDate,category: selectedCategory, priority: priority)
                    }else{
                        viewModel.add(title: title, notes: infoText, dueDate: dueDate, category: selectedCategory, priority: priority)
                    }
                    dismiss()
                } label: {
                    Text(item == nil ? "Add Item" : "Update Item")
                }
                .buttonStyle(.borderedProminent)
                .tint(.blue)
                .clipShape(.capsule)
                .disabled(title.isEmpty)
            }
        }
    }
}

#Preview {
    NavigationStack{
        AddItemView()
    }
}
