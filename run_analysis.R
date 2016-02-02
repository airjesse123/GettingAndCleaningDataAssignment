url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv"
filepath  <-file.path(getwd(),"FGDP.csv")
download.file(url, filepath, mode = "wb")
dtGDP <- data.table(read.csv(filepath, skip = 4, nrows = 215))
dtGDP <- dtGDP[X != ""]
dtGDP <- dtGDP[, list(X, X.1, X.3, X.4)]
setnames(dtGDP, c("X", "X.1", "X.3", "X.4"), c("CountryCode", "rankingGDP", 
                                               "Long.Name", "gdp"))

url2 <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv"
filepath2  <-file.path(getwd(),"FGDP.csv")
download.file(url2, filepath2, mode = "wb")
dtEd <- data.table(read.csv(filepath2))
dt <- merge(dtGDP, dtEd, all = TRUE, by = c("CountryCode"))
sum(!is.na(unique(dt$rankingGDP)))

dt[order(rankingGDP, decreasing = TRUE), list(CountryCode, Long.Name.x, Long.Name.y,rankingGDP, gdp)][13]

dt[, mean(rankingGDP, na.rm = TRUE), by = Income.Group]

cuts <- quantile(dt$rankingGDP, probs = c(0.0, 0.2,0.4,0.6,0.8, 1), na.rm = TRUE)
dt$quantileGDP <- cut(dt$rankingGDP, breaks = cuts)
dt[Income.Group == "Lower middle income", .N, by = c("Income.Group", "quantileGDP")]
