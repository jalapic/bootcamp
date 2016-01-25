#  Introduction to R & Sports Statistics


#  I will also put this up as a video online so you can recap.



### Preamble:

## I do expect that you've installed R and RStudio on your computer - see here for info:
# https://cran.r-project.org/bin/windows/base/
# https://www.rstudio.com/products/rstudio/download/


## Who is this appropriate for?     
# Beginners with no previous R experience
# Intermediates - I'll try and drop in things that you may have not previously considered


## Why I've structured the content like I have?
# Aim is that I will talk as I code/teach therefore...
# there is probably more reptition of code than you'd see if we were trying to make this compact and neat for reading only.
# why I keep writing "head(mydata)" - to show what happened following each bit
# there are also questions in the notes - this is to help me ask questions in class to the students

## Extra notes-
# Tried to get us as soon as possible to visualization and analysis without going too much into essentials of programming & R specifics
# There are dozens of ways of getting to the same endpoint in R - Tried showing you the ones that I think are best for new learners

# Each section shows some simple examples of how to do something that you will need. 
# There are references for help and more detailed info at the end of each section.



## What we are going to try and whizz through in 90 minutes........

#' Basic R Programming in RStudio
#' Getting Data into/out of RStudio
#' Data carpentry - how to navigate dataframes
#' dplyr & tidyr - some basics
#' Getting Summary Data and Descriptives
#' Basic Visualization using base and ggplot
#' Basic Statistics



# Stuff I'm not talking about today, but could go over another time (ask me)?

## Stats:

#'  Logistic Regression
#'  Multivariate Regression
#'  Non-linear Regression
#'  Mixed-effects models
#'  Factor Analysis
#'  Permutation Tests & Simulations
#'  Logisitic Regression
#'  Cluster Analysis
#'  Multidimensional Scaling
#'  PCA
#'  Mediation Analysis
#'  etc.


### Further R programming things:


#' - dates
#' - loops
#' - functions
#' - algorithms
#' - sampling, randomizations, permutations
#' - R data structures - vectors, dataframes, lists, factors/levels
#' - using apply, lapply, tapply, family
#' - interactivity in charts and tables 
#' - etc.
#' - etc. (there's a long list...)


### Next Class:

#'  Much more on visualization - e.g. using ggplot2










##########################################################################################################################################################

#### Obligatory Background Stuff. ----



## 1. Setting your working directory

getwd()  #where does RStudio think my working directory is
setwd("C:/Users/James Curley/Dropbox/Work/R/bootcamp/bootcamp") #type in the folder location you want to use here - can also set using Files panel in RStudio
#setwd("C:/Users/curley1/Dropbox/Work/R/bootcamp/bootcamp") # e.g. this is my laptop




## 2. Packages - What They Are & Installing Them


# Packages are lots of code, data, information, documentation all bound together for our convenience
# We can make our own packages, or we can install and use some that others have made


install.packages("dplyr")      # for example - if package hosted on CRAN - or use tab in RStudio


# Can install the latest development version from github with...
# devtools::install_github("hadley/dplyr")  #make sure you've already installed 'devtools' package

# Packages can be hosted elsewhere occasionally too (i.e. not only on GitHub or CRAN).



## Objects  ----

# Objects are things like data (in any of its forms), functions, etc.

mycolors <- c("blue", "red", "yellow")
mycolors

mynums <- 1:100
mynums

myfun <- function(x) {sample(x,1)}
myfun

myfun(mycolors)
myfun(mynums)



# some useful functions to do with objects

ls()  #should list objects in your global environment
list.files()  #lists files in your workspace (you can see these above with Rstudio)

x  <- c("just", "some", "things", 1, 2, 3, "james") #can combine numbers and characters - all will be characters
x


# Removing things 
rm(x)  #df should be removed
x
rm(list = ls(all = TRUE))  # or just all of it 

dev.off() #clears plots




##########################################################################################################################################################

####  Part 1: Getting Data into R ----


## Getting Data into R - 1.----

# There are ways of doing so from text file, csv file, excel file, other stats packages files, 
# webpages (HTML), XML, RData objects, fitbit, google drive, open docs, almost everything....
# special consideration maybe needed if you have really, really large files.
# see refs


# Example - csv file in working directory called pga.csv"
pga <- read.csv("C:/Users/James Curley/Dropbox/dataviz course/data/pga.csv", stringsAsFactors=FALSE)
head(pga)
tail(pga)

pga <- read.csv("pga.csv", stringsAsFactors=FALSE) # this will overwrite previous pga - be careful naming objects in R....   ok to use ".", "_", don't start with numbers
head(pga)
tail(pga)

dim(pga)
nrow(pga)
ncol(pga)

names(pga)
colnames(pga)
rownames(pga)

str(pga)


View(pga) # As you get more used to RStudio, you will likely not use this as much (useful for beginners though) #or just double click data in Global Environment



## Getting Data into R - 2. - Typing it in ----

df <- data.frame(
  country = c("Brazil", "Germany", "Italy", "Argentina", "Uruguay",
              "France", "England", "Spain", "Netherlands", "Czech_",
              "Hungary", "Sweden"),
  wins = c(5,4,4,2,2,1,1,1,0,0,0,0),
  runnerups = c(2,4,2,3,0,1,0,0,3,2,2,1),
  confed = c("COMMEBOL", "UEFA", "UEFA", "COMMEBOL", "COMMEBOL", "UEFA",
             "UEFA", "UEFA", "UEFA", "UEFA", "UEFA", "UEFA")
)

df

df$finals <- df$wins + df$runnerups


colnames(df)
colnames(df)[3]<-"finalists"
colnames(df)
colnames(df)<-c("Country", "Wins", "Finalists", "Confederation", "Finals")
df




### Brief aside: How to navigate our way around a dataframe in R using syntax:

head(pga)

pga$country  #dollar  sign here demarks the variable/column of interest
table(pga$country)

#rows come before comma
pga[1,]
pga[1:3,]

#columns come after
pga[,1,]
pga[,1:3]
pga[c(1:3)] #but you can do it this way which is useful sometimes

pga[1:3,1:3]



## Getting Data into R - 3.----

# Scraping Data, e.g. from NHL.com - as of 23 Jan 2016 (Season 2015/16) (note - be wary of Terms of Service)
# (note - if you can't get this to work - I'll make the csv available too - just skip next two lines)
home <- jsonlite::fromJSON("http://www.nhl.com/stats/rest/individual/skaters/game/skatersummary?cayenneExp=seasonId=20152016%20and%20gameTypeId=2%20and%20gameLocationCode=%22H%22")
road <- jsonlite::fromJSON("http://www.nhl.com/stats/rest/individual/skaters/game/skatersummary?cayenneExp=seasonId=20152016%20and%20gameTypeId=2%20and%20gameLocationCode=%22R%22")

home
str(home)

home$data
home[1]
home[[1]]

str(home[1])
str(home[[1]])


homedata <- home[[1]]
roaddata <- road[[1]]
homedata$location <- "home"
roaddata$location <- "road"
alldata <- rbind(homedata,roaddata)

head(alldata)
nhldata <- alldata[c(9,8,10,11,12,22,24,23,4,19,21,20,1,5,14,13,7,15,16,17,18)] #just putting columns into order I like 
# (normally wouldn't bother doing this, but just this once)


head(nhldata)
tail(nhldata)


#saving R-Data/Loading R-Data
write.table(nhldata, 'nhldata.csv', row.names = F, sep=",")  #save dataframe as csv
saveRDS(nhldata, 'nhldata.RData') #can use these for all R objects, not just dataframes

#to read these back in to RStudio
nhldata.X <- read.csv("nhldata.csv")
nhldata.Y <- readRDS("nhldata.RData")



#### REFERENCES:

#' https://www.datacamp.com/community/tutorials/r-data-import-tutorial
#' https://www.datacamp.com/community/tutorials/importing-data-r-part-two



##########################################################################################################################################################


####  Part 2:  Dataframe Carpentry:  Sorting, Filtering, Summarizing, Creating New Variables - with dplyr ----

#' Class Question - think of some things we'd like to do with these data...
head(nhldata)



### Adding Variables/Columns

#simple way:
nhldata$shotsPG <- nhldata$shots / nhldata$gamesPlayed
head(nhldata)


library(dplyr)

# new variable/column - total ice time 
nhldata <- nhldata %>% mutate(totalIceTime = timeOnIcePerGame * gamesPlayed)
head(nhldata)

nhldata <- nhldata %>% mutate(totalIceTime = round(timeOnIcePerGame * gamesPlayed, 0))
head(nhldata)


# new variable/column - total shifts 
nhldata <- nhldata %>% mutate(totalShifts = round(shiftsPerGame * gamesPlayed,0))
head(nhldata)


#new variable shots per minute
nhldata <- nhldata %>% mutate(shotsPM = shots / totalIceTime)
head(nhldata) #this would be shots per second

nhldata <- nhldata %>% mutate(shotsPM = (60*shots) / totalIceTime)
head(nhldata) #this is shots per minute - and we've overwritten the column/variable

nhldata <- nhldata %>% mutate(shotsPP = (60*shots*20) / totalIceTime) # you might prefer to do shot per period or something
head(nhldata)




### Sorting Variables/Columns

nhldata %>% arrange(shotsPM) 
nhldata %>% arrange(shotsPM) %>% head(10)  #to make output more visible
nhldata %>% arrange(shotsPM) %>% tail(10) 
nhldata %>% arrange(-shotsPM) %>% head(10) 


### Filtering data - e.g. just look at home data
nhldata %>% filter(location=='home') 

nhldata %>% filter(location=='home') %>% arrange(-shotsPM) %>% head(10)  #define in filter expression what we're keeping

nhldata.home <- nhldata %>% filter(location=='home') %>% arrange(-shotsPM)

#Let's look at a plot of shots vs shotsPM - much more on plotting later
plot(nhldata.home$shots, nhldata.home$shotsPM)
abline(h=0.2, col='red') #line to show 0.2 shots per minute


#Just look at shots per minute of players who have at least 100 shifts?

#can chain together and use variables created in chain...
nhldata %>% 
  filter(location=='home' & totalShifts>=100) %>% 
  arrange(-shotsPM) %>% 
  head(10)


## group_by & Summarize
nhldata %>% group_by(location, playerPositionCode) %>% summarize(shotsPM.mean = mean(shotsPM), shotsPM.sd = sd(shotsPM))


## Summarizing Data by Player.  - there is a reason we're not doing this by playerId - anyone know why?
nhldata %>% group_by(playerName, teamAbbrev) %>% summarise_each(funs(sum(., na.rm = TRUE)), 9:26) #9:26 means sum the values in columns 9 thru 24.

nhldata.sum <- nhldata %>% group_by(playerName, teamAbbrev) %>% summarise_each(funs(sum(., na.rm = TRUE)), 9:26) #9:26 means sum the values in columns 9 thru 24.
nhldata.sum

#sanity check- does Aaron Ekblad FLA have 44 games and 105 shots in total ? (if scraped data yourself, these numbers will be different)
nhldata %>% filter(playerName=="Aaron Ekblad") #He only played for Florida this year


# Keep all that useful info about team, name, position... in its own data.frame
nhldata[,1:6]
nhldata[c(1:6)] #another way of doing it
nhl.players <- nhldata[c(1:6)]

nrow(nhl.players) #1589
unique(nhl.players)   # can also be written as...   nhl.players %>% unique
nrow(unique(nhl.players)) #820



## let's join these two things together... (there are several types of joins with dplyr - see refs)

nhl.players <- unique(nhl.players)

head(nhl.players)
head(nhldata.sum)

nhl.players %>% arrange(playerId) %>% head(10)  #do you notice anything about these players? (requires some hockey knowledge)


#
nhldata1 <- nhl.players %>% left_join(nhldata.sum) #What does this mean?   <Joining by: c("playerName", "teamAbbrev")>
head(nhldata1)

nrow(nhldata)       #1589
nrow(nhldata.sum)   #820
nrow(nhl.players)   #820
nrow(nhldata1)      #820

head(nhldata1)





### Deleting columns. - some columns are now meaningless when summed.  TotalIceTime is ok - that's just a sum already
nhldata1$shotsPP <- NULL
nhldata1$shotsPG <- NULL
nhldata1$shotsPM <- NULL
nhldata1$shootingPctg <- NULL
nhldata1$shiftsPerGame <- NULL


head(nhldata1)  #these summed variables make sense


#of course, we could have just overwritten them...

nhldata1 <- nhldata1 %>% 
                 mutate(shotsPG = shots / gamesPlayed,
                        shotsPM = (60*shots) / totalIceTime,
                        shotsPP = (60*shots*20) / totalIceTime,
                        shootingPctg = goals/shots,
                        shiftsPerGame = totalShifts/gamesPlayed
                        )
head(nhldata1)


# Why did I not do this by playerID ??? (because some players played for more than one team) - let's find them
nhldata %>%
  group_by(playerId, playerName) %>%
  summarize(total = n()) %>%
  filter(total>2)



### Let's Summarize Some Data By Team.
  
# total shots per team & total goals per team, goals/100shots
nhldata1 %>% group_by(teamAbbrev) %>% summarize(totalSh = sum(shots), totalG = sum(goals)) %>% mutate(G100Sh = (100*totalG)/totalSh)

nhldata %>% group_by(teamAbbrev,location) %>% summarize(totalSh = sum(shots), totalG = sum(goals)) %>% mutate(G100Sh = (100*totalG)/totalSh)



### Just as an FYI - some other helpful dplyr syntax.

nhldata1 %>% group_by(teamAbbrev) %>% summarize(totalplayers = n())    #n() will count variables

nhldata1 %>% group_by(teamAbbrev) %>% select(goals,shots,totalIceTime) #select - select columns/variables

#there are many other useful functions in dplyr - see references



### REFERENCES ON dplyr & JOINS - 

#' https://cran.rstudio.com/web/packages/dplyr/vignettes/introduction.html
#' http://www.dataschool.io/dplyr-tutorial-for-faster-data-manipulation-in-r/
#' http://genomicsclass.github.io/book/pages/dplyr_tutorial.html
#' https://stat545-ubc.github.io/bit001_dplyr-cheatsheet.html



##########################################################################################################################################################


### Part 3: Summary Statistics ----

# mean, median, stdev, n, st.error, inter-quartile ranges, min, max

head(nhldata1)

nhldata1$shiftsPerGame
length(nhldata1$shiftsPerGame)
summary(nhldata1$shiftsPerGame)

mean(nhldata1$shiftsPerGame)
mean(nhldata1$shiftsPerGame,na.rm=T)
median(nhldata1$shiftsPerGame,na.rm=T)
sd(nhldata1$shiftsPerGame,na.rm=T)
var(nhldata1$shiftsPerGame,na.rm=T)
min(nhldata1$shiftsPerGame)
max(nhldata1$shiftsPerGame)
range(nhldata1$shiftsPerGame)

sem <- function(x) sd(x,na.rm=T)/sqrt(length(x))
sem(nhldata1$shiftsPerGame)


summary(nhldata1)

nhldata1 %>% filter(totalIceTime<100)

nhldata1 %>% filter(totalIceTime>=3600) %>% summary

nhldata1 %>% filter(totalIceTime>=3600) %>% arrange(-shootingPctg) %>% head(10)


# histograms
hist(nhldata1$shiftsPerGame) #we'll modify and make nicer ones later
hist(nhldata1$shiftsPerGame, main="histogram of Shifts/Game") #we'll modify and make nicer ones later
hist(nhldata1$shiftsPerGame, main="histogram of Shifts/Game", breaks=20) 



# boxplots
boxplot(nhldata1$shiftsPerGame) #we'll modify and make nicer ones later
boxplot(shiftsPerGame~playerPositionCode, data=nhldata1) #


## summary stats by group:
nhldata1 %>% 
  group_by(playerPositionCode) %>%
  summarize(meanShifts = mean(shiftsPerGame),
            sdShifts = sd(shiftsPerGame)
  )




##########################################################################################################################################################


### Part 4: Basic Stats ----

## 1 - correlations, linear regression. 

#Do road & home shots/g correlate
nhldata %>% group_by(teamAbbrev,location) %>% summarize(totalSh = sum(shots), totalG = sum(goals)) %>% mutate(ShPG = totalSh/totalG)

nhldata.shpg <- nhldata %>% group_by(teamAbbrev,location) %>% summarize(totalSh = sum(shots), totalG = sum(goals)) %>% mutate(ShPG = totalSh/totalG)
nrow(nhldata.shpg) #60 - sanity check - 30 teams playing home/road

library(tidyr)
nhldata.shpg1 <- nhldata.shpg %>% select(teamAbbrev,location,ShPG) %>% spread(location, ShPG)

plot(nhldata.shpg1$home, nhldata.shpg1$road)

library(ggplot2)
ggplot(nhldata.shpg1, aes(home,road)) + geom_point()
ggplot(nhldata.shpg1, aes(home,road)) + geom_point(size=3) + stat_smooth(method='lm')
ggplot(nhldata.shpg1, aes(home,road)) + geom_point(size=3) + stat_smooth(method='lm', se=F)


cor(nhldata.shpg1$home, nhldata.shpg1$road)
cor.test(nhldata.shpg1$home, nhldata.shpg1$road)
cor.test(nhldata.shpg1$home, nhldata.shpg1$road, method='spearman')

summary(lm(road~home, nhldata.shpg1)) #linear regression
     

### REFERENCES:

#' basic stats:
#' http://www.statmethods.net/stATS/index.html
#' https://github.com/jalapic/IntroR

#' ggplotting - (we will go over this in much more detail later) 
#'  http://zevross.com/blog/2014/08/04/beautiful-plotting-in-r-a-ggplot2-cheatsheet-3/
#'  http://docs.ggplot2.org/current/index.html
#'  http://www.cookbook-r.com/Graphs/

#' tidyr
#' http://www.jvcasillas.com/tidyr_tutorial/
#' https://rpubs.com/bradleyboehmke/data_wrangling


##############


### Basic Stats;  2 sample T-tests / Mann-Whitney Test
nhldata.shpg1

boxplot(ShPG~location,nhldata.shpg)

t.test(nhldata.shpg1$home, nhldata.shpg1$road, paired=T)
wilcox.test(nhldata.shpg1$home, nhldata.shpg1$road, paired=T)



## Non-paired - do forwards have smaller shooting percentages than Defensemen?

boxplot(shootingPctg~playerPositionCode, data=nhldata1) 

nhldata1 %>% filter(shootingPctg>=1)

head(nhldata1)

nhldata1 <- nhldata1 %>% mutate(position = ifelse(playerPositionCode=="D", "D", "F"))
boxplot(shootingPctg~position, data=nhldata1) 

shots.def <- nhldata1 %>% filter(position=="D") %>% .$shootingPctg
shots.for <- nhldata1 %>% filter(position!="D") %>% .$shootingPctg

shots.def
shots.for

t.test(shots.def, shots.for)
t.test(shots.def, shots.for, var.equal = T ) #I don't recommend

hist(shots.def)
hist(shots.for)

shapiro.test(shots.def) #not normal
shapiro.test(shots.for) #not normal

wilcox.test(shots.def, shots.for)

#of course, better ways exist to answer the question such as using mixed-effects models


head(nhldata1)
## Do defensemen have more penalty minutes?
boxplot(penaltyMinutes~position, data=nhldata1) 

#using split plus doing a one-tailed test
split(nhldata1$penaltyMinutes, nhldata1$position)
a1<-split(nhldata1$penaltyMinutes, nhldata1$position)[[1]] #defensemen
b1<-split(nhldata1$penaltyMinutes, nhldata1$position)[[2]] #forwards - it's done alphabetically

hist(a1)
hist(b1)

wilcox.test(a1,b1) #two-tailed by default
wilcox.test(a1,b1, alternative=c("greater")) #"two.sided" (default), "greater" or "less". 
wilcox.test(a1,b1, alternative=c("less")) # alternative refers to 1st compared to 2nd argument




##########################################################################################################################################################

### Basic Stats: One Way ANOVA & post-hoc tests

head(nhldata1)
boxplot(shiftsPerGame~playerPositionCode, data=nhldata1) 

aov(shiftsPerGame~playerPositionCode, data=nhldata1) 
aov(shiftsPerGame~playerPositionCode, data=nhldata1) %>% summary

pairwise.t.test(nhldata1$shiftsPerGame, nhldata1$playerPositionCode, p.adj = "none")
pairwise.t.test(nhldata1$shiftsPerGame, nhldata1$playerPositionCode, p.adj = "bonf")
pairwise.t.test(nhldata1$shiftsPerGame, nhldata1$playerPositionCode, p.adj = "holm")



##########################################################################################################################################################


