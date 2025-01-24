README for Data and R code for a project to find the association between wastewater measurements and COVID-19 case data at different sampling scales. 

Author: WZ
Associated publication: https://doi.org/10.1021/acsestwater.2c00050

FILES
1)	ww_sampling_scales.Rproj: 		R project file needed to run main R script
2)	main_ww_sampling_scales.R:		Main R script to run
3)	data_ww_sampling_scales.xlsx: 	    Data used in main R script 


1) ww_sampling_scales.Rproj
Necessary to run main R script. Save all files (includes this one) in the same directory before running main_ww_sampling_scales.R.

2) main_ww_sampling_scales.R
The main script for the analysis. This script is used to determine the association between wastewater measurements and COVID-19 case data at different sampling scales.

3) data_ww_sampling_scales.xlsx
[Original data source: https://doi.org/10.25740/vm787sj6177]

Code:				Sample code corresponding to location; CO = Codiga Resource Recovery Center (Level 1); MU= Building Cluster (Level 2); MAC= Residence Building (Level 3)
Date:				Date sample was collected
N1_gc_l:			N1 gene concentration in units of copies per l of wastewater sampled
N1_uci_gc_l:			N1 gene concentration in units of copies per l of wastewater sampled - 68% upper confidence limit
N1_lci_gc_l:			N1 gene concentration in units of copies per l of wastewater sampled - 68% lower confidence limit
N2_gc_l:			N2 gene concentration in units of copies per l of wastewater sampled
N2_uci_gc_l:			N2 gene concentration in units of copies per l of wastewater sampled - 68% upper confidence limit
N2_lci_gc_l:			N2 gene concentration in units of copies per l of wastewater sampled - 68% lower confidence limit
PMMOV_gc_l:			PMMOV gene concentration in units of copies per l of wastewater sampled
PMMOV_uci_gc_l:			PMMOV gene concentration in units of copies per l of wastewater sampled - 68% upper confidence limit
PMMOV_lci_gc_l:			PMMOV gene concentration in units of copies per l of wastewater sampled - 68% lower confidence limit
recovery:			BCoV recovery - ranges from 0 to 1, to get percent recovery, multiply by 100
anti_conc _fg_l:		N antigen concentration in units of fg per l of wastewater sampled
anti_conc_fg_mL:		N antigen concentration in units of fg per ml of wastewater sampled
--

Level1_Data:			RNA data, level 1 (campus level)
Level1_Data_Antigen:		Antigen data, level 1 (campus level)
Level2_Data:			RNA data, level 2 (multiple-building level)
Level3_Data:			RNA data, level 3(individual-building level)



