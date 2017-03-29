#from the pdf
getwd()
list.files()
dir()
setwd("/media/jp/SHARE/udacity/p4/EDA_Course_Materials/lesson3/")
list.files()
pf <- read.csv('pseudo_facebook.tsv', sep = '\t')
names(pf)
install.packages('ggplot2')
library(ggplot2)

#play
levels(pf$age)
str(pf)
table(pf$age)
qplot(data = pf, x = age)

#dob by age
qplot(x = dob_day, data = pf) +
  scale_x_continuous(breaks=1:31)

# Faceting
# facet_wrap(formula)
# facet_wrap(~variable)
# facet_wrap useful for one variable
qplot(x = dob_day, data = pf) +
  scale_x_continuous(breaks=1:31) +
  facet_wrap(~dob_month, ncol=3)
# facet_grid(formula)
# facet_grid(vertical ~ horizontal)
# facet_grid useful for two or more variables

#FRIEND COUNT
qplot(x = friend_count,data = pf)

#this data is called long tailed data
qplot(x = friend_count,data = pf,xlim = c(0,1000))

#alternate way of creating same output
qplot(x = friend_count, data = pf) +
  scale_x_continuous(limits = c(0,1000))

#adjusting bin width
qplot(x = friend_count, data = pf, binwidth = 25) +
  scale_x_continuous(limits = c(0,1000))

#breaking the X-axis at intervals
qplot(x = friend_count, data = pf, binwidth = 25) +
  scale_x_continuous(limits = c(0,1000), breaks = seq(0,1000,50))#the seq object has start, end, step values

#split by gender
qplot(x = friend_count, data = pf, binwidth = 25) +
  scale_x_continuous(limits = c(0,1000), breaks = seq()) +
  facet_wrap(~gender, ncol(3))
#missing values take up the value NA in R
#----------------------------------------------------------------
#scales in ggplot2(notes below video)
#Equivalent ggplot syntax: 
  ggplot(aes(x = friend_count), data = pf) + 
  geom_histogram(binwidth = 25) + 
  scale_x_continuous(limits = c(0, 1000), breaks = seq(0, 1000, 50))

qplot(x = friend_count, data = pf, binwidth = 25) + 
  scale_x_continuous(limits = c(0, 1000), breaks = seq(0, 1000, 50))

#In the alternate solution below, the period or dot in the formula for facet_grid() represents all of the other variables in the data set. Essentially, this notation splits up the data by gender and produces three histograms, each having their own row. 
qplot(x = friend_count, data = pf) + 
  facet_grid(gender ~ .) 

#Equivalent ggplot syntax: 
  ggplot(aes(x = friend_count), data = pf) + 
  geom_histogram() + 
  scale_x_continuous(limits = c(0, 1000), breaks = seq(0, 1000, 50)) + 
  facet_wrap(~gender)
#--------------------------------------------
#omitting NA Gender Observations
  qplot(x = friend_count, data = subset(pf, !is.na(gender)), binwidth = 25) +
    scale_x_continuous(limits = c(0,1000), breaks = seq()) +
    facet_wrap(~gender, ncol(3))
  
#omitting Any NA observations
  qplot(x = friend_count, data = na.omit(pf), binwidth = 25) +
    scale_x_continuous(limits = c(0,1000), breaks = seq()) +
    facet_wrap(~gender, ncol(3))
#na.omit removes all entries with atleas one NA in them for e.g. friend counts for certain people
  
##Statistics by gender
table(pf$gender)
by(pf$friend_count, pf$gender, summary)
#median is a better statistic for this exercise because our sample is long-tailed and median is a robust statistic than mean

##Tenure
qplot(data = pf, x = tenure,colour = I('black'), fill = I('#099DD9'))
#setting binwidth=30
qplot(data = pf, x = tenure,colour = I('black'), fill = I('#099DD9'), binwidth=30)
#measuring tenure in years
qplot(data = pf, x = tenure,colour = I('black'), fill = I('#099DD9'), binwidth=365)
#the below option of breaks does not work
qplot(data = pf, x = tenure,colour = I('black'), fill = I('#099DD9'), binwidth=365,
      breaks = seq(0,3000,365))
#solution
qplot(data=pf, x = tenure/365, binwidth = .25, 
      colour = I('black'), fill = I('#F79420')) + 
      scale_x_continuous(breaks = seq(1,7,1), limits = c(0,7))
#---------------------------------------------------
#QUIZ:TENURE
#The parameter color determines the color outline of objects in a plot. 

#The parameter fill determines the color of the area inside objects in a plot. 

#You might notice how the color black and the hex code color of #099DD9 (a shade of blue) are wrapped inside of I(). The I() functions stand for 'as is' and tells qplot to use them as colors. 

#Learn more about what you can adjust in a plot by reading the ggplot theme documentation 

#Equivalent ggplot syntax: 
  ggplot(aes(x = tenure), data = pf) + 
  geom_histogram(binwidth = 30, color = 'black', fill = '#099DD9')

#Equivalent ggplot syntax: 
  ggplot(aes(x = tenure/365), data = pf) + 
  geom_histogram(binwidth = .25, color = 'black', fill = '#F79420')
#----------------------------------------------------------------
## Labelling Plots
qplot(data=pf, x = tenure/365,
      xlab = 'Number of years using Facebook',
      ylab = 'Number of users in sample',
      colour = I('black'), fill = I('#F79420')) + 
  scale_x_continuous(breaks = seq(1,7,1), lim = c(0,7))
  
#Users by age
qplot(data=pf, x = age, binwidth = 1,
      xlab = 'Age of users in sample',
      ylab = 'Number of users in sample',
      colour = I('black'), fill = I('#e64200')) +
  scale_x_continuous(breaks = seq(0,120,5))
summary(pf$age)
#-----------------------------------------------------------------------
#Quiz: User Ages
#Equivalent ggplot syntax: 
ggplot(aes(x = age), data = pf) + 
  geom_histogram(binwidth = 1, fill = '#5760AB') + 
  scale_x_continuous(breaks = seq(0, 113, 5))
#-----------------------------------------------------------------------
#engagement variables have orders of magnitude differences in the values and so is useful to be plotted on a log scale
summary(pf$friend_count)
summary(log10(pf$friend_count))
summary(log10(pf$friend_count + 1))
summary(sqrt(pf$friend_count))

install.packages('gridExtra')
#plot three plots
p1 = qplot(data=pf, x = friend_count,
           xlab = 'Number of friends (linear)',
           ylab = 'Number of Facebook users',
           colour = I('black'), fill = I('#e64200'))

p2 = qplot(data=pf, x = log10(friend_count),
           xlab = 'Number of friends (log10)',
           ylab = 'Number of Facebook users',
           colour = I('black'), fill = I('#38654b'))

p3 = qplot(data=pf, x = sqrt(friend_count),
           xlab = 'Number of friends (square root)',
           ylab = 'Number of Facebook users',
           colour = I('black'), fill = I('#005b96'))
library(gridExtra)
grid.arrange(p1, p2, p3, ncol=1)

#Alternate Solution using Scaling Layer
p1 <- ggplot(aes(x = friend_count), data = pf) + geom_histogram()
p2 <- p1 + scale_x_log10()
p3 <- p1 + scale_x_sqrt()

grid.arrange(p1, p2, p3, ncol=1)

#Add a Scaling Layer
logScale <- qplot(x = log10(friend_count), data = pf)

countScale <- ggplot(aes(x = friend_count), data = pf) +
  geom_histogram() +
  scale_x_log10()

grid.arrange(logScale, countScale, ncol=2)

#Another example
qplot(x = friend_count, data = pf) +
  scale_x_log10()

##FREQUENCY POLYGONS
qplot(x = friend_count, data = subset(pf, !is.na(gender)),
      xlab = 'Friend Count',
      ylab = 'Users with that Friend Count',
      binwidth = 10,
      geom='freqpoly', color=gender) +
  scale_x_continuous(lim = c(0,1000), breaks = seq(0,1000,50))

#converting Y axis into proportions
qplot(x = friend_count, y = ..count../sum(..count..),
      data = subset(pf, !is.na(gender)),
      xlab = 'Friend Count',
      ylab = 'Proportion of Users with that Friend Count',
      binwidth = 10,geom='freqpoly', color=gender) +
  scale_x_continuous(lim = c(0,1000), breaks = seq(0,1000,50))

#----------------------------------------
#Quiz : Frequency Polygons
#----------------------------------------
#Note that the shape of the frequency polygon depends on how our bins are set up - the height of the lines are the same as the bars in individual histograms, but the lines are easier to make a comparison with since they are on the same axis.

#Equivalent ggplot syntax: 
  ggplot(aes(x = friend_count, y = ..count../sum(..count..)), data = subset(pf, !is.na(gender))) + 
  geom_freqpoly(aes(color = gender), binwidth=10) + 
  scale_x_continuous(limits = c(0, 1000), breaks = seq(0, 1000, 50)) + 
  xlab('Friend Count') + 
  ylab('Percentage of users with that friend count')

#Note that sum(..count..) will sum across color, so the percentages displayed are percentages of total users. To plot percentages within each group, you can try y = ..density...

#Note that the shape of the frequency polygon depends on how our bins are set up - the height of the lines are the same as the individual histograms, but the lines are easier to make a comparison since they are on the same axis.

#Note that the shape of the frequency polygon depends on how our bins are set up - the height of the lines are the same as bars in individual histograms, but the lines are easier to make a comparison with since they are on the same axis. Equivalent ggplot syntax: 
  ggplot(aes(x = www_likes), data = subset(pf, !is.na(gender))) + 
  geom_freqpoly(aes(color = gender)) + 
  scale_x_log10()

#FINISHED LESSON 3 WITHOUT ANY FURTHER NOTES
