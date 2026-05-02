//
//  LeagueDetailsViewController.swift
//  Top-League
//

import UIKit

class LeagueDetailsViewController: UIViewController {

    var league: League!
    var sport:  SportType!

    var presenter: LeagueDetailsPresenterProtocol!

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var headerView: LeagueHeaderView?
    @IBOutlet weak var emptyStateLabel: UILabel?

    // Programmatic spinner overlay — never nil, always guaranteed to show
    private lazy var loadingOverlay: UIView = {
        let overlay = UIView()
        overlay.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        overlay.translatesAutoresizingMaskIntoConstraints = false
        overlay.isHidden = true
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.color = .white
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        overlay.addSubview(spinner)
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: overlay.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: overlay.centerYAnchor)
        ])
        return overlay
    }()

    private var isDataLoaded    = false
    private var favoriteButton: UIBarButtonItem!

    enum SectionType: Int {
        case upcoming = 0
        case latest   = 1
        case teams    = 2
    }
    private var visibleSections: [SectionType] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupPresenter()
        setupNavigationBar()
        setupCollectionView()

        headerView?.formatBadgeLabel?.isHidden = true
        emptyStateLabel?.isHidden = true

        headerView?.leagueNameLabel?.text = league.name ?? ""
        headerView?.countryNameLabel?.text = league.countryName ?? ""

        // Add full-screen loading overlay on top of everything
        view.addSubview(loadingOverlay)
        NSLayoutConstraint.activate([
            loadingOverlay.topAnchor.constraint(equalTo: view.topAnchor),
            loadingOverlay.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            loadingOverlay.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loadingOverlay.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        presenter.fetchImageData(from: league.badgeURL ?? "") { [weak self] data in
            if let d = data { self?.headerView?.leagueLogoImage?.image = UIImage(data: d) }
        }

        presenter.loadLeagueDetails()
    }

    private func setupPresenter() {
        let p = LeagueDetailsPresenter(league: league, sport: sport)
        p.view = self
        presenter = p
    }

    private func setupNavigationBar() {
        title = league.name ?? "League"
        favoriteButton = UIBarButtonItem(image: UIImage(systemName: "star"), style: .plain, target: self, action: #selector(favTapped))
        navigationItem.rightBarButtonItem = favoriteButton
    }

    @objc private func favTapped() { presenter.toggleFavorite() }

    private func setupCollectionView() {
        
        collectionView.register(UINib(nibName: UpcomingEventCell.reuseID, bundle: nil), forCellWithReuseIdentifier: UpcomingEventCell.reuseID)
        collectionView.register(UINib(nibName: LatestEventCell.reuseID, bundle: nil), forCellWithReuseIdentifier: LatestEventCell.reuseID)
        collectionView.register(UINib(nibName: TeamCell.reuseID, bundle: nil), forCellWithReuseIdentifier: TeamCell.reuseID)
        collectionView.register(EmptyStateCell.self, forCellWithReuseIdentifier: EmptyStateCell.reuseID)
        collectionView.register(NestedLatestContainerCell.self, forCellWithReuseIdentifier: NestedLatestContainerCell.reuseID)
        collectionView.register(SectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeaderView.reuseID)

        collectionView.collectionViewLayout = createCompositionalLayout()
    }

    private func rebuildSections() {
        visibleSections.removeAll()
        visibleSections.append(.upcoming)
        visibleSections.append(.latest)
        if presenter.getTeamsCount() > 0 { visibleSections.append(.teams) }
        collectionView.reloadData()
    }

    // MARK: - Compositional Layout
    private func createCompositionalLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
            guard let self = self else { return nil }
            let sectionType = self.visibleSections[sectionIndex]

            switch sectionType {
            case .upcoming: return self.createUpcomingSection()
            case .latest:   return self.createLatestSection()
            case .teams:    return self.createTeamsSection()
            }
        }
    }

    private func createHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(40))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: size, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        return header
    }

    private func createEmptySection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(100))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 16, bottom: 20, trailing: 16)
        section.boundarySupplementaryItems = [createHeader()]
        return section
    }

    private func createUpcomingSection() -> NSCollectionLayoutSection {
        if presenter.getUpcomingCount() == 0 && isDataLoaded { return createEmptySection() }
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.95), heightDimension: .absolute(150))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        section.interGroupSpacing = 14
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 16, bottom: 20, trailing: 16)
        section.boundarySupplementaryItems = [createHeader()]
        return section
    }

    private func createLatestSection() -> NSCollectionLayoutSection {
        if presenter.getLatestCount() == 0 && isDataLoaded { return createEmptySection() }
        
        let latestHeight: CGFloat = 500 // Fixed height holds ~3 larger items, scrolls internally
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(latestHeight))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 16, bottom: 20, trailing: 16)
        section.boundarySupplementaryItems = [createHeader()]
        return section
    }

    private func createTeamsSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(100), heightDimension: .absolute(120))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 12
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 16, bottom: 20, trailing: 16)
        section.boundarySupplementaryItems = [createHeader()]
        return section
    }

    private var sportAccentColor: UIColor {
        switch sport {
        case .football:   return UIColor(hex: "#00C853")
        case .basketball: return UIColor(hex: "#FF6D00")
        case .cricket:    return UIColor(hex: "#1565C0")
        default:          return UIColor(hex: "#F5C518")
        }
    }
}

extension LeagueDetailsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return visibleSections.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch visibleSections[section] {
        case .upcoming:
            let c = presenter.getUpcomingCount()
            return (c == 0 && isDataLoaded) ? 1 : c
        case .latest:
            return 1 // Always 1 item: the nested container
        case .teams:    return presenter.getTeamsCount()
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch visibleSections[indexPath.section] {
        case .upcoming:
            if presenter.getUpcomingCount() == 0 && isDataLoaded {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmptyStateCell.reuseID, for: indexPath) as! EmptyStateCell
                cell.label.text = "No upcoming events"
                return cell
            }
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UpcomingEventCell.reuseID, for: indexPath) as! UpcomingEventCell
            cell.configure(with: presenter.getUpcomingEvent(at: indexPath.item), sport: sport)
            return cell
        case .latest:
            if presenter.getLatestCount() == 0 && isDataLoaded {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmptyStateCell.reuseID, for: indexPath) as! EmptyStateCell
                cell.label.text = "No latest results"
                return cell
            }
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NestedLatestContainerCell.reuseID, for: indexPath) as! NestedLatestContainerCell
            let events = (0..<presenter.getLatestCount()).map { presenter.getLatestEvent(at: $0) }
            cell.configure(with: events, sport: sport)
            return cell
        case .teams:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TeamCell.reuseID, for: indexPath) as! TeamCell
            cell.configure(with: presenter.getTeam(at: indexPath.item), accentColor: sportAccentColor, sport: sport)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else { return UICollectionReusableView() }
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeaderView.reuseID, for: indexPath) as! SectionHeaderView
        
        switch visibleSections[indexPath.section] {
        case .upcoming: header.titleLabel.text = "UPCOMING EVENTS"
        case .latest:   header.titleLabel.text = "LATEST RESULTS"
        case .teams:    header.titleLabel.text = sport == .tennis ? "PLAYERS" : "TEAMS"
        }
        return header
    }
}

extension LeagueDetailsViewController: LeagueDetailsViewProtocol {
    func reloadUpcomingEvents() { rebuildSections() }
    func reloadLatestEvents()   { rebuildSections() }
    func showTeamsSection()     { rebuildSections() }
    func hideTeamsSection()     { rebuildSections() }
    
    func setScoreLabel(_ text: String) { }
    func showMatchFormatBadge() { headerView?.formatBadgeLabel?.isHidden = false }
    func updateFavoriteButton(isFavorite: Bool) {
        favoriteButton.image = UIImage(systemName: isFavorite ? "star.fill" : "star")
    }
    func showEmptyState() {
        emptyStateLabel?.isHidden = false
    }
    func showLoading() {
        loadingOverlay.isHidden = false
        view.bringSubviewToFront(loadingOverlay)
    }
    func hideLoading() {
        isDataLoaded = true
        loadingOverlay.isHidden = true
        collectionView.reloadData()
    }
    func showError(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

class SectionHeaderView: UICollectionReusableView {
    static let reuseID = "SectionHeaderView"
    let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.systemFont(ofSize: 13, weight: .heavy)
        titleLabel.textColor = UIColor(hex: "#8E9BB5")
        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    required init?(coder: NSCoder) { fatalError() }
}

class EmptyStateCell: UICollectionViewCell {
    static let reuseID = "EmptyStateCell"
    let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(hex: "#8E9BB5")
        label.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        label.textAlignment = .center
        contentView.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    required init?(coder: NSCoder) { fatalError() }
}

class NestedLatestContainerCell: UICollectionViewCell, UICollectionViewDataSource {
    static let reuseID = "NestedLatestContainerCell"
    let nestedCollectionView: UICollectionView
    var events: [SportEvent] = []
    var sport: SportType = .football
    
    override init(frame: CGRect) {
        let layout = UICollectionViewCompositionalLayout { _, _ in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(150))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(150))
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 16
            return section
        }
        nestedCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        super.init(frame: frame)
        
        nestedCollectionView.translatesAutoresizingMaskIntoConstraints = false
        nestedCollectionView.backgroundColor = .clear
        nestedCollectionView.dataSource = self
        nestedCollectionView.showsVerticalScrollIndicator = false
        nestedCollectionView.register(UINib(nibName: LatestEventCell.reuseID, bundle: nil), forCellWithReuseIdentifier: LatestEventCell.reuseID)
        
        contentView.addSubview(nestedCollectionView)
        NSLayoutConstraint.activate([
            nestedCollectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            nestedCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            nestedCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nestedCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    required init?(coder: NSCoder) { fatalError() }
    
    func configure(with events: [SportEvent], sport: SportType) {
        self.events = events
        self.sport = sport
        nestedCollectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return events.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LatestEventCell.reuseID, for: indexPath) as! LatestEventCell
        cell.configure(with: events[indexPath.row], sport: sport)
        return cell
    }
}
