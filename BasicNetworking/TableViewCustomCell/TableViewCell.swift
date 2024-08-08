//
//  TableViewCell.swift
//  BasicNetworking
//
//  Created by Muhammad Kumail on 8/5/24.
//

import UIKit

protocol TableViewCellProtocol {
    func updateBtnTap(tag: Int)
    func deldeteBtnTap(tag: Int)
}

class TableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    var delegate: TableViewCellProtocol? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func updateBtn(_ sender: Any) {
        delegate?.updateBtnTap(tag: editButton.tag)
        
    }
    
    @IBAction func deleteRow(_ sender: Any) {
        delegate?.deldeteBtnTap(tag: deleteButton.tag)
    }
}
