########################################################################
#              data.table Exercises - By Sam Chiu                     
# Dataset            : Iris, Diamonds, Airquality
# Utilized Packages  : data.table, ggplot2
# Utilized Techniques: data.table techniques
# Exercise Source    : https://www.r-exercises.com/2017/06/15/data-manipulation-with-data-table-part-1/
########################################################################

rm(list=ls())
##########
# Part 1 #
##########

# exercise 1
# Load the iris dataset
# make it a data.table and name it iris_dt
# Print mean of Petal.Length, grouping by first letter of Species from iris_dt
data(iris)
iris_dt = data.table(iris)
iris_dt[,.(mean=mean(Petal.Length)), by=.(first.letter=substr(Species,1,1))]

# exercise 2
# Load the diamonds dataset from ggplot2 package as dt (a data.table).
# Find mean price for each group of cut and color 
library(ggplot2)
data(diamonds)
setDT(diamonds)
class(diamonds)
e2=diamonds[,.(mean.price=mean(price)),by=.(cut,color)]
e2

# exercise 3
# Load the diamonds dataset from ggplot2 package as dt . 
# Now group the dataset by price per carat and print top 5 in terms of count per group . 
# Dont use head ,use chaining in data.table to achieve this
e3 = copy(diamonds)
e3[,.N,by=.(price/carat)][order(-N)][1:5]

# exercise 4
# Use the already loaded diamonds dataset and print the last two carat value of each cut
e4 = diamonds[, .(tail(carat,2)), by=cut]
e4

# exercise 5
# In the same data set , find median of the columns x,y,z per cut . 
# Use data.table’s methods to achieve this
e5 = diamonds[,.(med.x=median(x), med.y=median(y), med.z=median(z)), by=cut] ## My solution
e5 = diamonds[, lapply(.SD, median), by=cut, .SDcols=c('x','y','z')] ## A more elegant solution
e5

# exercise 6
# Load the airquality dataset as data.table, Now I want to find Logarithm of wind rate for each month and for days greater than 15
data(airquality)
setDT(airquality)
class(airquality)
e6 = airquality[, lapply(.SD, log10), by=.(by1=Month, by2=Day>15), .SDcols=c("Wind")][by2==T]
e6

# exercise 7
# In the same data set , for all the odd rows ,update Temp column by adding 10
airquality[rep(c(TRUE,FALSE),length = .N), Temp:=Temp+10]

# exercise 8
# data.table comes with a powerful feature of updating column by reference as you have seen in the last exercise,
# Its even possible to update /create multiple columns .
# Now to test that in the airquality data.table that you have created previously, add 10 to Solar.R, Wind
airquality[, `:=`(Solar.R=Solar.R+10, Wind=Wind+10)]

# exercise 9
# Now you have a fairly good idea of how easy its to create multiple column.
# Its even possible to use delete multiple column using the same idea. 
# In this exercise, use the same airquality data.table that you have created previously from airquality 
# and delete Solar.R,Wind,Temp using a single expression
airquality[, c('Solar.R','Wind','Temp') := NULL]

# exercise 10
# Load the airquality dataset as data.table again. 
# I want to create two columns a,b which indicates temp in Celcius and Kelvin scale. Write a expression to achieve same.
# Celcius = (Temp-32)*5/9
# Kelvin = Celcius + 273.15
data(airquality)
setDT(airquality)
airquality[,c("Celcius", "Kelvin") := .(Celcius = (Temp-32)*5/9, Kelvin = Celcius + 273.15)] # . (dot) is essentially equivalent to list in data.table

##########
# Part 2 #
##########

# exercise 1
# Create a data.table from diamonds dataset ,create key using setkey over cut and color.
# Now select first entry of the groups Ideal and Premium
data(diamonds)
setDT(diamonds)
setkey(diamonds, cut, color)
diamonds[c('Ideal','Premium'),mult='first']

# exercise 2
# With the same dataset,select the first and last entry of the groups Ideal and Premium
diamonds[c('Ideal','Premium'), .SD[c(1, .N)], by=.EACHI]

# exercise 3
# Earlier we have seen how we can create/update columns by reference using := .
# However there is a lower over head, faster alternative in data.table . 
# This is achieved by SET and Loop in data.table.
# however this is meant for simple operations and will not work in grouped operation. 
# Now take the diamonds data.table and make columns x,y,z value squared. 
# For example if the value is currently 10 ,the resulting value would be 100 .
# You are awesome if you find out all alternative answer and check the time using system.time.
data(diamonds)
setDT(diamonds)
system.time(diamonds[, `:=`(x=x^2, y=y^2, z=z^2)])

cols = c('x', 'y', 'z')
system.time(for (i in cols){set(diamonds, j = i, value = diamonds[[i]]^2)})

# exercise 4
# In the same dataset ,capitalize first letter of column names.
data(diamonds)
setDT(diamonds)
e4 = copy(diamonds)

names(e4)
setnames(e4, names(e4), sapply(names(e4), function(x) paste(toupper(substr(x,1,1)), substr(x,2,nchar(x)), sep='') ))

# exercise 5
# Now reorder your diamonds data.table’s column by sorting alphabetically
e5 = copy(diamonds)

setcolorder(e5, sort(names(e5)))

# exercise 6
# Suppose I want to have a metric on diamonds where I want to find for each group of 
# cut maximum of x * mean of depth and name it my_int_feature 
# and also I want another metric which is my_int_feature* maximum of y again for each group of cut. 
# This is achievable by chaining but also with a single operation without chaining which is the expected answer.
e6 = copy(diamonds)
e6[, {m = mean(depth)
      my_int_feature = max(x)*m
      my_int_feature2 = max(y)* my_int_feature
      .("my_int_feature" = my_int_feature, "my_int_feature_2" = my_int_feature2)}, by = cut
   ][order(cut)] # right brackets must be an independent row so that it can be piped

# exercise 7
# Suppose we want to merge iris and airquality, akin to the functionlaity of rbind. 
# We want to do it fast and want to keep track of the rows with their original dataset , 
# and keep all the columns of both the data set in the merged data set as well. 
data(iris)
setDT(iris)
e7.1 = copy(airquality)
e7.2 = copy(iris)

list = list('diamonds'=e7.1, 'iris'=e7.2)
rbindlist(list, fill = T, idcol = 'source')

# exercise 8
# Execute below
set.seed(1024)
x <- data.frame(rep(letters[1:2],6),c(1,2,3,4,6,7),sample(100,6))
names(x) <- c("id","day","value")
test_dt <- setDT(x)
# Now this mimics a sales data of 7 days for a and b. 
# Notice that day 5 is not present for both a and b. 
# This is not desirable in many situations. A common practise is to use the previous days data. 
# How do we get previous days data for the id a?
# You should ideally set keys and do it using join features 
setkey(test_dt, id, day)
test_dt[.("a",5), roll=T]

# exercise 9
# May be you dont want the previous day’s data, you may want to copy the nearest value for day 5.
setkey(test_dt, id, day)
test_dt[.("a",5), roll='nearest']

# exercise 10
# Now there may be a case when you don’t want to copy any value if the date is beyond last observation.
# Use your answer for question 8 to find the value for day 5 and 9 for b
# Now since 9 falls beyond last observation of 7 you might want to avoid copying it.
# How do you explicitly tell your data.table to stop when it sees last observation and don’t copy previous value.
# This may not seem useful since you know that here 9 falls beyond 7, but imagine you have a series of data points and you don’t really want to copy data to observations after your last observation.
# This might come handy in such cases .
test_dt[.("a", c(5, 9)), roll=T, rollends=F]
