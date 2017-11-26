library(rvest)

#time start
time_start <- Sys.time()
#base_url
base_url <- "https://www.cosmed.com.tw/Contact"

#get total page count
#find the last element of <div class="btn-digit">
last_pages <-
  read_html(paste0(base_url, "/Shop_list.aspx?pg=9999")) %>%
  html_nodes(".btn-digit") %>%
  html_text()
page_count <- last_pages[length(last_pages)]

#download all pages
unlink("pages/*") # delete old data
for (i in 1:page_count) {
  url <- paste0(base_url, "/Shop_list.aspx?pg=", i)
  download.file(url, paste0("pages/", i, ".html"))
}

###################################################################################
# html example (of one store) (6 stores in a page) ################################
###################################################################################
# <div class="outletsList">
#   <table width="100%" border="0" cellspacing="0" cellpadding="0">
#     <tr>
#       <td class="TableTitile_OrangeredNo">門市名稱</td>
#       <td class="TableItem_OrangeredNo"><a href="Shop_intro.aspx?ID=270">西華門市</a>
#       </td>
#     </tr>
#     <tr>
#       <td class="TableTitile_OrangeredNo">門市地址</td>
#       <td class="TableItem_OrangeredNo">台北市松山區復興北路313巷30號1樓</td>
#     </tr>
#     <tr>
#       <td class="TableTitile_OrangeredNo">門市電話</td>
#       <td class="TableItem_OrangeredNo">02-25452182</td>
#     </tr>
#     <tr>
#       <td class="TableTitile_OrangeredNo">營業時間</td>
#       <td class="TableItem_OrangeredNo">平日08：00-23：00<br>假日09：00-23：00</td>
#     </tr>
#   </table>
#</div>
###################################################################################

#第i頁
#門市名稱/門市地址/門市電話/營業時間
#欄位名稱 TableTitile_OrangeredNo
#資料內容 TableItem_OrangeredNo
shop_list <- c()
for (i in 1:page_count) {
  doc <- read_html(paste0("pages/", i, ".html"))
  #欄位名稱 TableTitile
  TableTitile_OrangeredNo <-
    doc %>% html_nodes(".TableTitile_OrangeredNo") %>% html_text()
  #資料內容 TableItem
  TableItem_OrangeredNo <-
    doc %>% html_nodes(".TableItem_OrangeredNo") %>% html_text(trim = TRUE)
  #營業時間 open hours
  #replace <br>" to "\n"
  #replace <td class=\"TableItem_OrangeredNo\"> and </td>
  TableItem_OrangeredNo_2 <-
    doc %>% html_nodes(".TableItem_OrangeredNo") %>% gsub("<br>", "\n", .) %>%
    gsub("<td class=\"TableItem_OrangeredNo\">", "", .) %>% gsub("</td>", "", .)
  #門市網址 store_url
  store_url <-
    doc %>% html_nodes(".TableItem_OrangeredNo a") %>% html_attr("href")
  #add to shop_list
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
shop_list[, "門市網址"] <- paste0(base_url, shop_list[, "門市網址"])

#output to csv file
write.csv(shop_list, "output/shop_list.csv", row.names = T)

##check_list.csv
#time Start
check_list1 <- c("開始時間", format(time_start, "%x %T"))
#time End
check_list2 <- c("結束時間", format(Sys.time(), "%x %T"))
#url of the first Page
check_list3 <-
  c("第一頁", paste0(base_url, "/Shop_list.aspx?pg=1"))
#url of the last page
check_list4 <-
  c("最後一頁",
    paste0(base_url, "/Shop_list.aspx?pg=", page_count))
#output to csv file
write.table(
  rbind(check_list1, check_list2, check_list3, check_list4),
  "output/check_list.csv",
  sep = ",",
  col.names = FALSE,
  row.names = FALSE
)