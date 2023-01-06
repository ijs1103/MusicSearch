# MusicSearch

![Simulator Screen Recording - iPod touch (7th generation) - 2023-01-06 at 16 53 42](https://user-images.githubusercontent.com/42196410/210957648-2c3f07d5-2f04-44e7-ad3a-f5d59d4d2aba.gif)


## 🧩 개요

itunes api로 받아온 데이터를 테이블뷰 및 컬렉션뷰(flowLayout)에 표시

## 🤔 배운 내용

### ✔️ 네임스페이스

열거형 혹은 구조체로 네임스페이스 만들기

### ✔️ 네트워킹

1) 싱글톤

서버와 통신하는 클래스 인스턴스를 싱글톤으로 생성. 네트워킹은 여러 화면에서 요청되는 경우가 많으므로 메모리 누수를 방지하기 위해 싱글톤 패턴을 적용. 

2) 에러처리

`Result` 타입으로 성공과 실패 케이스를 정의하고, 실패 케이스는 열거형으로 분기 처리. 

### ✔️ 서치바

`searchResultsController`, `UISearchResultsUpdating`프로토콜을 사용. 글자가 입력될때 마다 api를 fetch하여 컬렉션뷰에 검색결과를 표시.

### ✔️ 이미지 동시성처리

시간이 오래걸리는 이미지 데이터 로드 작업은 global queue에서, UI 관련작업은 main queue에서 처리.

``` 
// Data 메서드를 비동기적으로 실행시킴
DispatchQueue.global().async {
            // URL을 가지고 데이터를 로드하는 동기적인 메서드
            guard let data = try? Data(contentsOf: url) else { return }
            // 빠르게 스크롤이 일어날때, 셀의 이미지가 꼬이는것을 방지 
            guard self.imageUrl! == url.absoluteString else { return }
            // 다른 큐에서 작업하더라도(여기선 global) UI 관련작업은 메인 스레드에서 실행시키는 코드
            DispatchQueue.main.async {
                self.mainImageView.image = UIImage(data: data)
            }
        } 
```

### ✔️ 기타

- `automaticDimension`: 테이블뷰에서 높이를 동적으로 조절할 수 있음
- `Codable, CodingKey`: fetch한 데이터의 key값을 커스터마이징 하기 위해 사용
- `iso8601DateFormatter`: string 날짜데이터를 원하는 형식으로 파싱 하기 위해 사용
