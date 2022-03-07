//
//  PostListController.swift
//  CorrectMVC
//
//  Created by Miras Karazhigitov on 06.03.2022.
//

import UIKit
import Combine

final class PostListController: BaseViewController<PostListModel, PostListView> {
    private var posts: [Post] = [] {
        didSet {
            DispatchQueue.main.async {
                self.typeSafeView.collectionView.reloadData()
            }
        }
    }

    private var bag = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()

        typeSafeView.collectionView.delegate = self
        typeSafeView.collectionView.dataSource = self
        typeSafeView.collectionView.register(PostListCell.self)
        model.$state
            .sink { state in
                switch state {
                case .list(let posts):
                    self.posts = posts
                case .error:
                    break
                }
            }
            .store(in: &bag)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        model.fetchPosts()
    }
}

extension PostListController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: PostListCell = collectionView.dequeueCell(for: indexPath)
        var config = UIListContentConfiguration.valueCell()
        let post = posts[indexPath.row]
        config.text = post.title

        switch post.type {
        case .image(let url):
            config.image = UIImage(contentsOfFile: url.path)
        case .text(let text):
            config.secondaryText = text
        }

        cell.contentConfiguration = config
        
        return cell
    }
}

extension PostListController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        model.onItemSelect?(posts[indexPath.item])
    }
}