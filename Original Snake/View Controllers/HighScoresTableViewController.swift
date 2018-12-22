//
//  HighScoresTableViewController.swift
//  Original Snake
//
//  Created by Bartłomiej Świerad on 22/12/2018.
//  Copyright © 2018 Bartłomiej Świerad. All rights reserved.
//

import UIKit

class HighScoresTableViewController: UITableViewController {
    
    let scores: [Score] = UserDefaults.standard.scores
    
    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scores.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "defaultCell", for: indexPath) as! ScoreTableViewCell
        let score = scores[indexPath.row]
        let date = Date(timeIntervalSince1970: TimeInterval(score.timestamp))
        cell.titleLabel.text = dateFormatter.string(from: date)
        cell.detailLabel.text = String(describing: score.points)
        return cell
    }
    
}
