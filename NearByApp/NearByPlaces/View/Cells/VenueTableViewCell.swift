//
//  VenueTableViewCell.swift
//  NearByApp
//
//  Created by Sachin Yadav on 16/03/24.
//

import UIKit

internal final class VenueTableViewCell: UITableViewCell {

    @IBOutlet private var venueImageView: UIImageView!
    @IBOutlet private var venueTitleLabel: UILabel!
    @IBOutlet private var venueDescriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    internal func updateData(venue: PlaceResponseModel) {
        venueTitleLabel.text = venue.name
        venueDescriptionLabel.text = venue.address
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        venueImageView.image = nil
        venueTitleLabel.text = nil
        venueDescriptionLabel.text = nil

    }
    
}
