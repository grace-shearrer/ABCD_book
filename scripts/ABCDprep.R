#prep script for ABCD data analysis
library(plyr)
library(psych)
library(ggplot2)
PDS_score<-function(x){
  sums<-rowSums (x, na.rm = TRUE, dims = 1)
  divBy<-apply(x,1, test)
  PDSscore<-sums/divBy
  return(PDSscore)
}

test<-function(x){
  y<-sum(!is.na(x))
  return(y)
}

#load in data
setwd("/Users/gracer/Google Drive/ABCD/important_txt/")
test1<-read.table("abcd_ant01.txt", header=T, fill=T)
head(test1)
test1$anthroheightcalc
summary(test1)
#exclusion criteria
#brain injury, cancer, palsy, diabetes, epilepsy, kidney disease, MS
test2<-read.table("abcd_hsss01.txt", header=T, fill=T)
dim(test)
test3<-read.table("abcd_mx01.txt", header=T, fill=T)
dim(test2)
test4<-read.table("abcd_ppdms01.txt", header=T, fill=T)
dim(test4)
test5<-read.table("abcd_ypdms01.txt", header=T, fill=T)
dim(test4)
test6<-read.table("fmriresults01.txt", header=T, fill=T)
dim(test5)
#join them all together
################################################################################################################################################################
data<-join(test1,test2)
data2<-join(data,test3)
data3<-join(data2,test4)
data4<-join(data3,test5)
data5<-join(data4,test6)
dim(data5)
names(data5)
################################################################################################################################################################
keep<-c(	"src_subject_id",
        "interview_age","gender","anthroheightcalc","anthroweightcalc","anthro_waist_cm",
        "hormone_scr_dhea_mean","hormone_scr_hse_mean","hormone_scr_ert_mean",
        "medhx_2c","medhx_2e","medhx_2f","medhx_2g","medhx_2h","medhx_2j","medhx_2m", "pds_1_p","pds_2_p","pds_3_p","pds_m5_p",
        "pds_m4_p","pds_f4_p",	"pds_f5b_p",	"pds_f6_p",	"pds_f6_p_dk",	"menstrualcycle1_p",
        "menstrualcycle2_p",	"menstrualcycle2_p_dk",	"menstrualcycle3_p",	"menstrualcycle4_p",	"menstrualcycle5_p",	"menstrualcycle6_p",
        "pds_ht2_y",	"pds_skin2_y",	"pds_bdyhair_y",	"pds_f4_2_y",	"pds_f5_y",	"pds_f6_y",	"pds_f6_y_dk",	"pds_m4_y",	"pds_m5_y",	"menstrual_cycle_script",
        "menstrualcycle1_y",	"menstrualcycle2_y",	"menstrualcycle2_y_dk",	"menstrualcycle3_y",	"menstrualcycle4_y",	"menstrualcycle5_y",	"menstrualcycle6_y",
        "img03_id",	"file_source",	"derived_files",	"scan_type",	"session_det")
final_data<-data5[keep]
names(final_data)
write.table(final_data, "joind_interest_variables.csv", sep=",",row.names=F)
head(final_data)



#seperate male female
################################################################################################################################################################
female<-subset(final_data,final_data$gender=="F")
head(female)
fvars<-c(	"src_subject_id",
         "interview_age","gender","anthroheightcalc","anthroweightcalc","anthro_waist_cm",
         "hormone_scr_dhea_mean","hormone_scr_hse_mean","hormone_scr_ert_mean",
         "medhx_2c","medhx_2e","medhx_2f","medhx_2g","medhx_2h","medhx_2j","medhx_2m", "pds_1_p","pds_2_p","pds_3_p",
         "pds_f4_p",	"pds_f5b_p",	"pds_f6_p",	"pds_f6_p_dk",	"menstrualcycle1_p",
         "menstrualcycle2_p",	"menstrualcycle2_p_dk",	"menstrualcycle3_p",	"menstrualcycle4_p",	"menstrualcycle5_p",	"menstrualcycle6_p",
         "pds_ht2_y",	"pds_skin2_y",	"pds_bdyhair_y",	"pds_f4_2_y",	"pds_f5_y",	"pds_f6_y",	"pds_f6_y_dk",	"menstrual_cycle_script",
         "menstrualcycle1_y",	"menstrualcycle2_y",	"menstrualcycle2_y_dk",	"menstrualcycle3_y",	"menstrualcycle4_y",	"menstrualcycle5_y",	"menstrualcycle6_y",
         "img03_id",	"file_source",	"derived_files",	"scan_type",	"session_det")
fdata<-female[fvars]
head(fdata)
#taking out the exclusion vars
dim(fdata)
fdata<-subset(fdata,fdata$medhx_2c == 0)
dim(fdata)
fdata<-subset(fdata,fdata$medhx_2e == 0)
dim(fdata)
fdata<-subset(fdata,fdata$medhx_2f == 0)
dim(fdata)
fdata<-subset(fdata,fdata$medhx_2g == 0)
dim(fdata)
fdata<-subset(fdata,fdata$medhx_2h == 0)
dim(fdata)
fdata<-subset(fdata,fdata$medhx_2j == 0)
dim(fdata)
fdata<-subset(fdata,fdata$medhx_2m == 0)
dim(fdata)
head(fdata)

names(fdata)
#excluding incomplete puberty data
pubSub<-c("src_subject_id","pds_ht2_y","pds_skin2_y","pds_bdyhair_y","pds_f4_2_y","pds_f5_y")
pubFem<-fdata[pubSub]
head(pubFem)
summary(pubFem)
pubFemC <- na.omit(pubFem)
pubFemC
pubFemC[!complete.cases(pubFemC),]
class(pubFemC$pds_f5_y)
pubFemC$pds_bdyhair_y<-as.integer(pubFemC$pds_bdyhair_y)

pubFemC$PDS<-PDS_score(pubFemC[2:6])
hist(pubFemC$PDS, breaks=12, col="red")
describe(pubFemC$PDS)

all_fem <- merge(pubFemC, fdata,by=c("src_subject_id"))
head(all_fem)
summary(all_fem$PDS)
describe(all_fem$PDS)
describe(all_fem$anthroheightcalc)
summary(all_fem$session_det)
hist(all_fem$anthroheightcalc, breaks=12, col="red")
hist(all_fem$anthroweightcalc, breaks=12, col="red")
hist(all_fem$anthro_waist_cm, breaks=12, col="red")
all_fem$hormone_scr_dhea_mean<-as.numeric(all_fem$hormone_scr_dhea_mean)
hist(all_fem$hormone_scr_dhea_mean, breaks=12, col="red")
summary(all_fem$hormone_scr_dhea_mean)
hist(all_fem$hormone_scr_hse_mean, breaks=12, col="red")
hist(all_fem$hormone_scr_ert_mean, breaks=12, col="red")
names(all_fem)
vars<-c("src_subject_id", "PDS","interview_age","gender" ,"anthroheightcalc",      
        "anthroweightcalc","anthro_waist_cm","hormone_scr_dhea_mean","hormone_scr_hse_mean","hormone_scr_ert_mean",  
        "img03_id","file_source","derived_files","scan_type",             
        "session_det" )
final_female<-all_fem[vars]

ggplot(final_female, aes(PDS, hormone_scr_ert_mean)) +
  geom_point(shape=1)      # Use hollow circles
##################################################################################################################################
male<-subset(final_data,final_data$gender=="M")

mvars<-c(	"src_subject_id",
        "interview_age","gender","anthroheightcalc","anthroweightcalc","anthro_waist_cm",
        "hormone_scr_dhea_mean","hormone_scr_hse_mean","hormone_scr_ert_mean",
        "medhx_2c","medhx_2e","medhx_2f","medhx_2g","medhx_2h","medhx_2j","medhx_2m",
        "pds_ht2_y",	"pds_skin2_y",	"pds_bdyhair_y",	"pds_m4_y",	"pds_m5_y",	
        "img03_id",	"file_source",	"derived_files",	"scan_type",	"session_det")

mdata<-male[mvars]
summary(mdata)

dim(mdata)
mdata<-subset(mdata,mdata$medhx_2c == 0)
dim(mdata)
mdata<-subset(mdata,mdata$medhx_2e == 0)
dim(mdata)
mdata<-subset(mdata,mdata$medhx_2f == 0)
dim(mdata)
mdata<-subset(mdata,mdata$medhx_2g == 0)
dim(mdata)
mdata<-subset(mdata,mdata$medhx_2h == 0)
dim(mdata)
mdata<-subset(mdata,mdata$medhx_2j == 0)
dim(mdata)
mdata<-subset(mdata,mdata$medhx_2m == 0)
dim(mdata)
summary(mdata)
#excluding incomplete puberty data
men_pub<-read.table("abcd_ypdms01_male.txt",header=T, fill=T)
head(men_pub)

men_pub <- na.omit(men_pub)

men_pub[!complete.cases(men_pub),]
class(men_pub$pds_m5_y)

men_pub$PDS<-PDS_score(men_pub[3:7])
hist(men_pub$PDS, breaks=12, col="red")
describe(men_pub$PDS)


all_male <- merge(men_pub, mdata,by=c("src_subject_id"))
head(all_male)
hist(all_male$PDS, breaks=12, col="red")
hist(all_male$anthroheightcalc, breaks=12, col="red")
hist(all_male$anthro_waist_cm, breaks=12, col="red")
all_male$hormone_scr_dhea_mean<-as.numeric(all_male$hormone_scr_dhea_mean)
hist(all_male$hormone_scr_dhea_mean, breaks=12, col="red")
hist(all_male$hormone_scr_hse_mean, breaks=12, col="red")
hist(all_male$hormone_scr_ert_mean, breaks=12, col="red")
summary(all_male$hormone_scr_dhea_mean)

sd(all_male$hormone_scr_dhea_mean)
summary(all_male$src_subject_id)

vars<-c("src_subject_id", "PDS","interview_age","gender.x" ,"anthroheightcalc",      
        "anthroweightcalc","anthro_waist_cm","hormone_scr_dhea_mean","hormone_scr_hse_mean","hormone_scr_ert_mean",  
        "img03_id","file_source","derived_files","scan_type",             
        "session_det" )
final_male<-all_male[vars]

write.table(final_male, "male_data.csv", sep=",", row.names=F)
write.table(final_female, "female_data.csv", sep=",", row.names=F)
males<-unique(final_male$src_subject_id)
length(males)
write.table(males,"listMale.txt", sep="\t", row.names=F,quote=FALSE, col.names = F)
females<-unique(final_female$src_subject_id)
length(females)
write.table(females,"listFemale.txt", sep="\t", row.names=F,quote=FALSE, col.names = F)

ggplot(final_male, aes(PDS, hormone_scr_hse_mean)) +
  geom_point(shape=1)      # Use hollow circles
