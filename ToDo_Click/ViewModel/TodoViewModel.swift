//
//  TodoViewModel.swift
//  ToDo_Click
//
//  Created by A'zamjon Abdumuxtorov on 12/12/25.
//

import SwiftUI
import Combine

@MainActor
class TodoViewModel: ObservableObject {
    @Published var items: [TodoItem] = [] {
        didSet { saveItems() }
    }
    
    private let key = "todo_items"
    
    init() {
        loadItems()
    }
    
    func add(
        title: String,
        notes: String? = nil,
        dueDate: Date? = nil,
        category: TodoCategory = .others,
        priority: TodoPriority = .medium
    ) {
        let item = TodoItem(
            title: title,
            isCompleted: false,
            dueDate: dueDate,
            notes: notes,
            category: category.rawValue,
            priority: priority.rawValue
        )
        
        items.append(item)
    }
    
    
   
    func update(_ item: TodoItem,
                title: String? = nil,
                notes: String? = nil,
                dueDate: Date? = nil,
                category: TodoCategory? = nil,
                priority: TodoPriority? = nil) {
        
        guard let index = items.firstIndex(where: { $0.id == item.id }) else { return }
        
        if let title = title {
            items[index].title = title
        }
        if let notes = notes {
            items[index].notes = notes
        }
        if let dueDate = dueDate {
            items[index].dueDate = dueDate
        }
        if let category = category {
            items[index].category = category.rawValue
        }
        if let priority = priority {
            items[index].priority = priority.rawValue
        }
    }
    
    
    func toggleCompleted(_ item: TodoItem) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index].isCompleted.toggle()
        }
    }
    
    
    func remove(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
    }
    
    
    // MARK: - Persistence
    
    private func saveItems() {
        do {
            let data = try JSONEncoder().encode(items)
            UserDefaults.standard.set(data, forKey: key)
        } catch {
            print("Error saving items:", error)
        }
    }
    
    private func loadItems() {
        guard let data = UserDefaults.standard.data(forKey: key) else {
            items = []
            return
        }
        do {
            items = try JSONDecoder().decode([TodoItem].self, from: data)
        } catch {
            print("Error loading items:", error)
            items = []
        }
    }
}
