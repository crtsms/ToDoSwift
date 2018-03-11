//
//  ToDoTableViewCell.swift
//  To Do
//
//  Created by Crislei Terassi Sorrilha on 2/28/18.
//  Copyright © 2018 Crislei Terassi Sorrilha. All rights reserved.
//

import UIKit

class ToDoTableViewCell: UITableViewCell {

    //MARK: Properties
    
    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
