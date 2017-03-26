getwd()
reddit <- read.csv('reddit.csv')
str(reddit)
table(reddit$employment.status)
table(reddit$income.range)
levels(reddit$age.range)
library(ggplot2)
qplot(data = reddit,x = age.range)
qplot(data = reddit,x = income.range)

#orders the ages in the levels shown
reddit$age.range <- ordered(reddit$age.range, levels = c('Under 18','18-24','25-34','35-44','45-54','55-64','65 of Above'))
qplot(data = reddit,x = age.range)

#alternate souluion
reddit$age.range <- factor(reddit$age.range, levels = c('Under 18','18-24','25-34','35-44','45-54','55-64','65 of Above'), ordered = T)
qplot(data = reddit,x = age.range)

#Challenge
levels(reddit$income.range)
reddit$income.range <- ordered(reddit$income.range, levels = c('Under $20,000','$20,000 - $29,999','$30,000 - $39,999','$40,000 - $49,999','$50,000 - $69,999','$70,000 - $99,999','$100,000 - $149,999','$150,000 or more'))
qplot(data = reddit, x = income.range)
#alternate way of doing the same graph
reddit$income.range <- factor(reddit$income.range, levels = c('Under $20,000','$20,000 - $29,999','$30,000 - $39,999','$40,000 - $49,999','$50,000 - $69,999','$70,000 - $99,999','$100,000 - $149,999','$150,000 or more'),ordered=T)
qplot(data = reddit, x = income.range)

