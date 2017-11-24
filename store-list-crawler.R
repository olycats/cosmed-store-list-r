library(rvest)

#time_start
time_start <- Sys.time()

#base_url
base_url <- "https://www.cosmed.com.tw/Contact/"

##total page
last_pages <-
  read_html(paste0(base_url, "Shop_list.aspx?pg=9999")) %>%
  html_nodes(".btn-digit") %>%
  html_text()
page_count <- last_pages[length(last_pages)]

#第i頁
#門市名稱/門市地址/門市電話/營業時間
#欄位名稱 TableTitile_OrangeredNo
#資料內容 TableItem_OrangeredNo
shop_list <- c()
for (i in 1:page_count) {
  url   <- paste0(base_url, "/Shop_list.aspx?pg=", i)
  doc   <- read_html(url)
  TableTitile_OrangeredNo <-
    doc %>% html_nodes(".TableTitile_OrangeredNo") %>% html_text()
  TableItem_OrangeredNo <-
    doc %>% html_nodes(".TableItem_OrangeredNo") %>% html_text(trim = TRUE)
  TableItem_OrangeredNo_2 <-
    doc %>% html_nodes(".TableItem_OrangeredNo") %>% gsub("<br>", "\n", .) %>% 
    gsub("<td class=\"TableItem_OrangeredNo\">", "", .) %>% gsub("</td>", "", .)
  store_url <-
    doc %>% html_nodes(".TableItem_OrangeredNo a") %>% html_attr("href")
  shop_list <- rbind(
    shop_list,
    cbind(
      TableItem_OrangeredNo[TableTitile_OrangeredNo == "門市名稱"],
      store_url,
      TableItem_OrangeredNo[TableTitile_OrangeredNo == "門市地址"],
      TableItem_OrangeredNo[TableTitile_OrangeredNo == "門市電話"],
      TableItem_OrangeredNo_2[TableTitile_OrangeredNo == "營業時間"]
    )
  )
}

##data convert
colnames(shop_list) <- c("門市名稱", "門市網址", "門市地址", "門市電話", "營業時間")
shop_list[, "門市名稱"] <- shop_list[, "門市名稱"]
shop_list[, "門市網址"] <- paste0(base_url, shop_list[, "門市網址"])
shop_list[, "營業時間"] <- shop_list[, "營業時間"]

## write table to file
write.csv(shop_list, "shop_list.csv", row.names = T)

##check_list()
check_list <- c()
check_list <- append(check_list, format(time_start, "%x %T"))
check_list <- append(check_list, format(Sys.time(), "%x %T"))
check_list <-
  append(check_list, paste0(base_url, "Shop_list.aspx?pg=1"))
check_list <-
  append(check_list,
         paste0(base_url, "Shop_list.aspx?pg=", page_count))
check_list <-
  data.frame(matrix(check_list, ncol = 4, byrow = T), stringsAsFactors = F)
colnames(check_list) <- c("開始時間", "結束時間", "第一頁", "最後一頁")
write.csv(check_list, "check_list.csv", row.names = T)

