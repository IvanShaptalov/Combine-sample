//
//  ViewController.swift
//  CombineIntro
//
//  Created by PowerMac on 24.04.2024.
//

import UIKit
import Combine

class MyCustomTableCell:  UITableViewCell {
    private let button: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemCyan
        button.setTitle("Button", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    let action = PassthroughSubject<String, Never>()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(button)
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    }
    
    @objc private func didTapButton(){
        action.send("Cool! Button was tapped!")
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        button.frame = CGRect(x: 10, y: 3, width: Int(contentView.frame.size.width) - 20, height: Int(contentView.frame.size.height) - 6)
    }
}

class ViewController: UIViewController, UITableViewDataSource {
    // MARK: - Fields 🌾
    // combine object
    var observers: [AnyCancellable] = []
    
    private var companies: [String] = []
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? MyCustomTableCell else {
            fatalError()
        }        
        cell.action.sink {
            string in
            print(string)
            cell.textLabel?.text = self.companies[indexPath.row]
        }.store(in: &observers)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return companies.count
    }
    
    
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(MyCustomTableCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    // MARK: - viewDidLoad ⚙️
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.frame = view.bounds
        
        // set what thread will be used when future will be ready
        APICaller.shared.fetchCompanies().receive(on: DispatchQueue.main)
        // notify completion
            .sink(receiveCompletion: { completion in
            switch completion {
            
            case .finished:
                NSLog("finished")
            case .failure(let error):
                NSLog("error while fetch: \(error.localizedDescription)")
            }
        // completion with future
        }, receiveValue: { value in
            self.companies = value
            self.tableView.reloadData()
            
        })
        // store all in observers
        .store(in: &observers)
    }
    
    
    
}

