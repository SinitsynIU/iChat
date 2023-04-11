//
//  ListChatsViewController.swift
//  iChat
//
//  Created by Илья Синицын on 05.07.2022.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class ListChatsViewController: UIViewController {
    
    var activeChats = [MChat]()
    var waitingChats = [MChat]()
    
    private var waitingChatsListener: ListenerRegistration?
    private var activeChatsListener: ListenerRegistration?
    
    enum Section: Int, CaseIterable {
        case waitingChats
        case activeChats
        
        func description() -> String {
            switch self {
            case .waitingChats:
                return "Waiting chats"
            case .activeChats:
                return "Active chats"
            }
        }
    }
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, MChat>?
    
    private let currentUser: MUser
    
    init(currentUser: MUser) {
        self.currentUser = currentUser
        super.init(nibName: nil, bundle: nil)
        title = currentUser.userName
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupSearchBar()
        setupCollectionView()
        ceateDataSource()
        reloadData()
        setupActions()
        
        waitingChatsListener = ListenerServiceManager.shared.waitingChatsObserve(chats: waitingChats, completion: { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let chats):
                if self.waitingChats != [], self.waitingChats.count <= chats.count {
                    let requestChatVC = RequestChatViewController(chat: chats.last!)
                    requestChatVC.delegate = self
                    self.present(requestChatVC, animated: true, completion: nil)
                }
                self.waitingChats = chats
                self.reloadData()
                self.collectionView.reloadData()
            case .failure(let error):
                self.showAlert(titel: "Error!", message: error.localizedDescription)
            }
        })
        
        activeChatsListener = ListenerServiceManager.shared.activeChatsObserve(chats: activeChats, completion: { [weak self] (result) in
            guard let self else { return }
            switch result {
            case .success(let chats):
                self.activeChats = chats
                self.reloadData()
                self.collectionView.reloadData()
            case .failure(let error):
                self.showAlert(titel: "Error!", message: error.localizedDescription)
            }
        })
        
        subscribeToKeyboardShowHide()
        dismissKey()
    }
    
    deinit {
        waitingChatsListener?.remove()
        activeChatsListener?.remove()
        unsubscribeToKeyboardShowHide()
    }
}

// MARK: - SetupActions
extension ListChatsViewController {
    
    private func setupActions() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Log Out", style: .plain, target: self, action: #selector(signOutButtonAction))
    }
    
    @objc private func signOutButtonAction() {
        let alertController = UIAlertController(title: nil, message: "Are you sure you want to sign out?", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "Sign Out", style: .destructive, handler: { (_) in
            do {
                try Auth.auth().signOut()
                UIApplication.shared.keyWindow?.rootViewController = AuthViewController()
            } catch {
                print("Error signing out \(error.localizedDescription)")
            }
        }))
        present(alertController, animated: true, completion: nil)
    }
}

// MARK: - UICollectionViewDelegate
extension ListChatsViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let chat = self.dataSource?.itemIdentifier(for: indexPath) else { return }
        guard let section = Section(rawValue: indexPath.section) else { return }
        
        switch section {
        case .waitingChats:
            let requestChatVC = RequestChatViewController(chat: chat)
            requestChatVC.delegate = self
            self.present(requestChatVC, animated: true, completion: nil)
        case .activeChats:
            let chatVC = ChatsViewController(user: currentUser, chat: chat)
            navigationController?.pushViewController(chatVC, animated: true)
        }
    }
}

// MARK: - ProtocolWaitingChatsNavigation
extension ListChatsViewController: ProtocolWaitingChatsNavigation {
    
    func removeWaitingChat(chat: MChat) {
        FirestoreServiceManager.shared.deleteWaitingChat(chat: chat, completion: { [weak self] (result) in
            guard let self else { return }
            switch result {
            case .success:
                print("Success! Chat with \(chat.friendUserName) was removed.")
            case .failure(let error):
                self.showAlert(titel: "Error!", message: error.localizedDescription)
            }
        })
    }
    
    func chatToActive(chat: MChat) {
        FirestoreServiceManager.shared.changeToActive(chat: chat) { [weak self] (result) in
            guard let self else { return }
            switch result {
            case .success:
                print("Success! Pleasant communication with \(chat.friendUserName).")
            case .failure(let error):
                self.showAlert(titel: "Error!", message: error.localizedDescription)
            }
        }
    }
}

// MARK: - SetupUI
extension ListChatsViewController {
    
    private func setupUI() {
        view.backgroundColor = .white
    }
}

// MARK: - SetupCollectionView
extension ListChatsViewController {
    
    private func setupCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .myWhite
        
        view.addSubview(collectionView)
        
        collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeader.reuseId)
        
        collectionView.register(ActiveChatCell.self, forCellWithReuseIdentifier: ActiveChatCell.reuseId)
        collectionView.register(WaitingChatCell.self, forCellWithReuseIdentifier: WaitingChatCell.reuseId)
        
        collectionView.delegate = self
    }
    
    private func reloadData() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, MChat>()
        
        snapshot.appendSections([.waitingChats, .activeChats])
        snapshot.appendItems(waitingChats, toSection: .waitingChats)
        snapshot.appendItems(activeChats, toSection: .activeChats)
        
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
}

// MARK: - SetupCollectionViewDataSource
extension ListChatsViewController {
    
    private func ceateDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, MChat>(collectionView: collectionView, cellProvider: { [weak self] collectionView, indexPath, itemIdentifier in
            guard let self else { return UICollectionViewCell() }
            guard let section = Section(rawValue: indexPath.section) else { fatalError("Unknown section kind") }
            
            switch section {
            case .activeChats:
                return self.configurationCell(collectionView: collectionView, cellType: ActiveChatCell.self, with: itemIdentifier, for: indexPath)
            case .waitingChats:
                return self.configurationCell(collectionView: collectionView, cellType: WaitingChatCell.self, with: itemIdentifier, for: indexPath)
            }
        })
        
        dataSource?.supplementaryViewProvider = {
            [weak self] collectionView, kind, indexPath in
            guard let self else { return UICollectionReusableView() }
            guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeader.reuseId, for: indexPath) as? SectionHeader else { fatalError("Can not create new section header") }
            guard let section = Section(rawValue: indexPath.section) else { fatalError("Unknown section kind") }
                    
            sectionHeader.configurationSectionHeader(text: section.description(), font: .laoSangamMN20, textColor: .myDarkGray)
            
            return  sectionHeader
        }
    }
}

// MARK: - SetupCollectionViewLayout
extension ListChatsViewController {
    
    private func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (senctionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            
            guard let section = Section(rawValue: senctionIndex) else { fatalError("Unknown section kind")}
            
            switch section {
            case .activeChats:
                return self.createActiveChatsSections()
            case .waitingChats:
                return self.createWaitingChatsSections()
            }
        }
        
        let configurationLayout = UICollectionViewCompositionalLayoutConfiguration()
        configurationLayout.interSectionSpacing = 20
        layout.configuration = configurationLayout
        
        return layout
    }
    
    private func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let sectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                       heightDimension: .estimated(1))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: sectionHeaderSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        
        return sectionHeader
    }
    
    private func createActiveChatsSections() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .absolute(78))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 8
        section.contentInsets = NSDirectionalEdgeInsets.init(top: 16, leading: 20, bottom: 0, trailing: 20)
        
        let sectionHeader = createSectionHeader()
        section.boundarySupplementaryItems = [sectionHeader]
        
        return section
    }
    
    private func createWaitingChatsSections() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(88),
                                               heightDimension: .absolute(88))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 20
        section.contentInsets = NSDirectionalEdgeInsets.init(top: 16, leading: 20, bottom: 0, trailing: 20)
        section.orthogonalScrollingBehavior = .continuous
        
        let sectionHeader = createSectionHeader()
        section.boundarySupplementaryItems = [sectionHeader]
        
        return section
    }
}

// MARK: - SetupSearchBar & UISearchBarDelegate
extension ListChatsViewController: UISearchBarDelegate {
    
    private func setupSearchBar() {
        navigationController?.navigationBar.barTintColor = .myWhite
        navigationController?.navigationBar.shadowImage = UIImage()
        
        let searchController = UISearchController(searchResultsController: nil)
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        
        searchController.searchBar.delegate = self
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        reloadData()
    }
}

// MARK: - SwiftUI
import SwiftUI

struct ListViewControllerProvider: PreviewProvider {
    static var previews: some  View {
        
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        
        let viewController = MainTabBarController()
         
        func makeUIViewController(context: Context) -> some UIViewController {
            return viewController
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        }
    }
}
