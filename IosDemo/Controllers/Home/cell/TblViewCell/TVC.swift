//
//  TVC.swift
//  IosDemo
//
//  Created by priyal on 15/05/25.
//

import UIKit

class TVC: UITableViewCell {
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var lblEmoji: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var attachmentsStackView: UIStackView!
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var viewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var stackViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var deleteView: UIView!
    private var stackViewHeightConstraint: NSLayoutConstraint?
    
    @IBOutlet weak var editView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        img.makeCircular()
        
        if let existingConstraint = stackViewHeightConstraint {
            existingConstraint.isActive = false
        }
        
        attachmentsStackView.translatesAutoresizingMaskIntoConstraints = false
        attachmentsStackView.isHidden = true // Hidden by default, shown only when attachments exist
    }
    func configure(with thread: Thread) {
        viewLeadingConstraint.constant = 16
        if let user = thread.user {
            lblName.text = "\(user.firstName) \(user.lastName) (\(user.professionalTitle))"
        }
        deleteView.isHidden  = false
        editView.isHidden = false
        
        
        attachmentsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        attachmentsStackView.spacing = 8
        if thread.attachmentsJson.isEmpty {
            attachmentsStackView.isHidden = true
            stackViewHeight.constant = 0
            return
        }
        
        attachmentsStackView.isHidden = false
        
        let numAttachments = thread.attachmentsJson.count
        let numRows = Int(ceil(Double(numAttachments) / 2.0))
        stackViewHeight.constant = CGFloat(numRows * 30) // Adjust as needed for row height
        
        for i in stride(from: 0, to: numAttachments, by: 2) {
            let containerStack = UIStackView()
            containerStack.axis = .horizontal
            containerStack.spacing = 8
            containerStack.distribution = .fillEqually
            
            let firstAttachment = thread.attachmentsJson[i]
            let firstView = createAttachmentView(for: firstAttachment)
            containerStack.addArrangedSubview(firstView)
            
            if i + 1 < numAttachments {
                let secondAttachment = thread.attachmentsJson[i + 1]
                let secondView = createAttachmentView(for: secondAttachment)
                containerStack.addArrangedSubview(secondView)
            } else {
                let spacer = UIView()
                containerStack.addArrangedSubview(spacer)
            }
            
            attachmentsStackView.addArrangedSubview(containerStack)
        }
    }
    private func createAttachmentView(for attachment: Attachment) -> UIView {
        let rowStack = UIStackView()
        rowStack.axis = .horizontal
        rowStack.spacing = 8
        rowStack.alignment = .center
        rowStack.isLayoutMarginsRelativeArrangement = true
        rowStack.layoutMargins = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        
        rowStack.layer.borderColor = UIColor.gray.cgColor
        rowStack.layer.borderWidth = 1
        rowStack.layer.cornerRadius = 6
        rowStack.clipsToBounds = true
        
        let imageView = UIImageView(image: UIImage.icPdf)
        imageView.tintColor = .gray
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 16),
            imageView.heightAnchor.constraint(equalToConstant: 16)
        ])
        
        let label = UILabel()
        label.text = attachment.fileOriginalName
        label.font = .systemFont(ofSize: 12)
        label.numberOfLines = 0
        
        rowStack.addArrangedSubview(imageView)
        rowStack.addArrangedSubview(label)
        
        return rowStack
        
    }
    
    func configure1(with thread: ThreadReply) {
        viewLeadingConstraint.constant = 50
        if let user = thread.user {
            lblName.text = "\(user.firstName) \(user.lastName) (\(user.professionalTitle))"
        }
        deleteView.isHidden  = true
        editView.isHidden = true
        
        
        attachmentsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        attachmentsStackView.spacing = 8
        if thread.attachmentsJson.isEmpty {
            attachmentsStackView.isHidden = true
            stackViewHeight.constant = 0
            return
        }
        
        attachmentsStackView.isHidden = false
        
        let numAttachments = thread.attachmentsJson.count
        let numRows = Int(ceil(Double(numAttachments) / 2.0))
        stackViewHeight.constant = CGFloat(numRows * 30) // Adjust as needed for row height
        
        for i in stride(from: 0, to: numAttachments, by: 2) {
            let containerStack = UIStackView()
            containerStack.axis = .horizontal
            containerStack.spacing = 8
            containerStack.distribution = .fillEqually
            
            let firstAttachment = thread.attachmentsJson[i]
            let firstView = createAttachmentView(for: firstAttachment)
            containerStack.addArrangedSubview(firstView)
            
            if i + 1 < numAttachments {
                let secondAttachment = thread.attachmentsJson[i + 1]
                let secondView = createAttachmentView(for: secondAttachment)
                containerStack.addArrangedSubview(secondView)
            } else {
                let spacer = UIView()
                containerStack.addArrangedSubview(spacer)
            }
            
            attachmentsStackView.addArrangedSubview(containerStack)
        }
    }
}
    
    
  
