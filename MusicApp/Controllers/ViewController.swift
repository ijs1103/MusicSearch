//
//  ViewController.swift
//  MusicApp
//
//  Created by Allen H on 2022/04/20.
//

import UIKit

final class ViewController: UIViewController {

    // ๐ ์์น ์ปจํธ๋กค๋ฌ ์์ฑ ===> ๋ค๋น๊ฒ์ด์ ์์ดํ์ ํ ๋น
//    let searchController = UISearchController()
    
    // ๐ ์์น Results์ปจํธ๋กค๋ฌ โญ๏ธ
    //let sear = UISearchController(searchResultsController: <#T##UIViewController?#>)
    
    let searchController = UISearchController(searchResultsController: UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SearchResultViewController") as! SearchResultViewController)
    
    @IBOutlet weak var musicTableView: UITableView!
    
    // ๋คํธ์ํฌ ๋งค๋์  (์ฑ๊ธํค)
    var networkManager = NetworkManager.shared
    
    // (์์ ๋ฐ์ดํฐ๋ฅผ ๋ค๋ฃจ๊ธฐ ์ํจ) ๋น๋ฐฐ์ด๋ก ์์
    var musicArrays: [Music] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupSearchBar()
        setupTableView()
        setupDatas()
    }
    
    // ์์น๋ฐ ์ํ
    func setupSearchBar() {
        self.title = "Music Search"
        navigationItem.searchController = searchController
        
        // ๐ 1) (๋จ์)์์น๋ฐ์ ์ฌ์ฉ
        //searchController.searchBar.delegate = self
        
        
        // ๐ 2) ์์น(๊ฒฐ๊ณผ)์ปจํธ๋กค๋ฌ์ ์ฌ์ฉ (๋ณต์กํ ๊ตฌํ ๊ฐ๋ฅ)
        //     ==> ๊ธ์๋ง๋ค ๊ฒ์ ๊ธฐ๋ฅ + ์๋ก์ด ํ๋ฉด์ ๋ณด์ฌ์ฃผ๋ ๊ฒ๋ ๊ฐ๋ฅ
        // UISearchResultsUpdating ํ๋กํ ์ฝ ๋ฑ๋ก
        searchController.searchResultsUpdater = self
        
        // ์ฒซ๊ธ์ ๋๋ฌธ์ ์ค์  ์์ ๊ธฐ
        searchController.searchBar.autocapitalizationType = .none
    }
    
    // ํ์ด๋ธ๋ทฐ ์ํ
    func setupTableView() {
        musicTableView.dataSource = self
        musicTableView.delegate = self
        // Nibํ์ผ์ ์ฌ์ฉํ๋ค๋ฉด ๋ฑ๋ก์ ๊ณผ์ ์ด ํ์
        
        musicTableView.register(UINib(nibName: Cell.musicCellIdentifier, bundle: nil), forCellReuseIdentifier: Cell.musicCellIdentifier)
        
        //musicTableView.rowHeight = 120
    }
    
    // ๋ฐ์ดํฐ ์์
    func setupDatas() {
        // ๋คํธ์ํน์ ์์
        networkManager.fetchMusic(searchTerm: "blackpink") { result in
            print(#function)
            switch result {
            case .success(let musicDatas):
                // ๋ฐ์ดํฐ(๋ฐฐ์ด)์ ๋ฐ์์ค๊ณ  ๋ ํ
                self.musicArrays = musicDatas
                // ํด๋ก์ ๋ 2๋ฒ์ค๋ ๋์์ ์คํ๋๋๋ฐ, ํ์ด๋ธ๋ทฐ ๋ฆฌ๋ก๋ํ๋ ํจ์๋ ๋ฉ์ธ์ค๋ ๋์์ ์คํ์์ผ์ผ ํจ
                DispatchQueue.main.async {
                    self.musicTableView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(#function)
        return self.musicArrays.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = musicTableView.dequeueReusableCell(withIdentifier: Cell.musicCellIdentifier, for: indexPath) as! MusicCell
        

        
        cell.imageUrl = musicArrays[indexPath.row].imageUrl
        
        cell.songNameLabel.text = musicArrays[indexPath.row].songName
        cell.artistNameLabel.text = musicArrays[indexPath.row].artistName
        cell.albumNameLabel.text = musicArrays[indexPath.row].albumName
        cell.releaseDateLabel.text = musicArrays[indexPath.row].releaseDateString
        
        cell.selectionStyle = .none
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    // ํ์ด๋ธ๋ทฐ ์์ ๋์ด๋ฅผ ์ ๋์ ์ผ๋ก ์กฐ์ ํ๊ณ  ์ถ๋ค๋ฉด ๊ตฌํํ  ์ ์๋ ๋ฉ์๋
    // (musicTableView.rowHeight = 120 ๋์ ์ ์ฌ์ฉ๊ฐ๋ฅ)
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    //MARK: - AutomaticDimension ์ฌ์ฉ์, ์ด๋ฏธ์ง๋ทฐ์ ๋ฐ๋ฅธ ๋์ด ์กฐ์ ํ๊ธฐ
    // https://g-y-e-o-m.tistory.com/136
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//    }

}


//MARK: - ๐ (๋จ์) ์์น๋ฐ ํ์ฅ

//extension ViewController: UISearchBarDelegate {
//
//    // ์ ์ ๊ฐ ๊ธ์๋ฅผ ์๋ ฅํ๋ ์๊ฐ๋ง๋ค ํธ์ถ๋๋ ๋ฉ์๋
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//
//        print(searchText)
//        // ๋ค์ ๋น ๋ฐฐ์ด๋ก ๋ง๋ค๊ธฐ โญ๏ธ
//        self.musicArrays = []
//
//        // ๋คํธ์ํน ์์
//        networkManager.fetchMusic(searchTerm: searchText) { result in
//            switch result {
//            case .success(let musicDatas):
//                self.musicArrays = musicDatas
//                DispatchQueue.main.async {
//                    self.musicTableView.reloadData()
//                }
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//        }
//    }
//}
//    // ๊ฒ์(Search) ๋ฒํผ์ ๋๋ ์๋ ํธ์ถ๋๋ ๋ฉ์๋
////    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
////        guard let text = searchController.searchBar.text else {
////            return
////        }
////        print(text)
////        // ๋ค์ ๋น ๋ฐฐ์ด๋ก ๋ง๋ค๊ธฐ โญ๏ธ
////        self.musicArrays = []
////
////        // ๋คํธ์ํน ์์
////        networkManager.fetchMusic(searchTerm: text) { result in
////            switch result {
////            case .success(let musicDatas):
////                self.musicArrays = musicDatas
////                DispatchQueue.main.async {
////                    self.musicTableView.reloadData()
////                }
////            case .failure(let error):
////                print(error.localizedDescription)
////            }
////        }
////        self.view.endEditing(true)
////    }
//}


//MARK: -  ๐ ๊ฒ์ํ๋ ๋์ (์๋ก์ด ํ๋ฉด์ ๋ณด์ฌ์ฃผ๋) ๋ณต์กํ ๋ด์ฉ ๊ตฌํ ๊ฐ๋ฅ

extension ViewController: UISearchResultsUpdating {
    // ์ ์ ๊ฐ ๊ธ์๋ฅผ ์๋ ฅํ๋ ์๊ฐ๋ง๋ค ํธ์ถ๋๋ ๋ฉ์๋ ===> ์ผ๋ฐ์ ์ผ๋ก ๋ค๋ฅธ ํ๋ฉด์ ๋ณด์ฌ์ค๋ ๊ตฌํ
    func updateSearchResults(for searchController: UISearchController) {
        print("์์น๋ฐ์ ์๋ ฅ๋๋ ๋จ์ด", searchController.searchBar.text ?? "")
        // ๊ธ์๋ฅผ ์น๋ ์๊ฐ์ ๋ค๋ฅธ ํ๋ฉด์ ๋ณด์ฌ์ฃผ๊ณ  ์ถ๋ค๋ฉด (์ปฌ๋ ์๋ทฐ๋ฅผ ๋ณด์ฌ์ค)
        let vc = searchController.searchResultsController as! SearchResultViewController
        // ์ปฌ๋ ์๋ทฐ์ ์ฐพ์ผ๋ ค๋ ๋จ์ด ์ ๋ฌ
        vc.searchTerm = searchController.searchBar.text ?? ""
    }
}
