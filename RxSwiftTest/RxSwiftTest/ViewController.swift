//
//  ViewController.swift
//  RxSwiftTest
//
//  Created by Jorge Vasquez on 17/03/2022.
//

import UIKit
import RxSwift
import RxCocoa

struct Product {
    var imageName: String
    var title: String
}

struct ProductViewModel {
    var items = PublishSubject<[Product]>()
    
    func fetchItems() {
        let products = [
            Product(imageName: "house", title: "Home"),
            Product(imageName: "gear", title: "Setting"),
            Product(imageName: "person.circle", title: "Profile"),
            Product(imageName: "airplane", title: "Flights"),
            Product(imageName: "bell", title: "Activity")
        ]
        
        items.onNext(products)
        items.onCompleted()
    }
}

class ViewController: UIViewController {

    private let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    private var viewModel = ProductViewModel()
    
    private var bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.frame = view.bounds
        bindTableData()
    }
    
    func bindTableData() {
        //Bind items to table
        viewModel.items.bind(
            to: tableView.rx.items(
                cellIdentifier: "cell",
                cellType: UITableViewCell.self)
        ) { row, model, cell in
            cell.textLabel?.text = model.title
            cell.imageView?.image = UIImage(systemName: model.imageName)
        }.disposed(by: bag)
         
        // Bind a model selected handler
        tableView.rx.modelSelected(Product.self).bind { product in
            print(product.title)
        }.disposed(by: bag)
        // fetch items
        viewModel.fetchItems()
    }

}

