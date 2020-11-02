//
//  DetailVC.swift
//  SharedElementTransition
//
//  Created by Victor Samuel Cuaca on 02/11/20.
//

import UIKit

protocol DetailVCDelegate: class {
    func didDismissDetail()
}

class DetailVC: UIViewController {
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    // The main view of this controller
    lazy var detailView: DetailView = {
        let detailView = DetailView(appCardView: appCardView)
        detailView.frame = view.bounds
        detailView.closeButton.addTarget(self, action: #selector(didTapCloseButton), for: .touchUpInside)
        return detailView
    }()
    
    weak var delegate: DetailVCDelegate?
    
    private let appCardView: AppCardView
    private let appCard: AppCard
    
    
    // MARK: - Inits
    init(appCard: AppCard) {
        self.appCard = appCard
        self.appCardView = AppCardView(appCard: appCard, appCardState: .full)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("Detail Deinit.")
    }
    
    
    // MARK: - VC Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view = detailView
    }
    
    
    // MARK: - Handlers
    @objc private func didTapCloseButton() {
        dismiss(animated: true) { [weak self] in
            self?.delegate?.didDismissDetail()
        }
    }
}
