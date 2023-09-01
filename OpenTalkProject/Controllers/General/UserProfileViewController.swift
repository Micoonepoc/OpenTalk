
import UIKit
import Combine
import SDWebImage

class UserProfileViewController: UIViewController {
    
    private var statusBarIsHidden: Bool = true
    private var viewModel = ProfileViewViewModel()
    private var subscriptions: Set<AnyCancellable> = []
    
    private let statusBar: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.opacity = 0
        return view
        
    }()
    
    private let userProfileTableView: UITableView = {
        let userProfileTableView = UITableView()
        userProfileTableView.register(PostsTableViewCell.self, forCellReuseIdentifier: PostsTableViewCell.identifier)
        userProfileTableView.translatesAutoresizingMaskIntoConstraints = false
        return userProfileTableView
    }()
    
    private lazy var userHeaderView = UserProfileHeader(frame: CGRect(x: 0, y: 0, width: userProfileTableView.frame.width, height: 380))

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        navigationItem.title = "Profile"
        view.addSubview(userProfileTableView)
        view.addSubview(statusBar)
        
        navigationController?.navigationBar.isHidden = true
        
        userProfileTableView.delegate = self
        userProfileTableView.dataSource = self
        userProfileTableView.tableHeaderView = userHeaderView
        userProfileTableView.contentInsetAdjustmentBehavior = .never
        configureConstraints()
        bindViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.retreiveUser()
    }
    
  
    
    // MARK: Functions
    
    private func bindViews() {
        viewModel.$user.sink { [weak self] user in
            guard let user = user else { return }
            self?.userHeaderView.nameLabel.text = user.displayName
            self?.userHeaderView.userNameLabel.text = "@\(user.userName)"
            self?.userHeaderView.subscribersCountLabel.text = "\(user.followersCount)"
            self?.userHeaderView.subscriptionsCountLabel.text = "\(user.followingCount)"
            self?.userHeaderView.userInfoLabel.text = "\(user.bio)"
            self?.userHeaderView.profileAvatarImageView.sd_setImage(with: URL(string: user.avatarPath))
            self?.userHeaderView.joinDateLabel.text = "Joined \(self?.viewModel.getFormattedDate(with:user.createdOn) ?? "")"
        }
        .store(in: &subscriptions)
        
        viewModel.$posts.sink { [weak self] _ in
            DispatchQueue.main.async {
                self?.sortAndReloadTableView()
            }
        } .store(in: &subscriptions)
        
        
    }
    
    func sortAndReloadTableView() {
        viewModel.posts.sort { $0.postCreationDate > $1.postCreationDate }
        userProfileTableView.reloadData()
    }
    
    private func configureConstraints() {
        
        let userProfileTableViewConstraints = [
            userProfileTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            userProfileTableView.topAnchor.constraint(equalTo: view.topAnchor),
            userProfileTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            userProfileTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        
        let statusBarConstraints = [
            statusBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            statusBar.topAnchor.constraint(equalTo: view.topAnchor),
            statusBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            statusBar.heightAnchor.constraint(equalToConstant: view.bounds.height > 800 ? 40 : 20)
        ]
        
        NSLayoutConstraint.activate(userProfileTableViewConstraints)
        NSLayoutConstraint.activate(statusBarConstraints)
    }
    
}

extension UserProfileViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = userProfileTableView.dequeueReusableCell(withIdentifier: PostsTableViewCell.identifier, for: indexPath) as? PostsTableViewCell else {
            return UITableViewCell()
        }
        let postModel = viewModel.posts[indexPath.row]
        cell.configurePost(with: postModel.author.displayName,
                            username: postModel.author.userName,
                            tweetTextContent: postModel.postContent,
                           avatarPath: postModel.author.avatarPath,
                           postCreationDate: postModel.postCreationDate)
        cell.delegate = self
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yPosition = scrollView.contentOffset.y
        
        if yPosition > 140 && statusBarIsHidden {
            statusBarIsHidden = false
            UIView.animate(withDuration: 0.1, delay: 0, options: .curveLinear) { [weak self] in
                self?.statusBar.layer.opacity = 1
            } completion: { _ in }

        } else if yPosition < 0 && !statusBarIsHidden {
            statusBarIsHidden = true
            UIView.animate(withDuration: 0.1, delay: 0, options: .curveLinear) { [weak self] in
                self?.statusBar.layer.opacity = 0
            } completion: { _ in }
        }
    }
}

extension UserProfileViewController: PostsTableViewCellDelegate {
    func postTableViewCellDidTapLike() {
        print("like")
    }
    
    func postTableViewCellDidTapRepost() {
        print("repost")
    }
    
    func postTableViewCellDidTapShare() {
        print("share")
    }
    
    func postTableViewCellDidTapReply() {
        print("reply")
    }
    
    
}
