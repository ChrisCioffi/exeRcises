#here's the code for installing most packages 
#install.packages("tidyverse")
#this is the code to call most packages
library(tidyverse)

#read the CSV into R and turn  it into a data table.
congress <- read_csv("2018Midterms.csv")



# [ ] subset things like dataframes
# ( ) pass arguments to a function -- for instance c("apple", "orange") the concatenate function creates a vector with two items


#So here' we're going to look at duplictaes... saying look at the subset of the dataframe congress that have duplicate items, and show them , all to me. 
#look at the head (beginning of the dataframe) and the n=10 rows.
head(congress[duplicated(congress), ], n=10)

#great. Now on a big screen, it may print them all off. So we need to figure out how to look at all the individual rows that are not identical. 

#looked at them manually, noted they were basically just except for the occupation ID row...and since this is just a basic exercise, we're going to just slice ooyt that occupation type id, so we can look at the data. 

#welcome to the tidyverse. And the world of pipes. 
#https://s3.amazonaws.com/assets.datacamp.com/blog_assets/Tidyverse+Cheat+Sheet.pdf
#https://www.rstudio.com/resources/cheatsheets/
#pipes %>% are these helpful little dealies that help us string functions together. 


#here' we're going to create a new dataframe, called cleancongress from congress. With only distinct records and the columns we want.
#first let's see the column names for our dataframe
#note. I took out race because the data is super dirty. And for the purposes of this exercise, it's too much trouble to clean.

head(congress, 0)


#create a new dataframe, call it cleancongresss from the old dataframe called congres
cleancongress <- congress %>%
# select columns you want. 
select(PERSON_ID, FIRST_NAME, LAST_NAME, PARTY_ABBREVIATION, STATE_POSTAL_CODE, OVERALL_START_DATE, DATE_TERM_ENDS, SEX_CODE, BIRTH_DATE, HIGHEST_DEGREE_TYPE_ID, RELIGION_TEXT) %>%
#now let's change the column names 
setNames(c('ID', 'first', 'last', 'party', "zip", "start", "end", "sex", "birthday", "degree", "religion")) %>%   
###### removed duplicated rows by selecting distinct records..now if this wasn't an exercise, I'd be a bit more circumspect about the entries we're dropping.
  distinct()

#So now that we've got the basic data, we need to prepare our data for charts.
religion <- cleancongress %>%
  #now we can group by religion
  group_by(religion) %>%
  #count what we've got
  #summarise(): they add an additional column rather than collapsing each group. by adding count = n()  we can name a new column 
  summarise(count = n()) %>%
  #now let's arrange it descending 
  arrange(desc(count)) %>%
  #annnd let's take the top 7 values (this can be changed to be anty number. To get the bottom 5, let's say, you would use -5)
  top_n(7)

#write CSV
write_csv(religion, "religion.csv")


#here's some other summary functions / https://suzan.rbind.io/2018/04/dplyr-tutorial-4/
#summarise(n = n(), average = mean(x), maximum = max(x))


# Basic barplot // this creates anx stores a chart, then it calls it 
p <-ggplot(data=religion, aes(x=religion, y=count)) +
  geom_bar(stat="identity")
p

# Horizontal bar plot
p + coord_flip()

#In stead of calling this as a aseparate thing, we're going to join the whole thing together using pipes and + signs

  # Change the width of bars
religion %>%
  ggplot(aes(x=religion, y=count)) +
  geom_bar(stat="identity", width=0.5)
# Change colors
religion %>%
  ggplot(aes(x=religion, y=count)) +
  geom_bar(stat="identity", color="blue", fill="white")
# Minimal theme + blue fill color
religion %>%
  ggplot(aes(x=religion, y=count)) +
  geom_bar(stat="identity", fill="steelblue")+
  theme_minimal()

# Outside bars
religion %>%
  ggplot(aes(x=religion, y=count)) +
  geom_bar(stat="identity", fill="steelblue")+
  geom_text(aes(label=count), vjust=-0.3, size=3.5)+
  theme_minimal()
# Inside bars
religion %>%
  ggplot(aes(x=religion, y=count)) +
  geom_bar(stat="identity", fill="steelblue")+
  geom_text(aes(label=count), vjust=1.6, color="white", size=3.5)+
  theme_minimal()

