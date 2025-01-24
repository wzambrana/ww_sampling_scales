######'SCRIPT DESCRIPTION ----
#'
#'This script is used to determine the association between wastewater measurements and COVID-19 case data. 
#'
#'There are three main levels at which testing was performed: 
#'1. Level 1: Campus level. 
#'2. Level 2: Multiple-building level.
#'3. Level 3: Individual-building level. 
#'
#' IMPORTANT NOTE:
#' This script does not include actual case data to maintain confidentiality.
#' Synthetic data has been generated and provided as an example for demonstration purposes.

######LOADING LIBRARIES ----
library(openxlsx)
library(here)

here::i_am("main_ww_sampling_scales.R") 

######FUNCTIONS ----


##FUNCTION: Data preparation ---

bootstrap_function <- function(BootStrapNumber, df_low, df_up) {
  
  ##'FUNCTION: Boostrapping function ---
  #'
  #'This function creates an array of uniformly distributed values between upper and lower intervals.
  #' 
  #'  Args:
  #'    BootStrapNumber: Number of times the bootstrap is happening, typically 1000.
  #'    df_low: A dataframe that contains the lower bound concentration values to be used for bootstrapping.
  #'    df_up: A dataframe that contains the upper bound concentration values to be used for bootstrapping.
  #'    
  #'  Returns:
  #'    value_selected: An array of  uniformly distributed values between upper and lower intervals.
  #'            
  
  #Define length of data set
  DataSetLength = length(df_low) 

  #Preparing bootstrap - create empty arrays
    #Create an empty array for selection of uniformly distributed values between upper and lower intervals
    value_selected<-array(NA,c(DataSetLength,BootStrapNumber)) 
    
    #Selecting samples from a uniform distribution from upper and lower bounds ----
    for(i in 1:DataSetLength)
    {
      value_selected[i,]=runif(BootStrapNumber,df_low[i],df_up[i])
    }
 
  return(value_selected)
}

##FUNCTION: Data analyisis ---

kendall_bootstrap <- function(df_boostrap,df_compare) {
  
  ##'FUNCTION: Kendall Bootstrapping function ---
  #'
  #'This function calculates Kendall's tau for each data set using bootstrapping.
  #' 
  #'  Args:
  #'    df_boostrap: An array of  uniformly distributed values between upper and lower intervals.
  #'    df_compare: An array of values to assess correlation against df_bootstrap.
  #'    
  #'  Returns:
  #'    tau_estimates_pvalue: A dataframe containing tau estimates and pvalues.
  #'            
  
  #Define length of data set
  DataSetLength = nrow(df_boostrap) 
  
  #Preparing bootstrap - create empty arrays
    #Create an empty array for storing the Tau estimates 
    tau_estimates<-array(NA,c(1,DataSetLength)) #one row, 1000 columns containing Tau values
    
    #Create an empty array for storing the p values                    
    pvalues<-array(NA,c(1,DataSetLength))
  
  #Calculating Kendall tau for each data set using bootstrapping  -----
  for (i in 1:DataSetLength){
    tau_result <- cor.test(df_boostrap[,i], df_compare,  method = "kendall")
    tau_estimates[,i] = tau_result$estimate
    pvalues[,i] = tau_result$p.value
  }
    tau_estimates_pvalue <-rbind(tau_estimates,pvalues) 
  return(tau_estimates_pvalue) 
}

######DATA PREPARATION ----

###Import wastewater and clinical data results ---
xlsx_source <- here("data_ww_sampling_scales.xlsx")  
Level_data<-read.xlsx(xlsx_source, sheet ="Level1_Data")  #Load the data for one single level at a time and run the script.
 
###Defining Variables ---

#Case data [not provided] 
  
  #Generating a synthetic dataset for demonstration purposes
  Level_data$case_synthethic_data <- sample(0:10, nrow(Level_data), replace = TRUE)
  cases <-Level_data$case_synthethic_data #Number of cases (synthetic)

##PMMOV values
pmmov_value<-Level_data$PMMOV_gc_l #Concentration gc/L
pmmov_up<-Level_data$PMMOV_uci_gc_l #Upper bound concentration gc/L 
pmmov_low<-Level_data$PMMOV_lci_gc_l #Lower bound concentration gc/L 
  
##N1 values
N1_value<-Level_data$N1_gc_l #Concentration gc/L
N1_up<-Level_data$N1_uci_gc_l #Upper bound concentration gc/L 
N1_low<-Level_data$N1_lci_gc_l #Lower bound concentration gc/L 

##N2 values
N2_value<-Level_data$N2_gc_l #Concentration gc/L
N2_up<-Level_data$N2_uci_gc_l #Upper bound concentration gc/L 
N2_low<-Level_data$N2_lci_gc_l #Lower bound concentration gc/L 


####STATISTICAL ANALYSIS ----

###Check normality using Shapiro-Wilk test ---
N1_NormalTestResult <-shapiro.test(N1_value)
N2_NormalTestResult <-shapiro.test(N2_value)

###Preparing bootstrap values function  ---
BootStrapNumber = 1000 #number of times the bootstrap is happening

N1selected<-bootstrap_function(BootStrapNumber,N1_low,N1_up) #Using the bootstrap_function function
N2selected<-bootstrap_function(BootStrapNumber,N2_low,N2_up) 
pmmovselected<-bootstrap_function(BootStrapNumber,pmmov_low,pmmov_up) 
  

###Calculating Kendall's tau  ---

  ###Calculate Overall Tau (Kendall's Tau, no bootstrapping) ---
  N1TauOverall <-cor.test(N1_value, cases,  method = "kendall") #calculating overall Tau w/o bootstrapping
  N2TauOverall <-cor.test(N2_value, cases,  method = "kendall")

  #calculating Median tau (Kendall's Tau, bootstrapping) ---
  N1TauBootstrap<- kendall_bootstrap(N1selected,cases)
  N1TauAve <-median(N1TauBoobstrap[1,])
  N1pvalues_bootstrap<-N1TauBootstrap[2,]

  N2TauBootstrap<- kendall_bootstrap(N2selected,cases)
  N2TauAve <-median(N2TauBootstrap[1,])
  N2pvalues_bootstrap<-N2TauBootstrap[2,]
  
    # calculating empirical p value ---
    N1_Pemp<- sum(N1pvalues_bootstrap<0, na.rm=TRUE)/BootStrapNumber
    N2_Pemp<-sum(N2pvalues_bootstrap<0, na.rm=TRUE)/BootStrapNumber
    N1N2_Pemp<-sum(N1N2estimates<0, na.rm=TRUE)/BootStrapNumber
 