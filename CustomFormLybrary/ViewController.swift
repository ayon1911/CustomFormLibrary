//
//  ViewController.swift
//  CustomFormLybrary
//
//  Created by Khaled Rahman Ayon on 19.09.18.
//  Copyright © 2018 Khaled Rahman Ayon. All rights reserved.
//

import UIKit

struct HotspotState {
    var isEnabled: Bool = true
    var password: String = "Hello"
}

class ViewController: UITableViewController {

    var state = HotspotState() {
        didSet {
            print(state)
            tableView.beginUpdates()
            let footer = tableView.footerView(forSection: 0)
            footer?.textLabel?.text = tableView(tableView, titleForFooterInSection: 0)
            footer?.setNeedsLayout()
            
            let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 1))
            cell?.detailTextLabel?.text = state.password
            
            tableView.endUpdates()
            UIView.setAnimationsEnabled(true)
        }
    }
    var toggle = UISwitch()
    
    init() {
        super.init(style: .grouped)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        navigationItem.title = "Settings"
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        if indexPath.section == 0 {
        cell.textLabel?.text = "Personal hotspot"
        cell.contentView.addSubview(toggle)
        toggle.isOn = state.isEnabled
        toggle.translatesAutoresizingMaskIntoConstraints = false
        toggle.addTarget(self, action: #selector(toggleChanged(_:)), for: .valueChanged)
        cell.contentView.addConstraints([
            toggle.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
            toggle.trailingAnchor.constraint(equalTo: cell.contentView.layoutMarginsGuide.trailingAnchor)
            ])
            
        } else if indexPath.section == 1 {
            cell.textLabel?.text = "Password"
            cell.detailTextLabel?.text = state.password
            cell.accessoryType = .disclosureIndicator
        } else {
            fatalError()
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            let passwordVC = PasswordVC(password: state.password) { [unowned self] in
                self.state.password = $0
            }
            navigationController?.pushViewController(passwordVC, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return indexPath.section != 0
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if section == 0 {
            return state.isEnabled ? "Personal hotspot is enabled" : nil
        }
        return nil
    }
    //MARK:- Handler
    @objc func toggleChanged(_ sender: Any) {
        state.isEnabled = toggle.isOn
    }
}

class PasswordVC: UITableViewController {
    let textField = UITextField()
    let onChange: (String) -> ()
    init(password: String, onChange: @escaping(String) -> ()){
        self.onChange = onChange
        super.init(style: .grouped)
        textField.text = password
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        textField.becomeFirstResponder()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        cell.textLabel?.text = "Password"
        cell.contentView.addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        cell.contentView.addConstraints([
            textField.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
            textField.leadingAnchor.constraint(equalTo: (cell.textLabel?.trailingAnchor)!, constant: 20),
            textField.trailingAnchor.constraint(equalTo: cell.contentView.layoutMarginsGuide.trailingAnchor)
        ])
        textField.addTarget(self, action: #selector(editingEnded(_:)), for: .editingDidEnd)
        textField.addTarget(self, action: #selector(editingDidEnter(_:)), for: .editingDidEndOnExit)
        return cell
    }
    
    @objc func editingEnded(_ sender: Any) {
        onChange(textField.text ?? "")
    }
    
    @objc func editingDidEnter(_ sender: Any) {
        onChange(textField.text ?? "")
        navigationController?.popViewController(animated: true)
    }
}
