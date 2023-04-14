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
    
    private let dashBoardView = DashBoardView()
    
    private let mealTimes = ["All", "Breakfast", "Lunch", "Dinner"]
    private lazy var segmentedControl = UISegmentedControl(items: mealTimes)
    private let segmentedView = SegmentedStackView()
    
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let eventsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let img = UIImage(named: "Table")
    
    private let scrollView = UIScrollView()
    
    private var reservations = [Reservation]()
    private var reservationIds = [String]()
    private var events = [Event]()
    private let bookingController = BookingController()
    private let reservationController = ReservationController()
    private let eventBookingController = EventBookingController()
    
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
        configureScrollView()
        configureTitleLabel()
        configureDashBoardView()
        configureReservationLabel()
        configureSegmentedControl()
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
        
        // Set up constraints to position and size the scroll view and its contents
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
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
    
    private func configureDashBoardView() {
        
        scrollView.addSubview(dashBoardView)
        
        dashBoardView.backgroundColor = .systemGray6
        dashBoardView.layer.cornerRadius = 10.0
        dashBoardView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            dashBoardView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            dashBoardView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 18),
            dashBoardView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            dashBoardView.trailingAnchor.constraint(lessThanOrEqualTo: scrollView.trailingAnchor, constant: -10),
            dashBoardView.heightAnchor.constraint(equalToConstant: 200),
//            dashBoardView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -10)
        ])
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
    
    private func configureSegmentedControl() {
        
        scrollView.addSubview(segmentedView)
        // Set up constraints to position and size the stack view
        segmentedView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            segmentedView.topAnchor.constraint(equalTo: reservationLabel.bottomAnchor, constant: 20),
            segmentedView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 18),
            segmentedView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -10),
            segmentedView.heightAnchor.constraint(equalToConstant: 44),
        ])
//        scrollView.addSubview(segmentedControl)
//        // Set up constraints to position and size the stack view
//        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
//        segmentedControl.selectedSegmentIndex = 0
//        NSLayoutConstraint.activate([
//            segmentedControl.topAnchor.constraint(equalTo: reservationLabel.bottomAnchor, constant: 20),
//            segmentedControl.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 18),
//            segmentedControl.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -10),
//            segmentedControl.heightAnchor.constraint(equalToConstant: 44),
//        ])
//        let font = UIFont.systemFont(ofSize: 17, weight: .medium)
//        segmentedControl.layer.cornerRadius = 8
//        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.font: font], for: .selected)
//        segmentedControl.setDividerImage(UIImage(), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
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
            eventsCollectionView.showLoadingIndicator()
        }
//        isLoading = true
        reservations = []
        events = []

        
        reservationController.getReservationsFor(date: date) {[weak self] reservations in
            
            self?.reservations = reservations
//            self?.collectionView.hideLoadingIndicator()
            self?.collectionView.reloadData()
            self?.getEvents(date: date)
            if self?.reservations.count ?? 0 > 0 {

                self?.collectionView.hideLoadingIndicator()
            } else {
                self?.collectionView.setEmptyView(title: "No tables booked for this day",
                                            message: "",
                                            image: UIImage(named: "noReservation"))
            }
        }
    }
    
    private func getEvents(date: Date) {
        
        eventBookingController.getEventsFor(date: date) { [weak self] events in
            
            self?.events = events
            self?.collectionView.reloadData()
            if events.count > 0 {
                
                self?.eventsCollectionView.hideLoadingIndicator()
            } else {
                
                self?.eventsCollectionView.setEmptyView(title: "No events booked for this day",
                                            message: "",
                                            image: UIImage(named: "noEvent"))
            }
            self?.eventsCollectionView.refreshControl?.endRefreshing()
        }
    }
}

extension HomeViewController2: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView.contentOffset.y < -50 {
            scrollView.contentOffset = CGPointMake(0, -50) // this is to disable tableview bouncing at top.
        }
      }
}

extension HomeViewController2: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return reservations.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TableCollectionViewCell", for: indexPath) as! TableCollectionViewCell
        
        
        if collectionView.tag == 1 {
            let reservationDetail = reservations[indexPath.row]
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
