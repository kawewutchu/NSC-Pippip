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
 
    var massage = [JSQMessage]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.senderId = "1"
        self.senderDisplayName = "jarb"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        print(text)
        collectionView.reloadData()
        massage.append(JSQMessage(senderId: senderId, displayName: senderDisplayName, text: text))
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
        print("kuy")
    }
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return massage[indexPath.item]
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let bubble = JSQMessagesBubbleImageFactory()
        return bubble?.outgoingMessagesBubbleImage(with: .blue)
    }
    
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
