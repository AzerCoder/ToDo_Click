//
//  ListRow.swift
//  ToDo_Click
//
//  Created by A'zamjon Abdumuxtorov on 12/12/25.
//

import SwiftUI

struct ListRow: View {
    var item: TodoItem
    @ObservedObject var viewModel: TodoViewModel
    var body: some View {
        HStack(spacing: 15){
            Button{
                withAnimation {
                    viewModel.toggleCompleted(item)
                    print("Toggled completion for item")
                }
            } label: {
                Image(systemName: item.isCompleted ? "checkmark.circle.fill" : "circle")
                    .resizable()
                    .foregroundColor(item.isCompleted ? .green : .gray)
                
                    .frame(width: 24, height: 24)
            }
            .buttonStyle(.borderless)
            
            NavigationLink {
                AddItemView(item: item, viewModel: viewModel)
            } label: {
                VStack(alignment:.leading,spacing:8){
                    HStack(spacing:8){
                        Text(item.title)
                            .font(.title3)
                            .lineLimit(1)
                        
                        Spacer()
                        
                        Image(systemName: getCategory().imageName)
                            .foregroundStyle(getCategory().color)
                        
                        Text("\(getCategory())".capitalized)
                        
                    }
                    .opacity(item.isCompleted ? 0.6 : 1.0)
                    .overlay{
                        if item.isCompleted{
                            Rectangle()
                                .foregroundColor(.gray)
                                .frame(height: 2)
                        }
                    }
                            
                    
                    if !item.isCompleted{
                        VStack(alignment:.leading){
                            if let notes = item.notes{
                                Text(notes)
                                    .font(.callout)
                                    .lineLimit(1)
                            }
                            
                            HStack(spacing: 8){
                                
                                Text(getPriority().title)
                                    .foregroundStyle(getPriority().color)
                                    .padding(4)
                                    .padding(.horizontal,8)
                                    .background(getPriority().color.opacity(0.1))
                                    .cornerRadius(15)
                                
                                Spacer()
                                
                                Text((item.dueDate ?? Date()).formatted(date: .abbreviated, time:.shortened))
                                    .lineLimit(1)
                                    .font(.caption)
                            }
                            .foregroundColor(.secondary)
                        }
                        .transition(.move(edge: .bottom).combined(with: .opacity) )
                    }
                       
                }
            }
            
        }
        
    }
    
    func getCategory()-> TodoCategory{
        return TodoCategory(rawValue: item.category) ?? .personal
    }
    
    func getPriority()-> TodoPriority{
        return TodoPriority(rawValue: item.priority) ?? .medium
    }
}
