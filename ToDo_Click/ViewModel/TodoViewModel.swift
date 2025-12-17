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
    @Published var title: String = ""
    @Published var infoText: String = ""
    @Published var dueDate: Date = Date()
    @Published var priority: TodoPriority = .medium
    @Published var selectedCategory: TodoCategory = .personal
    @Published var items: [TodoItem] = [] {
        didSet { saveItems() }
    }
    
    private let key = "todo_items"
    
    init() {
        loadItems()
    }
    
    func toggleCompleted(_ item: TodoItem) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index].isCompleted.toggle()
        }
    }
    
    
    func remove(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
    }
    
    func viewAppear(item: TodoItem?) {
        if let item = item {
            title = item.title
            infoText = item.notes ?? ""
            selectedCategory = TodoCategory(rawValue: item.category) ?? .personal
            priority = TodoPriority(rawValue: item.priority) ?? .medium
            dueDate = item.dueDate ?? Date()
        }
    }
    
    func pressToButton(item: TodoItem?){
        if let item = item {
            update(item, title: title, notes: infoText, dueDate: dueDate,category: selectedCategory, priority: priority)
        }else{
            add(title: title, notes: infoText, dueDate: dueDate, category: selectedCategory, priority: priority)
        }
    }
    
    //MARK: Private
    
    private func add(
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
    
    
    private func update(_ item: TodoItem,
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
