//
//  LoggedInViewController.swift
//  CRM Project
//
//  Created by guhan-pt6208 on 25/01/23.
//

import UIKit

class HomeViewController2: UIViewController {
    
    private let mainTabBarController = UITabBarController()
    
    private let titleLabel = UILabel()
    private let reservationLabel = UILabel()
    private let eventLabel = UILabel()
    
    private let segmentedView = SegmentedStackView()
    private let dashBoardView = DashBoardView()
    private var dashboardStats = [(String, String)](repeating: ("", ""), count: 4)
    private var lastPickedStats: DashBoardDetailOption = .weekly
    
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let eventsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let img = UIImage(named: "Table")
    private let scrollView = UIScrollView()
    
    private var isFirstTime = true
    private var isEmptyViewActive = false
    
    private var reservations = [Reservation]()
    private var filteredReservations = [Reservation]()
    private var reservationIds = [String]()
    private var events = [Event]()
    private let bookingController = BookingController()
    private let reservationController = ReservationController()
    private let eventBookingController = EventBookingController()
    private let userController: UserDetailControllerContract = UserDetailController()
    private let dashBoardController = DashBoardController()
    
    deinit {
        print("Login deinitialized")
    }

    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
       
        configureUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        segmentedView.setUp()
    }
    
    override func viewDidLayoutSubviews() {
        segmentedView.resetSelectedView()
    }
    
    private func configureUI() {
        
        navigationController?.navigationBar.isHidden = true
        getCurrentUser()
        configureScrollView()
        configureTitleLabel()
        configureDashBoardView()
        getDashBoardStats()
        configureReservationLabel()
        configureSegmentView()
        configureCollectionView()
        configureEventLabel()
        configureEventsCollectionView()
        scrollView.contentSize = CGSize(width: view.bounds.width, height: collectionView.frame.maxY + 20)
        getBookedTablesFor(date: Date())
    }

    
    private func configureScrollView() {
        
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.delegate = self
        scrollView.refreshControl = UIRefreshControl()
        scrollView.refreshControl?.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        
        // Set up constraints to position and size the scroll view and its contents
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    @objc private func didPullToRefresh() {
        
        getBookedTablesFor(date: Date())
        getDashBoardStats()
    }
    
    private func configureTitleLabel() {
        
        scrollView.addSubview(titleLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        let fontMetrics = UIFontMetrics(forTextStyle: .largeTitle)
        titleLabel.font = fontMetrics.scaledFont(for: .systemFont(ofSize: 30, weight: .bold))
        titleLabel.text = "Hello "
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 18),
            titleLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: scrollView.trailingAnchor),
        ])
    }
    
    private func getCurrentUser() {
        
        userController.getUserDetails { [weak self] currentUser in
            if self?.titleLabel.text == "Hello " {
                self?.titleLabel.text?.append(currentUser?.firstName ?? "")
            }
        }
    }
    
    private func configureDashBoardView() {
        
        scrollView.addSubview(dashBoardView)
        
        dashBoardView.backgroundColor = .systemGray6
        dashBoardView.layer.cornerRadius = 10.0
        dashBoardView.translatesAutoresizingMaskIntoConstraints = false
        dashBoardView.dropdownButton.menu = getMenu()
        dashBoardView.dropdownButton.showsMenuAsPrimaryAction = true
        
        NSLayoutConstraint.activate([
            dashBoardView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            dashBoardView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 18),
            dashBoardView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            dashBoardView.trailingAnchor.constraint(lessThanOrEqualTo: scrollView.trailingAnchor, constant: -10),
            dashBoardView.heightAnchor.constraint(equalToConstant: 200),
//            dashBoardView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -10)
        ])
    }

    private func getMenu() -> UIMenu {
        
        let todayAction = UIAction(title: "Today", image: UIImage(systemName: "calendar")) { [weak self] _ in
            
            guard let self = self else { return }
            self.lastPickedStats = .today
            self.dashBoardView.setStats(stats: self.dashboardStats[0])
            self.dashBoardView.dropdownButton.setTitle("Today", for: .normal)
            let reservationCount = String(self.reservations.count)
            let eventsCount = String(self.events.count)
            self.dashboardStats[0] = ((reservationCount, eventsCount))
            self.dashBoardView.setStats(stats: self.dashboardStats[0])
        }
        
        let weeklyAction = UIAction(title: "Weekly", image: UIImage(named: "weekly")) { [weak self] _ in
            
            guard let self = self else { return }
            self.setupDashBoard(option: .weekly, title: "Weekly", index: 1)

        }
        let monthlyAction = UIAction(title: "Monthly", image: UIImage(named: "yearly")) { [weak self] _ in
            
            guard let self = self else { return }
            self.setupDashBoard(option: .monthly, title: "Monthly", index: 2)

        }
        
        let yearlyAction = UIAction(title: "Yearly", image: UIImage(named: "yearly")) { [weak self] _ in
            
            guard let self = self else { return }
            self.setupDashBoard(option: .yearly, title: "Yearly", index: 3)

        }
        
        let menu = UIMenu(title: "", children: [todayAction, weeklyAction, monthlyAction, yearlyAction])
 
        return menu
    }
    
    private func setupDashBoard(option: DashBoardDetailOption, title: String, index: Int) {
        
        self.lastPickedStats = option
        self.dashBoardView.dropdownButton.setTitle(title, for: .normal)
        self.dashBoardView.setStats(stats: self.dashboardStats[index])
        
        self.dashBoardController.getStats(for: option) { [weak self] count in
            
            self?.dashboardStats[index] = count
            self?.dashBoardView.setStats(stats: count)
        }
    }
    
    private func getDashBoardStats() {
        
        dashBoardController.getStats(for: lastPickedStats) { [weak self] count in
            
            self?.dashBoardView.setStats(stats: count)
        }
    }
    
    private func configureReservationLabel() {
        
        scrollView.addSubview(reservationLabel)
        
        reservationLabel.translatesAutoresizingMaskIntoConstraints = false
        let fontMetrics = UIFontMetrics(forTextStyle: .largeTitle)
        reservationLabel.font = fontMetrics.scaledFont(for: .systemFont(ofSize: 20, weight: .semibold))
        reservationLabel.text = "Today's Reservations"
        
        NSLayoutConstraint.activate([
            reservationLabel.topAnchor.constraint(equalTo: dashBoardView.bottomAnchor, constant: 20),
            reservationLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 18),
            reservationLabel.trailingAnchor.constraint(lessThanOrEqualTo: scrollView.trailingAnchor),
        ])
    }
    
    private func configureSegmentView() {
        
        scrollView.addSubview(segmentedView)
        segmentedView.delegate = self
        // Set up constraints to position and size the stack view
        segmentedView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            segmentedView.topAnchor.constraint(equalTo: reservationLabel.bottomAnchor, constant: 20),
            segmentedView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 18),
            segmentedView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -10),
            segmentedView.heightAnchor.constraint(equalToConstant: 44),
        ])
    }
    
    private func configureCollectionView() {
        
        // Configure collection view
        collectionView.backgroundColor = .systemBackground
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 6)
        collectionView.tag = 1
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 10)
        layout.itemSize = CGSize(width: 300, height: 200)
        collectionView.collectionViewLayout = layout
//        collectionView.backgroundColor = .red
        
        // Register cell class
        collectionView.register(TableCollectionViewCell.self, forCellWithReuseIdentifier: "TableCollectionViewCell")
        scrollView.addSubview(collectionView)
        
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: segmentedView.bottomAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 250),
//            collectionView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            collectionView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    private func configureEventLabel() {
        
        scrollView.addSubview(eventLabel)
        
        eventLabel.translatesAutoresizingMaskIntoConstraints = false
        let fontMetrics = UIFontMetrics(forTextStyle: .largeTitle)
        eventLabel.font = fontMetrics.scaledFont(for: .systemFont(ofSize: 20, weight: .semibold))
        eventLabel.text = "Event's Happening"
        
        NSLayoutConstraint.activate([
            eventLabel.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 10),
            eventLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 18),
            eventLabel.trailingAnchor.constraint(lessThanOrEqualTo: scrollView.trailingAnchor),
        ])
    }
    
    private func configureEventsCollectionView() {
        
        // Configure collection view
        eventsCollectionView.backgroundColor = .systemBackground
        eventsCollectionView.showsHorizontalScrollIndicator = false
        eventsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        eventsCollectionView.dataSource = self
        eventsCollectionView.delegate = self
        eventsCollectionView.contentInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 6)
        eventsCollectionView.tag = 2
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 10)
        layout.itemSize = CGSize(width: 300, height: 200)
        eventsCollectionView.collectionViewLayout = layout
//        collectionView.backgroundColor = .red
        
        // Register cell class
        eventsCollectionView.register(TableCollectionViewCell.self, forCellWithReuseIdentifier: "TableCollectionViewCell")
        scrollView.addSubview(eventsCollectionView)
        
        
        NSLayoutConstraint.activate([
            eventsCollectionView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            eventsCollectionView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            eventsCollectionView.topAnchor.constraint(equalTo: eventLabel.bottomAnchor),
            eventsCollectionView.heightAnchor.constraint(equalToConstant: 250),
            eventsCollectionView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            eventsCollectionView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
}

extension HomeViewController2 {
    
    private func getBookedTablesFor(date: Date) {
        
        if reservations.isEmpty {
            collectionView.showLoadingIndicator()
        }
//        isLoading = true
        reservations = []
        events = []

        self.getEvents(date: date)
        reservationController.getReservationsFor(date: date) { [weak self] reservations in
            
            self?.reservations = reservations
            self?.filteredReservations = reservations
//            self?.collectionView.hideLoadingIndicator()
            if self?.reservations.count ?? 0 > 0 {

                self?.collectionView.hideLoadingIndicator()
            } else {
                self?.setEmptyViewForReservations()
            }
            self?.collectionView.reloadData()
        }
    }
    
    private func getEvents(date: Date) {
        
        if events.isEmpty {
            eventsCollectionView.showLoadingIndicator()
        }
        
        eventBookingController.getEventsFor(date: date) { [weak self] events in
            
            self?.events = events
            if events.count > 0 {
                
                self?.eventsCollectionView.hideLoadingIndicator()
            } else {
                
                self?.eventsCollectionView.setEmptyView(title: "No events booked for this day",
                                   message: "",
                                   image: UIImage(named: "noEvent"))
            }
            self?.eventsCollectionView.reloadData()
            self?.eventsCollectionView.refreshControl?.endRefreshing()
            self?.scrollView.refreshControl?.endRefreshing()
        }
    }
    
    private func setEmptyViewForReservations() {
        
        collectionView.setEmptyView(title: "No tables booked for this day",
                                                         message: "",
                                                         image: UIImage(named: "noReservation"))
    }
}

extension HomeViewController2: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
//        if scrollView.contentOffset.y < -100 {
//            scrollView.contentOffset = CGPointMake(0, -100) // this is to disable tableview bouncing at top.
//        }
      }
}

extension HomeViewController2: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView.tag == 1 {
            return filteredReservations.count
        } else {
            return events.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TableCollectionViewCell", for: indexPath) as! TableCollectionViewCell
        
        
        if collectionView.tag == 1 {
            let reservationDetail = filteredReservations[indexPath.row]
            cell.imageView.image = img
            cell.nameLabel.text = reservationDetail.name
            cell.tableNameLabel.text = reservationDetail.bookingTable
        } else {
            cell.imageView.image = UIImage(named: "Events")
            cell.nameLabel.text = "Booked by: John Doe"
            cell.tableNameLabel.text = "Table 1"
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView.tag == 1 {
            
            let reservationId = reservations[indexPath.row].id
            let recordInfoVc = RecordInfoTableViewController(recordModule: "Reservations", recordId: reservationId, title: "Reservation Details")
            recordInfoVc.modalPresentationStyle = .pageSheet
            if let sheet = recordInfoVc.sheetPresentationController {
                
                sheet.prefersGrabberVisible = true
                sheet.prefersEdgeAttachedInCompactHeight = true
            }
            present(recordInfoVc, animated: true)
        } else {
            
            if !events.isEmpty {
                let eventId = events[indexPath.row].id
                let recordInfoVc = RecordInfoTableViewController(recordModule: "Functions1", recordId: eventId, title: "Event Details")
                recordInfoVc.modalPresentationStyle = .pageSheet
                if let sheet = recordInfoVc.sheetPresentationController {
                    
                    sheet.prefersGrabberVisible = true
                    sheet.prefersEdgeAttachedInCompactHeight = true
                }
                present(recordInfoVc, animated: true)
            }
        }
    }
}

extension HomeViewController2: SegemetedStackViewDelegate {
    
    func didSelect(index: Int) {
        
        switch index {
        case 0:
            filteredReservations = reservations
        case 1:
            filteredReservations = reservations.filter({ reservartion in
                reservartion.bookingTime == "Breakfast" ? true : false
            })
        case 2:
            filteredReservations = reservations.filter({ reservartion in
                reservartion.bookingTime == "Meals" ? true : false
            })
        case 3:
            filteredReservations = reservations.filter({ reservartion in
                reservartion.bookingTime == "Lunch" ? true : false
            })
        default:
            print("This should not be called")
        }
        if filteredReservations.isEmpty {
            
            if isFirstTime {
                isFirstTime = false
            } else if isEmptyViewActive == false {
                isEmptyViewActive = true
                setEmptyViewForReservations()
            }
        } else {
            isEmptyViewActive = false
        }
        collectionView.reloadData()
    }
}
