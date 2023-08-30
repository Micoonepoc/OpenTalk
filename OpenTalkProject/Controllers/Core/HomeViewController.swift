import UIKit
import FirebaseAuth
import Combine

class HomeViewController: UIViewController {
    
    private lazy var composePostButton: UIButton = {
        
        let button = UIButton(type: .system, primaryAction: UIAction { [weak self] _ in
            self?.navigateToPostCompose()
        })
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .customBluelueColor
        button.tintColor = .white
        let plusSign = UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 18, weight: .bold))
        button.setImage(plusSign, for: .normal)
        button.layer.cornerRadius = 30
        button.clipsToBounds = false
        return button
    }()
    
    private var viewModel = HomeViewViewModel()
    private var subscriptions: Set<AnyCancellable> = []

    private let homeFeedTableView: UITableView = {
        let homeFeedTableView = UITableView()
        homeFeedTableView.register(PostsTableViewCell.self, forCellReuseIdentifier: PostsTableViewCell.identifier)
        return homeFeedTableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(homeFeedTableView)
        view.addSubview(composePostButton)
        homeFeedTableView.delegate = self
        homeFeedTableView.dataSource = self
        configureNavBar()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "rectangle.portrait.and.arrow.right"), style: .plain, target: self, action: #selector(didTapSignOut))
        bindViews()
        configureConstraints()
    }
    
    
    
    // MARK: Functions
    
    @objc private func didTapSignOut() {
       try? Auth.auth().signOut()
        handleAuth()
    }
    
    func completeUserOnBoarding() {
        let vc = ProfileDataFormViewController()
        present(vc, animated: true)
    }
    
    func bindViews() {
        viewModel.$user.sink { [weak self] user in
            guard let user = user else { return }
            if !user.isUserOnBoarded {
                self?.completeUserOnBoarding()
            }
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
        homeFeedTableView.reloadData()
    }

    
    func configureNavBar() {
        let size: CGFloat = 36
        let logoImage = UIImageView(frame: CGRect(x: 0, y: 0, width: size, height: size))
        logoImage.contentMode = .scaleAspectFill
        logoImage.image = UIImage(named: "app-logo")
        logoImage.tintColor = .white
        
        let centreView = UIView(frame: CGRect(x: 0, y: 0, width: size, height: size))
        centreView.addSubview(logoImage)
        navigationItem.titleView = centreView
        
        let profileImage = UIImage(systemName: "person")
        profileImage?.withTintColor(.white)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: profileImage, style: .plain, target: self, action: #selector(profileButtonTapped))
    }
    
    @objc private func profileButtonTapped() {
        
        let vc = UserProfileViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeFeedTableView.frame = view.frame
    }
    
    private func handleAuth() {
        if Auth.auth().currentUser == nil {
            let vc = UINavigationController(rootViewController: OnboardingViewController())
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        handleAuth()
        viewModel.retreiveUser()
    }
    
    private func configureConstraints() {
        let composePostButtonConstraints = [
            composePostButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            composePostButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -120),
            composePostButton.widthAnchor.constraint(equalToConstant: 60),
            composePostButton.heightAnchor.constraint(equalToConstant: 60)
        ]
        NSLayoutConstraint.activate(composePostButtonConstraints)
    }
    
    private func navigateToPostCompose() {
        let vc = UINavigationController(rootViewController: PostComposeViewController())
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = homeFeedTableView.dequeueReusableCell(withIdentifier: PostsTableViewCell.identifier, for: indexPath) as? PostsTableViewCell else {
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
    
    
}

extension HomeViewController: PostsTableViewCellDelegate {
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
