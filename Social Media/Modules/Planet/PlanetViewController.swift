//
//  PlanetViewController.swift
//  Social Media
//
//  Created by Philipp Lazarev on 25.06.2024.
//

import Foundation

import UIKit

class PlanetViewController: UIViewController {
    
    var planet: Planet?
    var residents = [Person]()

    
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
    
    private lazy var residentsTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        addSubviews()
        setupConstraints()
        fetchPlanetData()
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

    private func setupUI() {
        view.backgroundColor = UIColor(named: "BackgroundColor")
    }
    
    private func addSubviews() {
        view.addSubview(activityIndicator)
        view.addSubview(planetLabel)
        view.addSubview(orbitalPeriodLabel)
        view.addSubview(residentsTableView)
    }
    
    private func setupConstraints() {
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
        
        NSLayoutConstraint.activate([
            residentsTableView.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor),
            residentsTableView.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor),
            residentsTableView.topAnchor.constraint(equalTo: orbitalPeriodLabel.bottomAnchor, constant: 20)
        ])
        
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        
        residentsTableView.delegate = self
        residentsTableView.dataSource = self
        //residentsTableView.register(PostViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    private func fetchPlanetData() {
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
                        
                        self.planet = planet
                        fetchResidentsData()
                    }
                } catch {
                    print("Error decoding data!")
                }
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    private func fetchResidentsData() {
        guard let planet else {
            return
        }
        
        let dispatchGroup = DispatchGroup()
        
        for resident in planet.residents {
            dispatchGroup.enter()
            NetworkService.request(urlString: resident) { result in
                switch result {
                case .success(let data):
                    let decoder = JSONDecoder()
                    do {
                        let person = try decoder.decode(Person.self, from: data as! Data)
                        self.residents.append(person)
                    } catch {
                        print("Error decoding data!")
                    }
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                }
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            for resident in self.residents {
                print(resident.name)
            }
            self.residentsTableView.reloadData()
            print(self.residentsTableView.numberOfRows(inSection: 0))
        }
    }
}

extension PlanetViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        residents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = residents[indexPath.row]
        let cell = UITableViewCell()
        
        return cell
    }
}

extension PlanetViewController: UITableViewDelegate {
    
}
