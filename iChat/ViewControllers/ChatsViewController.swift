//
//  ChatsViewController.swift
//  iChat
//
//  Created by Илья Синицын on 08.08.2022.
//

import UIKit
import MessageKit
import InputBarAccessoryView
import FirebaseFirestore
import Photos
import AVFoundation

class ChatsViewController: MessagesViewController {

    private let user: MUser
    private let chat: MChat
    private var messages:[MMessage] = []
    
    private var messageListener: ListenerRegistration?
    private var imagePickerController = UIImagePickerController()
    
    init (user:MUser, chat: MChat) {
        self.user = user
        self.chat = chat
        super.init(nibName: nil, bundle: nil)
        
        title = chat.friendUserName
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let layout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout {
            layout.textMessageSizeCalculator.outgoingAvatarSize = .zero
            layout.textMessageSizeCalculator.incomingAvatarSize = .zero
            layout.photoMessageSizeCalculator.incomingAvatarSize = .zero
            layout.photoMessageSizeCalculator.outgoingAvatarSize = .zero
        }
        
        configureMessageInputBar()
        messagesCollectionView.showsVerticalScrollIndicator = false
        messagesCollectionView.showsHorizontalScrollIndicator = false
        messagesCollectionView.backgroundColor = .myWhite
        messageInputBar.delegate = self
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messagesLayoutDelegate = self
        
        imagePickerController.delegate = self
        
        messageListener = ListenerServiceManager.shared.messagesObserve(chat: chat, completion: { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(var message):
                if let url = message.downloadUrl {
                    StorageServiceManager.shared.downloadImage(url: url) { result in
                        switch result {
                        case .success(let image):
                            message.image = image
                            self.insertNewMessage(message: message)
                        case .failure(let error):
                            self.showAlert(titel: "Error", message: error.localizedDescription)
                        }
                    }
                } else {
                    self.insertNewMessage(message: message)
                }
            case .failure(let error):
                self.showAlert(titel: "Error", message: error.localizedDescription)
            }
        })
        
        subscribeToKeyboardShowHideChatsViewController()
    }
    
    deinit {
        messageListener?.remove()
        unsubscribeToKeyboardShowHide()
    }
    
    func subscribeToKeyboardShowHideChatsViewController() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShowChatsViewController), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHideChatsViewController), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer( target: self, action: #selector(dismissKeyboardChatsViewController))
        tap.cancelsTouchesInView = false
        self.messagesCollectionView.addGestureRecognizer(tap)
    }
    
    @objc func keyboardWillShowChatsViewController(notification: Notification) {
        let info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        self.messagesCollectionView.frame.origin.y = -keyboardFrame.size.height
    }
    
    @objc func keyboardWillHideChatsViewController(notification: Notification) {
        
        self.messagesCollectionView.frame.origin.y = 0
    }
    
    @objc func dismissKeyboardChatsViewController() {
        self.messageInputBar.inputTextView.endEditing(true)
        self.messageInputBar.inputTextView.resignFirstResponder()
    }
    
    private func insertNewMessage(message: MMessage) {
        guard !messages.contains(message) else { return }
        messages.append(message)
        messages.sort()
        
        let isLatestMessage = messages.firstIndex(of: message) == (messages.count - 1)
        let shouldScrollToBottom = messagesCollectionView.isAtBottom && isLatestMessage
        
        messagesCollectionView.reloadData()
        
        if shouldScrollToBottom {
            DispatchQueue.main.async {
                self.messagesCollectionView.scrollToLastItem(at: .bottom, animated: true)
            }
        }
    }
    
    private func sendPhoto(image: UIImage) {
        StorageServiceManager.shared.uploadImageMessage(image: image, to: chat) { result in
            switch result {
            case .success(let url):
                var message = MMessage(user: self.user, image: image)
                message.downloadUrl = url
                FirestoreServiceManager.shared.sendMessage(chat: self.chat, message: message) { [weak self] result in
                    guard let self else { return }
                    switch result {
                    case .success():
                        self.messagesCollectionView.scrollToLastItem(at: .bottom, animated: true)
                    case .failure(let error):
                        self.showAlert(titel: "Error", message: error.localizedDescription)
                    }
                }
            case .failure(let error):
                self.showAlert(titel: "Error", message: error.localizedDescription)
            }
        }
    }
}

// MARK: - ConfigureMessageInputBar
extension ChatsViewController {
   private func configureMessageInputBar() {
        messageInputBar.isTranslucent = true
        messageInputBar.separatorLine.isHidden = true
        messageInputBar.backgroundView.backgroundColor = .myWhite
        messageInputBar.inputTextView.backgroundColor = .white
        messageInputBar.inputTextView.showsHorizontalScrollIndicator = false
        messageInputBar.inputTextView.showsVerticalScrollIndicator = false
        messageInputBar.inputTextView.placeholderTextColor = #colorLiteral(red: 0.7411764706, green: 0.7411764706, blue: 0.7411764706, alpha: 1)
        messageInputBar.inputTextView.textContainerInset = UIEdgeInsets(top: 14, left: 14, bottom: 14, right: 50)
        messageInputBar.inputTextView.placeholderLabelInsets = UIEdgeInsets(top: 14, left: 21, bottom: 14, right: 36)
        messageInputBar.inputTextView.layer.borderColor = #colorLiteral(red: 0.7411764706, green: 0.7411764706, blue: 0.7411764706, alpha: 0.4033635232)
        messageInputBar.inputTextView.layer.borderWidth = 0.2
        messageInputBar.inputTextView.layer.cornerRadius = 18.0
        messageInputBar.inputTextView.layer.masksToBounds = true

        messageInputBar.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        messageInputBar.layer.shadowRadius = 5
        messageInputBar.layer.shadowOpacity = 0.3
        messageInputBar.layer.shadowOffset = CGSize(width: 0, height: 4)
            
        configureSendButton()
        configureCameraButton()
    }
        
    private func configureSendButton() {
        messageInputBar.sendButton.title = nil
        let sentImage = UIImage(named: "sent")
        messageInputBar.sendButton.setImage(sentImage, for: .normal)
        messageInputBar.sendButton.setSize(CGSize(width: 48, height: 48), animated: false)
        messageInputBar.middleContentViewPadding.right = -54
    }
    
    private func configureCameraButton() {
        let cameraItem = InputBarButtonItem(type: .system)
        cameraItem.tintColor = .myPurple
        let cameraImage = UIImage(systemName: "camera")
        cameraItem.image = cameraImage
        
        cameraItem.addTarget(self, action: #selector(cameraButtonAction), for: .primaryActionTriggered)
        
        cameraItem.setSize(CGSize(width: 60, height: 30), animated: false)
        
        messageInputBar.leftStackView.alignment = .center
        messageInputBar.setLeftStackViewWidthConstant(to: 50, animated: false)
        messageInputBar.setStackViewItems([cameraItem], forStack: .left, animated: false)
    }
    
// MARK: - CameraButtonAction
    @objc func cameraButtonAction() {
        self.showActionSheetAlert(titel: "Photo Source", message: "Choose a Source", titleActionFirst: "Photo Library", titleActionSecond: "Camera") { [weak self] sourceType in
            guard let self else { return }
            switch sourceType {
            case .photoLibrary:
                self.presentImagePicker(sourceType: .photoLibrary)
            case .camera:
                self.presentImagePicker(sourceType: .camera)
            }
        }
    }
    
    private func presentImagePicker(sourceType: UIImagePickerController.SourceType) {
        self.imagePickerController.sourceType = sourceType
        
        if sourceType == .photoLibrary {
            
            let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
            switch photoAuthorizationStatus {
            case .authorized:
                self.present(imagePickerController, animated: true, completion: nil)
            case .notDetermined:
                PHPhotoLibrary.requestAuthorization { (newStatus) in
                    DispatchQueue.main.async {
                        if newStatus == .authorized {
                            self.present(self.imagePickerController, animated: true, completion: nil)
                        }else{
                            self.showAlert(titel: "Alert", message: "Access to denied library.")
                        }
                    }
                }
                break
            case .restricted:
                break
            case .denied:
                self.showAlert(titel: "Alert", message: "Access to denied library.")
            case .limited:
                break
            @unknown default:
                break
            }
        } else {
            
            let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
            switch cameraAuthorizationStatus {
            case .authorized:
                self.present(self.imagePickerController, animated: true, completion: nil)
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: .video) { (newStatus) in
                    DispatchQueue.main.async {
                        if newStatus {
                            self.present(self.imagePickerController, animated: true, completion: nil)
                        }else{
                            self.showAlert(titel: "Alert", message: "Access to denied camera.")
                        }
                    }
                }
            case .restricted:
                break
            case .denied:
                self.showAlert(titel: "Alert", message: "Access to denied camera.")
            @unknown default:
                break
            }
        }
    }
}

// MARK: - MessagesDataSource
extension ChatsViewController: MessagesDataSource {
    var currentSender: SenderType {
        return MKSender(senderId: user.uid, displayName: user.userName)
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.item]
    }
    
    func numberOfItems(inSection section: Int, in messagesCollectionView: MessagesCollectionView) -> Int {
        messages.count
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return 1
    }
    
    func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        if indexPath.item % 4 == 0 {
            return NSAttributedString(string: MessageKitDateFormatter.shared.string(from: message.sentDate), attributes: [
                NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 10),
                NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        } else {
            return nil
        }
    }
}

// MARK: - MessagesLayoutDelegate
extension ChatsViewController: MessagesLayoutDelegate {
    func footerViewSize(for section: Int, in messagesCollectionView: MessagesCollectionView) -> CGSize {
        return CGSize(width: 0, height: 8)
    }
    
    func cellTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        if indexPath.item % 4 == 0 {
            return 30
        } else {
            return 0
        }
    }
}

// MARK: - MessagesDisplayDelegate
extension ChatsViewController: MessagesDisplayDelegate {
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? .white : .myBlack
    }
    
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? .black : .white
    }
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        avatarView.isHidden = true
    }
    
    func avatarSize(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGSize? {
        return .zero
    }
    
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        return .bubble
    }
}

// MARK: - InputBarAccessoryViewDelegate
extension ChatsViewController: InputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        let message = MMessage(user: user, content: text)
        FirestoreServiceManager.shared.sendMessage(chat: chat, message: message) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success():
                self.messagesCollectionView.scrollToLastItem(at: .bottom, animated: true)
            case .failure(let error):
                self.showAlert(titel: "Error", message: error.localizedDescription)
            }
        }
        inputBar.inputTextView.text = ""
    }
}

// MARK: - UINavigationControllerDelegate, UIImagePickerControllerDelegate
extension ChatsViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image  = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }

        sendPhoto(image: image)
    }
}
