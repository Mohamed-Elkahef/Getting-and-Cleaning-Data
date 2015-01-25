### set the Files location 
## here we set the loaction of the data files 


flocation<-"D:\\Training videoes\\The Data Scientist\\Tools\\UCI HAR Dataset"

### Load Data
## load the data from each file to the dataframe 
##x_tr for X_train
x_tr<-read.table(paste(flocation,sep = "","\\train\\X_train.txt"))
##y_tr for y_train
y_tr<-read.table(paste(flocation,sep = "", "\\train\\y_train.txt"))
##s_tr for subject_train
s_tr<-read.table(paste(flocation,sep = "","\\train\\subject_train.txt"))

##dnames for names of the features
dnames<-read.table(paste(flocation,sep = "", "\\features.txt"))
##act_lab for the activity names 
act_lab<-read.table(paste(flocation,sep = "", "\\activity_labels.txt"))
##x_te for X_test
x_te<-read.table(paste(flocation,sep = "", "\\test\\X_test.txt"))
##y_te for y_test
y_te<-read.table(paste(flocation,sep = "", "\\test\\y_test.txt"))
##s_te for subject_test
s_te<-read.table(paste(flocation,sep = "", "\\test\\subject_test.txt"))

### rename Vars
## here we rename the variable names to be more Meaningful
colnames(s_tr)<-c("Subject")

colnames(s_te)<-c("Subject")

colnames(x_tr)<-dnames[[2]]

colnames(x_te)<-dnames[[2]]

colnames(y_tr)<-c("Activity")

colnames(y_te)<-c("Activity")


###Rbind the data sets
##mearge the test and the train dataframes in x_tr,y_tr and s_tr
x_tr<-rbind(x_tr,x_te)
y_tr<-rbind(y_tr,y_te)
s_tr<-rbind(s_tr,s_te)

### Generate one dataset 
## add all the datafarames at one dataframe DS  
Ds<-x_tr
Ds<-cbind(Ds,y_tr)
Ds<-cbind(Ds,s_tr)

### Extracts only the measurements on the mean and standard deviation for each measurement
## fiter the Ds dataframe to contain only the measuers mean & std and  subject and activity
meanAndSd<-grep("mean()|std()|Subject|Activ", colnames(Ds))
temp<-Ds[,meanAndSd]
Ds<-temp

###Uses descriptive activity names to name the activities in the data set
## update the col activity with the names from the act_lab dataset
Ds$Activity<-act_lab[Ds$Activity,2]

###Appropriately labels the data set with descriptive variable names.
##Cleaning the data of the columns by susing the gsub funaction  
cols <- names(Ds)
cols <- gsub("[()]", "", cols)
cols <- gsub("[-]", "_", cols)
cols <- gsub("^[tf]", "", cols)
colnames(Ds)<-cols

###From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
## use the melt function to make the reshape the data and 
##get the mean using the ddply funaction 
library("reshape2")
library(plyr)
te<-melt(Ds,id.vars = grep("Activ|Subje", colnames(Ds)))
Result <- ddply(te, .(Activity,Subject, variable), summarize, mean=mean(value))

write.table(file = "Result.txt",Result,row.name=FALSE)

