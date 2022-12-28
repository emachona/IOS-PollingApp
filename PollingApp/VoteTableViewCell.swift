//
//  VoteTableViewCell.swift
//  PollingApp
//
//  Created by Emilija Chona on 12/27/22.
//

import UIKit

class VoteTableViewCell: UITableViewCell {

    @IBOutlet weak var questionTL: UILabel!
    @IBOutlet weak var answerTL: UILabel!
    @IBOutlet weak var startTL: UILabel!
    @IBOutlet weak var endTL: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
