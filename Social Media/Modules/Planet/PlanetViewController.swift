//
//  PlanetViewController.swift
//  Social Media
//
//  Created by Philipp Lazarev on 25.06.2024.
//

import Foundation

import UIKit

class PlanetViewController: UIViewController {
    
    // MARK: - Subviews
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private lazy var planetLabel: UILabel = {
        let label = UILabel()

        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        label.text = "N/A"
        label.font = .boldSystemFont(ofSize: 20)
        
        return label
    }()
    
    private lazy var orbitalPeriodLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        label.text = "Orbital period: N/A"
        label.font = .systemFont(ofSize: 16)
        
        return label
    }()
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        addSubviews()
        setupConstraints()
        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    
    // MARK: - Actions

    
    // MARK: - Private

    func setupUI() {
        view.backgroundColor = UIColor(named: "BackgroundColor")
    }
    
    func addSubviews() {
        view.addSubview(activityIndicator)
        view.addSubview(planetLabel)
        view.addSubview(orbitalPeriodLabel)
    }
    
    func setupConstraints() {
        let safeAreaGuide = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: safeAreaGuide.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: safeAreaGuide.centerYAnchor),
        ])
        
        NSLayoutConstraint.activate([
            planetLabel.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor, constant: 20),
            planetLabel.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor, constant: -20),
            planetLabel.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor, constant: 20),
            planetLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        NSLayoutConstraint.activate([
            orbitalPeriodLabel.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor, constant: 20),
            orbitalPeriodLabel.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor, constant: -20),
            orbitalPeriodLabel.topAnchor.constraint(equalTo: planetLabel.bottomAnchor, constant: 20),
            orbitalPeriodLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func fetchData() {
        let urlString = "https://swapi.dev/api/planets/1"
        NetworkService.request(urlString: urlString) { result in
            switch result {
            case .success(let data):
                let decoder = JSONDecoder()
                do {
                    let planet = try decoder.decode(Planet.self, from: data as! Data)
                    DispatchQueue.main.async { [self] in
                        activityIndicator.stopAnimating()
                        activityIndicator.isHidden = true
                        
                        planetLabel.text = planet.name
                        planetLabel.isHidden = false
                        
                        orbitalPeriodLabel.text = "Orbital period: \(planet.orbitalPeriod)"
                        orbitalPeriodLabel.isHidden = false
                    }
                } catch {
                    print("Error decoding data!")
                }
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
        

    }
}
