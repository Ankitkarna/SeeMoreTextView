//
//  ViewController.swift
//  SeeMoreTextView
//
//  Created by Ankit Karna on 4/24/20.
//  Copyright © 2020 Ankit Karna. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let textView = SeeMoreTextView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()
    }
    
    let shortText = "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu"
    let longText = "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda."
    
    private func setupUI() {
        view.addSubview(textView)
        textView.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            textView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            textView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
        textView.text = longText
        
        let textViewFont = UIFont.systemFont(ofSize: 16)
        textView.font = textViewFont
        let attributes: [NSAttributedString.Key: Any] = [.font: textViewFont, .foregroundColor: UIColor.lightGray]
        textView.attributedSeeMoreText = NSMutableAttributedString(string: "... Read More", attributes: attributes)
    
    }
    
    private func setupNavigationBar() {
        let nextButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(nextButtonTapped))
        navigationItem.rightBarButtonItem = nextButton
    }
    
    @objc private func nextButtonTapped() {
        let controller = ExampleTableController()
        controller.text = longText
        navigationController?.pushViewController(controller, animated: true)
    }

}

