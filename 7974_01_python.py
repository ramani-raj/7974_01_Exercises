# %load python_exercise_solution_ramani.py
# %load python_exercise_template.py
# import pandas, numpy
# Create the required data frames by reading in the files

import numpy as np
import pandas as pd
from datetime import datetime


# To read the 'SaleData'
df = pd.read_excel("SaleData.xlsx")

# To read the 'imdb.csv'
df= pd.read_csv("imdb.csv",escapechar="\\")

#To read 'diamonds.csv'
df = pd.read_csv("diamonds.csv")

# Q1 Find least sales amount for each item
def least_sales(df):
    # write code to return pandas dataframe
    ls = df.groupby(["Item"])["Sale_amt"].min().reset_index()
    return ls

# Q2 compute total sales at each year X region
def sales_year_region(df):
    # write code to return pandas dataframe
    copy_df=df.copy()
    copy_df['Year']=copy_df['OrderDate'].apply(lambda x: x.year)
    sal=copy_df.groupby(['Year','Region'])['Sale_amt'].sum()
    return sal

# Q3 append column with no of days difference from present date to each order date
def days_diff(df,date):
    # write code to return pandas dataframe
    mod_df=df.copy()
    dateFormat="%Y-%m-%d"
    t=datetime.strptime(str(date),dateFormat)
    mod_df['days_diff']=mod_df['OrderDate'].apply(lambda x : (t-x).days)
    return mod_df


# Q4 get dataframe with manager as first column and  salesman under them as lists in rows in second column.
def mgr_slsmn(df):
    # write code to return pandas dataframe
    grouped_df=df.groupby(['Manager','SalesMan']).describe()
    grouped_df.drop(columns=['Units','Unit_price','Sale_amt'],inplace=True)
    return grouped_df


# Q5 For all regions find number of salesman and total sales
def slsmn_units(df):
    # write code to return pandas dataframe
    slsmn=df.groupby('Region').agg({'SalesMan':'count','Sale_amt':'sum'}).reset_index().rename(columns={'SalesMan':'salesman_count','Sale_amt':'total_sales'})
    return slsmn

# Q6 Find total sales as percentage for each manager
def sales_pct(df):
    # write code to return pandas dataframe
    total_sales=df.groupby('Manager').agg({'Sale_amt':'sum'}).rename(columns={'Sale_amt':'percent_sales'})
    total_sales=total_sales/total_sales.sum()*100
    return total_sales



# Q7 get imdb rating for fifth movie of dataframe
def fifth_movie(df):
	# write code here
    val=df[df['type']=='video.movie'].reset_index().iloc[4]['imdbRating']
    return val

# Q8 return titles of movies with shortest and longest run time
def movies(df):
	# write code here
    df1=df[df['type']=='video.movie'].reset_index()
    mlist=df1[(df1['duration'].min()==df1['duration']) |(df1['duration'].max()==df1['duration'])]['title']
    return mlist

# Q9 sort by two columns - release_date (earliest) and Imdb rating(highest to lowest)
def sort_df(df):
	# write code here
    sort=df.sort_values(by=['year','imdbRating'],ascending=[True,False])
    return sort

# Q10 subset revenue more than 2 million and spent less than 1 million & duration between 30 mintues to 180 minutes
def subset_df(df):
	# write code here
    subset=df[(df['duration']>30) & (df['duration']<180) & (df['gross']>2000000) & (df['budget']<1000000)]
    return subset



# Q11 count the duplicate rows of diamonds DataFrame.
def dupl_rows(df):
	# write code here
    dup_count=len(df[df.duplicated(subset=None)])
    return dup_count
    

# Q12 droping those rows where any value in a row is missing in carat and cut columns
def drop_row(df):
	# write code here
    df=df.dropna(axis=0,how='any',subset=['carat','cut'],inplace=True)
    return df


# Q13 subset only numeric columns
def sub_numeric(df):
	# write code here
    df['carat']=pd.to_numeric(df['carat'],errors='coerce')
    df['z']=pd.to_numeric(df['z'],errors='coerce')
    new_df=df.select_dtypes(include=np.number)
    return new_df


# Q14 compute volume as (x*y*z) when depth > 60 else 8
def volume(df):
	# write code here
    df['volume']=df.apply(calc,axis=1)
    return df

def calc(row): 
        if row['depth']<60:
            return 8
        else:
            x=pd.to_numeric(row['x'],errors='coerce')
            y=pd.to_numeric(row['y'],errors='coerce')
            z=pd.to_numeric(row['z'],errors='coerce')
            return x*y*z
        

# Q15 impute missing price values with mean
def impute(df):
	# write code here
    df['price'].fillna(df['price'].mean(),inplace=True)

# Bonus Question
#Q1
def report1(df):
    df1 = df.groupby('year').sum()
    df1.drop(columns={'imdbRating', 'ratingCount', 'duration', 'nrOfWins', 'nrOfNominations',
       'nrOfPhotos', 'nrOfNewsArticles', 'nrOfUserReviews', 'nrOfGenre'},inplace=True)
    df1['genre_combo'] = df1.apply(lambda x: '|'.join(x.index[x>= 1]), axis=1)
    res1=df.groupby(['year','type'])['imdbRating'].agg([('avg_rating','mean'),('min_rating','min'),('max_rating','max')])
    res2=df.groupby(['year','type'])['duration'].agg([('total_run_time_mins','sum')])
    mer=pd.merge(res1,res2,on=['year','type'])
    df1.reset_index()
    mer=pd.merge(mer,df1['genre_combo'],on=['year'])
    return mer

#Bonus Question
#Q2

def report2(df):
    df1=df.copy()

    df1['title_len']=df1['wordsInTitle'].str.len()
    df2=df1.groupby('year')['title_len'].agg([('min_length','min'),('max_length','max')])
    df3=df1.groupby('year')['title_len'].describe(percentiles=[0.25,0.5,0.75]).drop(['count','mean','std','min','max'],axis=1).reset_index()
    df4= pd.merge(df2,df3,on='year')
    df4= pd.merge(df1,df4,on='year')
    df4['num_25']=(df4['title_len']<df4['25%'])*1
    df4['num_25_50']=((df4['title_len']>=df4['25%'])&(df4['title_len']<=df4['50%']))*1
    df4['num_50_75']=((df4['title_len']>df4['50%'])&(df4['title_len']<=df4['75%']))*1
    df4['num_75']=(df4['title_len']>df4['75%'])*1

    mer=df4.groupby('year')['num_25','num_25_50','num_50_75','num_75'].agg([('count','sum')])
    res=pd.merge(df2,mer,on='year').reset_index()
    res.columns=['year','min_length','max_length',' num_videos_less_than25Percentile','num_videos_25_50Percentile ','num_videos_50_75Percentile','num_videos_greaterthan75Precentile']
    return res


#Bonus Question
#Q3

def report3(df):
    df['bins']=pd.qcut(df['volume'],q=4)
    cross=pd.crosstab(df.bins, df.cut, normalize="all")*100
    return cross

#Bonus Question
#Q4
def report4(df): 
    grp=(df.groupby('title_year',group_keys=False).apply(lambda x: x.nlargest(int(len(x)*0.1),'gross'))).reset_index()
    df1=grp.groupby('title_year')['imdb_score'].mean().reset_index()
    df1.rename(columns={'imdb_score':'Avg_imdb_score'},inplace=True)
    
    new_df=grp.genres.str.get_dummies('|')
    mer=pd.merge(grp.title_year,new_df,on=None,left_index=True,right_index=True)
    mer=mer.groupby('title_year').sum()
    res=pd.merge(df1,mer,on='title_year')
    
    return res

#Bonus Question
#Q5
def report5(df):
    df['deciles']=pd.qcut(df['duration'],10,labels=False)
    df.dropna(axis=0,how='any',subset=['deciles'],inplace=True)
    df.deciles=df.deciles.astype(int)
    df.drop(columns=['imdbRating','ratingCount','duration','year','nrOfPhotos','nrOfNewsArticles','nrOfUserReviews','nrOfGenre'],axis=1,inplace=True)
    df1=df.groupby('deciles').sum()
    df2=df1.drop(columns=['nrOfWins','nrOfNominations'],axis=1)

    df3=df.groupby('deciles')['title'].count()
    df1=pd.merge(df1,df3, on='deciles')



    def get_n_largest_ind(a,n):
        ind = np.argpartition(a, -n)[-n:]
        return ind[0]

    cols = df2.columns
    for n in [1,2,3]:
        df1["top{}".format(n)] = df1[cols].apply(lambda x: cols[get_n_largest_ind(x,n)],axis=1)

    df1.drop(columns={'Action', 'Adult', 'Adventure',
       'Animation', 'Biography', 'Comedy', 'Crime', 'Documentary', 'Drama',
       'Family', 'Fantasy', 'FilmNoir', 'GameShow', 'History', 'Horror',
       'Music', 'Musical', 'Mystery', 'News', 'RealityTV', 'Romance', 'SciFi',
       'Short', 'Sport', 'TalkShow', 'Thriller', 'War', 'Western'},inplace=True)
    df1.columns=(['nrOfWins','nrOfNominations','count','top1','top2','top3'])
    return df1