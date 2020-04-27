//
//  ExampleTableController.swift
//  SeeMoreTextView
//
//  Created by Ankit Karna on 4/26/20.
//  Copyright © 2020 Ankit Karna. All rights reserved.
//

import UIKit

let cellIdentifier = "cell"
class ExampleTableController: UITableViewController {
    var text: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        tableView.register(ExampleTableCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableView.automaticDimension
    }
}

extension ExampleTableController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! ExampleTableCell
        cell.configureCell(text: text)
        cell.textView.onIntrinsicContentSizeChange = { [indexPath] in
            tableView.beginUpdates()
            tableView.endUpdates()
            tableView.scrollToRow(at: indexPath, at: .top, animated: true)
            cell.textView.setNeedsLayout()
        }
        return cell
    }
}

class ExampleTableCell: UITableViewCell {
    let textView = SeeMoreTextView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        contentView.backgroundColor = .red
        contentView.addSubview(textView)
        textView.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            textView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            textView.topAnchor.constraint(equalTo: contentView.topAnchor),
            textView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            textView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
        textView.font = UIFont.systemFont(ofSize: 14)
    }
    
    func configureCell(text: String) {
        textView.text = text
    }
}
