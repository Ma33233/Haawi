//
//  profileTableViewCell.swift
//  FinalProject
//
//  Created by Faisal Almutairi on 19/02/1444 AH.
//

import UIKit

class profileTableViewCell: UITableViewCell {

    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var isClosed: UILabel!
    @IBOutlet weak var endSessionBtn: UIButton!
    @IBOutlet weak var categoryImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
