//
//  ViewController.swift
//  SentiTable
//
//  Created by cis on 27/01/2020.
//  Copyright © 2020 cis. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    // tableview - 여러개의 행이 모여있는 목록 뷰
    // 1. 데이터 무엇? - 전화번호부 목록
    // 2. 데이터 몇 개? - 100, 1000 ~~
    // (옵션) 데이터 행 눌렀다 - 클릭
    
    @IBOutlet weak var tableViewMain: UITableView!
    
    var newsData : Array<Dictionary<String,Any>>?
    
    // 1. http 통신 방법 - URLSession 사용함
    // 2. JSON 데이터 형태
    // 3. 테이블뷰의 데이터 매칭! - 맴버 변수를 이용하도록 한다. 그리고 값을 다 가지고 오면 통보를 해줘야 한다.
    // 네트워크 통신의 원칙 - 통신은 background 에서 처리해주고 화면을 그리는건 main thread 가 해주도록 한다. 그렇지 않으면 화면에 나타나지 않는다.
    
    func getNews() {
        let task = URLSession.shared.dataTask(with: URL(string:"https://newsapi.org/v2/top-headlines?country=kr&apiKey=37423d586cf34ab8ac8ff9325c8c04d8")!) { (data, response, error) in
            
            if let dataJson = data {
                // print(dataJson) // 16847 bytes 가 나타났음.
                // json parsing 필요함. 에러 처리도 필요하다. do {} catch {} 로 처리함.
                do {
                    // swift에서 json 은 dictionary 와 동급으로 본다.
                    let json = try JSONSerialization.jsonObject(with: dataJson, options: []) as! Dictionary<String, Any>
                    // print(json) => key값은 제대로 나오지만 알 수 없는 값으로 나타난다. 한글이어서 \Uc544\Ub4e4 이런식으로 나타남.
                    
//                  가져온 json의 형태
//                    {
//                    "status": "ok",
//                    "totalResults": 28,
//                    -"articles": [
//                    -{
//                    -"source": {
//                    "id": null,
//                    "name": "Gfr.co.kr"
//                    },
//                    "author": "황채영 기자",
//                    "title": "'라임사태' 이어 알펜루트자산운용 28일 부터 펀드 환매 중단 - 글로벌금융신문",
                    
                    // json 값 가져오기
                    let articles = json["articles"] as! Array<Dictionary<String, Any>>
                    // print(articles)
                    self.newsData = articles
                    
                    // main thread 에서 ui를 그려줄 수 있도록 해준다.
                    DispatchQueue.main.async {
                        self.tableViewMain.reloadData() // 통보하는 역할
                    }

                    // 데이터를 잘 가져오는지 프린트로 찍어보았음
//                    for (idx, value) in articles.enumerated(){ // for 문 돌리는 방법 중 하나
//                        if let v = value as? Dictionary<String, Any> {
//                            print("\(v["title"])")
//                            v["description"]
//                        }
//                    }
                }
                catch {}
            }
        }
        
        task.resume()
    }
    
    // 필수 함수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 데이터 몇 개? 숫자
        if let news = newsData {
            return news.count
        } else {
            return 0
        }
//        return 100
    }
    
    // 필수 함수
    // 위의 numberOfRowsInSection 숫자 만큼 반복
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 데이터 무엇? 반복 10번?
        
        // 셀을 만드는 2가지 방법이 있음
        
        // 1번 방법 - 임의의 셀 만들기 : 1번 방법은 그냥 연습용이다.
        // 2번 방법 - 스토리보드 + id : 대부분을 2번 방법으로 한다.
        
        // 1번 방법을 사용
//        let cell = UITableViewCell.init(style: .default, reuseIdentifier: "tableCellType1")
//        cell.textLabel?.text = "\(indexPath.row)"
        
//        return cell
        
        // 2번 방법 사용
//        let cell = tableViewMain.dequeueReusableCell(withIdentifier: "Type1", for: indexPath) as! Type1
        
        // as? : 형변환. 불확실할 때 사용. 이거 맞아? 의미로 사용
        // as! : 형변환. 확실할 때 사용. 이거 맞아! 의미로 사용
        
//        cell.LabelText.text = "\(indexPath.row)"
        
        let cell = tableViewMain.dequeueReusableCell(withIdentifier: "Type1", for: indexPath) as! Type1
        
        let idx = indexPath.row
        if let news = newsData {
            let row = news[idx]
            if let r = row as? Dictionary<String, Any> {
                if let title = r["title"] as? String {
                    cell.LabelText.text = title
                }
            }
        }

        return cell
    }
    
    // 1. 디테일 상세화면 만들기
    // 2. 값을 보내기. 2가지 방법이 있음.
    // 2-1. tableview delegate 방식
    // 2-2. storyboard 방식(segue 또는 세그웨이라고 한다.)
    // 3. 화면 이동 (이동하기 전에 값을 미리 셋팅해야 한다.)

    
    // 아이템 클릭 가능하게 함. 이건 옵션이다. 이게 2-1번 방법
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\(indexPath.row) 클릭됨")
        
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(identifier: "NewsDetailController") as! NewsDetailController
       
        if let news = newsData {
            let row = news[indexPath.row]
            if let r = row as? Dictionary<String, Any> {
                if let imageUrl = r["urlToImage"] as? String {
                        controller.imageUrl = imageUrl
                }
                if let desc = r["description"] as? String {
                    controller.desc = desc
                }
            }
        }
        
        // 이동 - 수동으로 넘겨줘야 한다.
//        showDetailViewController(controller, sender: nil) 스토리보드 방법인 2-2 가 잘 작동하는지 보기 위해 주석 처리 하였음
    }
    
    // 2-2번 방법
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let id = segue.identifier, "NewsDetail" == id {
            if let controller = segue.destination as? NewsDetailController {
                
                if let news = newsData {
                    if let indexPath =                     tableViewMain.indexPathForSelectedRow {
                        let row = news[indexPath.row]
                        if let r = row as? Dictionary<String, Any> {
                            if let imageUrl = r["urlToImage"] as? String {
                                    controller.imageUrl = imageUrl
                            }
                            if let desc = r["description"] as? String {
                                controller.desc = desc
                            }
                        }
                    }
                }
            }
        }
        
        // 이동 - 스토리보드에서 자동으로 넘겨준다.
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableViewMain.delegate = self
        tableViewMain.dataSource = self
        
        getNews()
    }

    @IBAction func moveNextView(_ sender: UIButton) {
        
        if let second = self.storyboard?.instantiateViewController(withIdentifier: "SecondViewController") {
            self.navigationController?.pushViewController(second, animated: true)
        }
    }
}

