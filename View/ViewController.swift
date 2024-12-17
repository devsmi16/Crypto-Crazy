import UIKit
import RxSwift
import RxCocoa
class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    let cryptoVM = CryptoViewModel()
    var cryptoList = [Crypto]()
    let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        view.backgroundColor = .black
        
        cryptoVM.requestData()
        setupBindings()
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cryptoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var content = cell.defaultContentConfiguration()
        content.text = cryptoList[indexPath.row].currency
        content.secondaryText = cryptoList[indexPath.row].price
        cell.contentConfiguration = content
        return cell
    }
    
    private func setupBindings() {
        
        cryptoVM
            .loading
            .bind(to: self.indicatorView.rx.isAnimating)
            .disposed(by: disposeBag)
        
        cryptoVM
            .error
            .observe(on: MainScheduler.asyncInstance)
            .subscribe { errorString in
                print(errorString)
            }
            .disposed(by: disposeBag)
        
        cryptoVM
            .cryptos
            .observe(on: MainScheduler.asyncInstance)
            .subscribe { cryptoList in
                self.cryptoList = cryptoList
                self.tableView.reloadData()
            }
            .disposed(by: disposeBag)
        
        
        
    }
}

