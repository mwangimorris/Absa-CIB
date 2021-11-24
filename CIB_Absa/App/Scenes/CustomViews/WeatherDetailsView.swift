//
//  WeatherDetailsView.swift
//  CIB_Absa
//
//  Created by Morris Mwangi on 24/11/2021.
//

import UIKit

class WeatherDetailsView: UIView {

    // MARK: - Data Source
    var weatherDetails: [String]? {
        didSet {
            configureWeatherDetails()
        }
    }

    // MARK: UI Properties
    lazy var contentStackView: UIStackView = {
        let stack = UIStackView()
        stack.alignment = .leading
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.spacing = 3
        stack.translatesAutoresizingMaskIntoConstraints = false

        return stack
    }()

    lazy var closeBtn: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(UIImage(named: "xmark.circle.fill"), for: .normal)
        button.addTarget(self, action: #selector(dismiss), for: .touchUpInside)

        return button
    }()

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubViews()
        setupConstraints()
    }

    @objc fileprivate func dismiss() {
        self.removeFromSuperview()
    }

    // MARK: - Private Instance Methods
    private func setupSubViews() {
        self.backgroundColor = .systemGray2
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.cornerRadius = 20
        self.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]

        [closeBtn, contentStackView].forEach { addSubview($0) }
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            closeBtn.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            closeBtn.topAnchor.constraint(equalTo: topAnchor, constant: 10),

            contentStackView.topAnchor.constraint(equalTo: closeBtn.bottomAnchor, constant: 10),
            contentStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -30),
            contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            contentStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
        ])
    }

    private func configureWeatherDetails() {
        guard let details = weatherDetails else { return }

        details.forEach {
            let detailLabel: UILabel = {
                let lbl = UILabel()
                lbl.textAlignment = .left
                lbl.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
                lbl.translatesAutoresizingMaskIntoConstraints = false

                return lbl
            }()

            detailLabel.text = $0
            contentStackView.addArrangedSubview(detailLabel)
        }
    }
}
