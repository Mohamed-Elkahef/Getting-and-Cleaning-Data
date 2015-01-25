
## load Data

x_tr<-read.table("D:\\Training videoes\\The Data Scientist\\Tools\\UCI HAR Dataset\\train\\X_train.txt")

y_tr<-read.table("D:\\Training videoes\\The Data Scientist\\Tools\\UCI HAR Dataset\\train\\y_train.txt")

s_tr<-read.table("D:\\Training videoes\\The Data Scientist\\Tools\\UCI HAR Dataset\\train\\subject_train.txt")

dnames<-read.table("D:\\Training videoes\\The Data Scientist\\Tools\\UCI HAR Dataset\\features.txt")

act_lab<-read.table("D:\\Training videoes\\The Data Scientist\\Tools\\UCI HAR Dataset\\activity_labels.txt")

x_te<-read.table("D:\\Training videoes\\The Data Scientist\\Tools\\UCI HAR Dataset\\test\\X_test.txt")

y_te<-read.table("D:\\Training videoes\\The Data Scientist\\Tools\\UCI HAR Dataset\\test\\y_test.txt")

s_te<-read.table("D:\\Training videoes\\The Data Scientist\\Tools\\UCI HAR Dataset\\test\\subject_test.txt")

## rename Vars
colnames(s_tr)<-c("Subject")

colnames(s_te)<-c("Subject")

colnames(x_tr)<-dnames[[2]]

colnames(x_te)<-dnames[[2]]

colnames(y_tr)<-c("Activity")

colnames(y_te)<-c("Activity")


##Rbind the data sets
x_tr<-rbind(x_tr,x_te)
y_tr<-rbind(y_tr,y_te)
s_tr<-rbind(s_tr,s_te)

## Generate one dataset 
Ds<-x_tr
Ds<-cbind(Ds,y_tr)
Ds<-cbind(Ds,s_tr)

## Extracts only the measurements on the mean and standard deviation for each measurement
meanAndSd<-grep("mean()|std()|Subject|Activ", colnames(Ds))
temp<-Ds[,meanAndSd]
Ds<-temp

##Uses descriptive activity names to name the activities in the data set
Ds$Activity<-act_lab[Ds$Activity,2]

##Appropriately labels the data set with descriptive variable names.
cols <- names(Ds)
cols <- gsub("[()]", "", cols)
cols <- gsub("[-]", "_", cols)
cols <- gsub("^[tf]", "", cols)
colnames(Ds)<-cols

##From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
te<-melt(Ds,id.vars = grep("Activ|Subje", colnames(Ds)))
Result <- ddply(te, .(Activity,Subject, variable), summarize, mean=mean(value))

write.table(file = "Result.txt",Result,row.name=FALSE)

