
import UIKit


protocol PostsTableViewCellDelegate: AnyObject {
    
    func postTableViewCellDidTapLike()
    func postTableViewCellDidTapRepost()
    func postTableViewCellDidTapShare()
    func postTableViewCellDidTapReply()

}

class PostsTableViewCell: UITableViewCell {

    static let identifier = "PostsTableViewCell"
    
    weak var delegate: PostsTableViewCellDelegate?
    
    private let actionSpacing: CGFloat = 60
    private let avatarImageView: UIImageView = {      
       
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 25
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        imageView.backgroundColor = .green
        return imageView
    }()
    
    
    private let displayNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let postTextContentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
        
    }()
    
    private let replyButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "bubble.left"), for: .normal)
        button.tintColor = .systemGray2
        return button
    }()
    
    
    private let repostButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "arrow.2.squarepath"), for: .normal)
        button.tintColor = .systemGray2
        return button
    }()
    
    private let likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.tintColor = .systemGray2
        return button
    }()
    
    
    private let shareButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "arrowshape.turn.up.left"), for: .normal)
        button.tintColor = .systemGray2
        return button
    }()
    
    private let postCreationDateLabel: UILabel = {
            let label = UILabel()
            label.textColor = .secondaryLabel
            label.font = .systemFont(ofSize: 14, weight: .regular)
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(avatarImageView)
        contentView.addSubview(displayNameLabel)
        contentView.addSubview(usernameLabel)
        contentView.addSubview(postTextContentLabel)
        contentView.addSubview(replyButton)
        contentView.addSubview(repostButton)
        contentView.addSubview(likeButton)
        contentView.addSubview(shareButton)
        contentView.addSubview(postCreationDateLabel)
        configureConstraints()
        buttonsAction()
     
    }
    
    @objc private func replyButtonTapped() {
        delegate?.postTableViewCellDidTapReply()
    }
    
    @objc private func shareButtonTapped() {
        delegate?.postTableViewCellDidTapShare()
    }
    
    @objc private func likeButtonTapped() {
        delegate?.postTableViewCellDidTapLike()
    }
    
    @objc private func repostButtonTapped() {
        delegate?.postTableViewCellDidTapRepost()
    }
    
    private func buttonsAction() {
        replyButton.addTarget(self, action: #selector(replyButtonTapped), for: .touchUpInside)
        shareButton.addTarget(self, action: #selector(shareButtonTapped), for: .touchUpInside)
        likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        repostButton.addTarget(self, action: #selector(repostButtonTapped), for: .touchUpInside)
    }
    
    func configurePost(with displayName: String, username: String, tweetTextContent: String, avatarPath: String, postCreationDate: Date) {
        let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMM HH:mm"
        displayNameLabel.text = displayName
        usernameLabel.text = "@\(username)"
        postTextContentLabel.text = tweetTextContent
        avatarImageView.sd_setImage(with: URL(string: avatarPath))
        postCreationDateLabel.text = dateFormatter.string(from: postCreationDate)
    }
    
    private func configureConstraints() {
        
        let avatarImageViewConstraints = [
            avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            avatarImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 14),
            avatarImageView.heightAnchor.constraint(equalToConstant: 50),
            avatarImageView.widthAnchor.constraint(equalToConstant: 50)
        ]
        
        
        let displayNameLabelConstraints = [
            displayNameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 20),
            displayNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20)
        ]
        
        let usernameLabelConstraints = [
            usernameLabel.leadingAnchor.constraint(equalTo: displayNameLabel.trailingAnchor, constant: 10),
            usernameLabel.centerYAnchor.constraint(equalTo: displayNameLabel.centerYAnchor)
        ]
        
        let postTextContentLabelConstraints = [
            postTextContentLabel.leadingAnchor.constraint(equalTo: displayNameLabel.leadingAnchor),
            postTextContentLabel.topAnchor.constraint(equalTo: displayNameLabel.bottomAnchor, constant: 10),
            postTextContentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
        ]
        
        let replyButtonConstraints = [
            replyButton.leadingAnchor.constraint(equalTo: postTextContentLabel.leadingAnchor),
            replyButton.topAnchor.constraint(equalTo: postTextContentLabel.bottomAnchor, constant: 10),
            replyButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15)
        ]
        
        
        let repostButtonConstraints = [
            repostButton.leadingAnchor.constraint(equalTo: replyButton.trailingAnchor, constant: actionSpacing),
            repostButton.centerYAnchor.constraint(equalTo: replyButton.centerYAnchor),
        ]
        
        
        let likeButtonConstraints = [
            likeButton.leadingAnchor.constraint(equalTo: repostButton.trailingAnchor, constant: actionSpacing),
            likeButton.centerYAnchor.constraint(equalTo: replyButton.centerYAnchor)
        ]
        
        let shareButtonConstraints = [
            
            shareButton.leadingAnchor.constraint(equalTo: likeButton.trailingAnchor, constant: actionSpacing),
            shareButton.centerYAnchor.constraint(equalTo: replyButton.centerYAnchor)
        
        ]
        
        let postCreationDateLabelConstraints = [
            postCreationDateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            postCreationDateLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20)
        ]
        
        NSLayoutConstraint.activate(avatarImageViewConstraints)
        NSLayoutConstraint.activate(displayNameLabelConstraints)
        NSLayoutConstraint.activate(usernameLabelConstraints)
        NSLayoutConstraint.activate(postTextContentLabelConstraints)
        NSLayoutConstraint.activate(replyButtonConstraints)
        NSLayoutConstraint.activate(repostButtonConstraints)
        NSLayoutConstraint.activate(likeButtonConstraints)
        NSLayoutConstraint.activate(shareButtonConstraints)
        NSLayoutConstraint.activate(postCreationDateLabelConstraints)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    

}
