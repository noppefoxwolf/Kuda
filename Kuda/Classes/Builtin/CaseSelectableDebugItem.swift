//
//  CaseSelectableDebugItem.swift
//  App
//
//  Created by Tomoya Hirano on 2020/05/14.
//

import UIKit

public struct CaseSelectableDebugItem<T: CaseIterable & RawRepresentable>: DebugItem where T.RawValue: Equatable {
    
    public init(currentValue: T, didSelected: @escaping (T) -> Void) {
        self.currentValue = currentValue
        self.didSelected = didSelected
    }
    
    public let currentValue: T
    public let didSelected: (T) -> Void
    public var debugItemTitle: String { "Select " + String(describing: T.self) }
    
    public func didSelectedDebuggerItem(_ controller: UIViewController, completionHandler: @escaping (Result<String?, Error>) -> Void) {
        let vc = CaseSelectableTableController<T>(currentValue: currentValue, didSelected: didSelected)
        controller.navigationController?.pushViewController(vc, animated: true)
    }
}

fileprivate class CaseSelectableTableController<T: CaseIterable & RawRepresentable>: UITableViewController where T.RawValue: Equatable {
    let currentValue: T
    let didSelected: (T) -> Void
    
    init(currentValue: T, didSelected: @escaping (T) -> Void) {
        self.currentValue = currentValue
        self.didSelected = didSelected
        super.init(style: .plain)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        T.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        let value = T.allCases.map({ $0 })[indexPath.row]
        cell.textLabel?.text = "\(value)"
        cell.accessoryType = (value.rawValue == currentValue.rawValue) ? .checkmark : .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let value = T.allCases.map({ $0 })[indexPath.row]
        didSelected(value)
        navigationController?.popViewController(animated: true)
    }
}
