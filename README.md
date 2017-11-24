# cosmed-store-list
使用R語言rvest套件，擷取康是美門市列表。

資料來源： [康是美門市查詢](https://www.cosmed.com.tw/Contact/Shop_list.aspx)
![webpage](/screenshots/webpage.png?raw=true "webpage")

輸出結果（csv檔）： 
![webpage](/screenshots/store_list_csv.png?raw=true "webpage")




## Requirements

須安裝[R](https://www.r-project.org/)以及R語言的[rvest](https://github.com/hadley/rvest)套件

安裝rvest
```
install.packages("rvest")
```

若是使用Ubuntu安裝可能會出現錯誤訊息，請參考：
> [https://olycats.github.io/2017/11/24/ubuntu-rvest/](https://olycats.github.io/2017/11/24/ubuntu-rvest/)


## 執行
因執行結果會將檔案輸出在目前的工作目錄，
開啟R後，請先確認目前的工作目錄。
```
getwd()
```

若您有指定的路徑，請自行設定工作目錄。
```
setwd(dir)
```

## 輸出結果
執行 store-list-crawler.R ，會將結果輸出為兩個CSV檔案：

* shop_list.csv

    除標題欄、標題列之外，共有6欄 * N列。

    欄位名稱  |資料範例
    -------- | ---------------------------------- 
    門市名稱 | 富農門市
    門市網址 | https://www.cosmed.com.tw/Contact/Shop_intro.aspx?ID=519
    門市地址 | 台南市東區裕農路766號
    門市電話 | 036-3317533
    營業時間 | "假日:9-23 平日:9-23"

    其中「營業時間」包含換行字元。

* check_list.csv
    除標題欄、標題列之外，共有4欄 * 1列。

    欄位名稱  |資料範例
    -------- | ---------------------------------- 
    開始時間  |	2017年11月24日 星期五 01:48:35 
    結束時間  |	2017年11月24日 星期五 01:48:57 
    第一頁    |      https://www.cosmed.com.tw/Contact/Shop_list.aspx?pg=1 
    最後一頁  |	https://www.cosmed.com.tw/Contact/Shop_list.aspx?pg=67 

## 我的開發環境：
* Ubuntu 16.04.3 LTS
* R version 3.4.2 (2017-09-28) -- "Short Summer"
* RStudio Version 1.1.383 – © 2009-2017 RStudio, Inc.

尚未在其他環境測試，不確定是否能支援。
