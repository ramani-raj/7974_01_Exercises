# import dplyr
# df data frame is created to read files


library(readxl)
library(dplyr)
library(readr)
library(stringr)
library(binr)
library(assertr)
library(mltools)
library(lubridate)
library(imputeTS)
library(descr)
#To read 'SaleData.xlsx'
df <- read_excel("SaleData.xlsx")

#To read diamond data set
df <- read.csv("diamonds.csv")

# To read the 'imdb.csv'
df<-read_delim("imdb.csv", delim=',', escape_double=FALSE, escape_backslash=TRUE)

# To read the 'movie_metadata.csv'
df <- read.csv("movie_metadata.csv")

# Q1  Find the least amount sale that was done for each item. 
least_sales <- function(df){
  ls <- df %>% group_by(Item) %>% summarise(min_sale=min(Sale_amt,na.rm = T))
  return(ls)
}


#Q2 Compute the total sales for each year and region across all items
sales_year_region  <-function(df){
  ts <- df %>% group_by(Year=as.numeric(format(OrderDate,'%Y')),Region) %>% summarise(Total_Sales=sum(Sale_amt,na.rm = T))
  return(ts)
}


#Q3 Create new column 'days_diff' with number of days difference between reference date passed and each order date 
days_diff <- function(df,date){
  df<- cbind(df,day_difference=floor(difftime(date,df$OrderDate)))
  return(df) 
}


# Q4 get dataframe with manager as first column and  salesman under them as lists in rows in second column.
mgr_slsmn <- function(df){
  ml <- df %>% group_by(Manager) %>% summarise(SalesMan=toString(unique(SalesMan)))
  return(ml) 
}


#Q5 For all regions find number of salesman and total sales. Return as a dataframe with three columns Region, salesmen_count and total_sales 
slsmn_units <-function(df){
  rf <- df %>% group_by(Region) %>% summarise(salesmen_count=n(),total_sales=sum(Sale_amt,na.rm=T))
  return(rf) 
}


#Q6 Create a dataframe with total sales as percentage for each manager. Dataframe to contain manager and percent_sales 
total_sales_pct <- function(df){
  tsum=sum(df$Sale_amt)
  total.sale.manager <- df  %>% group_by(Manager) %>% summarise(percent_sales= (sum(Sale_amt)/tsum )*100)
  return(total.sale.manager)
}



# Q7 get imdb rating for fifth movie of dataframe
fifth_movie <- function(df){
  val <-  df %>% group_by(type) %>% filter(type=="video.movie") %>% slice(5) %>% select(imdbRating)
  return (val)
}

# Q8 return titles of movies with shortest and longest run time
movies <- function(df){
  df1 <-df %>% group_by(type) %>% filter(type=="video.movie")
  res <-df1  %>% filter(duration == min(duration,na.rm=TRUE) ) %>% select(title)
  res <-rbind(res,df1  %>% filter(duration == max(duration,na.rm=TRUE) ) %>% select(title))
  return (res)
}

# Q9 sort by two columns - release_date (earliest) and Imdb rating(highest to lowest)
sort_df <- function(df){
  res <- arrange(df,year,desc(imdbRating))
  return (res)
}

# Q10 subset revenue more than 2 million and spent less than 1 million & duration between 30 mintues to 180 minutes
subset_df <- function(df){
  df$duration <- as.numeric(df$duration)
  res <- df %>% filter(duration<180 & duration>30 & gross>2000000 & budget <1000000 )
  return (res)
}




# Q11 count the duplicate rows of diamonds DataFrame.
dupl_rows <- function(df){
  val <- count(df[duplicated(df),])
  return (val)
}

# Q12 droping those rows where any value in a row is missing in carat and cut columns
drop_row <- function(df){
  df <- na.omit(df,cols=c("carat","cut"))
  return (df)
}

# Q13 subset only numeric columns
sub_numeric <-function(df){
  df$carat <- as.numeric(df$carat)
  df$z <- as.numeric(df$z)
  sub <-  select_if(df, is.numeric )
  return (sub)
}

# Q14 compute volume as (x*y*z) when depth > 60 else 8
volume <- function(df){
  df$z <- as.numeric(levels(df$z))[df$z]
  df <- cbind(df,vol= ifelse( df$depth < 60 , 8 , df$x*df$y*df$z))
  return (df)
}

# Q15 impute missing price values with mean
impute <- function(df){
  df <- df %>% mutate_at(vars(price),~ifelse(is.na(.x),mean(.x,na.rm = TRUE),.x))
  return(df)
}


#Bonus1
report1 <- function(df){
  df1 <- df %>% select(17:44)
  df['genre_combo'] <- apply(df1, 1, function(x) paste(names(x[x>=1]), collapse="|"))
  df1 <- df %>% group_by(year,type,genre_combo) %>% summarise(avg_rating=mean(imdbRating),min_rating=min(imdbRating),max_rating=max(imdbRating),total_run_time_mins=sum(duration))
  return(df1)
}

#Bonus2
report2 <- function(df){
  df <- na_mean(df)
  df$title_len <-nchar(df$wordsInTitle)
  df$percentile<-bin_data(df$duration,bins=4,binType = "quantile")
  df[is.na(df$wordsInTitle),"len"]=nchar(as.character(unlist(df[is.na(df$wordsInTitle),"title"])))
  res<-as.data.frame.matrix(table(df$year,df$percentile))
  colnames(res)<-c("num_videos_less_than25Percentile","num_videos_25_50Percentile ","num_videos_50_75Percentile","num_videos_greaterthan75Precentile")
  res2<-df%>%group_by(year)%>%summarise(min_len=min(title_len),max_len=max(title_len))
  return(cbind(res,res2))
}

#Bonus3
report3<- function(df){
  df$z <- as.numeric(df$z)
  df <- cbind(df,vol= ifelse( df$depth < 60 , 8 , df$x*df$y*df$z))
  cut=bin_data(df$vol,bins=4)
  df['bins']=as.numeric(cut)
  df=na.omit(df)
  res<-crosstab(df$bins,df$cut,prop.t=TRUE)
  return(res)
}