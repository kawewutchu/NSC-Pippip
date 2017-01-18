//
//  chatController.swift
//  Pippip
//
//  Created by Kawewut Chujit on 12/31/2559 BE.
//  Copyright © 2559 Kawewut Chujit. All rights reserved.
//

import UIKit
import Firebase
import JSQMessagesViewController
import MobileCoreServices
import AVKit
import AVFoundation
class chatController: JSQMessagesViewController {
    var userChat = User()
    var massage = [JSQMessage]()
    var messageFormSendCheck = false
    
    override func viewDidLoad() {
        massage.removeAll()
        super.viewDidLoad()
        self.senderId = FIRAuth.auth()!.currentUser!.uid
        self.senderDisplayName = "jarb"
        navigationItem.title = userChat.name
        collectionView?.collectionViewLayout.incomingAvatarViewSize = .zero
        collectionView?.collectionViewLayout.outgoingAvatarViewSize = .zero
        observeMessages()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
   
    var messages = [Message]()
    
    func observeMessages() {
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            return
        }
        self.senderId = uid
        let userMessagesRef = FIRDatabase.database().reference().child("user-messages").child(uid)
        userMessagesRef.observe(.childAdded, with: { (snapshot) in
            
            let messageId = snapshot.key
            let messagesRef = FIRDatabase.database().reference().child("messages").child(messageId)
            messagesRef.observeSingleEvent(of: .value, with: { (snapshot) in
                
                guard let dictionary = snapshot.value as? [String: AnyObject] else {
                    return
                }
                
                let message = Message()
                message.setValuesForKeys(dictionary)
            
                var chatPartnerId =  message.chatPartnerId()
                if chatPartnerId == self.userChat.id && !self.messageFormSendCheck{
                   self.messages.append(message)
                   let text = message.text
                    if(self.senderId == message.fromId){
                        print(message.fromId)
                        self.massage.append(JSQMessage(senderId: message.fromId, displayName: "1", text: text))
                    }else{
                        print(message.fromId)
                        self.massage.append(JSQMessage(senderId: message.fromId, displayName: "1", text: text))
                    }
                    
                    DispatchQueue.main.async{
                        self.collectionView.reloadData()
                    }
                }
                
            }, withCancel: nil)
            
        }, withCancel: nil)
    }
    
    
    private func setupOutgoingBubble() -> JSQMessagesBubbleImage {
        let bubbleImageFactory = JSQMessagesBubbleImageFactory()
        return bubbleImageFactory!.outgoingMessagesBubbleImage(with: UIColor(red:255.0/255.0, green: 159.0/255.0, blue: 28/255.0, alpha: 1.0))
    }
    
    private func setupIncomingBubble() -> JSQMessagesBubbleImage {
        let bubbleImageFactory = JSQMessagesBubbleImageFactory()
        return bubbleImageFactory!.incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())
    }
    
    
    lazy var outgoingBubbleImageView: JSQMessagesBubbleImage = self.setupOutgoingBubble()
    lazy var incomingBubbleImageView: JSQMessagesBubbleImage = self.setupIncomingBubble()
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let message = massage[indexPath.item] // 1
        print(message.senderId)
        print(senderId)
        if message.senderId == senderId { // 2
            return outgoingBubbleImageView
        } else { // 3
            return incomingBubbleImageView
        }
    }
    
    func collectionView(collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageAvatarImageDataSource? {
        return nil
    }
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        print(text)
        
        collectionView.reloadData()
        massage.append(JSQMessage(senderId: senderId, displayName: senderDisplayName, text: text))
        
        messageFormSendCheck = true
        let ref = FIRDatabase.database().reference().child("messages")
        let childRef = ref.childByAutoId()
        let toId = userChat.id
        let fromId = FIRAuth.auth()!.currentUser!.uid
        let timestamp = Int(Date().timeIntervalSince1970)
        let values = ["text": text, "toId": toId, "fromId": fromId, "timestamp": timestamp] as [String : Any]
       
        childRef.updateChildValues(values) { (error, ref) in
            if error != nil {
                print(error)
                return
            }
            
            let userMessagesRef = FIRDatabase.database().reference().child("user-messages").child(fromId)
            
            let messageId = childRef.key
            userMessagesRef.updateChildValues([messageId: 1])
            
            let recipientUserMessagesRef = FIRDatabase.database().reference().child("user-messages").child(toId!)
            recipientUserMessagesRef.updateChildValues([messageId: 1])
            
        }
        
        self.finishSendingMessage()
        
     
    }
    
    override func didPressAccessoryButton(_ sender: UIButton!) {
        let sheet = UIAlertController(title: "Media Massage", message: "Please selecta media", preferredStyle: UIAlertControllerStyle.actionSheet)
        let cancel = UIAlertAction(title: "cancle", style: UIAlertActionStyle.cancel) { (UIAlertAction) in
            
        }
        
        let photo = UIAlertAction(title: "Photo Libary", style: UIAlertActionStyle.default) { (UIAlertAction) in
            self.getMediaPicker(type: kUTTypeImage)
        }
        
        let vedio = UIAlertAction(title: "Vedio Libare", style: UIAlertActionStyle.default) { (UIAlertAction) in
            self.getMediaPicker(type: kUTTypeMovie)
        }
        
        sheet.addAction(photo)
        sheet.addAction(vedio)
        sheet.addAction(cancel)
        self.present(sheet, animated: true, completion: nil)

    }
    func getMediaPicker(type: CFString){
        let MediaPicker = UIImagePickerController()
        MediaPicker.delegate = self
        MediaPicker.mediaTypes = [type as String]
        self.present(MediaPicker, animated: true, completion: nil)
    }
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return massage[indexPath.item]
    }
    
//    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
//        let bubble = JSQMessagesBubbleImageFactory()
//        return bubble?.outgoingMessagesBubbleImage(with: .blue)
//    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        return nil
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return massage.count
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, didTapMessageBubbleAt indexPath: IndexPath!) {
        let messages = massage[indexPath.item]
        if messages.isMediaMessage{
            if let mediaItem = messages.media as? JSQVideoMediaItem{
                let player = AVPlayer(url: mediaItem.fileURL)
                let playerController = AVPlayerViewController()
                playerController.player = player
                self.present(playerController, animated: true, completion: nil)
            }
        }
 
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        self.scrollToBottom(animated: true)
        return cell
        
    }
    
      /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension chatController: UIImagePickerControllerDelegate , UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let picture = info[UIImagePickerControllerOriginalImage] as? UIImage {
            let photo = JSQPhotoMediaItem(image: picture)
            massage.append(JSQMessage(senderId: senderId, displayName: senderDisplayName, media: photo))

        }else if let video =  info[UIImagePickerControllerMediaURL] as? NSURL{
            let videoItem = JSQVideoMediaItem(fileURL: video as URL!, isReadyToPlay: true)
            massage.append(JSQMessage(senderId: senderId, displayName: senderDisplayName, media: videoItem))

        }
        self.dismiss(animated: true,completion: nil)
        collectionView.reloadData()
        
    }
}
