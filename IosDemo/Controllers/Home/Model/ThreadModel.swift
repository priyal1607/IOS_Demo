//
//  ThreadModel.swift
//  IosDemo
//
//  Created by priyal on 15/05/25.
//

import Foundation
class ThreadModel : NSObject{
    
    var data: ThreadData!
    var message : String = ""
    var statusCode : Int = 0
    var success : Bool = false
    
   
    init(fromDictionary dictionary: [String:Any]){
        if let dataDict = dictionary["data"] as? [String: Any] {
                   self.data = ThreadData(fromDictionary: dataDict)
               }
        message = dictionary["message"] as? String ?? ""
        statusCode = dictionary["statusCode"] as? Int ?? 0
        success = dictionary["success"] as? Bool ?? false
    }
}


class ThreadData : NSObject{
    
    var pagination : [ThreadPagination]
    var threads : [Thread]
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        pagination = [ThreadPagination]()
        if let dataArray = dictionary["pagination"] as? [[String:Any]]{
            for dic in dataArray{
                let value = ThreadPagination(fromDictionary: dic)
                pagination.append(value)
            }
        }
       
        threads = [Thread]()
        if let threadsArray = dictionary["threads"] as? [[String:Any]]{
            for dic in threadsArray{
                let value = Thread(fromDictionary: dic)
                threads.append(value)
            }
        }
    }
}

class ThreadReactions : NSObject {
    var emoji: String = ""
    var users: [ThreadUser] = []
    
    init(fromDictionary dictionary: [String: Any]) {
        self.emoji = dictionary["emoji"] as? String ?? ""
        if let usersArray = dictionary["users"] as? [[String: Any]] {
            self.users = usersArray.map { ThreadUser(fromDictionary: $0) }
        } else {
            self.users = []
        }
    }
}

class Thread: NSObject {

    var attachmentsJson: [Attachment] = []
    var createdAt: String = ""
    var id: Int = 0
    var isEdited: Int = 0
    var lastEditTime: String = ""
    var mentionList: [Mention] = []
    var mentionsJson: String = ""
    var message: String = ""
    var parentId: Int = 0
    var patientUuid: String = ""
    var reactions: [ThreadReactions] = []
    var reactionsJson: [ThreadReactionsJson] = []
    var replies: [ThreadReply] = []
    var updatedAt: String = ""
    var user: ThreadUser?
    var userId: Int = 0
    var isRepliesExpanded: Bool = false
    var repliesToShow = 0 
    
    init(fromDictionary dictionary: [String: Any]) {
        if let attachmentsArray = dictionary["attachments_json"] as? [[String: Any]] {
            attachmentsJson = attachmentsArray.map { Attachment(fromDictionary: $0) }
        } else {
            attachmentsJson = []
        }
        createdAt = dictionary["created_at"] as? String ?? ""
        id = dictionary["id"] as? Int ?? 0
        isEdited = dictionary["is_edited"] as? Int ?? 0
        lastEditTime = dictionary["last_edit_time"] as? String ?? ""
        if let mentionListArray = dictionary["mention_list"] as? [[String: Any]] {
            mentionList = mentionListArray.map { Mention(fromDictionary: $0) }
        } else {
            mentionsJson = dictionary["mentions_json"] as? String ?? ""
        }
        message = dictionary["message"] as? String ?? ""
        parentId = dictionary["parent_id"] as? Int ?? 0
        patientUuid = dictionary["patient_uuid"] as? String ?? ""
        if let reactionsArray = dictionary["reactions"] as? [[String: Any]] {
            for dict in reactionsArray {
                let reaction = ThreadReactions(fromDictionary: dict)
                reactions.append(reaction)
            }
        }
        if let reactionsArray = dictionary["reactions_json"] as? [[String: Any]] {
            for dict in reactionsArray {
                let reaction = ThreadReactionsJson(fromDictionary: dict)
                reactionsJson.append(reaction)
            }
        }

        if let repliesArray = dictionary["replies"] as? [[String: Any]] {
            for dict in repliesArray {
                let reply = ThreadReply(fromDictionary: dict)
                replies.append(reply)
            }
        }

        if let userDict = dictionary["user"] as? [String: Any] {
                   user = ThreadUser(fromDictionary: userDict)
               }

        updatedAt = dictionary["updated_at"] as? String ?? ""
        userId = dictionary["user_id"] as? Int ?? 0
    }
}

class Attachment: NSObject {
    var fileName: String = ""
    var fileOriginalName: String = ""

    init(fromDictionary dictionary: [String: Any]) {
        fileName = dictionary["file_name"] as? String ?? ""
        fileOriginalName = dictionary["file_original_name"] as? String ?? ""
    }
}

class ThreadReply : NSObject{
    
    var attachmentsJson: [Attachment] = []
    var createdAt : String = ""
    var id : Int = 0
    var isEdited : Int = 0
    var lastEditTime : String = ""
    var mentionList : [Mention] = []
    var mentionsJson : String = ""
    var message : String = ""
    var parentId : Int = 0
    var patientUuid : String = ""
    var reactions : [String] = []
    var reactionsJson : [ThreadReactionsJson]
    var updatedAt : String = ""
    var user: ThreadUser?
    var userId : Int = 0
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        if let attachmentsArray = dictionary["attachments_json"] as? [[String: Any]] {
            attachmentsJson = attachmentsArray.map { Attachment(fromDictionary: $0) }
        } else {
            attachmentsJson = []
        }        
        createdAt = dictionary["created_at"] as? String ?? ""
        id = dictionary["id"] as? Int ?? 0
        isEdited = dictionary["is_edited"] as? Int ?? 0
        lastEditTime = dictionary["last_edit_time"] as? String ?? ""
        if let mentionListArray = dictionary["mention_list"] as? [[String: Any]] {
            mentionList = mentionListArray.map { Mention(fromDictionary: $0) }
        } else {
            mentionList = []
        }
        mentionsJson = dictionary["mentions_json"] as? String ?? ""
        message = dictionary["message"] as? String ?? ""
        parentId = dictionary["parent_id"] as? Int ?? 0
        patientUuid = dictionary["patient_uuid"] as? String ?? ""
        reactions = dictionary["reactions"] as? [String] ?? []
        
        reactionsJson = [ThreadReactionsJson]()
        if let dataArray = dictionary["reactions_json"] as? [[String:Any]]{
            for dic in dataArray{
                let value = ThreadReactionsJson(fromDictionary: dic)
                reactionsJson.append(value)
            }
        }
        
        
        if let userDict = dictionary["user"] as? [String: Any] {
                   user = ThreadUser(fromDictionary: userDict)
               }
        
        
        updatedAt = dictionary["updated_at"] as? String ?? ""
        
        userId = dictionary["user_id"] as? Int ?? 0
    }
}

class Mention: NSObject {
    var id: Int = 0
    var name: String = ""

    init(fromDictionary dict: [String: Any]) {
        self.id = dict["id"] as? Int ?? 0
        self.name = dict["name"] as? String ?? ""
    }
}


class ThreadUser : NSObject{
    
    var firstName : String = ""
    var id : Int = 0
    var lastName : String = ""
    var professionalTitle : String = ""
    var profilePic : String = ""
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        firstName = dictionary["first_name"] as? String ?? ""
        id = dictionary["id"] as? Int ?? 0
        lastName = dictionary["last_name"] as? String ?? ""
        professionalTitle = dictionary["professional_title"] as? String ?? ""
        profilePic = dictionary["profile_pic"] as? String ?? ""
    }
    
}
class ThreadReactionsJson : NSObject{
    
    
    init(fromDictionary dictionary: [String:Any]){
    }
    
}

class ThreadPagination : NSObject{
    
    var index : Int = 0
    var perPage : Int = 0
    var total : Int = 0
    var totalPages : Int = 0
    
    
    init(fromDictionary dictionary: [String:Any]){
        index = dictionary["index"] as? Int ?? 0
        perPage = dictionary["per_page"] as? Int ?? 0
        total = dictionary["total"] as? Int ?? 0
        totalPages = dictionary["total_pages"] as? Int ?? 0
    }
    
    
}
