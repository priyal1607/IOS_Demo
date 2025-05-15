//
//  ViewController.swift
//  IosDemo
//
//  Created by priyal on 15/05/25.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var lblTitle: UILabel!

    var threads: [Thread] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupview()
    }

    func setupview(){
        loadThreadsFromJSON()
        img.makeCircular()
        setupTbl()
        tblView.delegate = self
        tblView.dataSource = self
    }

    private func setupTbl() {
        let nib = UINib(nibName: "TVC", bundle: nil)
        tblView.register(nib, forCellReuseIdentifier: "TVC")
        let nib2 = UINib(nibName: "ViewMore", bundle: nil)
        tblView.register(nib2, forCellReuseIdentifier: "ViewMore")
        
    }
}

extension ViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return threads.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let thread = threads[section]
        let repliesCount = thread.replies.count

        if repliesCount == 0 {
            return 1
        }

        let visibleReplies = thread.repliesToShow

        if thread.isRepliesExpanded {
            if visibleReplies >= repliesCount {
                return 1 + repliesCount + 1
            } else {
                return 1 + visibleReplies + 1
            }
        } else {
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let separator = UIView()
        separator.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        
        let container = UIView()
        container.backgroundColor = .clear
        container.addSubview(separator)
        
        separator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            separator.heightAnchor.constraint(equalToConstant: 1),
            separator.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            separator.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
            separator.topAnchor.constraint(equalTo: container.topAnchor),
        ])
        
        return container
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 8
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let thread = threads[indexPath.section]
        let repliesCount = thread.replies.count
        let visibleReplies = thread.repliesToShow
        let totalReactionsCount = thread.reactions.reduce(0) { $0 + $1.users.count }
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TVC", for: indexPath) as! TVC
            if thread.attachmentsJson.count > 0 {
                cell.lblDescription.text = thread.parsedMessage + " 📌 Important attention"
            } else {
                 cell.lblDescription.text = thread.parsedMessage
            }
            
            cell.lblDate.text = relativeTime(from: thread.lastEditTime)
            if let firstReaction = thread.reactions.first {
                  // Example format: "👍 5" (emoji + total count)
                cell.lblEmoji.text = "\(firstReaction.emoji) \(totalReactionsCount)"
              } else {
                  cell.lblEmoji.text = ""
              }
            cell.configure(with: thread)
            return cell
        }

        if thread.isRepliesExpanded {
            if indexPath.row <= visibleReplies {
                let reply = thread.replies[indexPath.row - 1]
                let cell = tableView.dequeueReusableCell(withIdentifier: "TVC", for: indexPath) as! TVC
                cell.configure1(with: reply)
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ViewMore", for: indexPath)as! ViewMore
                cell.lbl.text = (visibleReplies >= repliesCount) ? "Hide Replies" : "View More Replies"
                return cell
            }
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ViewMore", for: indexPath)as! ViewMore
            cell.lbl.text = "View More Replies"
            return cell
        }
    }


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let thread = threads[indexPath.section]
        let repliesCount = thread.replies.count

        if indexPath.row == 1 && !thread.isRepliesExpanded {
            thread.isRepliesExpanded = true
            thread.repliesToShow = min(3, repliesCount)
            tableView.reloadSections([indexPath.section], with: .automatic)
        } else if thread.isRepliesExpanded && indexPath.row == thread.repliesToShow + 1 {
            if thread.repliesToShow < repliesCount {
                thread.repliesToShow = min(thread.repliesToShow + 3, repliesCount)
            } else {
                thread.isRepliesExpanded = false
                thread.repliesToShow = 0
            }
            tableView.reloadSections([indexPath.section], with: .automatic)
        }
    }


}

extension ViewController {
    func loadThreadsFromJSON() {
        guard let url = Bundle.main.url(forResource: "thread_list", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []),
              let jsonDict = jsonObject as? [String: Any] else {
            print("Failed to load or parse JSON.")
            return
        }

        let threadModel = ThreadModel(fromDictionary: jsonDict)

        self.threads = threadModel.data.threads
        print("Loaded \(threads.count) threads.")
    }
    
    func relativeTime(from isoDateString: String) -> String {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

        guard let date = isoFormatter.date(from: isoDateString) ?? ISO8601DateFormatter().date(from: isoDateString) else {
            return "25 days ago"
        }

        let now = Date()
        let secondsAgo = Int(now.timeIntervalSince(date))

        if secondsAgo < 60 {
            return "Just now"
        } else if secondsAgo < 3600 {
            let minutes = secondsAgo / 60
            return "\(minutes) min ago"
        } else if secondsAgo < 86400 {
            let hours = secondsAgo / 3600
            return "\(hours) hour\(hours > 1 ? "s" : "") ago"
        } else {
            let days = secondsAgo / 86400
            return "\(days) day\(days > 1 ? "s" : "") ago"
        }
    }

}

extension Thread {
    var parsedMessage: String {
        var updatedMessage = self.message

        let mentionList = self.mentionList

        let regex = try! NSRegularExpression(pattern: "\\{user_(-?\\d+)\\}")
        let matches = regex.matches(in: message, range: NSRange(message.startIndex..., in: message))

        for match in matches.reversed() {
            if let range = Range(match.range(at: 0), in: message),
               let idRange = Range(match.range(at: 1), in: message),
               let id = Int(message[idRange]) {

                if let mention = mentionList.first(where: { $0.id == id }) {
                    updatedMessage.replaceSubrange(range, with: "@\(mention.name)")
                } else {
                    updatedMessage.replaceSubrange(range, with: "@Unknown")
                }
            }
        }

        return updatedMessage
    }

}
