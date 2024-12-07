// Last update: Aug 30, 2024

// Brief description
// This is a STATA do-file for cleaning the Cortellis data. 
// Since the Cortellis is a private data source, we cannot publicy share the data. 

// (Step 1) Generate [003] by appending [001] and [002], 
// [001] 'history development' column from the original data
// [002] 'current development' column from the original data
{
	clear
	use  "~\[002] Drug_development summary (current).dta"
	append using "~\[001] Drug_development summary (history).dta"
	sort id_cortellis develop_company develop_indication develop_country develop_year develop_date	
	save "~\[003] Drug_development summary (history+current).dta"
}

// (Step 2) Generate [004] after cleaning the develop_year from [003]
{
	clear 
	use "~\[003] Drug_development summary (history+current).dta"
	
	gen develop_status_num = 1 if strpos(develop_status, "Discovery")
	replace develop_status_num = 2 if strpos(develop_status, "Preclinical")
	replace develop_status_num = 3 if strpos(develop_status, "Phase 1")
	replace develop_status_num = 4 if strpos(develop_status, "Phase 2")
	replace develop_status_num = 5 if strpos(develop_status, "Phase 3")
	replace develop_status_num = 6 if strpos(develop_status, "Pre-registration")
	replace develop_status_num = 7 if strpos(develop_status, "Registered")
	replace develop_status_num = 8 if strpos(develop_status, "Launched")

	sort id_cortellis develop_company develop_indication develop_country develop_status_num develop_year develop_date
	*interested in the earliest year of starting the new develop_indication
	*not interested in information of develop_country
	
	drop develop_country num_develop_history num_develop_current
	duplicates drop
	save "~\[004] Drug_development summary (history+current)_no dups.dta"
	
}

// (Step 3) Extract the list of 'develop_company' from [004]. Clean 'develop_company' if necessary
// Summary
// - (before cleaning company name) number of develop_company_original: 19,441 firms
// - (after cleaning company name)  number of develop_company: 18,899 firms
// - (after merging with company original data) (before cleaning company name) number of develop_company_original: 19,358 firms (83 develop_company_original unmatched)
// - (after merging with company original data) (after cleaning company name) number of develop_company: 18,818 firms

// - list of 83 develop_company_original unmatched : [100_1] Company_list of develop company name_unmatched with company original.dta
// - list of 19358 develop_company_original matched: [101] Company_list of develop company name_matched with company original.dta

//gvkey unmatched develop_company_original: 15,821 firms
//gvkey unmatched develop_company:		   15,497 firms
//gvkey unmatched ParentCompany  : 		   13,166 firms (based on ParentCompanyName or id_parent_firm_CORT)
	
//gvkey matched develop_company_original: 3,537 firms
//gvkey matched develop_company:		     3,336 firms
//gvkey matched ParentCompany    :        1,282 firms (based on ParentCompanyName or id_parent_firm_CORT) // 1,255 firms (based on gvkey)

// list of 3,537 develop_company_original matched with gvkey: [102] Company_list of develop company name_gvkey exist.dta
(gvkey was matched based on parent company name)

{
	clear
	use "~\[004] Drug_development summary (history+current)_no dups.dta"
	keep develop_company 
	duplicates drop

	distinct develop_company

*                 |        Observations
*                 |      total   distinct
*-----------------+----------------------
* develop_company |      19442      19442

	sort develop_company
	save "~\[100] Company_list of develop company name.dta"
 
}

// develop_company name cleaning
{
	clear
	use "~\[100] Company_list of develop company name.dta"
	
	rename develop_company develop_company_original
	gen develop_company = develop_company_original
	egen id_dc_ori = group(develop_company_original)
	order id_dc_ori

	replace develop_company = subinstr(develop_company, "amp;", "",.)
	replace develop_company = upper(develop_company)
	replace develop_company = subinstr(develop_company, " CO LTD", "",.)
	replace develop_company = subinstr(develop_company, " A/S", "",.)
	replace develop_company = subinstr(develop_company, " CO., LTD", "",.)
	replace develop_company = subinstr(develop_company, " CO, LTD", "",.)
	replace develop_company = subinstr(develop_company, " CO. LTD.,", "",.)
	replace develop_company = subinstr(develop_company, " CO. LTD.", "",.)
	replace develop_company = subinstr(develop_company, " CO. LTD", "",.)
	replace develop_company = subinstr(develop_company, " LTD, CHINA", "",.)
	replace develop_company = subinstr(develop_company, " LTDD", "",.)
	replace develop_company = subinstr(develop_company, " PTY LTD", "",.)
	replace develop_company = subinstr(develop_company, " (UK)", "",.)
	replace develop_company = subinstr(develop_company, " (PTY)", "",.)
	replace develop_company = subinstr(develop_company, " (HOLDINGS)", "",.)
	replace develop_company = subinstr(develop_company, " (SOUTH AFRICA)", "",.)
	replace develop_company = subinstr(develop_company, " (HK)", "",.)
	replace develop_company = subinstr(develop_company, " (BOTSWANA)", "",.)
	replace develop_company = subinstr(develop_company, " (EUROPE)", "",.)
	replace develop_company = subinstr(develop_company, " (2012)", "",.)
	replace develop_company = subinstr(develop_company, " (MELBOURNE)", "",.)
	replace develop_company = subinstr(develop_company, " (SHENZHEN)", "",.)
	replace develop_company = subinstr(develop_company, " (JIANGSU)", "",.)
	replace develop_company = subinstr(develop_company, " (HONG KONG)", "",.)
	replace develop_company = subinstr(develop_company, " (IRELAND)", "",.)
	replace develop_company = subinstr(develop_company, " (CAYMAN)", "",.)
	replace develop_company = subinstr(develop_company, " (ASTHMA)", "",.)
	replace develop_company = subinstr(develop_company, " (USA)", "",.)
	replace develop_company = subinstr(develop_company, " (P)", "",.)
	replace develop_company = subinstr(develop_company, " (WALES)", "",.)
	replace develop_company = subinstr(develop_company, " (HANGZHOU)", "",.)
	replace develop_company = subinstr(develop_company, " (SHANGHAI)", "",.)
	replace develop_company = subinstr(develop_company, " (PVT)", "",.)
	replace develop_company = subinstr(develop_company, " (GUANGZHOU)", "",.)
	replace develop_company = subinstr(develop_company, " (BRASIL)", "",.)
	replace develop_company = subinstr(develop_company, " (JAPAN)", "",.)
	replace develop_company = subinstr(develop_company, " (BRISTOL)", "",.)
	replace develop_company = subinstr(develop_company, " (CANADA)", "",.)
	replace develop_company = subinstr(develop_company, " (SUZHOU)", "",.)
	replace develop_company = subinstr(develop_company, " (CHINA)", "",.)

	replace develop_company = subinstr(develop_company, " LTDA", "",.)
	replace develop_company = subinstr(develop_company, " LTD CO", "",.)
	replace develop_company = subinstr(develop_company, " (WUHAN).", "",.)
	replace develop_company = subinstr(develop_company, " LTD.", "",.)
	replace develop_company = subinstr(develop_company, " LTD", "",.)
	replace develop_company = subinstr(develop_company, " INC.,", "",.)
	replace develop_company = subinstr(develop_company, " INC, CANADA", "",.)
	replace develop_company = subinstr(develop_company, " INC,", "",.)
	replace develop_company = subinstr(develop_company, ", INC.", "",.)
	replace develop_company = subinstr(develop_company, " INC.", "",.)
	replace develop_company = subinstr(develop_company, " INC (US)", "",.)
	replace develop_company = subinstr(develop_company, " INC (MARYLAND)", "",.)
	replace develop_company = subinstr(develop_company, " INC (FL)", "",.)
	replace develop_company = subinstr(develop_company, " INC (NZ)", "",.)
	replace develop_company = subinstr(develop_company, " INC (CHONGQING)", "",.)
	replace develop_company = subinstr(develop_company, " INC(US)", "",.)
	replace develop_company = subinstr(develop_company, " GMBH & CO KGA", "",.)
	replace develop_company = subinstr(develop_company, " GMBH & CO KG", "",.)
	replace develop_company = subinstr(develop_company, " GMBH & CO KEG", "",.)
	replace develop_company = subinstr(develop_company, " GMBH AND CO KG", "",.)
	replace develop_company = subinstr(develop_company, " GMBH & CO", "",.)
	replace develop_company = subinstr(develop_company, " GMBH KGAA", "",.)
	replace develop_company = subinstr(develop_company, " GMBH", "",.)
	replace develop_company = subinstr(develop_company, " S.R.L.", "",.)
	replace develop_company = subinstr(develop_company, " S.R.L", "",.)
	replace develop_company = subinstr(develop_company, " SRL", "",.)
	replace develop_company = subinstr(develop_company, " CO LLC", "",.)
	replace develop_company = subinstr(develop_company, " CO DD", "",.)
	replace develop_company = subinstr(develop_company, " CO SPA", "",.)
	replace develop_company = subinstr(develop_company, " CO (US)", "",.)
	replace develop_company = subinstr(develop_company, " CO LIMITED", "",.)
	replace develop_company = subinstr(develop_company, " CO &", "",.)
	replace develop_company = subinstr(develop_company, " & CO INC", "",.)
	replace develop_company = subinstr(develop_company, " CO INC", "",.)
	replace develop_company = subinstr(develop_company, " GROUP PLC", "",.)
	replace develop_company = subinstr(develop_company, " GROUP CORPORATION", "",.)
	replace develop_company = subinstr(develop_company, " GROUP CORP", "",.)
	replace develop_company = subinstr(develop_company, " GROUP COMPANY", "",.)
	replace develop_company = subinstr(develop_company, " GROUP CO", "",.)
	replace develop_company = subinstr(develop_company, " GROUP KFT", "",.)
	replace develop_company = subinstr(develop_company, " GROUP LLC", "",.)
	replace develop_company = subinstr(develop_company, " GROUP INC", "",.)	
	replace develop_company = subinstr(develop_company, " GROUP AB", "",.)	
	replace develop_company = subinstr(develop_company, " GROUP LIMITED", "",.)	
	replace develop_company = subinstr(develop_company, " GROUP BV", "",.)	
	replace develop_company = subinstr(develop_company, " GROUP AG", "",.)
	replace develop_company = subinstr(develop_company, " GROUP HF", "",.)
	replace develop_company = subinstr(develop_company, " GROUP NV", "",.)
	replace develop_company = subinstr(develop_company, " GROUP HOLDING LIMITED", "",.)
	replace develop_company = subinstr(develop_company, " GROUPE SA", "",.)
	replace develop_company = subinstr(develop_company, " GROUP RESEARCH", "",.)
	replace develop_company = subinstr(develop_company, " GROUP", "",.) if !strpos(develop_company, " GROUP ")
	replace develop_company = subinstr(develop_company, " CO.LTD", "",.)
	replace develop_company = subinstr(develop_company, " (BEIJING)", "",.)
	replace develop_company = subinstr(develop_company, ", B.V", "",.)
	replace develop_company = subinstr(develop_company, " B.V.", "",.)
	replace develop_company = subinstr(develop_company, " B.V", "",.)
	replace develop_company = subinstr(develop_company, " HOLDING BV", "",.)
	replace develop_company = subinstr(develop_company, " HOLDINGS BV/A", "",.)
	replace develop_company = subinstr(develop_company, " HOLDINGS BV", "",.)
	replace develop_company = subinstr(develop_company, " BVBA", "",.)
	replace develop_company = subinstr(develop_company, " BV (NETHERLANDS)", "",.)
	replace develop_company = subinstr(develop_company, " BV", "",.)
	replace develop_company = subinstr(develop_company, " AG", "",.) if !strpos(develop_company, " AGR") & !strpos(develop_company, " AG ")  & !strpos(develop_company, " AGE") & !strpos(develop_company, " AGI")
	replace develop_company = subinstr(develop_company, ", LLC,", "",.)
	replace develop_company = subinstr(develop_company, ", LLC", "",.)
	replace develop_company = subinstr(develop_company, " LLC, TAIWAN", "",.)
	replace develop_company = subinstr(develop_company, " LLC", "",.)
	replace develop_company = subinstr(develop_company, " LP", "",.)
	replace develop_company = subinstr(develop_company, " AB (PUBL)", "",.)
	replace develop_company = subinstr(develop_company, " ABR", "",.)
	replace develop_company = subinstr(develop_company, " AB", "",.) if !strpos(develop_company, " ABE") & !strpos(develop_company, " ABO") & !strpos(develop_company, " ABU") &  !strpos(develop_company, " ABO")  &  !strpos(develop_company, " ABD")  &  !strpos(develop_company, " ABX")  &  !strpos(develop_company, " ABC")  &  !strpos(develop_company, " ABZ")    &  !strpos(develop_company, " ABT")
	replace develop_company = subinstr(develop_company, " PTE", "",.)
	replace develop_company = subinstr(develop_company, " LIMITED", "",.)
	replace develop_company = subinstr(develop_company, " PTY.,", "",.)
	replace develop_company = subinstr(develop_company, " PTY", "",.)
	replace develop_company = subinstr(develop_company, " CORPORATIONS", "",.)
	replace develop_company = subinstr(develop_company, " CO.,LTD", "",.)
	replace develop_company = subinstr(develop_company, " CO.", "",.)
	replace develop_company = subinstr(develop_company, " CO,.LTD", "",.)
	replace develop_company = subinstr(develop_company, " AG & CO KGAA", "",.)
	replace develop_company = subinstr(develop_company, " SE & CO KGAA", "",.)
	replace develop_company = subinstr(develop_company, " CO LTT", "",.)
	replace develop_company = subinstr(develop_company, " MBH & CO KG", "",.)
	replace develop_company = subinstr(develop_company, " CO ", "",.) if !strpos(develop_company, "WUHAN")
	replace develop_company = subinstr(develop_company, " KGAA", "",.)
	replace develop_company = subinstr(develop_company, " GESMBH NFG KG", "",.)
	replace develop_company = subinstr(develop_company, " KG", "",.)
	replace develop_company = subinstr(develop_company, " KK", "",.)
	replace develop_company = subinstr(develop_company, " SAS", "",.) if !strpos(develop_company, " SASK")	
	
	replace develop_company = subinstr(develop_company, ", SA DE CV", "",.)
	replace develop_company = subinstr(develop_company, " SA DE CV", "",.)
	replace develop_company = subinstr(develop_company, " SARL", "",.)
	replace develop_company = subinstr(develop_company, ", S.A. DE C.V.", "",.)
	replace develop_company = subinstr(develop_company, " S.A. DE C.V", "",.)
	replace develop_company = subinstr(develop_company, " S.A.", "",.)
	replace develop_company = subinstr(develop_company, " S.A", "",.)
	replace develop_company = subinstr(develop_company, " SAU", "",.) if !strpos(develop_company, " SAUD")	
	replace develop_company = subinstr(develop_company, " PVT.", "",.)
	replace develop_company = subinstr(develop_company, " PVT", "",.)
	replace develop_company = "ALGORITHM" if develop_company == "ALGORITHM SAL"
	replace develop_company = subinstr(develop_company, " SA/NV", "",.)
	replace develop_company = subinstr(develop_company, " SA", "",.) if !strpos(develop_company, " SAN")  &  !strpos(develop_company, " SAU")  & !strpos(develop_company, " SAL") & !strpos(develop_company, " SAI") & !strpos(develop_company, " SAS") & !strpos(develop_company, " SAA")  & !strpos(develop_company, " SAO") & !strpos(develop_company, " SAC")  & !strpos(develop_company, " SA ") & !strpos(develop_company, " SAX") & !strpos(develop_company, " SAT") & !strpos(develop_company, " SAF") & !strpos(develop_company, " SAV") & !strpos(develop_company, " SAG")& !strpos(develop_company, " SAP")
	replace develop_company = subinstr(develop_company, " CORPORATION", "",.) if  !strpos(develop_company, " CORPORATION ")
	replace develop_company = subinstr(develop_company, " CORP.", "",.)
	replace develop_company = subinstr(develop_company, " CORP PLC", "",.)
	replace develop_company = subinstr(develop_company, " CORP INC", "",.)
	replace develop_company = subinstr(develop_company, " CORP II INC", "",.)
	replace develop_company = subinstr(develop_company, " CORP", "",.) if !strpos(develop_company, " CORP ")  & !strpos(develop_company, " CORPORATION")
	replace develop_company = subinstr(develop_company, " INCORPORATED", "",.)
	replace develop_company = subinstr(develop_company, " INCS", "",.)
	replace develop_company = subinstr(develop_company, " INC", "",.) if !strpos(develop_company, " INCU") & !strpos(develop_company, " INCR")
	replace develop_company = subinstr(develop_company, " (US)", "",.)
	replace develop_company = subinstr(develop_company, " (TAIWAN)", "",.)
	replace develop_company = subinstr(develop_company, " (AUSTRALIA).", "",.)
	replace develop_company = subinstr(develop_company, " (AUSTRALIA)", "",.)
	replace develop_company = subinstr(develop_company, " S.P.A.,", "",.)
	replace develop_company = subinstr(develop_company, " N.V", "",.)
	replace develop_company = subinstr(develop_company, " NV", "",.)
	replace develop_company = subinstr(develop_company, " (BE)", "",.)
	replace develop_company = subinstr(develop_company, " (DENMARK)", "",.)
	replace develop_company = subinstr(develop_company, " (MUNICH)", "",.)
	replace develop_company = subinstr(develop_company, " (XIAMEN)", "",.)
	replace develop_company = subinstr(develop_company, " (WUXI)", "",.)
	replace develop_company = subinstr(develop_company, " (DALIAN)", "",.)
	replace develop_company = subinstr(develop_company, " (NANTONG)", "",.)
	replace develop_company = subinstr(develop_company, " (SCHWEIZ)", "",.)
	replace develop_company = subinstr(develop_company, " (SUZHOU, CHINA)", "",.)
	replace develop_company = subinstr(develop_company, "(TAICANG)", "",.)
	replace develop_company = subinstr(develop_company, " (SHANDONG)", "",.)
	replace develop_company = subinstr(develop_company, " (ZHEJIANG)", "",.)
	replace develop_company = subinstr(develop_company, " (ES)", "",.)
	replace develop_company = subinstr(develop_company, " (JILIN)", "",.)
	replace develop_company = subinstr(develop_company, " (GREECE)", "",.)
	replace develop_company = subinstr(develop_company, " (FIOCRUZ)", "",.)
	replace develop_company = subinstr(develop_company, " (CHENGDU)", "",.)
	replace develop_company = subinstr(develop_company, " (FRANCE)", "",.)
	replace develop_company = subinstr(develop_company, " (TIANJIN)", "",.)
	replace develop_company = subinstr(develop_company, " (INDIA)", "",.)
	replace develop_company = subinstr(develop_company, " (ARGENTINA)", "",.)
	replace develop_company = subinstr(develop_company, " (SHANDONG)", "",.)
	replace develop_company = subinstr(develop_company, " (GUANGDONG)", "",.)
	replace develop_company = subinstr(develop_company, " (KUNSHAN)", "",.)
	replace develop_company = subinstr(develop_company, " (CHUV)", "",.)
	replace develop_company = subinstr(develop_company, " (SPAIN)", "",.)
	replace develop_company = subinstr(develop_company, " (JILIN CHINA)", "",.)
	replace develop_company = subinstr(develop_company, " (CY)", "",.)
	replace develop_company = subinstr(develop_company, " (HAINAN)", "",.)
	replace develop_company = subinstr(develop_company, " (CHILE)", "",.)
	replace develop_company = subinstr(develop_company, " (HEFEI)", "",.)
	replace develop_company = subinstr(develop_company, " (QINGDAO)", "",.)
	replace develop_company = subinstr(develop_company, "(AUSTRALIA)", "",.)
	replace develop_company = subinstr(develop_company, "(CHANGZHOU)", "",.)
	replace develop_company = subinstr(develop_company, "(NORTH-WEST)", "",.)
	replace develop_company = subinstr(develop_company, "(WUHAN)", "",.)
	replace develop_company = subinstr(develop_company, "(NEW JERSEY)", "",.)
	replace develop_company = subinstr(develop_company, "(NINGBO)", "",.)
	replace develop_company = subinstr(develop_company, " SLU", "",.)
	replace develop_company = subinstr(develop_company, ", SL", "",.)
	replace develop_company = subinstr(develop_company, " SL", "",.) if !strpos(develop_company, " SLO") & !strpos(develop_company, " SLI") & !strpos(develop_company, " SL ")
	replace develop_company = subinstr(develop_company, " ASA", "",.)
	replace develop_company = subinstr(develop_company, " AS", "",.) if !strpos(develop_company, " ASI") & !strpos(develop_company, " ASS")& !strpos(develop_company, " ASH") & !strpos(develop_company, " AST") & !strpos(develop_company, " AS ")& !strpos(develop_company, " AS-")
	replace develop_company = subinstr(develop_company, " SPA", "",.)  if  !strpos(develop_company, " SPAI")
}

*merge with company original data
{
	clear
	use "~\[100] Company_list of develop company name.dta"
	rename develop_company_original CompanyName
	
	merge 1:m CompanyName using "~\Cortellis_Company_processing.dta"
	drop if _merge == 2
	rename CompanyName develop_company_original

	gen CompanyName = develop_company_original
	replace CompanyName  = subinstr(CompanyName , "amp;", "",.)
	drop _merge
	save "~\[100] Company_list of develop company name.dta", replace
	
	keep if missing(id_firm_CORT)
	keep id_dc_ori - id_dc CompanyName
	
	duplicates list CompanyName
	
*	  +-----------------------------------------------------------------+
*	  | Group   Obs                                         CompanyName |
*	  |-----------------------------------------------------------------|
*	  |     1   151       Hainan Helpson Medicine & Biotechnique Co Ltd |
*	  |     1   152       Hainan Helpson Medicine & Biotechnique Co Ltd |
*	  |     2   285   Palo Alto Institute for Research & Education, Inc |
*	  |     2   286   Palo Alto Institute for Research & Education, Inc |
*	  +-----------------------------------------------------------------+

	drop if id_dc == 7022
	drop if id_dc == 12533
	merge 1:m CompanyName using "~\Cortellis_Company_processing.dta"
	drop if _merge == 2
	save "~\[100_1] Company_list of develop company name_unmatched with company original.dta"
	
	replace id_firm_CORT = 241306 if id_dc_ori == 19145
	replace id_firm_CORT = 229034 if id_dc_ori == 18283
	replace id_firm_CORT = 228552 if id_dc_ori == 18223
	replace id_firm_CORT = 226261 if id_dc_ori == 17846
	replace id_firm_CORT = 220163 if id_dc_ori == 17271
	replace id_firm_CORT = 211115 if id_dc_ori == 16618
	replace id_firm_CORT = 185101 if id_dc_ori == 14681
	replace id_firm_CORT = 183304 if id_dc_ori == 14520
	replace id_firm_CORT = 162506 if id_dc_ori == 12820
	replace id_firm_CORT = 159348 if id_dc_ori == 12520
	replace id_firm_CORT = 158132 if id_dc_ori == 12401
	replace id_firm_CORT = 157609 if id_dc_ori == 12324
	replace id_firm_CORT = 152258 if id_dc_ori == 11863
	replace id_firm_CORT = 147444 if id_dc_ori == 11406
	replace id_firm_CORT = 136138 if id_dc_ori == 10556
	replace id_firm_CORT = 134056 if id_dc_ori == 10421
	replace id_firm_CORT = 116962 if id_dc_ori == 9197
	replace id_firm_CORT = 113191 if id_dc_ori == 8956
	replace id_firm_CORT = 110414 if id_dc_ori == 8730
	replace id_firm_CORT = 105156 if id_dc_ori == 8397
	replace id_firm_CORT = 104405 if id_dc_ori == 8355
	replace id_firm_CORT = 101228 if id_dc_ori == 7989
	replace id_firm_CORT = 92792 if id_dc_ori == 7439
	replace id_firm_CORT = 79641 if id_dc_ori == 6532
	replace id_firm_CORT = 77590 if id_dc_ori == 6366
	replace id_firm_CORT = 74470 if id_dc_ori == 6203
	replace id_firm_CORT = 64521 if id_dc_ori == 5440
	replace id_firm_CORT = 63282 if id_dc_ori == 5378
	replace id_firm_CORT = 40649 if id_dc_ori == 3693
	replace id_firm_CORT = 40014 if id_dc_ori == 3633
	replace id_firm_CORT = 34074 if id_dc_ori == 3161
	replace id_firm_CORT = 28069 if id_dc_ori == 2590
	replace id_firm_CORT = 28162 if id_dc_ori == 2530
	replace id_firm_CORT = 3770 if id_dc_ori == 362

	distinct id_dc if missing(id_firm_CORT)

*			   |        Observations
*			   |      total   distinct
* 		-------+----------------------
*		 id_dc |         79         79

	merge 1:m id_firm_CORT using "~\Cortellis_Company_processing.dta", replace update
	drop if _merge == 2
	drop _merge
	save "~\[100_1] Company_list of develop company name_unmatched with company original.dta", replace
	
	clear
	use "~\[100] Company_list of develop company name.dta"
	drop if missing(id_firm_CORT)
	append using "~\[100_1] Company_list of develop company name_unmatched with company original.dta"
	save "~\[101] Company_list of develop company name_matched with company original.dta"
	
}

*gvkey matching (by parent company name)
{
	clear
	use "~\[101] Company_list of develop company name_matched with company original.dta"
	merge m:1 id_parent_firm_CORT using "~\[101_2] Company_Parent Co-gvkey matched from [100]_no dups.dta"
	drop if _merge == 2
	
	replace gvkey = 38910 if id_parent_firm_CORT == 4442
	replace gvkey = 36768 if id_parent_firm_CORT == 12654
	replace gvkey = 37786 if id_parent_firm_CORT == 29296
	replace gvkey = 2044 if id_parent_firm_CORT == 31751
	replace gvkey = 33723 if id_parent_firm_CORT == 47820
	replace gvkey = 38467 if id_parent_firm_CORT == 58634
	replace gvkey = 36555 if id_parent_firm_CORT == 65187
	replace gvkey = 38389 if id_parent_firm_CORT == 67119
	replace gvkey = 35376 if id_parent_firm_CORT == 70860
	replace gvkey = 36847 if id_parent_firm_CORT == 83061
	replace gvkey = 166491 if id_parent_firm_CORT == 91127
	replace gvkey = 6506 if id_parent_firm_CORT == 110425
	replace gvkey = 36482 if id_parent_firm_CORT == 113724
	replace gvkey = 36642 if id_parent_firm_CORT == 139673
	replace gvkey = 36705 if id_parent_firm_CORT == 149530
	replace gvkey = 36049 if id_parent_firm_CORT == 152441
	replace gvkey = 35728 if id_parent_firm_CORT == 152907
	replace gvkey = 39359 if id_parent_firm_CORT == 162136
	replace gvkey = 65920 if id_parent_firm_CORT == 163006
	replace gvkey = 38474 if id_parent_firm_CORT == 163096
	replace gvkey = 38453 if id_parent_firm_CORT == 164147
	replace gvkey = 37282 if id_parent_firm_CORT == 168909
	replace gvkey = 36051 if id_parent_firm_CORT == 172023
	replace gvkey = 25047 if id_parent_firm_CORT == 172148
	replace gvkey = 23337 if id_parent_firm_CORT == 203953
	replace gvkey = 187720 if id_parent_firm_CORT == 44018

	
	save "~\[101] Company_list of develop company name_matched with company original.dta", replace
	
	*gvkey unmatched develop_company_original: 	   15,820 firms
	*gvkey unmatched develop_company:		   15,496 firms
	*gvkey unmatched ParentCompany  : 		   13,165 firms (based on ParentCompanyName or id_parent_firm_CORT)
	
	*gvkey matched develop_company_original:     3,538 firms
	*gvkey matched develop_company:		     3,337 firms
	*gvkey matched ParentCompany    :            1,282 firms (based on ParentCompanyName or id_parent_firm_CORT)
	
	keep if !missing(gvkey)
	save "~\[102] Company_list of develop company name_gvkey exist.dta"
	
}

* Clean 'develop_company' in [102] data
{
	clear
	use "~\[102] Company_list of develop company name_gvkey exist.dta"
	
	gen develop_company_2 = develop_company, a(develop_company)
	replace develop_company_2 = "ABBOTT" if strpos(develop_company_2, "ABBOTT")
	replace develop_company_2 = "ABBVIE" if strpos(develop_company_2, "ABBVIE")
	replace develop_company_2 = "AMGEN" if strpos(develop_company_2, "AMGEN") & !strpos(develop_company_2, "KIRIN")
	replace develop_company_2 = "ASTRAZENECA" if strpos(develop_company_2, "ASTRAZENECA") 
	replace develop_company_2 = "ASTRA" if strpos(develop_company_2, "ASTRA") & !strpos(develop_company_2, "ASTRAZ") & !strpos(develop_company_2, "ASTRAL")
	replace develop_company_2 = "ZENECA" if strpos(develop_company_2, "ZENECA") & !strpos(develop_company_2, "ASTRAZ") & !strpos(develop_company_2, "ZENECA AGROCHEMICALS") 
	replace develop_company_2 = "BAYER" if strpos(develop_company_2, "BAYER")
	replace develop_company_2 = "BRISTOL-MYERS SQUIBB" if strpos(develop_company_2, "SQUIBB") & !strpos(develop_company_2, "SANOFI") & !strpos(develop_company_2, "GILEAD")
	replace develop_company_2 = "BRISTOL-MYERS SQUIBB" if strpos(develop_company_2, "MYERS") & !strpos(develop_company_2, "SANOFI") & !strpos(develop_company_2, "GILEAD") & !strpos(develop_company_2, "SQUIBB")
	replace develop_company_2 = "ELI LILLY" if  strpos(develop_company_2, "ELI LILLY")
	replace develop_company_2 = "GILEAD SCIENCES" if strpos(develop_company_2, "GILEAD")
	replace develop_company_2 = "GSK" if strpos(develop_company_2, "GSK")
	replace develop_company_2 = "GSK" if strpos(develop_company_2, "GLAXOSMITH")
	replace develop_company_2 = "GLAXO" if develop_company_2 == "GLAXO CANADA"
	replace develop_company_2 = "GLAXO" if develop_company_2 == "GLAXO NORWAY"
	replace develop_company_2 = "GLAXO WELLCOME" if strpos(develop_company_2, "GLAXO WE")
	replace develop_company_2 = "SMITHKLINE BEECHAM" if strpos(develop_company_2, "SMITHK")
	replace develop_company_2 = "JANSSEN" if strpos(develop_company_2, "JANSSEN") & !strpos(develop_company_2, "-")
	replace develop_company_2 = "JANSSEN-CILAG" if strpos(develop_company_2, "JANSSEN") & strpos(develop_company_2, "CILAG")
	replace develop_company_2 = "JANSSEN" if strpos(develop_company_2, "XIAN-JANSSEN") 
	replace develop_company_2 = "JOHNSON & JOHNSON" if strpos(develop_company_2, "JOHNSON &") & !strpos(develop_company_2, "MEAD")
	replace develop_company_2 = "MERCK" if strpos(develop_company_2, "MERCK") & !strpos(develop_company_2, "MERCKL")
	replace develop_company_2 = "NOVARTIS" if strpos(develop_company_2, "NOVARTIS")
	replace develop_company_2 = "PFIZER" if strpos(develop_company_2, "PFIZER") & !strpos(develop_company_2, "RINAT")
	replace develop_company_2 = "ROCHE" if strpos(develop_company_2, "ROCHE") & !strpos(develop_company_2, "ROCHEM")
	replace develop_company_2 = "TEVA" if strpos(develop_company_2, "TEVA") & !strpos(develop_company_2, "-")
	replace develop_company_2 = "NOVO NORDISK" if strpos(develop_company_2, "NORDISK")
	replace develop_company_2 = "IBIO" if strpos(develop_company_2, "IBIO DO BRASIL BIOFARMACEUTICA")
	replace develop_company_2 = "UNIQURE" if strpos(develop_company_2, "UNIQURE GERMANY")
	replace develop_company_2 = "PLIVA" if  strpos(develop_company_2, "PLIV")
	replace develop_company_2 = "IVAX" if  strpos(develop_company_2, "IVAX") & !strpos(develop_company_2, "LIVAX")
	replace develop_company_2 = "TARO PHARMACEUTICALS" if  strpos(develop_company_2, "TARO P")
	replace develop_company_2 = "TAKEDA" if strpos(develop_company_2, "TAKEDA")
	replace develop_company_2 = "ALLERGAN" if strpos(develop_company_2, "ALLERGAN")
	replace develop_company_2 = "KNOLL" if strpos(develop_company_2, "KNOLL")
	replace develop_company_2 = "ADAMIS" if strpos(develop_company_2, "ADAMIS")
	replace develop_company_2 = "AGENNIX" if strpos(develop_company_2, "AGENNIX")
	replace develop_company_2 = "ACEA BIOSCIENCES" if strpos(develop_company_2, "ACEA ")
	replace develop_company_2 = "ALBANY MOLECULAR RESEARCH" if strpos(develop_company_2, "ALBANY")
	replace develop_company_2 = "CURATIS" if strpos(develop_company_2, "CURATIS")
	replace develop_company_2 = "PHILIP MORRIS" if strpos(develop_company_2, "MORRIS")
	replace develop_company_2 = "ALVOTECH" if strpos(develop_company_2, "ALVOTECH")
	replace develop_company_2 = "DECODE" if strpos(develop_company_2, "DECODE")
	replace develop_company_2 = "ASSEMBLY" if strpos(develop_company_2, "ASSEMBLY")
	replace develop_company_2 = "ASSERTIO" if strpos(develop_company_2, "ASSERTIO")	
	replace develop_company_2 = "CELGENE" if strpos(develop_company_2, "CELGENE")
	replace develop_company_2 = "COMPUGEN" if strpos(develop_company_2, "COMPUGEN")
	replace develop_company_2 = "INDAPTUS THERAPEUTICS" if strpos(develop_company_2, "INDAPTUS THERAPEUTICS")
	replace develop_company_2 = "F-STAR THERAPEUTICS" if strpos(develop_company_2, "F-STAR")
	replace develop_company_2 = "CALLIDITAS THERAPEUTICS" if strpos(develop_company_2, "CALLIDITAS THERAPEUTICS")
	replace develop_company_2 = "ARGENX" if strpos(develop_company_2, "ARGENX")
	replace develop_company_2 = "4D PHARMA" if strpos(develop_company_2, "4D PHARMA")
	replace develop_company_2 = "INCANNEX HEALTHCARE" if strpos(develop_company_2, "INCANNEX")
	replace develop_company_2 = "VERONA PHARMA" if strpos(develop_company_2, "VERONA PHARMA")
	replace develop_company_2 = "CELLECTIS" if strpos(develop_company_2, "CELLECTIS")
	replace develop_company_2 = "BIOFRONTERA" if strpos(develop_company_2, "BIOFRONTERA")
	replace develop_company_2 = "DR REDDY'S LABORATORIES" if strpos(develop_company_2, "REDDY")
	replace develop_company_2 = "FRESENIUS" if strpos(develop_company_2, "FRESENIUS")
	replace develop_company_2 = "SILENCE THERAPEUTICS" if strpos(develop_company_2, "SILENCE THERAPEUTICS")
	replace develop_company_2 = "TONIX PHARMACEUTICALS" if strpos(develop_company_2, "TONIX PHARMACEUTICALS")
	replace develop_company_2 = "CELLECTAR" if strpos(develop_company_2, "CELLECTAR")
	replace develop_company_2 = "PACIRA" if strpos(develop_company_2, "PACIRA")
	replace develop_company_2 = "HORIZON" if strpos(develop_company_2, "HORIZON")
	replace develop_company_2 = "CELLDEX THERAPEUTICS" if strpos(develop_company_2, "CELLDEX THERAPEUTICS")
	replace develop_company_2 = "CUMBERLAND" if strpos(develop_company_2, "CUMBERLAND")
	replace develop_company_2 = "PREDICTIVE" if strpos(develop_company_2, "PREDICTIVE")
	replace develop_company_2 = "JAZZ PHARMACEUTICALS" if strpos(develop_company_2, "JAZZ PHARMACEUTICALS")
	replace develop_company_2 = "AFFYMAX" if strpos(develop_company_2, "AFFYMAX")
	replace develop_company_2 = "EMERGENT" if strpos(develop_company_2, "EMERGENT")
	replace develop_company_2 = "PTC THERAPEUTICS" if strpos(develop_company_2, "PTC THERAPEUTICS")
	replace develop_company_2 = "SINOVAC" if strpos(develop_company_2, "SINOVAC")
	replace develop_company_2 = "GALECTIN" if strpos(develop_company_2, "GALECTIN")
	replace develop_company_2 = "MILLENIUM BIOLOGIX" if strpos(develop_company_2, "MILLENIUM BIOLOGIX")
	replace develop_company_2 = "BIOMARIN PHARMACEUTICAL" if strpos(develop_company_2, "BIOMARIN")
	replace develop_company_2 = "PANACOS PHARMACEUTICALS" if strpos(develop_company_2, "PANACOS PHARMACEUTICALS")
	replace develop_company_2 = "CELLPOINT" if strpos(develop_company_2, "CELL") & strpos(develop_company_2, "POINT")
	replace develop_company_2 = "SMITH & NEPHEW" if strpos(develop_company_2, "SMITH & NEPHEW")
	replace develop_company_2 = "STERLING WINTHROP" if strpos(develop_company_2, "STERLING") & strpos(develop_company_2, "WINTHROP")
	replace develop_company_2 = "SANOFI" if strpos(develop_company_2, "SANOFI") & strpos(develop_company_2, "WINTHROP")
	replace develop_company_2 = "SANOFI" if strpos(develop_company_2, "SANOFI") & strpos(develop_company_2, "AVENTIS") & !strpos(develop_company_2, "CHUGAI")
	replace develop_company_2 = "SANOFI" if strpos(develop_company_2, "SANOFI RECHERCHE")
	replace develop_company_2 = "SANOFI"  if strpos(develop_company_2, "SANOFI PHARMA") & !strpos(develop_company_2, "BRISTOL")
	replace develop_company_2 = "SANOFI"  if strpos(develop_company_2, "SANOFI CANADA")
	replace develop_company_2 = "SANOFI"  if strpos(develop_company_2, "SANOFI GENZYME")
	replace develop_company_2 = "SANOFI"  if strpos(develop_company_2, "SANOFI BIOSURGERY")
	replace develop_company_2 = "SANOFI"  if strpos(develop_company_2, "SANOFI (PRE-1999)")
	replace develop_company_2 = "SANOFI"  if strpos(develop_company_2, "SANOFI PA") & !strpos(develop_company_2, "MSD")
	replace develop_company_2 = "EISAI"  if strpos(develop_company_2, "EISAI")
	replace develop_company_2 = "ENDO"  if strpos(develop_company_2, "ENDO ") & !strpos(develop_company_2, "CRESCENDO")   & !strpos(develop_company_2, "MILLENDO") & !strpos(develop_company_2, "FORENDO")
	replace develop_company_2 = "HELIX BIOPHARMA"  if strpos(develop_company_2, "HELIX ") & !strpos(develop_company_2, "MEDIX")
	replace develop_company_2 = "SAB BIOTHERAPEUTICS"  if strpos(develop_company_2, "SAB ")
	replace develop_company_2 = "CENTURY THERAPEUTICS"  if strpos(develop_company_2, "CENTURY T")
	replace develop_company_2 = "CULLINAN"  if strpos(develop_company_2, "CULLINAN ")
	replace develop_company_2 = "CLENE"  if strpos(develop_company_2, "CLENE")
	replace develop_company_2 = "KINETA"  if strpos(develop_company_2, "KINETA")
	replace develop_company_2 = "PRAXIS PRECISION MEDICINES"  if strpos(develop_company_2, "PRAXIS PRECISION")
	replace develop_company_2 = "CHINOOK THERAPEUTICS"  if strpos(develop_company_2, "CHINOOK THERAPEUTICS")
	replace develop_company_2 = "IMMATICS"  if strpos(develop_company_2, "IMMATICS")
	replace develop_company_2 = "FORTE BIOSCIENCES"  if strpos(develop_company_2, "FORTE B")
	replace develop_company_2 = "NEUROBO PHARMACEUTICALS"  if strpos(develop_company_2, "NEUROBO P")
	replace develop_company_2 = "BIONTECH"  if strpos(develop_company_2, "BIONTECH")
	replace develop_company_2 = "ADC THERAPEUTICS"  if strpos(develop_company_2, "ADC ")
	replace develop_company_2 = "EDESA BIOTECH"  if strpos(develop_company_2, "EDESA BIOTECH")
	replace develop_company_2 = "ENLIVEX THERAPEUTICS"  if strpos(develop_company_2, "ENLIVEX T")
	replace develop_company_2 = "PDS BIOTECHNOLOGY"  if strpos(develop_company_2, "PDS ")
	replace develop_company_2 = "X4 PHARMACEUTICALS"  if strpos(develop_company_2, "X4 ")
	replace develop_company_2 = "ORCHARD THERAPEUTICS"  if strpos(develop_company_2, "ORCHARD T")
	replace develop_company_2 = "RVL PHARMACEUTICALS"  if strpos(develop_company_2, "RVL P")
	replace develop_company_2 = "XERIS"  if strpos(develop_company_2, "XERIS")
	replace develop_company_2 = "XORTX"  if strpos(develop_company_2, "XORTX")
	replace develop_company_2 = "ITERUM THERAPEUTICS"  if strpos(develop_company_2, "ITERUM")
	replace develop_company_2 = "ROCKET PHARMACEUTICALS"  if strpos(develop_company_2, "ROCKET ")
	replace develop_company_2 = "ACER THERAPEUTICS"  if strpos(develop_company_2, "ACER THERAPEUTICS")
	replace develop_company_2 = "OPTINOSE"  if strpos(develop_company_2, "OPTINOSE")
	replace develop_company_2 = "ALPINE IMMUNE SCIENCES"  if strpos(develop_company_2, "ALPINE IMMUNE SCIENCES")
	replace develop_company_2 = "MOLECULAR TEMPLATES"  if strpos(develop_company_2, "MOLECULAR TEMPLATES")
	replace develop_company_2 = "MIRAVANT"  if strpos(develop_company_2, "MIRAVANT")
	replace develop_company_2 = "VIRIDIAN THERAPEUTICS"  if strpos(develop_company_2, "VIRIDIAN THERAPEUTICS")
	replace develop_company_2 = "BAUSCH & LOMB"  if strpos(develop_company_2, "LOMB")
	replace develop_company_2 = "KALVISTA PHARMACEUTICALS"  if strpos(develop_company_2, "KALVISTA")
	replace develop_company_2 = "ALBIREO"  if strpos(develop_company_2, "ALBIREO")
	replace develop_company_2 = "SHAMAN"  if strpos(develop_company_2, "SHAMAN")
	replace develop_company_2 = "MADRIGAL PHARMACEUTICALS"  if strpos(develop_company_2, "MADRIGAL")
	replace develop_company_2 = "FIRST WAVE BIOPHARMA"  if strpos(develop_company_2, "FIRST W")
	replace develop_company_2 = "MOLECULIN BIOTECH"  if strpos(develop_company_2, "MOLECULIN")
	replace develop_company_2 = "PLX PHARMA"  if strpos(develop_company_2, "PLX")
	replace develop_company_2 = "SCICLONE PHARMACEUTICAL"  if strpos(develop_company_2, "SCICLONE")
	replace develop_company_2 = "PERRIGO"  if strpos(develop_company_2, "PERRIGO")
	replace develop_company_2 = "BIOGEN"  if strpos(develop_company_2, "BIOGEN ") & !strpos(ParentCompanyName, "Sanofi")
	replace develop_company_2 = "VIRACTA"  if strpos(develop_company_2, "VIRACTA ")
	replace develop_company_2 = "REGENERON"  if strpos(develop_company_2, "REGENERON")
	replace develop_company_2 = "KEMPHARM"  if strpos(develop_company_2, "KEMPHARM")
	replace develop_company_2 = "MABVAX THERAPEUTICS"  if strpos(develop_company_2, "MABVAX")
	replace develop_company_2 = "CATALENT"  if strpos(develop_company_2, "CATALENT")
	replace develop_company_2 = "MULTICELL"  if strpos(develop_company_2, "MULTICELL")
	replace develop_company_2 = "CARDAX"  if strpos(develop_company_2, "CARDAX")
	replace develop_company_2 = "MEDEXUS"  if strpos(develop_company_2, "MEDEXUS")
	replace develop_company_2 = "SIEMENS"  if strpos(develop_company_2, "SIEMENS")
	replace develop_company_2 = "CAPRICOR"  if strpos(develop_company_2, "CAPRICOR")
	replace develop_company_2 = "MITSUBISHI"  if strpos(develop_company_2, "MITSUBISHI")
	replace develop_company_2 = "KYOWA HAKKO" if develop_company_2 == "KYOWA HAKKO BIO"
	replace develop_company_2 = "KYOWA HAKKO" if develop_company_2 == "KYOWA HAKKO KOGYO"
	replace develop_company_2 = "KIRIN" if develop_company_2 == "KYOWA HAKKO KIRIN PHARMA"
	replace develop_company_2 = "KIRIN"  if strpos(develop_company_2, "KYOWA KIRIN") & joint_venture != 1
	replace develop_company_2 = "KIRIN"  if strpos(develop_company_2, "KIRIN") & joint_venture != 1
	replace develop_company_2 = "PRECIGEN"  if strpos(develop_company_2, "PRECIGEN")
	replace develop_company_2 = "MALLINCKRODT"  if strpos(develop_company_2, "MALLINCKROD") & strpos(ParentCompanyName, "Mall")
	replace develop_company_2 = "BASF"  if strpos(develop_company_2, "BASF")
	replace develop_company_2 = "NESTLE"  if strpos(develop_company_2, "NESTLE")
	replace develop_company_2 = "ZYUS LIFE SCIENCES"  if strpos(develop_company_2, "ZYUS")
	replace develop_company_2 = "CYTRX"  if strpos(develop_company_2, "CYTRX")
	replace develop_company_2 = "REPLIGEN"  if strpos(develop_company_2, "REPLIGEN")
	replace develop_company_2 = "VIRAGEN"  if strpos(develop_company_2, "VIRAGEN SCOTLAND")
	replace develop_company_2 = "NOVO NORDISK"  if strpos(develop_company_2, "NOVO ")
	replace develop_company_2 = "MYLAN"  if strpos(develop_company_2, "MYLAN")
	replace develop_company_2 = "MEDTRONIC"  if strpos(develop_company_2, "MEDTRONIC")
	replace develop_company_2 = "3M"  if strpos(develop_company_2, "3M")
	replace develop_company_2 = "ELI LILLY"  if strpos(develop_company_2, "LILLY INDUSTRIES")
	replace develop_company_2 = "ELI LILLY"  if strpos(develop_company_2, "LILLY RESEARCH CENTRE")
	replace develop_company_2 = "ELI LILLY"  if strpos(develop_company_2, "LILLY-NUS CENTRE FOR CLINICAL PHARMACOLOGY")
	replace develop_company_2 = "FUJIFILM"  if strpos(develop_company_2, "FUJIF") & joint_venture != 1 & !strpos(develop_company_2, "DIOSY")
	replace develop_company_2 = "ENZO BIOCHEM"  if strpos(develop_company_2, "ENZO ")
	replace develop_company_2 = "ENZON"  if strpos(develop_company_2, "ENZON")
	replace develop_company_2 = "BAXTER"  if strpos(develop_company_2, "BAXTER")
	replace develop_company_2 = "WYETH"  if  strpos(develop_company_2, "WYETH") & !strpos(develop_company_2, "AYERST")
	replace develop_company_2 = "WYETH"  if  strpos(develop_company_2, "WYETH")
	replace develop_company_2 = "ACAMBIS"  if  strpos(develop_company_2, "ACAMBIS")
	replace develop_company_2 = "ACTELION"  if  strpos(develop_company_2, "ACTELION")
	replace develop_company_2 = "AEROGEN"  if  strpos(develop_company_2, "AEROGEN")
	replace develop_company_2 = "AERPIO"  if  strpos(develop_company_2, "AERPIO")
	replace develop_company_2 = "ALCON"  if  strpos(develop_company_2, "ALCON")
	replace develop_company_2 = "ALLERGAN"  if strpos(develop_company_2, "ALLERGAN") & joint_venture != 1
	replace develop_company_2 = "ALPHARMA"  if strpos(develop_company_2, "ALPHARMA")
	replace develop_company_2 = "AMERSHAM"  if strpos(develop_company_2, "AMERSHAM")
	replace develop_company_2 = "ARIAD PHARMACEUTICALS"  if strpos(develop_company_2, "ARIAD ")
	replace develop_company_2 = "AVENTIS"  if strpos(develop_company_2, "AVENTIS") & !strpos(develop_company_2, "CHUGAI")
	replace develop_company_2 = "BERLEX"  if strpos(develop_company_2, "BERLEX")
	replace develop_company_2 = "BIOCHEM"  if strpos(develop_company_2, "BIOCHEM") & joint_venture != 1
	replace develop_company_2 = "BIOGLAN"  if strpos(develop_company_2, "BIOGLAN")
	replace develop_company_2 = "BIOTA"  if strpos(develop_company_2, "BIOTA")
	replace develop_company_2 = "AVIRAGEN"  if strpos(develop_company_2, "BIOTA")
	replace develop_company_2 = "AVIRAGEN"  if strpos(develop_company_2, "AVIRAGEN")
	replace develop_company_2 = "BIOVAIL"  if strpos(develop_company_2, "BIOVAIL")
	replace develop_company_2 = "BOEHRINGER MANNHEIM"  if strpos(develop_company_2, "BOEHRINGER")
	replace develop_company_2 = "BTG"  if strpos(develop_company_2, "BTG")
	replace develop_company_2 = "BURROUGHS WELLCOME"  if strpos(develop_company_2, "BURROUGHS WELLCOME")
	replace develop_company_2 = "GSK" if develop_company_2 == "BURROUGHS WELLCOME"
	replace develop_company_2 = "SMITHKLINE BEECHAM"  if strpos(develop_company_2, "BEECHAM")
	replace develop_company_2 = "WELLCOME" if develop_company_2 == "LABORATORIOS WELLCOME DE PORTUGAL LDA"
	replace develop_company_2 = "CAMBRIDGE DRUG DISCOVERY"  if strpos(develop_company_2, "CAMBRIDGE DRUG DISCOVERY")
	replace develop_company_2 = "CELERA"  if strpos(develop_company_2, "CELERA ")
	replace develop_company_2 = "CEPHALON"  if strpos(develop_company_2, "CEPHALON")
	replace develop_company_2 = "CHINOIN"  if strpos(develop_company_2, "CHINOIN")
	replace develop_company_2 = "CHIRON"  if strpos(develop_company_2, "CHIRON")
	replace develop_company_2 = "CHUGAI PHARMACEUTICAL"  if strpos(develop_company_2, "HUGAI PHARMA")
	replace develop_company_2 = "CONNETICS"  if strpos(develop_company_2, "CONNETICS")
	replace develop_company_2 = "CRUCELL"  if strpos(develop_company_2, "CRUCELL")
	replace develop_company_2 = "DELTAGEN"  if strpos(develop_company_2, "DELTAGEN")
	replace develop_company_2 = "DEPUY"  if strpos(develop_company_2, "DEPUY")
	replace develop_company_2 = "DURAMED"  if strpos(develop_company_2, "DURAMED")
	replace develop_company_2 = "DURA"  if strpos(develop_company_2, "DURA ")
	replace develop_company_2 = "WARNER-LAMBERT"  if strpos(develop_company_2, "WARNER-LAMBERT")
	replace develop_company_2 = "DUPONT"   if strpos(develop_company_2, "DUPONT")
	replace develop_company_2 = "DOWDUPONT"   if strpos(develop_company_2, "DUPONT")& strpos(ParentCompanyName, "DowDuPont Inc")
	replace develop_company_2 = "EURAND"   if strpos(develop_company_2, "EURAND")
	replace develop_company_2 = "EVOTEC"   if strpos(develop_company_2, "EVOTEC I")
	replace develop_company_2 = "FOREST LABORATORIES"   if strpos(develop_company_2, "FOREST L")
	replace develop_company_2 = "SOLVAY PHARMACEUTICALS"   if strpos(develop_company_2, "SOLVAY PHARMA")
	replace develop_company_2 = "FOURNIER PHARMA"   if strpos(develop_company_2, "FOURNIER")
	replace develop_company_2 = "FULCRUM THERAPEUTICS"   if strpos(develop_company_2, "FULCRUM")
	replace develop_company_2 = "GENZYME"   if strpos(develop_company_2, "GENZYME ")
	replace develop_company_2 = "GENZYME"   if strpos(develop_company_2, " GENZYME")
	replace develop_company_2 = "HOECHST MARION ROUSSEL"   if strpos(develop_company_2, "HOECHST")
	replace develop_company_2 = "HOSPIRA"   if strpos(develop_company_2, "HOSPIRA")
	replace develop_company_2 = "HUMABS"   if strpos(develop_company_2, "HUMABS")
	replace develop_company_2 = "HYBRITECH"   if strpos(develop_company_2, "HYBRITECH")
	replace develop_company_2 = "IKARIA"   if strpos(develop_company_2, "IKARIA")
	replace develop_company_2 = "ILEX ONCOLOGY"   if strpos(develop_company_2, "ILEX ONCOLOGY")
	replace develop_company_2 = "JANSSEN"   if strpos(develop_company_2, "JANSSEN")
	replace develop_company_2 = "PHARMACIA & UPJOHN"   if strpos(develop_company_2, "PHARMACIA & UPJOHN")
	replace develop_company_2 = "UPJOHN"   if strpos(develop_company_2, "JAPAN UPJOHN")
	replace develop_company_2 = "UPJOHN"   if strpos(develop_company_2, "UPJOHN PHARMACEUTICALS")
	replace develop_company_2 = "KABI PHARMACEUTICALS"   if strpos(develop_company_2, "KABI")
	replace develop_company_2 = "KADMON"   if strpos(develop_company_2, "KADMON")
	replace develop_company_2 = "KIADIS PHARMA"   if strpos(develop_company_2, "KIADIS PHARMA")
	replace develop_company_2 = "KING PHARMACEUTICALS"   if strpos(develop_company_2, "KING PHARMACEUTICALS")
	replace develop_company_2 = "LUNA"   if strpos(develop_company_2, "LUNA")
	replace develop_company_2 = "MEDA PHARMA"   if strpos(develop_company_2, "MEDA P") & !strpos(develop_company_2, "OHMEDA")
	replace develop_company_2 = "MEDA VALEANT PHARMA"   if strpos(develop_company_2, "MEDA VALEANT PHARMA")
	replace develop_company_2 = "MEDICURE"   if strpos(develop_company_2, "MEDICURE")
	replace develop_company_2 = "MEDIMMUNE"   if strpos(develop_company_2, "MEDIMMUNE")
	replace develop_company_2 = "MGI"   if strpos(develop_company_2, "MGI")
	replace develop_company_2 = "MIDATECH PHARMA"   if strpos(develop_company_2, "MIDATECH")
	replace develop_company_2 = "MSD "   if strpos(develop_company_2, "MSD") & !strpos(develop_company_2, "OSS")
	replace develop_company_2 = "MERCK"   if develop_company_2 == "MSD "
	replace develop_company_2 = "ORGANON"   if strpos(develop_company_2, "ORGANON")	
	replace develop_company_2 = "HOECHST MARION ROUSSEL"  if strpos(develop_company_2, "ROUSSEL")
	replace develop_company_2 = "NUVATION BIO"  if strpos(develop_company_2, "NUVATION")
	replace develop_company_2 = "NYCOMED"  if strpos(develop_company_2, "NYCOMED")
	replace develop_company_2 = "OHMEDA"  if strpos(develop_company_2, "OHMEDA MEDIZINTECHNIC")
	replace develop_company_2 = "ONCOLOGY VENTURE"  if strpos(develop_company_2, "ONCOLOGY VENTURE")
	replace develop_company_2 = "ALLARITY THERAPEUTICS"  if strpos(develop_company_2, "ONCOLOGY VENTURE")
	replace develop_company_2 = "PAR PHARMACEUTICAL"  if strpos(develop_company_2, "PAR SPECIALTY PHARMACEUTICALS")
	replace develop_company_2 = "PARKE-DAVIS"  if strpos(develop_company_2, "DAVIS")
	replace develop_company_2 = "SANOFI"  if strpos(develop_company_2, "PASTEUR ME")
	replace develop_company_2 = "STERLING WINTHROP" if strpos(develop_company_2, "STERLING")
	replace develop_company_2 = "SYNTHELABO" if strpos(develop_company_2, "SYNTHELABO") & joint_venture != 1
	replace develop_company_2 = "RHONE-POULENC RORER" if strpos(develop_company_2, "POULENC")
	replace develop_company_2 = "POWDERJECT" if strpos(develop_company_2, "POWDERJECT")
	replace develop_company_2 = "PROMETIC" if strpos(develop_company_2, "PROMETIC")
	replace develop_company_2 = "LIMINAL BIOSCIENCES" if strpos(develop_company_2, "PROMETIC")
	replace develop_company_2 = "RINAT NEUROSCIENCE"  if develop_company_2 == "RINAT-PFIZER"
	replace develop_company_2 = "ROTTAPHARM"  if develop_company_2 == "ROTTAPHARM MADAUS"
	replace develop_company_2 = "YM BIOSCIENCES" if strpos(develop_company_2, "YM BIOSCIENCES")
	replace develop_company_2 = "WARNER-LAMBERT" if strpos(develop_company_2, "LAMBERT")
	replace develop_company_2 = "VERNALIS" if strpos(develop_company_2, "VERNALIS")
	replace develop_company_2 = "VALEANT" if strpos(develop_company_2, "VALEANT CANADA")
	replace develop_company_2 = "VALEANT" if strpos(develop_company_2, "VALEANT PHARMACEUTICALS NORTH AMERICA")
	replace develop_company_2 = "SPEEDEL" if strpos(develop_company_2, "SPEEDEL")
	replace develop_company_2 = "SMITHKLINE BEECHAM" if develop_company_2 == "SMITH KLINE & FRENCH LABORATORIES"
	replace develop_company_2 = "SICOR" if develop_company_2 == "SICOR BIOTECH UAB"
	replace develop_company_2 = "SHIRE" if strpos(develop_company_2 , "SHIRE") & !strpos(ParentCompanyName , "GSK plc")
	

	egen id_dc_2 = group(develop_company_2)
	order id_dc_2, a( develop_company_2)
	replace id_dc_2 = 918200 if strpos(develop_company_2, "KNOLL")
	replace id_dc_2 = 208000 if strpos(develop_company_2, "ACEA BIO")
	replace id_dc_2 = 485100 if strpos(develop_company_2, "DECODE")
	
	save "~\[102] Company_list of develop company name_gvkey exist.dta", replace
	
}

* Clean 'Parent company name' in [102] 
{
	clear
	use "~\[102] Company_list of develop company name_gvkey exist.dta"
	
	gen upper_Parent = upper( ParentCompanyName)
	replace upper_Parent = "REVIVA PHARMACEUTICALS" if strpos(upper_Parent, "REVIVA")
	replace upper_Parent = "PDS BIOTECHNOLOGY" if strpos(upper_Parent, "PDS")
	replace upper_Parent = "X4 PHARMACEUTICALS" if strpos(upper_Parent, "X4")	replace upper_Parent = "XERIS PHARMACEUTICALS" if strpos(upper_Parent, "XERIS")
	replace upper_Parent = "ZAI LAB" if strpos(upper_Parent, "ZAI")
	replace upper_Parent = "FIRST WAVE BIOPHARMA" if strpos(upper_Parent, " WAVE")
	replace upper_Parent = "NOVO NORDISK" if strpos(upper_Parent, "NORDISK")
	replace upper_Parent = "PLX PHARMA" if strpos(upper_Parent, "PLX")
	replace upper_Parent = "MADRIGAL PHARMACEUTICALS" if strpos(upper_Parent, "MADRIGAL")
	replace upper_Parent = "ALPINE IMMUNE SCIENCES" if strpos(upper_Parent, "ALPINE")
	replace upper_Parent = "MOLECULAR TEMPLATES" if strpos(upper_Parent, "TEMPLA")
	replace upper_Parent = "ORCHARD THERAPEUTICS" if strpos(upper_Parent, "ORCHARD")
	replace upper_Parent = "EDESA BIOTECH" if strpos(upper_Parent, "EDESA BIOTECH")
	replace upper_Parent = "NEUROBO PHARMACEUTICALS" if strpos(upper_Parent, "NEUROBO PHARMACEUTICALS")
	replace upper_Parent = "FORTE BIOSCIENCES" if strpos(upper_Parent, "FORTE BIOSCIENCES")
	replace upper_Parent = "MARKER THERAPEUTICS" if strpos(upper_Parent, "MARKER THERAPEUTICS")
	replace upper_Parent = "SYNERGY PHARMACEUTICALS" if strpos(upper_Parent, "SYNERGY PHARMACEUTICALS")
	replace upper_Parent = "INDAPTUS THERAPEUTICS" if strpos(upper_Parent, "INDAPTUS THERAPEUTICS")
	
	drop if gvkey == 8719
	* PRECISION BIOLOGICS (Cortellis) - gvkey matched to PRECISION OPTICS (Compustat)

	save "~\[102] Company_list of develop company name_gvkey exist.dta", replace

	**Company name change
	*gvkey: 7637  | (~2016) MYLAN (2017~) VIATRIS
	*gvkey: 254096| (~2016) CYTORI THERAPEUTICS (2017~) PLUS THERAPEUTICS 

	**Merge
	*gvkey: 19458 | (~2016) SESEN BIO (2017~) CARISMA THERAPEUTICS // CARISMA merged SESENBIO in 2023.
	*gvkey: 20307 | (~2013) ANGION BIOMEDICA (2018~) ELICIO THERAPEUTICS // ELICO merged ANGION in 2023.
	*gvkey: 27354 | (~2016) SELECTA BIOSCIENCES (2017~) CARTESIAN THERAPEUTICS // SELECTA merged with CARTESIN in 2023.
	*gvkey: 33500 | (~2016) MAGENTA THRPUTCS (2017~) DIANTHUS THERAPEUTICS // MAGENTA merged with DIANTHUS in 2023.
	*gvkey: 61899 | (~2016) IDERA (2017~) ACERAGEN // IDERA acquired ACERAGEN in 2022.
	*gvkey: 176180| (~2016) ICO THEAPEUTICS (2017~) SATELLOS BIOSCIENCE // SATELLOS acquired ICO THERAPEUTICS in 2021.

	egen id_parent_firm_CORT_2 = group( upper_Parent )
}

// (Step 4) Correct 'added_year' in [102] 
// 'added_year': a year when a develop company becomes a part of parent company
// Among 1,255 parent firms having gvkey, (based on gvkey) 
// 771 firms have only one develop_company.
// 484 firms (parent company) have more than 2 develop_company.
// --> Among 484 firms, 337 firms are matched with M&A data. --> [102_3a]

{
	clear
	use "~\[102] Company_list of develop company name_gvkey exist.dta"
	keep ParentCompanyName id_parent_firm_CORT gvkey added_year id_dc_ori develop_company_original develop_company develop_company_2 id_dc
	duplicates drop
	save "~\[102_1] Company_list of develop company name_gvkey exist_firm list only.dta"
	
	clear
	use "~\[102_1] Company_list of develop company name_gvkey exist_firm list only.dta"
	bysort id_parent_firm_CORT (id_dc): gen cnt = _N
	keep if cnt != 1
 	distinct id_parent_firm_CORT
	save "~\[102_2] Company_list of develop company name_gvkey exist_firm list of more than two develop company.dta"
}

****(1) using M&A dataset downloaded from WRDS
*-> Final result file: [102_6] Company_gvkey-id_dc added_year_revised.dta
*-> Final result file only contains gvkey id_dc and year info.
*-> Detailed M&A descriptions can be found in following two files: 
*[102_5] Company_parent firm_child firm matching completed.dta"
*[102_5a] Company_parent firm_child firm matching completed_from 102_4d

{
	clear
	use "~\[102_3a] MnA data_tagging gvkey id_dc_for fuzzy matching_matched.dta"
	rename upper_amanames conm
	duplicates report id_upper_amanames
	merge 1:m  id_upper_amanames using  "~\[102_3] MnA data_tagging gvkey id_dc.dta"
	drop if _merge == 2
	drop _merge
	sort gvkey tmanames
	
	gen year_announce = substr(dateann,1,4)
	gen year_eventdate = substr(hdate,1,4)
	destring, replace
	egen id_tmanames = group(upper_tmanames)
	save "~\[102_4] MnA data_matched gvkey using 102_3a_matched.dta"
	
	*acquiror matching finished using 'gvkey
	*should match 'id_dc' of target firms
	
	*[102_4]: gvkey matched data from M&A data --> After extracting the list of target firm name, then do matchit 
	clear
	use "~\[102_4] MnA data_matched gvkey using 102_3a_matched.dta"
	keep if id_dc == 0
	keep gvkey id_upper_amanames upper_amanames id_tmanames upper_tmanames id_dc
	duplicates drop
	drop id_dc
	keep id_tmanames upper_tmanames
	duplicates drop
	save "~\[102_4b] MnA data_matched gvkey_target name only_for fuzzy matching.dta"

	*[102_4a]: data of parent firms having multiple develop companies --> After extracting the 'develop_compaby', then do matchit
	clear
	use "~\[102_4a] MnA data_from_[102] to match id_dc.dta"
	keep id_dc develop_company
	duplicates drop
	save "~\[102_4c] Company_id_dc_for fuzzy matching.dta"
	
	clear 
	use "~\[102_4c] Company_id_dc_for fuzzy matching.dta"
	matchit id_dc develop_company using "~\[102_4b] MnA data_matched gvkey_target name only_for fuzzy matching.dta", idu(id_tmanames) txtu(  upper_tmanames)
	save "~\[102_4c_1] Company_id_dc_for fuzzy matching_result.dta"
	
	***(data name: 102_4c_1)
	- task: Put 'id_dc' to the target company in M&A data
	- goal: Match 'id_tmanames' and 'id_dc' 
	***>> Result data: [102_4c_1_matched] Company_id_dc_for fuzzy matching_result.dta
	
	- Final goal: Obtain the exact 'added_year' info using gvkey (parent firm; acquiror) ~ id_dc (target firm)
	***>> Data: [102_6] Company_gvkey-id_dc added_year_revised.dta"
	
	clear
	use "~\[102_4] MnA data_matched gvkey using 102_3a_matched.dta"
	sort gvkey upper_tmanames
	joinby id_tmanames using "~\[102_4c_1_matched] Company_id_dc_for fuzzy matching_result.dta"
	drop if upper_amanames1 == upper_tmanames
	gen a_3 = substr( upper_amanames1, 1,3)
	gen t_3 = substr(upper_tmanames, 1,3)
	gen same = 1 if a_3 == t_3
	drop a_3 t_3

	list upper_amanames upper_tmanames if same == 1
	replace same = . in 1093
	replace same = . in 1401
	replace same = . in 1767
	replace same = . in 1768
	drop if same == 1
	drop same
	gsort gvkey id_dc -hdate
	by gvkey id_dc: gen tag = (_n ==1)	
	save "~\[102_4d] Joinby_102_4 and 102_4c_1_matched.dta"
	
	clear
	use "~\[102_4d] Joinby_102_4 and 102_4c_1_matched.dta"
	keep if tag == 1
	save "~\[102_5a] Company_parent firm_child firm matching completed_from 102_4d.dta"
	
	clear
	use "~\[102_5a] Company_parent firm_child firm matching completed_from 102_4d.dta"
	keep gvkey id_dc year_announce year_eventdate
	append using "~\[102_6] Company_gvkey-id_dc added_year_revised.dta"
	save "~\[102_6] Company_gvkey-id_dc added_year_revised.dta" , replace
	
	/// List of matched gvkey-id_dc-added_year_revised (year_announce, year_eventdate)
	
	clear
	use "~\[102_4] MnA data_matched gvkey using 102_3a_matched.dta"
	keep if id_dc != 0
	drop conm matched master_deal_no tn an acusip acquiror_sedol master_cusip target_sedol
	
	sort gvkey id_dc hdate
	gen hevent_tag = 1 if strpos(hevent, "completed")
	order hevent_tag, a(hevent)
	replace hevent_tag =1 if missing(hevent)
	replace hevent_tag = 1 in 32
	replace hevent_tag = 1 in 62
	replace hevent_tag = 1 in 141
	save "~\[102_5] Company_parent firm_child firm matching completed.dta"

	
	clear
	use  "~\[102_5] Company_parent firm_child firm matching completed.dta"
	keep if hevent_tag == 1
	keep gvkey id_dc year_announce year_eventdate
	duplicates drop
	drop in 21 // keep the latest year 
	drop in 4 // keep the latest year 
	save "~\[102_6] Company_gvkey-id_dc added_year_revised.dta"
	
}

****(2) Using subsidiary data 
*dataset: [103]
{
	clear
	use "~\[102_1] Company_list of develop company name_gvkey exist_firm list only.dta"
	keep gvkey
	duplicates drop
	merge 1:m gvkey using "E:\ARK\Preprocessing_as of Dec 2023\2024-March\[201] Subsidiary (first year of each subsidiary).dta"
	drop if _merge == 2
	drop _merge
	save "~\[103] Subsidiary_only gvkey firms from [102_1].dta"
	
	keep id_subsidiary clean_company
	duplicates drop
		
	clear 
	use "~\[102_4c] Company_id_dc_for fuzzy matching.dta"
	matchit id_dc develop_company using  "~\[103a] Subsidiary_only gvkey firms from [102_1]_for fuzzy matching.dta", idu(id_subsidiary) txtu(  clean_company)
	save "~\[103b] Subsidiary_results of fuzzy matching (102_4c and 103a).dta"
	
	clear
	use "~\[103b] Subsidiary_results of fuzzy matching (102_4c and 103a).dta"
	keep if similscore == 1
	save "~\[103b_matched] Subsidiary_results of fuzzy matching (102_4c and 103a).dta"
	
	clear
	use "~\[103b] Subsidiary_results of fuzzy matching (102_4c and 103a).dta"
	gen de_ = subinstr(develop_company, " ", "", .)
	gen cle_ = subinstr(clean_company, " " , "", .)
	gen de_5 = substr(de_, 1, 5)
	gen cle_5 = substr(cle_,1,5)
	gen same = 1 if de_5 == cle_5
	gen de_6 = substr(de_, 1, 6)
	gen cle_6 = substr(cle_,1,6)
	gen same2 = 1 if de_6 == cle_6
	list develop_company clean_company if same2 != 1 & same == 1
	keep if same == 1
	save "~\[103b_matched_check] Subsidiary_results of fuzzy matching (102_4c and 103a).dta"
	
	clear
	use "~\[103--gvkey to be matched] Subsidiary_only gvkey firms from [102_1].dta"
	joinby id_subsidiary using "~\[103b_matched] Subsidiary_results of fuzzy matching (102_4c and 103a).dta", unmatched(both)

*	        	               _merge |      Freq.     Percent        Cum.
*		------------------------------+-----------------------------------
*			  only in master data |     27,341       60.84       60.84
*			   only in using data |      4,276        9.52       70.36
*		both in master and using data |     13,322       29.64      100.00
*		------------------------------+-----------------------------------
*					Total |     44,939      100.00

	save "~\[103c] Joinby_103 and 103b_matched.dta"

	clear
	use "~\[103c] Joinby_103 and 103b_matched.dta"
	keep if _merge == 3
	drop _merge
	drop cik accession fdate rdate secpdate type location country_code subdiv_code clean_company_ori hierarchy extype description ex21url tag_follow
	drop similscore
	drop subsidiary_name
	rename year year_subsidiary
	drop in 5053
	drop if id_dc == 14470 & strpos(clean_company, "SCHERING")
	gsort gvkey id_dc year_subsidiary
	by gvkey id_dc: gen tag = (_n == 1)
	save "~\[103c_merge3] Joinby_103 and 103b_matched.dta"
		
	clear
	use  "~\[103c_merge3] Joinby_103 and 103b_matched.dta"
	keep if tag == 1
	save "~\[103c_merge3_tag1] Joinby_103 and 103b_matched.dta"
	
}	
	
	
****Correct 'added_year' info. using M&A data
{
	clear
	use "~\[102] Company_list of develop company name_gvkey exist.dta"
	drop _merge
	merge m:1 gvkey id_dc using  "~\[102_6] Company_gvkey-id_dc added_year_revised.dta"
		
*		Result                      Number of obs
*		-----------------------------------------
*		Not matched                         3,547
*			from master                     3,049  (_merge==1)
*			from using                        498  (_merge==2)
*
*		Matched                               489  (_merge==3)
*		-----------------------------------------

	drop if _merge == 2
	drop _merge	
	save "~\[102] Company_list of develop company name_gvkey exist.dta", replace

}

****Correct added_year info. using Subsidiary data
{
	clear
	use "~\[102] Company_list of develop company name_gvkey exist.dta"
	merge m:1 gvkey id_dc using "~\[103c_merge3_tag1] Joinby_103 and 103b_matched.dta"
*	    Result                      Number of obs
*	    -----------------------------------------
*	    Not matched                         3,365
*           from master                     2,611  (_merge==1)
*           from using                        754  (_merge==2)
*
*	    Matched                               927  (_merge==3)
*	    -----------------------------------------
	
	drop if _merge == 2
	drop _merge tag same
	save "~\[102] Company_list of develop company name_gvkey exist.dta", replace
}


// (Step 5) refine firm id if develop_company_2 == Parentcompany in [102]
// (a) develop_company name cleaning
//     -> Result data: [102] ; unique ID: id_dc_2
// (b) Parent Company Name cleaning (using [102]) 
//     -> Result data: [102] ; unique ID: id_parent_firm_CORT_2
// (c) put 'gvkey' to [102] by 'develop_company'
{
	clear
	use "~\[102] Company_list of develop company name_gvkey exist.dta"
	drop develop_company id_dc
	rename develop_company_original develop_company
	rename id_dc_ori id_dc
	rename develop_company_2 upper_develop_company
	rename id_dc_2 id_dc_upper
	rename id_parent_firm_CORT_2 id_parent_firm_CORT_upper
	rename gvkey gvkey_parent
	drop id_parent_firm_CORT_N
		
	distinct id_dc_upper
*		     |        Observations
*                    |      total   distinct
*	-------------+----------------------
*	  d_dc_upper |       3536       2767

	distinct id_parent_firm_CORT_upper
*	          	           |        Observations
*				   |      total   distinct
*	---------------------------+----------------------
*	 id_parent_firm_CORT_upper |       3536       1262

	 
	distinct gvkey_parent

*	              |        Observations
*      		      |      total   distinct
*	--------------+----------------------
*	 gvkey_parent |       3536       1254

	gen child = subinstr( upper_develop_company, " ", "", .)
	gen parent = subinstr( upper_Parent, " ", "", .)
	gen child_4 = substr(child,1,4)
	gen parent_4 = substr(parent,1,4)
	gen same = 1 if parent_4 == child_4
	
	gen gvkey_dc = gvkey_parent if same == 1
	drop same
	save "~\[104] develop - parent (gvkey).dta"

	clear
	use "~\[104] develop - parent (gvkey).dta"
	keep if missing(gvkey_dc)
	keep id_dc_upper upper_develop_company
	duplicates drop
	save "~\[104_1] id_dc_upper upper_dc for fuzzy matching.dta"

	clear
	use "~\[104_1] id_dc_upper upper_dc for fuzzy matching.dta"
	matchit id_dc_upper upper_develop_company using "E:\ARK\Preprocessing_as of Dec 2023\2024-March\Compustat_gvkey_conm.dta" , idusing(gvkey) txtusing(conm_COMPUSTAT)
	
	save "~\[104_2] Result of id_dc_upper upper_dc for fuzzy matching.dta"

	clear
	use "~\[104_2] Result of id_dc_upper upper_dc for fuzzy matching.dta"
	keep if similscore == 1
	save "~\[104_2_matched] Result of id_dc_upper upper_dc for fuzzy matching.dta"
	
	clear
	use "~\[104_2] Result of id_dc_upper upper_dc for fuzzy matching.dta"
	gen matched = 0
	replace matched = 1 if similscore == 1
	gsort id_dc_upper -similscore
	by id_dc_upper: replace matched = matched[1]
	drop if matched == 1
	save "~\[104_2_UNmatched] Result of id_dc_upper upper_dc for fuzzy matching.dta"
	
	*[104_2_UNmatched] (same equals to 1) put gvkey to develop_company using fuzzy matching 
}

{
	clear
	use "~\[104] develop - parent (gvkey).dta"
	merge m:1 id_dc_upper using "~\[104_2_matched] Result of id_dc_upper upper_dc for fuzzy matching.dta", update replace

	replace gvkey_dc = 121742 if develop_company == "Genzyme Surgical Products"
	rename conm_COMPUSTAT conm_COMPUSTAT_dc
	order conm_COMPUSTAT_dc, a(gvkey_dc)
	save "~\[105] develop (gvkey) - parent (gvkey).dta"
}

============================================================================
============================================================================
=========================<What I have done so far>==========================
============================================================================
============================================================================
// Cortellis company ~ Compustat gvkey: [105] develop (gvkey) - parent (gvkey).dta

// Short Summary
// (Step 1) Retrieve a list of companies (develop_company) and its parent company having drug development history data
// (Step 2) Filter out companies not having information in Compustat 

// Detailed Summary
// (Step 1) Identify a list of 'develop_company' from Cortellis Drug (firms having information on drug development records)
// (Step 2) Put 'ParentCompanyName' to this data
//	    - Rationale: If a 'develop_company' is acquired by one 'ParantCompanyNanme' in year t, then the drug development history of 'develop_company' after year t can be regarded as that of 'ParentCompanyName'
// 	    - ==> Among unique 223,760 Parent companies, 14,447 Parent companies are matched with 'develop_company'
// (Step 3) Put 'gvkey' to 'ParentCompanyName'
// 	    - ==> Among 14,447 Parent companies, gvkey matched to 1282 (1261 after deleting duplicates) companies 
// (Step 4) Put 'gvkey' to 'develop_company' whose 'ParentCompanyName' has 'gvkey' 
//	    - ==> Among 2766 develop companies whose parent company has gvkey, gvkey matched to 1656 (59.87%) develop companies

============================================================================
============================================================================

// (Step 6) Find missing 'added_year' info
// By manually searching internet sources (wikipedia, corporate website, newspaper article, https://cdek.pharmacy.purdue.edu/org/, etc.), complement missing 'added_year' info.
// Priority: top 15 pharmaceutcial firms 

{
	clear
	use "~\[105] develop (gvkey) - parent (gvkey).dta"
	gen check = 1 if missing(year_announce) & missing(year_eventdate) & missing(year_subsidiary) & missing(year_liner)

*1. ABBVIE (Done)
{
	list develop_company id_dc_upper gvkey_dc upper_develop_company upper_Parent joint_venture if strpos(upper_Parent, "ABBVIE") & check == 1 & gvkey_dc != gvkey_parent
	* Firms that were subsidiaries of Allergan become a part of ABBVIE in year_liner == 2020 (year_subsidiary == 2021)
	
	foreach num of numlist 75 205 240 389 699 1007 1711 1855 2207 2607 2700 2701 371 651 996 1096 1237 1850 1854 2280 2651 1124 1569 2178 2575 1712 {
		replace year_liner = 2020 if id_dc_upper == `num'
		replace year_subsidiary = 2021 if id_dc_upper == `num'
	}
}

*2. AMGEN (Done)
{
	list develop_company id_dc_upper gvkey_dc upper_develop_company upper_Parent joint_venture if strpos(upper_Parent, "AMGEN") & check == 1 & gvkey_dc != gvkey_parent
	foreach num of numlist 617 1666 843 {
		replace year_liner = 2012 if id_dc_upper == `num'
		replace year_subsidiary = 2013 if id_dc_upper == `num'
}

	foreach num of numlist 1194 1271 1381 23 {
		replace year_liner = 2005 if id_dc_upper == `num'
		replace year_subsidiary = 2006 if id_dc_upper == `num'
}
	foreach num of numlist 2119 {
		replace year_liner = 2013 if id_dc_upper == `num'
		replace year_subsidiary = 2014 if id_dc_upper == `num'
}

	
}

*3. AstraZeneca (Done)
{
	list develop_company id_dc_upper gvkey_dc upper_develop_company upper_Parent joint_venture if strpos(upper_Parent, "ASTRAZENECA") & check == 1 & gvkey_dc != gvkey_parent
	
	foreach num of numlist 49 151 550 2053 2438 2454 2707 {
		replace year_liner = 2021 if id_dc_upper == `num'
		replace year_subsidiary = 2022 if id_dc_upper == `num'
}
	foreach num of numlist 180 222 {
		replace year_liner = 2013 if id_dc_upper == `num'
		replace year_subsidiary = 2014 if id_dc_upper == `num'
}
	foreach num of numlist 623 1623 {
		replace year_liner = 2007 if id_dc_upper == `num'
		replace year_subsidiary = 2008 if id_dc_upper == `num'
}
	foreach num of numlist 754 {
		replace year_liner = 2014 if id_dc_upper == `num'
		replace year_subsidiary = 2015 if id_dc_upper == `num'
}


}

*4. Bayer (Done)
*- Farmades SpA (id_dc_upper 1028) >> no meaningful result in internet; nor in Cortellis company 
*- Sun Pharmaceutical Industries Inc (id_dc_upper 2422) >> not a part of Bayer
{
	list develop_company id_dc_upper gvkey_dc upper_develop_company upper_Parent joint_venture year_subsidiary year_announce  year_liner if strpos(upper_Parent, "BAYER") & check == 1  & gvkey_dc != gvkey_parent
	
	foreach num of numlist 152 {
		replace year_liner = 2013 if id_dc_upper == `num'
		replace year_subsidiary = 2014 if id_dc_upper == `num'
}
	foreach num of numlist 535 1730 331 2447 {
		replace year_liner = 2020 if id_dc_upper == `num'
		replace year_subsidiary = 2021 if id_dc_upper == `num'
}
	foreach num of numlist 720 2282 868 1424 1587 1686 {
		replace year_liner = 2006 if id_dc_upper == `num'
		replace year_subsidiary = 2007 if id_dc_upper == `num'
}
	foreach num of numlist 874 {
		replace year_liner = 2008 if id_dc_upper == `num'
		replace year_subsidiary = 2009 if id_dc_upper == `num'
}
	foreach num of numlist 877 1704 {
		replace year_liner = 2018 if id_dc_upper == `num'
		replace year_subsidiary = 2019 if id_dc_upper == `num'
}
	foreach num of numlist 1446 {
		replace year_liner = 2022 if id_dc_upper == `num'
		replace year_subsidiary = 2023 if id_dc_upper == `num'
}	
	foreach num of numlist 1485 {
		replace year_liner = 2014 if id_dc_upper == `num'
		replace year_subsidiary = 2015 if id_dc_upper == `num'
}

}

*5. Bristol-Myers Squibb (Done)
*- Lorantis (id_dc_upper 1555) >> acquired by Celldex Therapeutics, which is not a part of Bristol-Myers Squibb
{
	list develop_company id_dc_upper gvkey_dc upper_develop_company upper_Parent joint_venture year_subsidiary year_announce  year_liner if strpos(upper_Parent, "SQUIBB") & check == 1  & gvkey_dc != gvkey_parent
	
	foreach num of numlist 29 613 2013 1142 384 2146 2168 957 1302 1434 30 2175 2349 46 210 547 636 2035 2337 2713 {
		replace year_liner = 2019 if id_dc_upper == `num'
		replace year_subsidiary = 2020 if id_dc_upper == `num'
}
	foreach num of numlist 1051 {
		replace year_liner = 2020 if id_dc_upper == `num'
		replace year_subsidiary = 2021 if id_dc_upper == `num'
}
	foreach num of numlist 1032 1333 2131 {
		replace year_liner = 2012 if id_dc_upper == `num'
		replace year_subsidiary = 2013 if id_dc_upper == `num'
}
	foreach num of numlist 1117 1616 1211 {
		replace year_liner = 2009 if id_dc_upper == `num'
		replace year_subsidiary = 2010 if id_dc_upper == `num'
}


}

*6. Eli Lilly (Done)
{
	list develop_company id_dc_upper gvkey_dc upper_develop_company upper_Parent joint_venture year_subsidiary year_announce  year_liner if strpos(upper_Parent, "LILLY") & check == 1  & gvkey_dc != gvkey_parent
	
	foreach num of numlist 445 {
		replace year_liner = 2011 if id_dc_upper == `num'
		replace year_subsidiary = 2011 if id_dc_upper == `num'
}
	foreach num of numlist 1239 1238 {
		replace year_liner = 2007 if id_dc_upper == `num'
		replace year_subsidiary = 2008 if id_dc_upper == `num'
}
	foreach num of numlist 1625 {
		replace year_liner = 2004 if id_dc_upper == `num'
		replace year_subsidiary = 2005 if id_dc_upper == `num'
}
	foreach num of numlist 2077 2617 {
		replace year_liner = 2020 if id_dc_upper == `num'
		replace year_subsidiary = 2021 if id_dc_upper == `num'
}

}

*7. Gilead Sciences (Done)
*- Supragen (id_dc_upper 2427) >> no meaningful result in internet; nor in Cortellis company 
{
	list develop_company id_dc_upper gvkey_dc upper_develop_company upper_Parent joint_venture year_subsidiary year_announce  year_liner if strpos(upper_Parent, "GILEAD") & check == 1  & gvkey_dc != gvkey_parent
	
	foreach num of numlist 2561 378 {
		replace year_liner = 2003 if id_dc_upper == `num'
		replace year_subsidiary = 2004 if id_dc_upper == `num'
}

	foreach num of numlist 758 {
		replace year_liner = 2006 if id_dc_upper == `num'
		replace year_subsidiary = 2007 if id_dc_upper == `num'
}
	foreach num of numlist 658 315 {
		replace year_liner = 2010 if id_dc_upper == `num'
		replace year_subsidiary = 2011 if id_dc_upper == `num'
}
	foreach num of numlist 555 2007 {
		replace year_liner = 2011 if id_dc_upper == `num'
		replace year_subsidiary = 2012 if id_dc_upper == `num'
}
	foreach num of numlist 981 {
		replace year_liner = 2015 if id_dc_upper == `num'
		replace year_subsidiary = 2016 if id_dc_upper == `num'
}
	foreach num of numlist 1471 {
		replace year_liner = 2017 if id_dc_upper == `num'
		replace year_subsidiary = 2018 if id_dc_upper == `num'
}
	foreach num of numlist 1293 {
		replace year_liner = 2020 if id_dc_upper == `num'
		replace year_subsidiary = 2021 if id_dc_upper == `num'
}
	foreach num of numlist 845 {
		replace year_liner = 2013 if id_dc_upper == `num'
		replace year_subsidiary = 2015 if id_dc_upper == `num'
}

}

*8. GlaxoSmithKline; GSK (Done)
*- Dr Lo Zambeletti SpA (id_dc_upper 886) 
*- Instituto Luso Farmaco SA [Portugal] (id_dc_upper 1362)
*- ISF Societa Per Azioni (id_dc_upper 1399)
*- Laboratorios Morrith SA (id_dc_upper 1504)
*>> no meaningful result in internet; nor in Cortellis company

*- Japan Vaccine Co Ltd (id_dc_upper 1417) 
*- Shionogi-ViiV Healthcare LLC (id_dc_upper 2338)
*- Sino-American Tianjin Smith Kline & French Laboratories Ltd (id_dc_upper 2357)
*- ViiV Healthcare Ltd (id_dc_upper 2656)
*>> joint venture
{

	list develop_company id_dc_upper gvkey_dc upper_develop_company upper_Parent joint_venture year_subsidiary year_announce  year_liner if strpos(upper_Parent, "GSK") & check == 1  & gvkey_dc != gvkey_parent
	
	foreach num of numlist 1135 2704  {
		replace year_liner = 1995 if id_dc_upper == `num'
		replace year_subsidiary = 1996 if id_dc_upper == `num'
}

	foreach num of numlist 515  {
		replace year_liner = 2001 if id_dc_upper == `num'
		replace year_subsidiary = 2002 if id_dc_upper == `num'
}
	foreach num of numlist 630  {
		replace year_liner = 2011 if id_dc_upper == `num'
		replace year_subsidiary = 2012 if id_dc_upper == `num'
}
	foreach num of numlist 1147  {
		replace year_liner = 2015 if id_dc_upper == `num'
		replace year_subsidiary = 2016 if id_dc_upper == `num'
}
	foreach num of numlist 1214  {
		replace year_liner = 2013 if id_dc_upper == `num'
		replace year_subsidiary = 2014 if id_dc_upper == `num'
}
	foreach num of numlist 2347  {
		replace year_liner = 2022 if id_dc_upper == `num'
		replace year_subsidiary = 2023 if id_dc_upper == `num'
}
	foreach num of numlist 2364 2497 {
	replace year_liner = 2019 if id_dc_upper == `num'
	replace year_subsidiary = 2020 if id_dc_upper == `num'
}
	foreach num of numlist 242 749 764 1119 1242 1373 2224 2340 {
	replace year_liner = 2005 if id_dc_upper == `num'
	replace year_subsidiary = 2006 if id_dc_upper == `num'
}
	foreach num of numlist 425 {
	replace year_liner = 2000 if id_dc_upper == `num'
	replace year_subsidiary = 2001 if id_dc_upper == `num'
}
	foreach num of numlist 882 2060 {
	replace year_liner = 2006 if id_dc_upper == `num'
	replace year_subsidiary = 2007 if id_dc_upper == `num'
}
	foreach num of numlist 1099 2363 {
		replace year_liner = 2008 if id_dc_upper == `num'
		replace year_subsidiary = 2009 if id_dc_upper == `num'
}
	foreach num of numlist 1728 {
		replace year_liner = 2010 if id_dc_upper == `num'
		replace year_subsidiary = 2011 if id_dc_upper == `num'
}
	foreach num of numlist 2184  {
		replace year_liner = 2013 if id_dc_upper == `num'
		replace year_subsidiary = 2014 if id_dc_upper == `num'
}
	foreach num of numlist 2185  {
		replace year_liner = 2007 if id_dc_upper == `num'
		replace year_subsidiary = 2008 if id_dc_upper == `num'
}

}

*9. Johnson & Johnson (Done)
*- Immunobiology Research Institute Inc (id_dc_upper 1288) >> no meaningful result in internet; nor in Cortellis company 
*- Xian-Janssen Pharmaceutical Ltd (id_dc_upper 2773) >> joint venture
{
	list develop_company id_dc_upper gvkey_dc upper_develop_company upper_Parent joint_venture year_subsidiary year_announce  year_liner if strpos(upper_Parent, "JOHNSON") & check == 1  & gvkey_dc != gvkey_parent
	
	foreach num of numlist 395 645 {
		replace year_liner = 2017 if id_dc_upper == `num'
		replace year_subsidiary = 2018 if id_dc_upper == `num'
}
	foreach num of numlist 784 1156 2219 {
		replace year_liner = 2011 if id_dc_upper == `num'
		replace year_subsidiary = 2012 if id_dc_upper == `num'
}
	foreach num of numlist 1544 {
		replace year_liner = 2013 if id_dc_upper == `num'
		replace year_subsidiary = 2014 if id_dc_upper == `num'
}
	foreach num of numlist 1804 2291 {
		replace year_liner = 2003 if id_dc_upper == `num'
		replace year_subsidiary = 2006 if id_dc_upper == `num'
}
	foreach num of numlist 1926 {
		replace year_liner = 2003 if id_dc_upper == `num'
		replace year_subsidiary = 2006 if id_dc_upper == `num'
}
	foreach num of numlist 2248 2317 199 {
		replace year_liner = 2001 if id_dc_upper == `num'
		replace year_subsidiary = 2002 if id_dc_upper == `num'
}
	foreach num of numlist 2730 {
		replace year_liner = 2015 if id_dc_upper == `num'
		replace year_subsidiary = 2016 if id_dc_upper == `num'
}


	
}

*10. Merck (Done)
{
	list develop_company id_dc_upper gvkey_dc upper_develop_company upper_Parent joint_venture year_subsidiary year_announce  year_liner if strpos(upper_Parent, "MERCK") & check == 1  & gvkey_dc != gvkey_parent
	
	foreach num of numlist 2512 {
		replace year_liner = 2020 if id_dc_upper == `num'
		replace year_subsidiary = 2021 if id_dc_upper == `num'
}

}

*11. Novartis (Done)
*- LPB Istituto Farmaceutico SpA (id_dc_upper 1561) >> no meaningful result in internet; nor in Cortellis company 
{
	list develop_company id_dc_upper gvkey_dc upper_develop_company upper_Parent joint_venture year_subsidiary year_announce  year_liner if strpos(upper_Parent, "NOVARTIS") & check == 1  & gvkey_dc != gvkey_parent
	
	foreach num of numlist 16 494 {
		replace year_liner = 2017 if id_dc_upper == `num'
		replace year_subsidiary = 2018 if id_dc_upper == `num'
}
	foreach num of numlist 253 2510 1316 2088 2477 {
		replace year_liner = 2019 if id_dc_upper == `num'
		replace year_subsidiary = 2020 if id_dc_upper == `num'
}
	foreach num of numlist 655 677 1008 1599 1777 1967 {
		replace year_liner = 2006 if id_dc_upper == `num'
		replace year_subsidiary = 2007 if id_dc_upper == `num'
}
	foreach num of numlist 991 1919 {
		replace year_liner = 2010 if id_dc_upper == `num'
		replace year_subsidiary = 2011 if id_dc_upper == `num'
}
	foreach num of numlist 1062 2005 {
		replace year_liner = 2012 if id_dc_upper == `num'
		replace year_subsidiary = 2013 if id_dc_upper == `num'
}
	foreach num of numlist 1067 1109 1309 2761 {
		replace year_liner = 1996 if id_dc_upper == `num'
		replace year_subsidiary = 1997 if id_dc_upper == `num'
}
	foreach num of numlist 1328 2122 {
		replace year_liner = 2008 if id_dc_upper == `num'
		replace year_subsidiary = 2009 if id_dc_upper == `num'
}
	foreach num of numlist 1526 {
		replace year_liner = 2002 if id_dc_upper == `num'
		replace year_subsidiary = 2003 if id_dc_upper == `num'
}
	foreach num of numlist 2198 {
		replace year_liner = 2016 if id_dc_upper == `num'
		replace year_subsidiary = 2017 if id_dc_upper == `num'
}
	foreach num of numlist 2457 {
		replace year_liner = 1997 if id_dc_upper == `num'
		replace year_subsidiary = 1998 if id_dc_upper == `num'
}


	
}

*12. Pfizer (Done)
*- Institut de Recherche Jouveinal SA (IRJ) (id_dc_upper 1361)
*- Leo AB (id_dc_upper 1529)
*- Prodotti Formenti Srl (id_dc_upper 2087)
*>> no meaningful result in internet; nor in Cortellis company
{
	list develop_company id_dc_upper gvkey_dc upper_develop_company upper_Parent joint_venture year_subsidiary year_announce  year_liner if strpos(upper_Parent, "PFIZER") & check == 1  & gvkey_dc != gvkey_parent
	replace year_liner = 2009 if id_dc_upper == 15
	
	foreach num of numlist 88 1999 {
		replace year_liner = 2003 if id_dc_upper == `num'
		replace year_subsidiary = 2004 if id_dc_upper == `num'
}
	foreach num of numlist 139 124 2698 1150 {
		replace year_liner = 2000 if id_dc_upper == `num'
		replace year_subsidiary = 2001 if id_dc_upper == `num'
}
	foreach num of numlist 269 2712 2288 {
		replace year_liner = 2009 if id_dc_upper == `num'
		replace year_subsidiary = 2010 if id_dc_upper == `num'
}
	foreach num of numlist 485 2652 2155 {
		replace year_liner = 2005 if id_dc_upper == `num'
		replace year_subsidiary = 2006 if id_dc_upper == `num'
}
	foreach num of numlist 770 {
		replace year_liner = 2007 if id_dc_upper == `num'
		replace year_subsidiary = 2008 if id_dc_upper == `num'
}
	foreach num of numlist 988 1187 1436 2028 {
		replace year_liner = 2002 if id_dc_upper == `num'
		replace year_subsidiary = 2004 if id_dc_upper == `num'
}
	foreach num of numlist 1087 1999  {
		replace year_liner = 2003 if id_dc_upper == `num'
		replace year_subsidiary = 2004 if id_dc_upper == `num'
}
	foreach num of numlist 1148 2514  {
		replace year_liner = 2019 if id_dc_upper == `num'
		replace year_subsidiary = 2020 if id_dc_upper == `num'
}
	foreach num of numlist 1400 181 1464  {
		replace year_liner = 2011 if id_dc_upper == `num'
		replace year_subsidiary = 2012 if id_dc_upper == `num'
}


	
}

*13. Roche (Done)
{
	list develop_company id_dc_upper gvkey_dc upper_develop_company upper_Parent joint_venture year_subsidiary year_announce  year_liner if strpos(upper_Parent, "ROCHE") & check == 1  & gvkey_dc != gvkey_parent
	
	foreach num of numlist 234 {
		replace year_liner = 2011 if id_dc_upper == `num'
		replace year_subsidiary = 2012 if id_dc_upper == `num'
}
	foreach num of numlist 502 {
		replace year_liner = 2007 if id_dc_upper == `num'
		replace year_subsidiary = 2008 if id_dc_upper == `num'
}
	foreach num of numlist 682 683 {
		replace year_liner = 2002 if id_dc_upper == `num'
		replace year_subsidiary = 2003 if id_dc_upper == `num'
}
	foreach num of numlist 798 2319 {
		replace year_liner = 2014 if id_dc_upper == `num'
		replace year_subsidiary = 2015 if id_dc_upper == `num'
}
	foreach num of numlist 1056 {
		replace year_liner = 2017 if id_dc_upper == `num'
		replace year_subsidiary = 2018 if id_dc_upper == `num'
}
	foreach num of numlist 1094 2389  {
		replace year_liner = 2019 if id_dc_upper == `num'
		replace year_subsidiary = 2020 if id_dc_upper == `num'
}
	foreach num of numlist 1104 2471 {
		replace year_liner = 2009 if id_dc_upper == `num'
		replace year_subsidiary = 2010 if id_dc_upper == `num'
}
	foreach num of numlist 1422 {
		replace year_liner = 2018 if id_dc_upper == `num'
		replace year_subsidiary = 2019 if id_dc_upper == `num'
}
	foreach num of numlist 2270 {
		replace year_liner = 1958 if id_dc_upper == `num'
		replace year_subsidiary = 1959 if id_dc_upper == `num'
}



}

*14. Sanofi (Done)
*- Allegro Biologics Inc (id_dc_upper 164)
*- Auspharm Institute for Mucosal Immunology (AIMI) (id_dc_upper 363)
*- Bottu SA (id_dc_upper 530)
*- Laboratoires Houde SA (id_dc_upper 1499)
*- VaxServe Inc (id_dc_upper 2624)
*>> no meaningful result in internet; nor in Cortellis company

*- Sanofi Pharma Bristol-Myers Squibb SNC (id_dc_upper 2264)
*>> joint venture  
{
	list develop_company id_dc_upper gvkey_dc upper_develop_company upper_Parent joint_venture year_subsidiary year_announce  year_liner if strpos(upper_Parent, "SANOFI") & check == 1  & gvkey_dc != gvkey_parent
	
	foreach num of numlist 1556 {
		replace year_liner = 2002 if id_dc_upper == `num'
		replace year_subsidiary = 2003 if id_dc_upper == `num'
}

	*Genzyme
	foreach num of numlist 255 1127 448 459 526 862 1047 1091 1813 2261 1308 2423 2727 {
		replace year_liner = 2011 if id_dc_upper == `num'
		replace year_subsidiary = 2011 if id_dc_upper == `num'
}

	*Rhone-Poulenc Rorer / Aventis 
	foreach num of numlist 272 309 419 599 637 735 1041 1500 1669 1737 2305 2386 2674 {
		replace year_liner = 2004 if id_dc_upper == `num'
		replace year_subsidiary = 2005 if id_dc_upper == `num'
}
	
	foreach num of numlist 453 501 {
		replace year_liner = 2018 if id_dc_upper == `num'
		replace year_subsidiary = 2019 if id_dc_upper == `num'
}
	foreach num of numlist 520 2478 {
		replace year_liner = 2010 if id_dc_upper == `num'
		replace year_subsidiary = 2011 if id_dc_upper == `num'
}
	foreach num of numlist 522 {
		replace year_liner = 1996 if id_dc_upper == `num'
		replace year_subsidiary = 1997 if id_dc_upper == `num'
}
	foreach num of numlist 679 {
		replace year_liner = 1983 if id_dc_upper == `num'
		replace year_subsidiary = 1984 if id_dc_upper == `num'
}
	foreach num of numlist 828 1459 1779 {
		replace year_liner = 2020 if id_dc_upper == `num'
		replace year_subsidiary = 2021 if id_dc_upper == `num'
}
	foreach num of numlist 1064 2331 2332 {
		replace year_liner = 2009 if id_dc_upper == `num'
		replace year_subsidiary = 2010 if id_dc_upper == `num'
}

	*Synthelabo 
	foreach num of numlist 2449 1383 2450 1498 {
		replace year_liner = 1999 if id_dc_upper == `num'
		replace year_subsidiary = 2000 if id_dc_upper == `num'
}

	*Sterling-Winthrop
	foreach num of numlist 1580 2409 {
		replace year_liner = 1994 if id_dc_upper == `num'
		replace year_subsidiary = 1995 if id_dc_upper == `num'
}
	foreach num of numlist 2024 1437 {
		replace year_liner = 2021 if id_dc_upper == `num'
		replace year_subsidiary = 2022 if id_dc_upper == `num'
}


}

*15. Teva
*- QDose Ltd (id_dc_upper 2142)
*- Teva-Handok (id_dc_upper 2503)
*>> joint ventures
{
	list develop_company id_dc_upper gvkey_dc upper_develop_company upper_Parent joint_venture year_subsidiary year_announce  year_liner if strpos(upper_Parent, "TEVA") & check == 1  & gvkey_dc != gvkey_parent
	
	*Cephalon
	foreach num of numlist 244 644 289 439 646 668 689 1012 1092 1497 1980 2098 2256 2750 {
		replace year_liner = 2011 if id_dc_upper == `num'
		replace year_subsidiary = 2012 if id_dc_upper == `num'
}
	*SICOR
	foreach num of numlist 2344 288 1527 {
		replace year_liner = 2003 if id_dc_upper == `num'
		replace year_subsidiary = 2004 if id_dc_upper == `num'
}
	foreach num of numlist 362 {
		replace year_liner = 2015 if id_dc_upper == `num'
		replace year_subsidiary = 2016 if id_dc_upper == `num'
}
	foreach num of numlist 429 711 2037 406 {
		replace year_liner = 2008 if id_dc_upper == `num'
		replace year_subsidiary = 2009 if id_dc_upper == `num'
}
	foreach num of numlist 451 {
		replace year_liner = 1995 if id_dc_upper == `num'
		replace year_subsidiary = 1996 if id_dc_upper == `num'
}
	foreach num of numlist 454 2162 {
		replace year_liner = 2010 if id_dc_upper == `num'
		replace year_subsidiary = 2018 if id_dc_upper == `num'
}
	foreach num of numlist 786 1663 {
		replace year_liner = 2013 if id_dc_upper == `num'
		replace year_subsidiary = 2014 if id_dc_upper == `num'
}
	foreach num of numlist 1086 {
		replace year_liner = 1985 if id_dc_upper == `num'
		replace year_subsidiary = 1986 if id_dc_upper == `num'
}
	foreach num of numlist 1212 {
		replace year_liner = 2005 if id_dc_upper == `num'
		replace year_subsidiary = 2006 if id_dc_upper == `num'
}
	foreach num of numlist 1408 {
		replace year_liner = 2006 if id_dc_upper == `num'
		replace year_subsidiary = 2007 if id_dc_upper == `num'
}
	foreach num of numlist 1506 1829 {
		replace year_liner = 2014 if id_dc_upper == `num'
		replace year_subsidiary = 2015 if id_dc_upper == `num'
}
	foreach num of numlist 2464 {
		replace year_liner = 2011 if id_dc_upper == `num'
		replace year_subsidiary = 2012 if id_dc_upper == `num'
}

}

}

/// In addition to the top 15 pharma, manually search the missing 'added_year' info. for other remaining pharma firms.

{
	clear
	use "~\[105] develop (gvkey) - parent (gvkey).dta"
	*parent company name starting from number and letter A
	{
	*3M
	replace year_liner = 2019 if id_dc_upper == 775
	replace year_subsidiary = 2020 if id_dc_upper == 775

	*ABBOTT
	replace year_liner = 2001 if id_dc_upper == 408
	replace year_subsidiary = 2002 if id_dc_upper == 408
	replace year_liner = 2014 if id_dc_upper == 1846
	replace year_subsidiary = 2015 if id_dc_upper == 1846

	*(name changed) CHEMEX -> ACCESS PHARMA -> ABEONA THERAPEUTICS INC
	replace gvkey_dc = gvkey_parent if id_dc_upper == 667
	
	*ACCENTIA
	replace year_liner = 2010 if id_dc_upper == 503
	replace year_subsidiary = 2011 if id_dc_upper == 503

	*ACER THERAPEUTICS
	replace year_liner = 2017 if id_dc_upper == 1896
	replace year_subsidiary = 2018 if id_dc_upper == 1896

	*ACERAGEN
	replace year_liner = 2021 if id_dc_upper == 316
	replace year_subsidiary = 2022 if id_dc_upper == 316
	
	*ACORDA THERAPEUTICS INC
	foreach num of numlist 8 924 583 {
		replace year_liner = 2016 if id_dc_upper == `num'
		replace year_subsidiary = 2017 if id_dc_upper == `num'
	}
	
	*ADVANZ PHARMA
	replace gvkey_dc = gvkey_parent  if id_dc_upper == 732
	foreach num of numlist 208 1639 769 {
		replace year_liner = 2015 if id_dc_upper == `num'
		replace year_subsidiary = 2016 if id_dc_upper == `num'
	}
	foreach num of numlist 325 753 1958 {
		replace year_liner = 2020 if id_dc_upper == `num'
		replace year_subsidiary = 2021 if id_dc_upper == `num'
	}
	replace year_liner = 2013 if id_dc_upper == 2030
	replace year_subsidiary = 2014 if id_dc_upper == 2030

	*AERIE PHARMACEUTICALS
	replace year_liner = 2019 if id_dc_upper == 388
	replace year_subsidiary = 2020 if id_dc_upper == 388

	*AFFIMED (Amphivena Therapeutics Inc was a subsidiary of AMPHIVENA from 2013 according to the internet source. In Cortellis, Amphivena drug development history appeared from year 2015. Thus, change Amphivena's gvkey same as Affimed)
	replace gvkey_dc = gvkey_parent if id_dc_upper == 220

	*AGENNIX
	foreach num of numlist 397 1152 {
		replace year_liner = 2009 if id_dc_upper == `num'
		replace year_subsidiary = 2010 if id_dc_upper == `num'
	}

	*AGENUS
	replace gvkey_dc = gvkey_parent if id_dc_upper == 1679
	replace year_liner = 2004 if id_dc_upper == 1692
	replace year_subsidiary = 2005 if id_dc_upper == 1692
	
	foreach num of numlist 1877 2570 {
		replace year_liner = 2001 if id_dc_upper == `num'
		replace year_subsidiary = 2002 if id_dc_upper == `num'
	}
	foreach num of numlist 285 2610 {
		replace year_liner = 2000 if id_dc_upper == `num'
		replace year_subsidiary = 2001 if id_dc_upper == `num'
	}

	*AGILENT TECHNOLOGIES INC
	replace year_liner = 2018 if id_dc_upper == 39
	replace year_subsidiary = 2019 if id_dc_upper == 39
	
	*AIM IMMUNOTECH
	replace year_liner = 2004 if id_dc_upper == 1375
	replace year_subsidiary = 2005 if id_dc_upper == 1375
	
	*AKELA
	foreach num of numlist 1048 2325 {
		replace year_liner = 2003 if id_dc_upper == `num'
		replace year_subsidiary = 2004 if id_dc_upper == `num'
	}
	
	*AKZO NOBEL
	replace year_liner = 2008 if id_dc_upper == 1305
	replace year_subsidiary = 2009 if id_dc_upper == 1305
	replace year_liner = 1999 if id_dc_upper == 1447
	replace year_subsidiary = 2000 if id_dc_upper == 1447
	replace gvkey_dc = gvkey_parent if id_dc_upper == 1803

	*ALBANY MOLECULAR RESEARCH INC
	replace year_liner = 2016 if id_dc_upper == 2044
	replace year_subsidiary = 2017 if id_dc_upper == 2044

	*ALBERMARLE
	replace year_liner = 2004 if id_dc_upper == 2461
	replace year_subsidiary = 2005 if id_dc_upper == 2461

	*ALCON
	replace gvkey_dc = gvkey_parent if id_dc_upper == 145
	
	*ALEAFIA
	replace year_liner = 2018 if id_dc_upper == 935
	replace year_subsidiary = 2019 if id_dc_upper == 935

	*ALLARITY THERAPEUTICS
	replace gvkey_dc = gvkey_parent if id_dc_upper == 1935
	
	*ALLIANCE MEDICAL GROUP
	replace year_liner = 2018 if id_dc_upper == 2032
	replace year_subsidiary = 2019 if id_dc_upper == 2032
	
	*ALLIANCE PHARMA
	foreach num of numlist 91 2355 1397 2108 2110 {
		replace year_liner = 2015 if id_dc_upper == `num'
		replace year_subsidiary = 2016 if id_dc_upper == `num'
	}
	replace year_liner = 2010 if id_dc_upper == 565
	replace year_subsidiary = 2011 if id_dc_upper == 565

	*ALTAMIRA THERAPEUTICS LTD
	replace gvkey_dc = gvkey_parent if id_dc_upper == 2756

	*ALTIMMUNE
	replace year_liner = 2015 if id_dc_upper == 1278
	replace year_subsidiary = 2016 if id_dc_upper == 1278
	replace year_liner = 2017 if id_dc_upper == 2009
	replace year_subsidiary = 2018 if id_dc_upper == 2009
	replace year_liner = 2019 if id_dc_upper == 2397
	
	*AMAG PHARMACEUTICALS
	replace year_liner = 2014 if id_dc_upper == 2513
	replace year_subsidiary = 2015 if id_dc_upper == 2513
	
	*AMARANTUS (https://www.americanpharmaceuticalreview.com/1315-News/336531-Amarantus-Forms-Subsidiaries-Elto-Pharma-to-Focus-on-CNS-Disorders-and-MANF-Therapeutics-to-Focus-on-Ophthalmology/)
	replace gvkey_dc = gvkey_parent if id_dc_upper == 934
	replace gvkey_dc = gvkey_parent if id_dc_upper == 1585

	*AMBRILIA
	foreach num of numlist 507 2002 {
		replace year_liner = 2006 if id_dc_upper == `num'
		replace year_subsidiary = 2007 if id_dc_upper == `num'
	}

	*ANI PHARMACEUTICALS
	replace year_liner = 2006 if id_dc_upper == 507
	replace year_subsidiary = 2007 if id_dc_upper == 507
	foreach num of numlist 563 616 1173 2382 {
		replace year_liner = 2012 if id_dc_upper == `num'
		replace year_subsidiary = 2013 if id_dc_upper == `num'
	}

	*ANTHERA
	replace gvkey_dc = gvkey_parent if id_dc_upper == 160
	
	*APHTON
	replace year_liner = 2005 if id_dc_upper == 1253
	replace year_subsidiary = 2006 if id_dc_upper == 1253
	
	*APPLIED DNA
	replace gvkey_dc = gvkey_parent if id_dc_upper == 1543
	
	*APPLIED NEUROSOLUTIONS INC
	replace year_liner = 2001 if id_dc_upper == 1897
	replace year_subsidiary = 2002 if id_dc_upper == 1897
	
	*ARBUTUS
	replace year_liner = 2006 if id_dc_upper == 1322
	replace year_subsidiary = 2007 if id_dc_upper == 1322
	
	*ARCA BIOPHARMA
	foreach num of numlist 1224 1840 {
		replace year_liner = 2008 if id_dc_upper == `num'
		replace year_subsidiary = 2009 if id_dc_upper == `num'
	}

	*ARCTURUS THERAPEUTICS
	replace year_liner = 2017 if id_dc_upper == 144
	replace year_subsidiary = 2018 if id_dc_upper == 144
	
	*ARCUS BIOSCIENCES INC
	replace gvkey_dc = gvkey_parent if id_dc_upper == 1942

	*ARMATA
	foreach num of numlist 544 2218 {
		replace year_liner = 2019 if id_dc_upper == `num'
		replace year_subsidiary = 2020 if id_dc_upper == `num'
	}

	*ARROWHEAD
	replace year_liner = 2007 if id_dc_upper == 1732
	replace year_subsidiary = 2008 if id_dc_upper == 1732
	
	*ARTIVION
	replace gvkey_dc = gvkey_parent if id_dc_upper == 358
	
	*ASSERTIO
	replace gvkey_dc = gvkey_parent if id_dc_upper == 850
	
	*ATAI LIFE SCIENCES AG
	replace year_liner = 2018 if id_dc_upper == 727
	replace year_subsidiary = 2019 if id_dc_upper == 727
	
	*AUXLY CANNABIS GROUP INC
	replace year_liner = 2018 if id_dc_upper == 883
	replace year_subsidiary = 2019 if id_dc_upper == 883
	
	*AVADEL
	replace year_liner = 2012 if id_dc_upper == 906
	replace year_subsidiary = 2013 if id_dc_upper == 906
	replace year_liner = 2016 if id_dc_upper == 1068
	replace year_subsidiary = 2017 if id_dc_upper == 1068
	
	*AVIRAGEN
	replace year_liner = 2015 if id_dc_upper == 232
	replace year_subsidiary = 2016 if id_dc_upper == 232
	replace year_liner = 2009 if id_dc_upper == 2095
	replace year_subsidiary = 2010 if id_dc_upper == 2095
	
	*AXIM 
	replace year_liner = 2020 if id_dc_upper == 2271
	replace year_subsidiary = 2021 if id_dc_upper == 2271

	*AYTU
	replace year_liner = 2015 if id_dc_upper == 2694
	replace year_subsidiary = 2016 if id_dc_upper == 2694
}
	*parent company name starting from letter B
{
	*BASF
	replace year_liner = 2012 if id_dc_upper == 2102
	replace year_subsidiary = 2013 if id_dc_upper == 2102

	*BAUSCH HEALTH
	replace gvkey_dc = gvkey_parent if id_dc_upper == 2611
	foreach num of numlist 122 855 {
		replace year_liner = 2011 if id_dc_upper == `num'
		replace year_subsidiary = 2012 if id_dc_upper == `num'
	}

	foreach num of numlist 742 1336 2255 {
		replace year_liner = 2015 if id_dc_upper == `num'
		replace year_subsidiary = 2016 if id_dc_upper == `num'
	}
	
	foreach num of numlist 1153 1621 {
		replace year_liner = 2012 if id_dc_upper == `num'
		replace year_subsidiary = 2013 if id_dc_upper == `num'
	}
	replace year_liner = 2003 if id_dc_upper == 2223
	replace year_subsidiary = 2004 if id_dc_upper == 2223

	foreach num of numlist 1038 2412  {
		replace year_liner = 2013 if id_dc_upper == `num'
		replace year_subsidiary = 2014 if id_dc_upper == `num'
	}
	replace year_liner = 2005 if id_dc_upper == 2719
	replace year_subsidiary = 2006 if id_dc_upper == 2719

	*BAXTER
	replace year_liner = 2011 if id_dc_upper == 2082
	replace year_subsidiary = 2012 if id_dc_upper == 2082
	
	*BECTON, DICKINSON AND CO
	replace year_liner = 1998 if id_dc_upper == 521
	replace year_subsidiary = 1999 if id_dc_upper == 521
	
	*BELLUS HEALTH
	foreach num of numlist 580 908  {
		replace year_liner = 2013 if id_dc_upper == `num'
		replace year_subsidiary = 2014 if id_dc_upper == `num'
	}
	
	*BENDA
	replace year_liner = 2007 if id_dc_upper == 2335
	replace year_subsidiary = 2008 if id_dc_upper == 2335
	
	*BETTERLIFE
	foreach num of numlist 275 1321  {
		replace year_liner = 2015 if id_dc_upper == `num'
		replace year_subsidiary = 2016 if id_dc_upper == `num'
	}
	replace gvkey_dc = gvkey_parent if id_dc_upper == 514
	
	*BEYONDSPRING
	replace year_liner = 2015 if id_dc_upper == 835
	replace year_subsidiary = 2016 if id_dc_upper == 835
	
	*BIOFRONTERA
	replace year_liner = 2019 if id_dc_upper == 802
	replace year_subsidiary = 2020 if id_dc_upper == 802
	
	*BIOGEN
	replace gvkey_dc = gvkey_patent if id_dc_upper == 1744
	
	*BIOHAVEN
	replace year_liner = 2021 if id_dc_upper == 1472
	replace year_subsidiary = 2022 if id_dc_upper == 1472
	
	*BIOVIE
	replace year_liner = 2016 if id_dc_upper == 1516
	replace year_subsidiary = 2017 if id_dc_upper == 1516
	
	*BLUEBIRD BIO INC
	replace gvkey_dc = gvkey_patent if id_dc_upper == 5
	replace year_liner = 2014 if id_dc_upper == 2070
	replace year_subsidiary = 2015 if id_dc_upper == 2070
	
	*BOSTON SCIENTIFIC
	foreach num of numlist 442 540 626 944 2124 971 {
		replace year_liner = 2019 if id_dc_upper == `num'
		replace year_subsidiary = 2020 if id_dc_upper == `num'
	}

	*BOSTON THERAPEUTICS
	replace year_liner = 2018 if id_dc_upper == 797
	replace year_subsidiary = 2019 if id_dc_upper == 797
	
	*BRIDGEBIO
	replace year_liner = 2020 if id_dc_upper == 575
	replace year_subsidiary = 2021 if id_dc_upper == 575
}
	*parent company name starting from letter C
{
	*CAPSTONE
	replace year_liner = 2008 if id_dc_upper == 400
	replace year_subsidiary = 2009 if id_dc_upper == 400
	replace year_liner = 2004 if id_dc_upper == 680
	replace year_subsidiary = 2005 if id_dc_upper == 680

	*CATALYST
	replace year_liner = 2015 if id_dc_upper == 2476
	replace year_subsidiary = 2016 if id_dc_upper == 2476

	*CEL-SCI
	replace gvkey_dc = gvkey_parent if id_dc_upper == 1606
	
	*CELLDEX
	replace year_liner = 1998 if id_dc_upper == 2678
	replace year_subsidiary = 1999 if id_dc_upper == 2678
	
	*CELYAD
	replace year_liner = 2015 if id_dc_upper == 1891
	replace year_subsidiary = 2016 if id_dc_upper == 1891
	
	*CENTREXION
	replace year_liner = 2013 if id_dc_upper == 2616
	replace year_subsidiary = 2014 if id_dc_upper == 2616
	
	*CHARLES RIVER
	foreach num of numlist 450 564 449 300 1003 1354 {
		replace year_liner = 2014 if id_dc_upper == `num'
		replace year_subsidiary = 2015 if id_dc_upper == `num'
	}
	
	*CHINA BIOLOGIC PRODUCTS HOLDINGS
	replace year_liner = 2016 if id_dc_upper == 1168
	replace year_subsidiary = 2017 if id_dc_upper == 1168
	
	*CHINOOK
	foreach num of numlist 89 2572  {
		replace year_liner = 2020 if id_dc_upper == `num'
		replace year_subsidiary = 2021 if id_dc_upper == `num'
	}
	
	*CHRYSALIS
	replace year_liner = 1996 if id_dc_upper == 881
	replace year_subsidiary = 1997 if id_dc_upper == 881
	
	*CLOVIS ONCOLOGY INC
	replace year_liner = 2013 if id_dc_upper == 1000
	replace year_subsidiary = 2014 if id_dc_upper == 1000
	
	*CORBUS
	replace year_liner = 2014 if id_dc_upper == 1421
	replace year_subsidiary = 2015 if id_dc_upper == 1421
	
	*COTINGA
	replace year_liner = 2008 if id_dc_upper == 840
	replace year_subsidiary = 2009 if id_dc_upper == 840
	
	*CTI BIOPHARMA CORP
	replace gvkey_dc = gvkey_parent if id_dc_upper == 101 
	replace year_liner = 2004 if id_dc_upper == 1821
	replace year_subsidiary = 2005 if id_dc_upper == 1821
	replace year_liner = 2000 if id_dc_upper == 2043
	replace year_subsidiary = 2001 if id_dc_upper == 2043
	replace year_liner = 2007 if id_dc_upper == 2458
	replace year_subsidiary = 2008 if id_dc_upper == 2458
	
	*CULLINAN ONCOLOGY
	foreach num of numlist 1410 1782 1895 2543 {
		replace gvkey_dc = gvkey_parent if id_dc_upper == `num' 
	}
	
	*CYBIN
	replace year_liner = 2020 if id_dc_upper == 74 
	replace year_subsidiary = 2021 if id_dc_upper == 74 

	*CYTRX
	replace gvkey_dc = gvkey_parent if id_dc_upper == 642 
	replace year_liner = 2008 if id_dc_upper == 1349 
	replace year_subsidiary = 2009 if id_dc_upper == 1349 
}
	*parent company name starting from letter D
{
	*DARE BIOSCIENCE
	replace year_liner = 2019 if id_dc_upper == 1662
	replace year_subsidiary = 2020 if id_dc_upper == 1662
	replace year_liner = 2018 if id_dc_upper == 1972
	replace year_subsidiary = 2019 if id_dc_upper == 1972

	*DENALI
	replace year_liner = 2016 if id_dc_upper == 1317
	replace year_subsidiary = 2017 if id_dc_upper == 1317
	
	*DIFFUSION PHARMACEUTICALS
	foreach num of numlist 1220 2204 1949 2620 {
		replace year_liner = 2015 if id_dc_upper == `num'
		replace year_subsidiary = 2016 if id_dc_upper == `num'
	}
	
	*DIPLOMAT PHARMACY INC
	replace year_liner = 2015 if id_dc_upper == 484
	replace year_subsidiary = 2016 if id_dc_upper == 484
	
	*DR REDDY'S
	replace gvkey_dc = gvkey_parent  if id_dc_upper == 359
	replace gvkey_dc = gvkey_parent  if id_dc_upper == 2100
}
	*parent company name starting from letter E
{
	*EIGER BIOPHARMACEUTICALS INC
	replace year_liner = 2016 if id_dc_upper == 618
	replace year_subsidiary = 2017 if id_dc_upper == 618

	*EISAI
	foreach num of numlist 107 1658 1709 2107 {
		replace year_liner = 2007 if id_dc_upper == `num'
		replace year_subsidiary = 2008 if id_dc_upper == `num'
	}
	foreach num of numlist 901 1171 1445 {
		replace gvkey_dc = gvkey_parent if id_dc_upper == `num'
	}
	
	*ELEDON
	replace year_liner = 2020 if id_dc_upper == 241
	replace year_subsidiary = 2021 if id_dc_upper == 241
	replace year_liner = 2017 if id_dc_upper == 1932
	replace year_subsidiary = 2018 if id_dc_upper == 1932
	
	*ELOXX
	replace year_liner = 2017 if id_dc_upper == 1026
	replace year_subsidiary = 2018 if id_dc_upper == 1026
	replace year_liner = 2021 if id_dc_upper == 2755
	replace year_subsidiary = 2022 if id_dc_upper == 2755

	*EMERGENT
	foreach num of numlist 258 476 {
		replace year_liner = 2004 if id_dc_upper == `num'
		replace year_subsidiary = 2005 if id_dc_upper == `num'
	}
	
	*ENDO INTERNATIONAL
	foreach num of numlist 174 187 2668 {
		replace year_liner = 2013 if id_dc_upper == `num'
		replace year_subsidiary = 2014 if id_dc_upper == `num'
	}
	replace year_liner = 2021 if id_dc_upper == 2755
	replace year_subsidiary = 2022 if id_dc_upper == 2755
	replace year_subsidiary = 2011 if id_dc_upper == 772
	replace year_liner = 2006 if id_dc_upper == 2249
	replace year_subsidiary = 2007 if id_dc_upper == 2249

	*ENDOVASC
	replace gvkey_dc = gvkey_parent if id_dc_upper == 245
	replace gvkey_dc = gvkey_parent if id_dc_upper == 1549
	
	*EPIRUS
	replace year_liner = 2014 if id_dc_upper == 1770
	replace year_subsidiary = 2015 if id_dc_upper == 1770
	
	*EVOFEM
	replace year_liner = 2017 if id_dc_upper == 1750
	replace year_subsidiary = 2018 if id_dc_upper == 1750
	
	*EVOGENE
	replace gvkey_dc = gvkey_parent if id_dc_upper == 462
	
	*EVOTEC
	foreach num of numlist 1189  1982 {
		replace year_liner = 2010 if id_dc_upper == `num'
		replace year_subsidiary = 2011 if id_dc_upper == `num'
	}

	*EYEPOINT
	replace gvkey_dc = gvkey_parent if id_dc_upper == 2129
}
	*parent company name starting from letter F
{
	*FINCH THERAPEUTICS GROUP
	replace year_liner = 2017 if id_dc_upper == 781
	replace year_subsidiary = 2018 if id_dc_upper == 781

	*FMC
	replace year_liner = 2013 if id_dc_upper == 2578
	replace year_subsidiary = 2014 if id_dc_upper == 2578
	
	*FORTRESS
	replace gvkey_dc = gvkey_parent if id_dc_upper == 1184 
	
	*FRESENIUS
	replace gvkey_dc = gvkey_parent if id_dc_upper == 2594 
	
	*FUJIFILM
	replace year_liner = 2014 if id_dc_upper == 1416
	replace year_subsidiary = 2015 if id_dc_upper == 1416
	replace year_liner = 2009 if id_dc_upper == 1990
	replace year_subsidiary = 2010 if id_dc_upper == 1990
}
	*parent company name starting from letter G
{
	*GAIN THERAPEUTICS INC
	replace year_liner = 2020 if id_dc_upper == 787
	replace year_subsidiary = 2021 if id_dc_upper == 787

	*GALAPAGOS
	replace year_liner = 2010 if id_dc_upper == 1037 
	replace year_subsidiary = 2011 if id_dc_upper == 1037 
	
	*GENERAL ELECTRIC
	replace year_liner = 2003 if id_dc_upper == 2600 
	replace year_subsidiary = 2007 if id_dc_upper == 2600 
	replace year_liner = 2012 if id_dc_upper == 2721 
	replace year_subsidiary = 2013 if id_dc_upper == 2721 
	
	*GLOBAL CLEAN ENERGY
	replace year_liner = 2005 if id_dc_upper == 2278 
	replace year_subsidiary = 2006 if id_dc_upper == 2278 
	
	*GOSSAMER
	replace year_liner = 2018 if id_dc_upper == 79 
	replace year_subsidiary = 2019 if id_dc_upper == 79 
	replace year_liner = 2018 if id_dc_upper == 2133 
	replace year_subsidiary = 2019 if id_dc_upper == 2133 
	
	*GRIFOLS
	replace year_liner = 2021 if id_dc_upper == 496 
	replace year_subsidiary = 2022 if id_dc_upper == 496 
	replace year_liner = 2020 if id_dc_upper == 158 
	replace year_subsidiary = 2021 if id_dc_upper == 158 
}
	*parent company name starting from letter H
{
	*HALOZYME THERAPEUTICS
	replace year_liner = 2022 if id_dc_upper == 1987
	replace year_subsidiary = 2023 if id_dc_upper == 1987
	
	*HISTOGEN
	replace year_liner = 2020 if id_dc_upper == 730
	replace year_subsidiary = 2021 if id_dc_upper == 730
	replace year_liner = 2020 if id_dc_upper == 1249
	replace year_subsidiary = 2021 if id_dc_upper == 1249
	
	*HISTOGENICS
	replace year_liner = 2011 if id_dc_upper == 2084
	replace year_subsidiary = 2012 if id_dc_upper == 2084
	
	*HOLOGIC
	replace year_liner = 2007 if id_dc_upper == 77
	replace year_subsidiary = 2007 if id_dc_upper == 77

	*HORIZON THERAPEUTICS
	foreach num of numlist 394 2545 428 948 {
		replace year_liner = 2016 if id_dc_upper == `num'
		replace year_subsidiary = 2017 if id_dc_upper == `num'		
	}
	replace year_liner = 2015 if id_dc_upper == 777
	replace year_subsidiary = 2016 if id_dc_upper == 777
	replace year_liner = 2021 if id_dc_upper == 2654
	replace year_subsidiary = 2022 if id_dc_upper == 2654
	replace year_liner = 2014 if id_dc_upper == 2653
	replace year_subsidiary = 2015 if id_dc_upper == 2653
	replace year_liner = 2017 if id_dc_upper == 2232
	replace year_subsidiary = 2018 if id_dc_upper == 2232
	replace year_liner = 2015 if id_dc_upper == 2279
	replace year_subsidiary = 2016 if id_dc_upper == 2279
	replace year_liner = 2015 if id_dc_upper == 1718
	replace year_subsidiary = 2016 if id_dc_upper == 1718

	
}
	*parent company name starting from letter I
{
	*IGC
	replace gvkey_dc = gvkey_parent if id_dc_upper == 1252
	
	*IMMTECH
	replace gvkey_dc = gvkey_parent if id_dc_upper == 1786
	
	*IMMUNITYBIO (NANTCELL)
	replace gvkey_dc = gvkey_parent if id_dc_upper == 1734
	replace year_liner = 2017 if id_dc_upper == 192
	replace year_subsidiary = 2018 if id_dc_upper == 192
	replace year_liner = 2015 if id_dc_upper == 1005
	replace year_subsidiary = 2016 if id_dc_upper == 1005
	replace year_liner = 2017 if id_dc_upper == 1141
	replace year_subsidiary = 2018 if id_dc_upper == 1141

	*IMMUNOPRECISE ANTIBODIES
	replace gvkey_dc = gvkey_parent if id_dc_upper == 2466
	
	*IMMUTEP
	replace year_liner = 2005 if id_dc_upper == 568
	replace year_subsidiary = 2006 if id_dc_upper == 568
	replace year_liner = 2005 if id_dc_upper == 1879
	replace year_subsidiary = 2006 if id_dc_upper == 1879
	
	*INCYTE
	replace year_liner = 2002 if id_dc_upper == 1603
	replace year_subsidiary = 2003 if id_dc_upper == 1603
	
	*INNOVIVA
	replace year_liner = 1999 if id_dc_upper == 1314
	replace year_subsidiary = 2000 if id_dc_upper == 1314
	
	*INSTIL
	replace year_liner = 2020 if id_dc_upper == 1270
	replace year_subsidiary = 2021 if id_dc_upper == 1270
	
	*INSYS
	replace year_liner = 2010 if id_dc_upper == 1746
	replace year_subsidiary = 2011 if id_dc_upper == 1746
	
	*INTEGRA LIFESCIENCES
	replace year_liner = 1999 if id_dc_upper == 1763
	replace year_subsidiary = 2000 if id_dc_upper == 1763
	
	*INVITAE
	replace year_liner = 2017 if id_dc_upper == 1532
	replace year_subsidiary = 2018 if id_dc_upper == 1532
	
	*IONIS
	replace gvkey_dc = gvkey_parent if id_dc_upper == 1229

	*IR BIO
	replace gvkey_dc = gvkey_parent if id_dc_upper == 1281

	*IROKO
	replace year_liner = 2011 if id_dc_upper == 1231
	replace year_subsidiary = 2012 if id_dc_upper == 1231
	
	*IVERIC
	replace year_liner = 2018 if id_dc_upper == 1315
	replace year_subsidiary = 2019 if id_dc_upper == 1315
}
	*parent company name starting from letter J,K
{
	*JAGUAR
	replace gvkey_dc = gvkey_parent if id_dc_upper == 1736
	
	*JAZZ
	foreach num of numlist 619 821 1899 860 2467 {
		replace year_liner = 2012 if id_dc_upper == `num'
		replace year_subsidiary = 2013 if id_dc_upper == `num'		
	}
	foreach num of numlist 605 2722 {
		replace year_liner = 2019 if id_dc_upper == `num'
		replace year_subsidiary = 2020 if id_dc_upper == `num'		
	}

	*KAZIA
	replace year_liner = 2016 if id_dc_upper == 1138
	replace year_subsidiary = 2017 if id_dc_upper == 1138
	replace year_liner = 2012 if id_dc_upper == 2562
	replace year_subsidiary = 2013 if id_dc_upper == 2562

	*KINTARA
	replace year_liner = 2020 if id_dc_upper == 78
	replace year_subsidiary = 2021 if id_dc_upper == 78
	
	*KIRIN
	replace gvkey_dc = gvkey_parent if id_dc_upper == 506
	foreach num of numlist 1490 {
		replace year_liner = 2008 if id_dc_upper == `num'
		replace year_subsidiary = 2009 if id_dc_upper == `num'		
	}
	replace year_liner = 2011 if id_dc_upper == 2413
	replace year_subsidiary = 2012 if id_dc_upper == 2413

	*KNIGHT THERAPEUTICS INC
	replace year_liner = 2015 if id_dc_upper == 1758
	replace year_subsidiary = 2016 if id_dc_upper == 1758
	
	*KONINKLIJKE PHILIPS
	replace year_liner = 2009 if id_dc_upper == 1340
	replace year_subsidiary = 2010 if id_dc_upper == 1340
	replace year_liner = 2007 if id_dc_upper == 2089
	replace year_subsidiary = 2008 if id_dc_upper == 2089

}
	*parent company name starting from letter L,M,N
{
	*L'AIR LIQUIDE
	replace gvkey_dc = gvkey_parent if id_dc_upper == 2314
	
	*LEAP
	replace year_liner = 2016 if id_dc_upper == 1133
	replace year_subsidiary = 2017 if id_dc_upper == 1133
	
	*LIGAND
	foreach num of numlist 539 1389 2225 {
		replace year_liner = 2018 if id_dc_upper == `num'
		replace year_subsidiary = 2019 if id_dc_upper == `num'		
	}
	
	*LIMINAL
	replace year_liner = 2016 if id_dc_upper == 2488
	replace year_subsidiary = 2017 if id_dc_upper == 2488
	
	*LINEAGE CELL THERAPEUTICS INC
	replace year_liner = 2010 if id_dc_upper == 993
	replace year_subsidiary = 2011 if id_dc_upper == 993
	
	*MAIA
	replace gvkey_dc = gvkey_parent if id_dc_upper == 859
	
	*MALLINCKRODT
	foreach num of numlist 2156 2419 {
		replace year_liner = 2017 if id_dc_upper == `num'
		replace year_subsidiary = 2019 if id_dc_upper == `num'		
	}
	foreach num of numlist 1849 2557 {
		replace year_liner = 2017 if id_dc_upper == `num'
		replace year_subsidiary = 2018 if id_dc_upper == `num'		
	}
	
	*MANHATTAN
	replace year_liner = 2011 if id_dc_upper == 2310
	replace year_subsidiary = 2012 if id_dc_upper == 2310
	
	*MANNKIND
	replace year_liner = 2001 if id_dc_upper == 163
	replace year_subsidiary = 2002 if id_dc_upper == 163
	
	*MEDEXUS
	replace year_liner = 2018 if id_dc_upper == 1615
	replace year_subsidiary = 2019 if id_dc_upper == 1615
	
	*MEDTRONIC
	foreach num of numlist 705 768 2606 {
		replace year_liner = 2014 if id_dc_upper == `num'
		replace year_subsidiary = 2015 if id_dc_upper == `num'		
	}
	
	*MERRIMACK
	replace year_liner = 2009 if id_dc_upper == 1192
	replace year_subsidiary = 2010 if id_dc_upper == 1192
	
	*MIDATECH
	replace year_liner = 2015 if id_dc_upper == 1874
	replace year_subsidiary = 2016 if id_dc_upper == 1874
	replace gvkey_dc = gvkey_parent if id_dc_upper == 2011
	
	*MILLENIUM BIOLOGIX
	replace year_liner = 2004 if id_dc_upper == 830
	replace year_subsidiary = 2005 if id_dc_upper == 830
	
	*MIRNA THERAPEUTICS
	replace year_liner = 2017 if id_dc_upper == 2445
	replace year_subsidiary = 2018 if id_dc_upper == 2445
	
	*MIRUM PHARMACEUTICALS
	replace year_liner = 2022 if id_dc_upper == 2275
	replace year_subsidiary = 2023 if id_dc_upper == 2275
	
	*MITSUI
	replace year_liner = 2004 if id_dc_upper == 2462
	replace year_subsidiary = 2005 if id_dc_upper == 2462
	
	*MODERNA
	replace gvkey_dc = gvkey_parent if id_dc_upper == 1893
	replace gvkey_dc = gvkey_parent if id_dc_upper == 2614
	
	*MYLAN
	foreach num of numlist 1612 1629 2245 {
		replace year_liner = 2016 if id_dc_upper == `num'
		replace year_subsidiary = 2017 if id_dc_upper == `num'		
	}

	*MYMD
	replace gvkey_dc = gvkey_parent if id_dc_upper == 1910
	
	*MYND ANALYTICS
	replace year_liner = 2019 if id_dc_upper == 941
	replace year_subsidiary = 2020 if id_dc_upper == 941
	
	*NESTLE
	replace year_liner = 2020 if id_dc_upper == 127
	replace year_subsidiary = 2021 if id_dc_upper == 127
	replace year_liner = 2011 if id_dc_upper == 702
	replace year_subsidiary = 2012 if id_dc_upper == 702
	foreach num of numlist 719 2267 {
		replace year_liner = 2014 if id_dc_upper == `num'
		replace year_subsidiary = 2015 if id_dc_upper == `num'		
	}

	*NEUMORA
	replace year_liner = 2020 if id_dc_upper == 513
	replace year_subsidiary = 2021 if id_dc_upper == 513
	
	*NEXELL
	replace year_liner = 1998 if id_dc_upper == 774
	replace year_subsidiary = 1999 if id_dc_upper == 774
	
	*NOVAVAX
	replace year_liner = 2013 if id_dc_upper == 1795
	replace year_subsidiary = 2014 if id_dc_upper == 1795
	replace year_liner = 2013 if id_dc_upper == 1398
	replace year_subsidiary = 2014 if id_dc_upper == 1398
	
	*NOVELION
	replace year_liner = 2004 if id_dc_upper == 1462
	replace year_subsidiary = 2005 if id_dc_upper == 1462
	replace year_liner = 2004 if id_dc_upper == 2556
	replace year_subsidiary = 2005 if id_dc_upper == 2556
	
	*NORDISK
	replace year_liner = 2021 if id_dc_upper == 870
	replace year_subsidiary = 2022 if id_dc_upper == 870
	replace gvkey_dc = gvkey_parent if id_dc_upper == 2408
	
	*NRX
	replace gvkey_dc = gvkey_parent if id_dc_upper == 1773
	
	*NUVO PHARMACEUTICALS
	replace gvkey_dc = gvkey_parent if id_dc_upper == 873
	replace year_liner = 2005 if id_dc_upper == 1065
	replace year_subsidiary = 2006 if id_dc_upper == 1065
	replace year_liner = 2011 if id_dc_upper == 2745
	replace year_subsidiary = 2012 if id_dc_upper == 2745
	
	
}
	*parent company name starting from letter O,P,Q
{
	*OCUPHIRE
	replace year_liner = 2018 if id_dc_upper == 1853
	replace year_subsidiary = 2019 if id_dc_upper == 1853
	replace year_liner = 2020 if id_dc_upper == 1857
	replace year_subsidiary = 2021 if id_dc_upper == 1857
	
	*ONCOR
	replace year_liner = 1998 if id_dc_upper == 710
	replace year_subsidiary = 1999 if id_dc_upper == 710

	*ONCTERNAL
	replace year_liner = 2019 if id_dc_upper == 1165
	replace year_subsidiary = 2020 if id_dc_upper == 1165

	*OPKO
	foreach num of numlist 58 {
		replace year_liner = 2007 if id_dc_upper == `num'
		replace year_subsidiary = 2008 if id_dc_upper == `num'		
	}
	replace year_liner = 2016 if id_dc_upper == 932
	replace year_subsidiary = 2017 if id_dc_upper == 932
	replace year_liner = 2016 if id_dc_upper == 1771
	replace year_subsidiary = 2017 if id_dc_upper == 1771
	replace year_liner = 2016 if id_dc_upper == 2696
	replace year_subsidiary = 2017 if id_dc_upper == 2696
	
	*OPTHEA
	replace gvkey_dc = gvkey_parent if id_dc_upper == 649
	replace gvkey_dc = gvkey_parent if id_dc_upper == 2630
	replace gvkey_dc = gvkey_parent if id_dc_upper == 2045

	*OSCIENT
	replace year_liner = 2003 if id_dc_upper == 1107
	replace year_subsidiary = 2004 if id_dc_upper == 1107
	
	*PALISADE BIO
	foreach num of numlist 1325 1331 1520 2432 {
		replace year_liner = 2020 if id_dc_upper == `num'
		replace year_subsidiary = 2021 if id_dc_upper == `num'		
	}
	
	*PDL BIOPHARMA
	replace year_liner = 2003 if id_dc_upper == 974
	replace year_subsidiary = 2004 if id_dc_upper == 974
	replace year_liner = 2005 if id_dc_upper == 994
	replace year_subsidiary = 2006 if id_dc_upper == 994
	
	*PERKINELMER
	replace year_liner = 2007 if id_dc_upper == 2649
	replace year_subsidiary = 2008 if id_dc_upper == 2649
	
	*PERRIGO
	foreach num of numlist 393 893 1731 2396 2479 2509 {
		replace year_liner = 2013 if id_dc_upper == `num'
		replace year_subsidiary = 2014 if id_dc_upper == `num'		
	}
	
	*PHARMACEUTICAL PRODUCT DEVELOPMENT
	replace year_liner = 2009 if id_dc_upper == 2058
	replace year_subsidiary = 2010 if id_dc_upper == 2058
	
	*PHARMACYTE BIOTECH INC
	replace year_liner = 2011 if id_dc_upper == 2326
	replace year_subsidiary = 2012 if id_dc_upper == 2326
	
	*PHIO
	replace year_liner = 2016 if id_dc_upper == 1682
	replace year_subsidiary = 2017 if id_dc_upper == 1682
	
	*PHOTOMEDEX
	replace year_liner = 2004 if id_dc_upper == 2085
	replace year_subsidiary = 2005 if id_dc_upper == 2085
	
	*PLANET BIOPHARMACEUTICALS
	replace year_liner = 2007 if id_dc_upper == 262
	replace year_subsidiary = 2008 if id_dc_upper == 262
	
	*POSEIDA
	replace year_liner = 2016 if id_dc_upper == 2659
	replace year_subsidiary = 2017 if id_dc_upper == 2659
	
	*PRECIGEN
	replace year_liner = 2011 if id_dc_upper == 1291
	replace year_subsidiary = 2012 if id_dc_upper == 1291
	replace year_liner = 2013 if id_dc_upper == 1624
	replace year_subsidiary = 2014 if id_dc_upper == 1624
	replace year_liner = 2011 if id_dc_upper == 1756
	replace year_subsidiary = 2012 if id_dc_upper == 1756
	replace year_liner = 2017 if id_dc_upper == 2515
	replace year_subsidiary = 2018 if id_dc_upper == 2515
	replace year_liner = 2017 if id_dc_upper == 1126
	replace year_subsidiary = 2018 if id_dc_upper == 1126

	*PRESSURE BIOSCIENCES
	replace gvkey_dc = gvkey_parent if id_dc_upper == 495
	
	*PROQR THERAPEUTICS
	replace gvkey_dc = gvkey_parent if id_dc_upper == 228
	
	*PROTEOSTASIS
	replace year_liner = 2020 if id_dc_upper == 2739
	replace year_subsidiary = 2021 if id_dc_upper == 2739
	
	*PROVALIS
	replace gvkey_dc = gvkey_parent if id_dc_upper == 755

	*PURETECH HEALTH
	replace gvkey_dc = gvkey_parent if id_dc_upper == 726
	replace gvkey_dc = gvkey_parent if id_dc_upper == 1090
	replace gvkey_dc = gvkey_parent if id_dc_upper == 1843
	replace gvkey_dc = gvkey_parent if id_dc_upper == 2203
	replace gvkey_dc = gvkey_parent if id_dc_upper == 2628
	
	*QUIDEL 
	replace year_liner = 1999 if id_dc_upper == 1657
	replace year_subsidiary = 2000 if id_dc_upper == 1657
	
	
}
	*parent company name starting from letter R
{
	*RADIENT
	replace gvkey_dc = gvkey_parent if id_dc_upper == 1838
	
	*RAFAEL
	replace year_liner = 2011 if id_dc_upper == 589
	replace year_subsidiary = 2012 if id_dc_upper == 589

	*RELMADA
	replace year_liner = 2013 if id_dc_upper == 1617
	replace year_subsidiary = 2014 if id_dc_upper == 1617
	replace gvkey_dc = gvkey_parent if id_dc_upper == 2522
	
	*ROYALTY PHARMA
	replace year_liner = 2010 if id_dc_upper == 814
	replace year_subsidiary = 2011 if id_dc_upper == 814
	replace year_liner = 2010 if id_dc_upper == 2105
	replace year_subsidiary = 2011 if id_dc_upper == 2105
	
	*ROIVANT SCIENCES
	replace gvkey_dc = gvkey_parent if id_dc_upper == 327
	replace gvkey_dc = gvkey_parent if id_dc_upper == 829
	replace gvkey_dc = gvkey_parent if id_dc_upper == 2360
	replace gvkey_dc = gvkey_parent if id_dc_upper == 854
	replace gvkey_dc = gvkey_parent if id_dc_upper == 1185
	replace gvkey_dc = gvkey_parent if id_dc_upper == 1655
	replace gvkey_dc = gvkey_parent if id_dc_upper == 2201
	replace gvkey_dc = gvkey_parent if id_dc_upper == 2081
	replace year_liner = 2020 if id_dc_upper == 1882
	replace year_subsidiary = 2021 if id_dc_upper == 1882
	replace year_liner = 2021 if id_dc_upper == 2352
	replace year_subsidiary = 2022 if id_dc_upper == 2352
}
	*parent company name starting from letter U, V, W, X, Z
{
	*UNIQURE
	replace gvkey_dc = gvkey_parent if id_dc_upper == 225
	replace year_liner = 2021 if id_dc_upper == 750
	replace year_subsidiary = 2022 if id_dc_upper == 750
	
	*UNITED CANNABIS
	replace year_liner = 2017 if id_dc_upper == 2061
	replace year_subsidiary = 2018 if id_dc_upper == 2061
	
	*UNITED THERAPEUTICS
	replace gvkey_dc = gvkey_parent if id_dc_upper == 1798
	
	*URIGEN
	replace year_liner = 2006 if id_dc_upper == 1101
	replace year_subsidiary = 2007 if id_dc_upper == 1101
	replace year_liner = 2006 if id_dc_upper == 2612
	replace year_subsidiary = 2007 if id_dc_upper == 2612
	
	*US STEM CELL
	replace gvkey_dc = gvkey_parent if id_dc_upper == 472
	
	*VBI VACCINES
	replace year_liner = 2011 if id_dc_upper == 983
	replace year_subsidiary = 2012 if id_dc_upper == 983
	replace year_liner = 2015 if id_dc_upper == 2293
	replace year_subsidiary = 2016 if id_dc_upper == 2293
	
	*VENTYX BIOSCIENCES
	replace year_liner = 2021 if id_dc_upper == 1902
	replace year_subsidiary = 2022 if id_dc_upper == 1902
	replace year_liner = 2021 if id_dc_upper == 2757
	replace year_subsidiary = 2022 if id_dc_upper == 2757
	
	*VIA PHARMACEUTICALS
	replace year_liner = 2007 if id_dc_upper == 2619
	replace year_subsidiary = 2008 if id_dc_upper == 2619

	*VTV THERAPEUTICS
	replace gvkey_dc = gvkey_parent if id_dc_upper == 1197
	
	*WESTAIM
	replace year_liner = 2009 if id_dc_upper == 176
	replace year_subsidiary = 2010 if id_dc_upper == 176
	
	*WINDTREE THERAPEUTICS
	replace gvkey_dc = gvkey_parent if id_dc_upper == 63
	replace year_liner = 2018 if id_dc_upper == 804
	replace year_subsidiary = 2019 if id_dc_upper == 804
	
	*ZIMMER
	replace year_liner = 2014 if id_dc_upper == 461
	replace year_subsidiary = 2015 if id_dc_upper == 461
	
	*XBIOTECH
	replace year_liner = 2014 if id_dc_upper == 2417
	replace year_subsidiary = 2015 if id_dc_upper == 2417
	
	*XENON
	replace year_liner = 2003 if id_dc_upper == 939
	replace year_subsidiary = 2004 if id_dc_upper == 939
	
	*XERIS
	foreach num of numlist 473 756 2416 {
		replace year_liner = 2021 if id_dc_upper == `num'
		replace year_subsidiary = 2022 if id_dc_upper == `num'		
	}

	*XTL
	replace year_liner = 2009 if id_dc_upper == 436
	replace year_subsidiary = 2010 if id_dc_upper == 436
	
	
}
	*parent company name starting from letter S
{
	*SAREPTA THERAPEUTICS
	replace year_liner = 1998 if id_dc_upper == 1297
	replace year_subsidiary = 1999 if id_dc_upper == 1297

	*SCHRöDINGER
	replace year_liner = 2022 if id_dc_upper == 2733
	replace year_subsidiary = 2023 if id_dc_upper == 2733
	
	*SCISPARC
	replace year_liner = 2014 if id_dc_upper == 1513
	replace year_subsidiary = 2015 if id_dc_upper == 1513
	replace year_liner = 2009 if id_dc_upper == 1921
	replace year_subsidiary = 2010 if id_dc_upper == 1921
	replace year_liner = 2009 if id_dc_upper == 2116
	replace year_subsidiary = 2010 if id_dc_upper == 2116
	
	*SCOPUS BIOPHARMA
	replace gvkey_dc = gvkey_parent if id_dc_upper == 890
	replace year_liner = 2021 if id_dc_upper == 1864
	replace year_subsidiary = 2022 if id_dc_upper == 1864
	
	*SEAGEN
	foreach num of numlist 464 596 {
		replace year_liner = 2018 if id_dc_upper == `num'
		replace year_subsidiary = 2019 if id_dc_upper == `num'		
	}

	*SEELOS THERAPEUTICS
	replace year_liner = 2018 if id_dc_upper == 278
	replace year_subsidiary = 2019 if id_dc_upper == 278
	
	*SESEN BIO
	foreach num of numlist 1108 1820 2683 {
		replace year_liner = 2016 if id_dc_upper == `num'
		replace year_subsidiary = 2017 if id_dc_upper == `num'		
	}

	*SILENCE THERAPEUTICS
	replace year_liner = 2009 if id_dc_upper == 1380
	replace year_subsidiary = 2010 if id_dc_upper == 1380
	
	*SIMCERE
	replace gvkey_dc = gvkey_parent if id_dc_upper == 1428
	replace year_liner = 2007 if id_dc_upper == 2329
	replace year_subsidiary = 2008 if id_dc_upper == 2329
	replace year_liner = 2008 if id_dc_upper == 2711
	replace year_subsidiary = 2009 if id_dc_upper == 2711
	replace year_liner = 2009 if id_dc_upper == 1427
	replace year_subsidiary = 2010 if id_dc_upper == 1427
	
	*SMC VENTURES
	replace gvkey_dc = gvkey_parent if id_dc_upper == 1931
	
	*SMITH & NEPHEW
	replace year_liner = 2019 if id_dc_upper == 1930
	replace year_subsidiary = 2020 if id_dc_upper == 1930
	
	*SOCIETAL CDMO
	replace year_liner = 2021 if id_dc_upper == 1394
	replace year_subsidiary = 2022 if id_dc_upper == 1394
	
	*STATERA BIOPHARMA
	replace year_liner = 2020 if id_dc_upper == 819
	replace year_subsidiary = 2021 if id_dc_upper == 819
	replace year_liner = 2020 if id_dc_upper == 1114
	replace year_subsidiary = 2021 if id_dc_upper == 1114
	replace year_liner = 2020 if id_dc_upper == 1306
	replace year_subsidiary = 2021 if id_dc_upper == 1306
	replace year_liner = 2020 if id_dc_upper == 1950
	replace year_subsidiary = 2021 if id_dc_upper == 1950
	
	*SUMMIT THERAPEUTICS
	replace year_liner = 2007 if id_dc_upper == 836 
	replace year_subsidiary = 2008 if id_dc_upper == 836 
	replace year_liner = 2017 if id_dc_upper == 876 
	replace year_subsidiary = 2018 if id_dc_upper == 876 
	replace year_liner = 2006 if id_dc_upper == 1689 
	replace year_subsidiary = 2007 if id_dc_upper == 1689 
	
	*SWK HOLDINGS
	replace year_liner = 2019 if id_dc_upper == 964 
	replace year_subsidiary = 2020 if id_dc_upper == 964 
	
	*SYNERGY
	replace year_liner = 2012 if id_dc_upper == 560 
	replace year_subsidiary = 2013 if id_dc_upper == 560 
	replace gvkey_dc = gvkey_parent if id_dc_upper == 1256
	
	*SYNVISTA THERAPEUTICS
	replace year_liner = 2006 if id_dc_upper == 1175 
	replace year_subsidiary = 2007 if id_dc_upper == 1175 
	
	
}	
	*parent company name starting from letter T
{
	*TAIWAN LIPOSOME
	replace gvkey_dc = gvkey_parent if id_dc_upper == 1358
	
	*TWIST BIOSCIENCE
	replace gvkey_dc = gvkey_parent if id_dc_upper == 2209
	
	*TRILLIUM THERAPEUTICS
	replace year_liner = 2013 if id_dc_upper == 2405
	replace year_subsidiary = 2014 if id_dc_upper == 2405
	
	*TRAVERE THERAPEUTICS
	replace year_liner = 2013 if id_dc_upper == 1487
	replace year_subsidiary = 2014 if id_dc_upper == 1487
	replace year_liner = 2014 if id_dc_upper == 1584
	replace year_subsidiary = 2015 if id_dc_upper == 1584
	replace year_liner = 2020 if id_dc_upper == 1924
	replace year_subsidiary = 2021 if id_dc_upper == 1924
	
	*TONIX PHARMACEUTICALS
	replace year_liner = 2011 if id_dc_upper == 1480 
	replace year_subsidiary = 2012 if id_dc_upper == 1480 

	*TITAN PHARMACEUTICALS
	replace gvkey_dc = gvkey_parent if id_dc_upper == 2101
	replace year_liner = 1996 if id_dc_upper == 2566 
	replace year_subsidiary = 1997 if id_dc_upper == 2566 

	*TIKCRO TECHNOLOGIES
	replace year_liner = 2008 if id_dc_upper == 238 
	replace year_subsidiary = 2009 if id_dc_upper == 238 
	
	*THE PROCTER & GAMBLE
	replace year_liner = 2004 if id_dc_upper == 2680 
	replace year_subsidiary = 2005 if id_dc_upper == 2680 
	
	*TETRA BIO-PHARMA INC
	replace gvkey_dc = gvkey_parent if id_dc_upper == 958
	
	*TELIGENT
	replace year_liner = 2015 if id_dc_upper == 195 
	replace year_subsidiary = 2016 if id_dc_upper == 195 
	
	*TARO PHARMACEUTICAL
	replace year_liner = 2017 if id_dc_upper == 2507 
	replace year_subsidiary = 2018 if id_dc_upper == 2507 
	replace year_liner = 2015 if id_dc_upper == 2744 
	replace year_subsidiary = 2016 if id_dc_upper == 2744 
	
	*TEVA PHARMACEUTICAL
	replace year_liner = 2013 if id_dc_upper == 2142 
	replace year_subsidiary = 2014 if id_dc_upper == 2142 
	
	*TBG DIAGNOSTICS
	replace year_liner = 2008 if id_dc_upper == 625 
	replace year_subsidiary = 2009 if id_dc_upper == 625 
	replace gvkey_dc = gvkey_parent if id_dc_upper == 976
	replace year_liner = 2008 if id_dc_upper == 2366 
	replace year_subsidiary = 2009 if id_dc_upper == 2366 
	
	*TG THERAPEUTICS
	replace year_liner = 2010 if id_dc_upper == 304 
	replace year_subsidiary = 2011 if id_dc_upper == 304 
	replace year_liner = 2005 if id_dc_upper == 2482 
	replace year_subsidiary = 2006 if id_dc_upper == 2482 
	replace gvkey_dc = gvkey_parent if id_dc_upper == 349
	replace year_liner = 2006 if id_dc_upper == 2139 
	replace year_subsidiary = 2007 if id_dc_upper == 2139 
	
	
	*THERMO FISHER SCIENTIFIC
	replace year_liner = 2017 if id_dc_upper == 404  
	replace year_subsidiary = 2018 if id_dc_upper == 404  
	replace year_liner = 2021 if id_dc_upper == 2059  
	replace year_subsidiary = 2022 if id_dc_upper == 2059  
	replace year_liner = 2021 if id_dc_upper == 2715  
	replace year_subsidiary = 2022 if id_dc_upper == 2715  
	replace year_liner = 2008 if id_dc_upper == 317  
	replace year_subsidiary = 2009 if id_dc_upper == 317  
	replace year_liner = 2008 if id_dc_upper == 1458  
	replace year_subsidiary = 2009 if id_dc_upper == 1458  
	replace year_liner = 2008 if id_dc_upper == 2315  
	replace year_subsidiary = 2009 if id_dc_upper == 2315  

	*TAKEDA 
	replace year_liner = 2016 if id_dc_upper == 193  
	replace year_subsidiary = 2017 if id_dc_upper == 193  
	replace year_liner = 2007 if id_dc_upper == 209  
	replace year_subsidiary = 2008 if id_dc_upper == 209 
	replace year_liner = 2012 if id_dc_upper == 969  
	replace year_subsidiary = 2013 if id_dc_upper == 969  
	replace year_liner = 2013 if id_dc_upper == 1384  
	replace year_subsidiary = 2014 if id_dc_upper == 1384  
	replace year_liner = 2013 if id_dc_upper == 2356  
	replace year_subsidiary = 2014 if id_dc_upper == 2356  

	***Shire
	foreach num of numlist 357 413 435 2339 891 898 1425 1534 1563 1643 1702 2233 1778 1822 1991 2072 2272 2426 {
		replace year_liner = 2019 if id_dc_upper == `num'  
		replace year_subsidiary = 2020 if id_dc_upper == `num'  
	}
	
	***Nycomed
	foreach num of numlist 455 531 542 1844 1371 1525 {
		replace year_liner = 2011 if id_dc_upper == `num'  
		replace year_subsidiary = 2012 if id_dc_upper == `num'  
	}
	foreach num of numlist 624 2530 746  {
		replace year_liner = 2018 if id_dc_upper == `num'  
		replace year_subsidiary = 2019 if id_dc_upper == `num'  
	}
	foreach num of numlist 741 1674 1533 823 {
		replace year_liner = 2008 if id_dc_upper == `num'  
		replace year_subsidiary = 2009 if id_dc_upper == `num'  
	}
	foreach num of numlist 979 1248 1287 2316 {
		replace year_liner = 2009 if id_dc_upper == `num'  
		replace year_subsidiary = 2010 if id_dc_upper == `num'  
	}
	foreach num of numlist 1033 1036 1053 {
		replace year_liner = 2019 if id_dc_upper == `num'  
		replace year_subsidiary = 2020 if id_dc_upper == `num'  
	}

	
	
}
}

