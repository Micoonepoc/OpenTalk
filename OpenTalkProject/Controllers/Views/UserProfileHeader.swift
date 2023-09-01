
import UIKit

class UserProfileHeader: UIView {
    
    private enum SectionTabs: String {
        case posts = "Posts"
        case postsAndReplies = "Posts & Replies"
        case media = "Media"
        case likes = "Likes"
        
        var sectionIndex: Int {
            
            switch self {
            case .posts:
                return 0
            case .postsAndReplies:
                return 1
            case .media:
                return 2
            case .likes:
                return 3
                
            }
        }
    }
    
    private var leadingAnchors: [NSLayoutConstraint] = []
    private var trailingAnchors: [NSLayoutConstraint] = []
    
    
    private let indicator: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .customBluelueColor
        return view
    }()
    
    private var selectedSectionIndex: Int = 0 {
        didSet {
            for i in 0..<tabs.count {
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut ) { [ weak self ] in
                    self?.sectionStack.arrangedSubviews[i].tintColor = i == self?.selectedSectionIndex ? .label : .secondaryLabel
                    self?.leadingAnchors[i].isActive = i == self?.selectedSectionIndex ? true : false
                    self?.trailingAnchors[i].isActive = i == self?.selectedSectionIndex ? true : false
                    self?.layoutIfNeeded()
                } completion: { _ in
                    
                }
            }
        }
    }
    
    private var tabs: [UIButton] = ["Posts", "Posts & Replies", "Media", "Likes"]
        .map { buttonTitle in
            let button = UIButton(type: .system)
            button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
            button.tintColor = .label
            button.setTitle(buttonTitle, for: .normal)
            button.translatesAutoresizingMaskIntoConstraints = false
            return button
        }
    
    private lazy var sectionStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: tabs)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .equalSpacing
        stackView.axis = .horizontal
        stackView.alignment = .center
        return stackView
        
    }()
    
    private let subscribersTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Followers"
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    var subscribersCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textColor = .label
        return label
    }()
    
    private let subscriptionsTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Following"
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    var subscriptionsCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textColor = .label
        return label
    }()
    
    var joinDateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let joinDateImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "calendar", withConfiguration: UIImage.SymbolConfiguration(pointSize: 14))
        imageView.tintColor = .secondaryLabel
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var userInfoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 3
        label.textColor = .label
        return label
    }()
    
    var userNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 18, weight: .regular)
        return label
    }()
    
    var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.textColor = .label
        return label
    }()
    
    var profileAvatarImageView: UIImageView = {
        
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 40
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let profileHeaderImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "Header")
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(profileHeaderImageView)
        addSubview(profileAvatarImageView)
        addSubview(nameLabel)
        addSubview(userNameLabel)
        addSubview(userInfoLabel)
        addSubview(joinDateImageView)
        addSubview(joinDateLabel)
        addSubview(subscriptionsCountLabel)
        addSubview(subscriptionsTextLabel)
        addSubview(subscribersCountLabel)
        addSubview(subscribersTextLabel)
        addSubview(sectionStack)
        addSubview(indicator)
        configureConstraints()
        configureStackButtons()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureStackButtons() {
        for (i , button) in sectionStack.arrangedSubviews.enumerated() {
            guard let button = button as? UIButton else {return}
            
            if i == selectedSectionIndex {
                button.tintColor = .label
            } else {
                button.tintColor = .secondaryLabel
            }
            
            button.addTarget(self, action: #selector(didTapSection(_:)), for: .touchUpInside)
        }
    }
    
    @objc private func didTapSection(_ sender: UIButton) {
        guard let label = sender.titleLabel?.text else { return }
        switch label {
        case SectionTabs.posts.rawValue:
            selectedSectionIndex = 0
        case SectionTabs.postsAndReplies.rawValue:
            selectedSectionIndex = 1
        case SectionTabs.media.rawValue:
            selectedSectionIndex = 2
        case SectionTabs.likes.rawValue:
            selectedSectionIndex = 3
        default:
            selectedSectionIndex = 0
        }
    }
    
    // MARK: Constraints
    
    private func configureConstraints() {
        
        for i in 0..<tabs.count {
            let leadingAnchor = indicator.leadingAnchor.constraint(equalTo: sectionStack.arrangedSubviews[i].leadingAnchor)
            leadingAnchors.append(leadingAnchor)
            let trailingAnchor = indicator.trailingAnchor.constraint(equalTo: sectionStack.arrangedSubviews[i].trailingAnchor)
            trailingAnchors.append(trailingAnchor)
        }
        
        let profileHeaderImageViewConstraints = [
            profileHeaderImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            profileHeaderImageView.topAnchor.constraint(equalTo: topAnchor),
            profileHeaderImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            profileHeaderImageView.heightAnchor.constraint(equalToConstant: 140)
        ]
        
        
        let profileAvatarImageViewConstrainrs = [
            profileAvatarImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            profileAvatarImageView.centerYAnchor.constraint(equalTo: profileHeaderImageView.bottomAnchor, constant: 10),
            profileAvatarImageView.widthAnchor.constraint(equalToConstant: 80),
            profileAvatarImageView.heightAnchor.constraint(equalToConstant: 80)
        ]
        
        
        
        let nameLabelConstraints = [
            nameLabel.leadingAnchor.constraint(equalTo: profileAvatarImageView.leadingAnchor),
            nameLabel.topAnchor.constraint(equalTo: profileAvatarImageView.bottomAnchor, constant: 20)
        ]
        
        let userNameLabelConstraints = [
            userNameLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            userNameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5)
        ]
        
        let userInfoLabelConstraints = [
            userInfoLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            userInfoLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            userInfoLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 5)
        ]
        
        
        let joinDateImageViewConstraints = [
            joinDateImageView.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            joinDateImageView.topAnchor.constraint(equalTo: userInfoLabel.bottomAnchor, constant: 5)
        ]
        
        
        let joinDateLabelConstraints = [
            joinDateLabel.leadingAnchor.constraint(equalTo: joinDateImageView.trailingAnchor, constant: 2),
            joinDateLabel.bottomAnchor.constraint(equalTo: joinDateImageView.bottomAnchor)
        ]
        
        let subscriptionsCountLabelConstraints  = [
            subscriptionsCountLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            subscriptionsCountLabel.topAnchor.constraint(equalTo: joinDateLabel.bottomAnchor, constant: 10)
        ]
        
        let subscriptionsTextLabelConstraints = [
            subscriptionsTextLabel.leadingAnchor.constraint(equalTo: subscriptionsCountLabel.trailingAnchor, constant: 4),
            subscriptionsTextLabel.bottomAnchor.constraint(equalTo: subscriptionsCountLabel.bottomAnchor)
        ]
        
        let subscribersCountLabelConstraints = [
            subscribersCountLabel.leadingAnchor.constraint(equalTo: subscriptionsTextLabel.trailingAnchor, constant: 8),
            subscribersCountLabel.bottomAnchor.constraint(equalTo: subscriptionsCountLabel.bottomAnchor)
        ]
        
        let subscribersTextLabelConstraints = [
            subscribersTextLabel.leadingAnchor.constraint(equalTo: subscribersCountLabel.trailingAnchor, constant: 8),
            subscribersTextLabel.bottomAnchor.constraint(equalTo: subscriptionsCountLabel.bottomAnchor)
        ]
        
        let sectionStackConstraints = [
            sectionStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25),
            sectionStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25),
            sectionStack.topAnchor.constraint(equalTo: subscriptionsCountLabel.bottomAnchor, constant: 5),
            sectionStack.heightAnchor.constraint(equalToConstant: 35)
        ]
        
        let indicatorConstraits = [
            leadingAnchors[0],
            trailingAnchors[0],
            indicator.topAnchor.constraint(equalTo: sectionStack.arrangedSubviews[0].bottomAnchor),
            indicator.heightAnchor.constraint(equalToConstant: 4)
        ]

        NSLayoutConstraint.activate(profileHeaderImageViewConstraints)
        NSLayoutConstraint.activate(profileAvatarImageViewConstrainrs)
        NSLayoutConstraint.activate(nameLabelConstraints)
        NSLayoutConstraint.activate(userNameLabelConstraints)
        NSLayoutConstraint.activate(userInfoLabelConstraints)
        NSLayoutConstraint.activate(joinDateImageViewConstraints)
        NSLayoutConstraint.activate(joinDateLabelConstraints)
        NSLayoutConstraint.activate(subscriptionsCountLabelConstraints)
        NSLayoutConstraint.activate(subscriptionsTextLabelConstraints)
        NSLayoutConstraint.activate(subscribersCountLabelConstraints)
        NSLayoutConstraint.activate(subscribersTextLabelConstraints)
        NSLayoutConstraint.activate(sectionStackConstraints)
        NSLayoutConstraint.activate(indicatorConstraits)
    }
    
}
