** Cortellis Drug data

★(1)	Original data 에서 history development, current development column 을 각각의 row로 처리 
(폴더경로: E: > ARK > as of Jul 2024) (파일이름: history – [001]; current – [002])

★(2)	[001] 과 [002] 를 append
{
	clear
	use  "E:\ARK\as of Jul 2024\[002] Drug_development summary (current).dta"
	append using "E:\ARK\as of Jul 2024\[001] Drug_development summary (history).dta"
	sort id_cortellis develop_company develop_indication develop_country develop_year develop_date	
	save "E:\ARK\as of Jul 2024\[003] Drug_development summary (history+current).dta"
}

★(3) [003] 에서 연도 처리
{
	clear 
	use "E:\ARK\as of Jul 2024\[003] Drug_development summary (history+current).dta"
	
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
	save "E:\ARK\as of Jul 2024\[004] Drug_development summary (history+current)_no dups.dta"
	
}


★(4) [004] data 에서 develop_company 이름 뽑아서 전처리 필요할 경우 전처리 수행
*Summary
*-- (before cleaning company name) number of develop_company_original: 19,441 firms
*-- (after cleaning company name)  number of develop_company: 18,899 firms

*-- (after merging with company original data) (before cleaning company name) number of develop_company_original: 19,358 firms (83 develop_company_original unmatched)
*-- (after merging with company original data) (after cleaning company name) number of develop_company: 18,818 firms

>> list of 83 develop_company_original unmatched: [100_1] Company_list of develop company name_unmatched with company original.dta
>> list of 19358 develop_company_original matched: [101] Company_list of develop company name_matched with company original.dta

*gvkey unmatched develop_company_original: 15,821 firms
*gvkey unmatched develop_company:		   15,497 firms
*gvkey unmatched ParentCompany  : 		   13,166 firms (based on ParentCompanyName or id_parent_firm_CORT)
	
*gvkey matched develop_company_original: 3,537 firms
*gvkey matched develop_company:		     3,336 firms
*gvkey matched ParentCompany    :        1,282 firms (based on ParentCompanyName or id_parent_firm_CORT) // 1,255 firms (based on gvkey)

>> list of 3,537 develop_company_original matched with gvkey: [102] Company_list of develop company name_gvkey exist.dta
(gvkey was matched based on parent company name)
	

{
	clear
	use "E:\ARK\as of Jul 2024\[004] Drug_development summary (history+current)_no dups.dta"
	keep develop_company 
	duplicates drop

	distinct develop_company

                 |        Observations
                 |      total   distinct
-----------------+----------------------
 develop_company |      19442      19442

	sort develop_company
	save "E:\ARK\as of Jul 2024\[100] Company_list of develop company name.dta"
 
	}
*develop_company name cleaning
{
	clear
	use "E:\ARK\as of Jul 2024\[100] Company_list of develop company name.dta"
	
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
*merging with company original data
{
	clear
	use "E:\ARK\as of Jul 2024\[100] Company_list of develop company name.dta"
	rename develop_company_original CompanyName
	merge 1:m CompanyName using "E:\ARK\Original data\Cortellis_Company_processing.dta"
	drop if _merge == 2
	rename CompanyName develop_company_original
	gen CompanyName = develop_company_original
	replace CompanyName  = subinstr(CompanyName , "amp;", "",.)
	drop _merge
	save "E:\ARK\as of Jul 2024\[100] Company_list of develop company name.dta", replace
	
	keep if missing(id_firm_CORT)
	keep id_dc_ori - id_dc CompanyName
	
	duplicates list CompanyName
	
	  +-----------------------------------------------------------------+
	  | Group   Obs                                         CompanyName |
	  |-----------------------------------------------------------------|
	  |     1   151       Hainan Helpson Medicine & Biotechnique Co Ltd |
	  |     1   152       Hainan Helpson Medicine & Biotechnique Co Ltd |
	  |     2   285   Palo Alto Institute for Research & Education, Inc |
	  |     2   286   Palo Alto Institute for Research & Education, Inc |
	  +-----------------------------------------------------------------+

	drop if id_dc == 7022
	drop if id_dc == 12533
	merge 1:m CompanyName using "E:\ARK\Original data\Cortellis_Company_processing.dta"
	drop if _merge == 2
	save "E:\ARK\as of Jul 2024\[100_1] Company_list of develop company name_unmatched with company original.dta"
	
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

			   |        Observations
			   |      total   distinct
		-------+----------------------
		 id_dc |         79         79

	merge 1:m id_firm_CORT using "E:\ARK\Original data\Cortellis_Company_processing.dta", replace update
	drop if _merge == 2
	drop _merge
	save "E:\ARK\as of Jul 2024\[100_1] Company_list of develop company name_unmatched with company original.dta", replace
	
	clear
	use "E:\ARK\as of Jul 2024\[100] Company_list of develop company name.dta"
	drop if missing(id_firm_CORT)
	append using "E:\ARK\as of Jul 2024\[100_1] Company_list of develop company name_unmatched with company original.dta"
	save "E:\ARK\as of Jul 2024\[101] Company_list of develop company name_matched with company original.dta"
	
}
*gvkey matching (by parent company name)
{
	clear
	use "E:\ARK\as of Jul 2024\[101] Company_list of develop company name_matched with company original.dta"
	merge m:1 id_parent_firm_CORT using "E:\ARK\as of Jul 2024\[101_2] Company_Parent Co-gvkey matched from [100] in 2024March_no dups.dta"
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

	
	save "E:\ARK\as of Jul 2024\[101] Company_list of develop company name_matched with company original.dta", replace
	
	*gvkey unmatched develop_company_original: 15,820 firms
	*gvkey unmatched develop_company:		   15,496 firms
	*gvkey unmatched ParentCompany  : 		   13,165 firms (based on ParentCompanyName or id_parent_firm_CORT)
	
	*gvkey matched develop_company_original: 3,538 firms
	*gvkey matched develop_company:		     3,337 firms
	*gvkey matched ParentCompany    :        1,282 firms (based on ParentCompanyName or id_parent_firm_CORT)
	
	keep if !missing(gvkey)
	save "E:\ARK\as of Jul 2024\[102] Company_list of develop company name_gvkey exist.dta"
	
}
*[102] data 에서 develop_company 이름 교정
{
	clear
	use "E:\ARK\as of Jul 2024\[102] Company_list of develop company name_gvkey exist.dta"
	
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
	
	save "E:\ARK\as of Jul 2024\[102] Company_list of develop company name_gvkey exist.dta", replace
	
}
*[102] data 에서 Parent company name 이름 교정
{
	clear
	use "E:\ARK\as of Jul 2024\[102] Company_list of develop company name_gvkey exist.dta"
	
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

	save "E:\ARK\as of Jul 2024\[102] Company_list of develop company name_gvkey exist.dta", replace

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


★(5) [102] data added_year 정보 교정
- 해당 develop_company 가 parent company 의 일부가 된 연도
(a year when a develop company becomes a part of parent company)
*Among 1,255 parent firms having gvkey, (based on gvkey) 
* 771 firms have only one develop_company.
* 484 firms (parent company) have more than 2 develop_company.
*--- Among 484 firms, 337 firms are matched with M&A data. --> [102_3a]

{
	clear
	use "E:\ARK\as of Jul 2024\[102] Company_list of develop company name_gvkey exist.dta"
	keep ParentCompanyName id_parent_firm_CORT gvkey added_year id_dc_ori develop_company_original develop_company develop_company_2 id_dc
duplicates drop
save "E:\ARK\as of Jul 2024\[102_1] Company_list of develop company name_gvkey exist_firm list only.dta"
	
	clear
	use "E:\ARK\as of Jul 2024\[102_1] Company_list of develop company name_gvkey exist_firm list only.dta"
	bysort id_parent_firm_CORT (id_dc): gen cnt = _N
keep if cnt != 1
 distinct id_parent_firm_CORT
save "E:\ARK\as of Jul 2024\[102_2] Company_list of develop company name_gvkey exist_firm list of more than two develop company.dta"
	
}

****(1) using M&A dataset downloaded from WRDS
*-> Final result file: [102_6] Company_gvkey-id_dc added_year_revised.dta
*-> Final result file only contains gvkey id_dc and year info.
*-> Detailed M&A descriptions can be found in following two files: 
[102_5] Company_parent firm_child firm matching completed.dta"
[102_5a] Company_parent firm_child firm matching completed_from 102_4d

{
	clear
	use "E:\ARK\as of Jul 2024\[102_3a] MnA data_tagging gvkey id_dc_for fuzzy matching_matched.dta"
	rename upper_amanames conm
	duplicates report id_upper_amanames
	merge 1:m  id_upper_amanames using  "E:\ARK\as of Jul 2024\[102_3] MnA data_tagging gvkey id_dc.dta"
	drop if _merge == 2
	drop _merge
	sort gvkey tmanames
	
	gen year_announce = substr(dateann,1,4)
	gen year_eventdate = substr(hdate,1,4)
	destring, replace
	egen id_tmanames = group(upper_tmanames)
	save "E:\ARK\as of Jul 2024\[102_4] MnA data_matched gvkey using 102_3a_matched.dta"
	
	*acquiror 는 gvkey 사용해서 matching 완료
	*target firm 의 id_dc 를 matching 해야 함
	
	[102_4]: M&A data 에서 gvkey matching 되는 걸 가져온 파일 --> 여기서 target firm name 추출한 다음 matchit 작업 필요 
	clear
	use "E:\ARK\as of Jul 2024\[102_4] MnA data_matched gvkey using 102_3a_matched.dta"
	keep if id_dc == 0
	keep gvkey id_upper_amanames upper_amanames id_tmanames upper_tmanames id_dc
	duplicates drop
	drop id_dc
	keep id_tmanames upper_tmanames
	duplicates drop
	save "E:\ARK\as of Jul 2024\[102_4b] MnA data_matched gvkey_target name only_for fuzzy matching.dta"

	[102_4a]: Cortellis data 에서 한 기업 내에 여러 개의 company 가 있는 걸 가져온 파일 --> 여기서 develop_company 추출한 다음 matchit 작업 필요  
	clear
	use "E:\ARK\as of Jul 2024\[102_4a] MnA data_from_[102] to match id_dc.dta"
	keep id_dc develop_company
	duplicates drop
	save "E:\ARK\as of Jul 2024\[102_4c] Company_id_dc_for fuzzy matching.dta"
	
	clear 
	use "E:\ARK\as of Jul 2024\[102_4c] Company_id_dc_for fuzzy matching.dta"
	matchit id_dc develop_company using "E:\ARK\as of Jul 2024\[102_4b] MnA data_matched gvkey_target name only_for fuzzy matching.dta", idu(id_tmanames) txtu(  upper_tmanames)
	save "E:\ARK\as of Jul 2024\[102_4c_1] Company_id_dc_for fuzzy matching_result.dta"
	
	***(data name: 102_4c_1)
	- M&A data 의 target company 에 id_dc 붙이는 작업
	- 목표: id_tmanames ~ id_dc 붙이기 
	***>> Result data: [102_4c_1_matched] Company_id_dc_for fuzzy matching_result.dta
	
	- 최종목표: gvkey (parent firm; acquiror) ~ id_dc (target firm) 로 정확한 added_year 정보 확보
	***>> Data: [102_6] Company_gvkey-id_dc added_year_revised.dta"
	
	clear
	use "E:\ARK\as of Jul 2024\[102_4] MnA data_matched gvkey using 102_3a_matched.dta"
	sort gvkey upper_tmanames
	joinby id_tmanames using "E:\ARK\as of Jul 2024\[102_4c_1_matched] Company_id_dc_for fuzzy matching_result.dta"
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
	save "E:\ARK\as of Jul 2024\[102_4d] Joinby_102_4 and 102_4c_1_matched.dta"
	
	clear
	use "E:\ARK\as of Jul 2024\[102_4d] Joinby_102_4 and 102_4c_1_matched.dta"
	keep if tag == 1
	save "E:\ARK\as of Jul 2024\[102_5a] Company_parent firm_child firm matching completed_from 102_4d.dta"
	
	clear
	use "E:\ARK\as of Jul 2024\[102_5a] Company_parent firm_child firm matching completed_from 102_4d.dta"
	keep gvkey id_dc year_announce year_eventdate
	append using "E:\ARK\as of Jul 2024\[102_6] Company_gvkey-id_dc added_year_revised.dta"
	save "E:\ARK\as of Jul 2024\[102_6] Company_gvkey-id_dc added_year_revised.dta" , replace
	
	/// List of matched gvkey-id_dc-added_year_revised (year_announce, year_eventdate)
	
	clear
	use "E:\ARK\as of Jul 2024\[102_4] MnA data_matched gvkey using 102_3a_matched.dta"
	keep if id_dc != 0
	drop conm matched master_deal_no tn an acusip acquiror_sedol master_cusip target_sedol
	
	sort gvkey id_dc hdate
	gen hevent_tag = 1 if strpos(hevent, "completed")
	order hevent_tag, a(hevent)
	replace hevent_tag =1 if missing(hevent)
	replace hevent_tag = 1 in 32
	replace hevent_tag = 1 in 62
	replace hevent_tag = 1 in 141
	save "E:\ARK\as of Jul 2024\[102_5] Company_parent firm_child firm matching completed.dta"

	
	clear
	use  "E:\ARK\as of Jul 2024\[102_5] Company_parent firm_child firm matching completed.dta"
	keep if hevent_tag == 1
	keep gvkey id_dc year_announce year_eventdate
	duplicates drop
	drop in 21 // keep the latest year 
	drop in 4 // keep the latest year 
	save "E:\ARK\as of Jul 2024\[102_6] Company_gvkey-id_dc added_year_revised.dta"
	
}

****(2) Using subsidiary data 
*dataset: [103]
{
	clear
	use "E:\ARK\as of Jul 2024\[102_1] Company_list of develop company name_gvkey exist_firm list only.dta"
	keep gvkey
	duplicates drop
	merge 1:m gvkey using "E:\ARK\Preprocessing_as of Dec 2023\2024-March\[201] Subsidiary (first year of each subsidiary).dta"
	drop if _merge == 2
	drop _merge
	save "E:\ARK\as of Jul 2024\[103] Subsidiary_only gvkey firms from [102_1].dta"
	
	keep id_subsidiary clean_company
	duplicates drop
	
	
	clear 
	use "E:\ARK\as of Jul 2024\[102_4c] Company_id_dc_for fuzzy matching.dta"
	matchit id_dc develop_company using  "E:\ARK\as of Jul 2024\[103a] Subsidiary_only gvkey firms from [102_1]_for fuzzy matching.dta", idu(id_subsidiary) txtu(  clean_company)
	save "E:\ARK\as of Jul 2024\[103b] Subsidiary_results of fuzzy matching (102_4c and 103a).dta"
	
	clear
	use "E:\ARK\as of Jul 2024\[103b] Subsidiary_results of fuzzy matching (102_4c and 103a).dta"
	keep if similscore == 1
	save "E:\ARK\as of Jul 2024\[103b_matched] Subsidiary_results of fuzzy matching (102_4c and 103a).dta"
	
	clear
	use "E:\ARK\as of Jul 2024\[103b] Subsidiary_results of fuzzy matching (102_4c and 103a).dta"
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
	save "E:\ARK\as of Jul 2024\[103b_matched_check] Subsidiary_results of fuzzy matching (102_4c and 103a).dta"
	
	clear
	use "E:\ARK\as of Jul 2024\[103--gvkey to be matched] Subsidiary_only gvkey firms from [102_1].dta"
	joinby id_subsidiary using "E:\ARK\as of Jul 2024\[103b_matched] Subsidiary_results of fuzzy matching (102_4c and 103a).dta", unmatched(both)

	                       _merge |      Freq.     Percent        Cum.
	------------------------------+-----------------------------------
			  only in master data |     27,341       60.84       60.84
			   only in using data |      4,276        9.52       70.36
	both in master and using data |     13,322       29.64      100.00
	------------------------------+-----------------------------------
							Total |     44,939      100.00

	save "E:\ARK\as of Jul 2024\[103c] Joinby_103 and 103b_matched.dta"

	clear
	use "E:\ARK\as of Jul 2024\[103c] Joinby_103 and 103b_matched.dta"
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
	save "E:\ARK\as of Jul 2024\[103c_merge3] Joinby_103 and 103b_matched.dta"
		
	clear
	use  "E:\ARK\as of Jul 2024\[103c_merge3] Joinby_103 and 103b_matched.dta"
	keep if tag == 1
	save "E:\ARK\as of Jul 2024\[103c_merge3_tag1] Joinby_103 and 103b_matched.dta"
	
}	
	
	
****Revised added_year info. using M&A data
{
	clear
	use "E:\ARK\as of Jul 2024\[102] Company_list of develop company name_gvkey exist.dta"
	drop _merge
	merge m:1 gvkey id_dc using  "E:\ARK\as of Jul 2024\[102_6] Company_gvkey-id_dc added_year_revised.dta"
		
		Result                      Number of obs
		-----------------------------------------
		Not matched                         3,547
			from master                     3,049  (_merge==1)
			from using                        498  (_merge==2)

		Matched                               489  (_merge==3)
		-----------------------------------------

	drop if _merge == 2
	drop _merge	
	save "E:\ARK\as of Jul 2024\[102] Company_list of develop company name_gvkey exist.dta", replace

}

****Revised added_year info. using Subsidiary data
{
	clear
	use "E:\ARK\as of Jul 2024\[102] Company_list of develop company name_gvkey exist.dta"
	merge m:1 gvkey id_dc using "E:\ARK\as of Jul 2024\[103c_merge3_tag1] Joinby_103 and 103b_matched.dta"
	    Result                      Number of obs
    -----------------------------------------
    Not matched                         3,365
        from master                     2,611  (_merge==1)
        from using                        754  (_merge==2)

    Matched                               927  (_merge==3)
    -----------------------------------------
	
	drop if _merge == 2
	drop _merge tag same
	save "E:\ARK\as of Jul 2024\[102] Company_list of develop company name_gvkey exist.dta", replace
}


###FROM HERE (2024-07-30)
★(6) [102] data 에서 develop_company_2 == Parentcompany 인 경우, firm id 수정 필요 
	
*(a) develop_company name cleaning
*----> 2024-07-31 완료 
*----> Result data: [102] ; unique ID: id_dc_2

*(b) Parent Company Name 도 정리 필요 (using [102]) 
*----> 2024-08-01 완료 
*----> Result data: [102] ; unique ID: id_parent_firm_CORT_2

*(c) [102] data 가 Company name key file: id_dc_ori ~ id_dc_2; id_parent_firm_CORT ~ id_parent_firm_CORT_2 ~ gvkey 
*develop_company 기준으로 gvkey 붙이기 
{
	clear
	use "E:\ARK\as of Jul 2024\[102] Company_list of develop company name_gvkey exist.dta"
	drop develop_company id_dc
	rename develop_company_original develop_company
	rename id_dc_ori id_dc
	rename develop_company_2 upper_develop_company
	rename id_dc_2 id_dc_upper
	rename id_parent_firm_CORT_2 id_parent_firm_CORT_upper
	rename gvkey gvkey_parent
	drop id_parent_firm_CORT_N
		
	distinct id_dc_upper

				 |        Observations
				 |      total   distinct
	-------------+----------------------
	 id_dc_upper |       3536       2767

	distinct id_parent_firm_CORT_upper

							   |        Observations
							   |      total   distinct
	---------------------------+----------------------
	 id_parent_firm_CORT_upper |       3536       1262

	 
	distinct gvkey_parent

				  |        Observations
				  |      total   distinct
	--------------+----------------------
	 gvkey_parent |       3536       1254

	gen child = subinstr( upper_develop_company, " ", "", .)
	gen parent = subinstr( upper_Parent, " ", "", .)
	gen child_4 = substr(child,1,4)
	gen parent_4 = substr(parent,1,4)
	gen same = 1 if parent_4 == child_4
	
	gen gvkey_dc = gvkey_parent if same == 1
	drop same
	save "E:\ARK\as of Jul 2024\[104] develop - parent (gvkey).dta"

	clear
	use "E:\ARK\as of Jul 2024\[104] develop - parent (gvkey).dta"
	keep if missing(gvkey_dc)
	keep id_dc_upper upper_develop_company
	duplicates drop
	save "E:\ARK\as of Jul 2024\[104_1] id_dc_upper upper_dc for fuzzy matching.dta"

	clear
	use "E:\ARK\as of Jul 2024\[104_1] id_dc_upper upper_dc for fuzzy matching.dta"
	matchit id_dc_upper upper_develop_company using "E:\ARK\Preprocessing_as of Dec 2023\2024-March\Compustat_gvkey_conm.dta" , idusing(gvkey) txtusing(conm_COMPUSTAT)
	
	save "E:\ARK\as of Jul 2024\[104_2] Result of id_dc_upper upper_dc for fuzzy matching.dta"

	clear
	use "E:\ARK\as of Jul 2024\[104_2] Result of id_dc_upper upper_dc for fuzzy matching.dta"
	keep if similscore == 1
	save "E:\ARK\as of Jul 2024\[104_2_matched] Result of id_dc_upper upper_dc for fuzzy matching.dta"
	
	clear
	use "E:\ARK\as of Jul 2024\[104_2] Result of id_dc_upper upper_dc for fuzzy matching.dta"
	gen matched = 0
	replace matched = 1 if similscore == 1
	gsort id_dc_upper -similscore
	by id_dc_upper: replace matched = matched[1]
	drop if matched == 1
	save "E:\ARK\as of Jul 2024\[104_2_UNmatched] Result of id_dc_upper upper_dc for fuzzy matching.dta"
	
	*- [104_2_UNmatched] (same equals to 1) put gvkey to develop_company using fuzzy matching 
}

{
clear
use "E:\ARK\as of Jul 2024\[104] develop - parent (gvkey).dta"
merge m:1 id_dc_upper using "E:\ARK\as of Jul 2024\[104_2_matched] Result of id_dc_upper upper_dc for fuzzy matching.dta", update replace

replace gvkey_dc = 121742 if develop_company == "Genzyme Surgical Products"
rename conm_COMPUSTAT conm_COMPUSTAT_dc
order conm_COMPUSTAT_dc, a(gvkey_dc)

save "E:\ARK\as of Jul 2024\[105] develop (gvkey) - parent (gvkey).dta"
}

---> gvkey 가 matching 된 develop_company: 2275 개 //distinct id_dc if !missing(gvkey_dc)
---> gvkey 가 matching 된 upper_develop_company: 1656 개 //distinct id_dc_upper if !missing(gvkey_dc)
---> gvkey 가 matching 된 upper_Parent: 1261 개 // distinct id_parent_firm_CORT_upper if !missing(gvkey_parent)


======================================<2024-08-05 까지 진행상황 정리>
======================================<2024-08-05 까지 진행상황 정리>
======================================<2024-08-05 까지 진행상황 정리>
======================================<2024-08-05 까지 진행상황 정리>
======================================<2024-08-05 까지 진행상황 정리>
======================================<2024-08-05 까지 진행상황 정리>
======================================<2024-08-05 까지 진행상황 정리>
======================================<2024-08-05 까지 진행상황 정리>

*Cortellis company ~ Compustat gvkey 관련 결과파일: [105] develop (gvkey) - parent (gvkey).dta

	<만든순서 (summary)>
	(Step 1) Retrieve a list of companies (develop_company) and its parent company having drug development history data
	(Step 2) Filter out companies not having information in Compustat 

	<만든순서 (detail)>
	(Step 1) Cortellis drug file 에서 develop_company 이름 추출 (약 개발 정보가 존재하는 회사 목록 추출)
	(Step 2) 여기에 Parent company name 붙임 (using Cortellis company file | 붙인 이유: 어떤 develop_company 가 인수된 이후에는 해당 develop_company 의 정보를 Parent company 의 것으로도 여길 수 있기 때문) ==> 원본 223,760 Parent companies 중 14,447 Parent companies 가 붙여짐 
	(Step 3) Parent company 에 gvkey 를 붙임 (Among 14,447 Parent companies, 1282 (1261 after deleting duplicates) companies were matched with gvkey)
	(Step 4) gvkey가 있는 1261개 Parent company 의 develop company 에 gvkey matching (gvkey 가 있는 parent companies 의 develop_company 총 숫자: 2766 firms)
	(Step 5) Among 2766 develop companies whose parent company has gvkey, 1656 (59.87%) develop companies were matched with gvkey 

	


★(7) Final dataset 구축 
* (To-do #0 ---> 2024-08-07 DONE) Top 15 pharmaceutical companies (ref: Markou MS paper) 에서 added_year 정보만 있는 경우, 검색해서 정보 보완 
*- top 15 pharma firms (parent) 의 upper_develop_company 의 year_liner, year_subsidiary revise
*- by searching through internet sources (wikipedia, corporate website, newspaper article, https://cdek.pharmacy.purdue.edu/org/, etc.), Cortellis company data first paragraph of summary, etc.
*- check firm name.xlsx 파일 sheet 2 에 top 15 pharma 의 일부 develop_company (Subsidiary 와 M&A에서 정보가 없었던) 의 acquisition history 기록해놓았음  (파일경로: E: > ARK > as of Jul 2024)
{
clear
use "E:\ARK\as of Jul 2024\[105] develop (gvkey) - parent (gvkey).dta"
gen check = 1 if missing(year_announce) & missing(year_eventdate) & missing(year_subsidiary) & missing(year_liner)

*1. ABBVIE (Done)
{
list develop_company id_dc_upper gvkey_dc upper_develop_company upper_Parent joint_venture if strpos(upper_Parent, "ABBVIE") & check == 1 & gvkey_dc != gvkey_parent
	
---- Allergan 의 subsidiary 였던 기업들은 year_liner == 2020 (year_subsidiary == 2021) 에 become a part of ABBVIE

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
- Farmades SpA (id_dc_upper 1028) >> no meaningful result in internet; nor in Cortellis company 
- Sun Pharmaceutical Industries Inc (id_dc_upper 2422) >> not a part of Bayer
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
- Lorantis (id_dc_upper 1555) >> acquired by Celldex Therapeutics, which is not a part of Bristol-Myers Squibb
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
- Supragen (id_dc_upper 2427) >> no meaningful result in internet; nor in Cortellis company 
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
- Dr Lo Zambeletti SpA (id_dc_upper 886) 
- Instituto Luso Farmaco SA [Portugal] (id_dc_upper 1362)
- ISF Societa Per Azioni (id_dc_upper 1399)
- Laboratorios Morrith SA (id_dc_upper 1504)
>> no meaningful result in internet; nor in Cortellis company

- Japan Vaccine Co Ltd (id_dc_upper 1417) 
- Shionogi-ViiV Healthcare LLC (id_dc_upper 2338)
- Sino-American Tianjin Smith Kline & French Laboratories Ltd (id_dc_upper 2357)
- ViiV Healthcare Ltd (id_dc_upper 2656)
>> joint venture
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
- Immunobiology Research Institute Inc (id_dc_upper 1288) >> no meaningful result in internet; nor in Cortellis company 
- Xian-Janssen Pharmaceutical Ltd (id_dc_upper 2773) >> joint venture
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
- LPB Istituto Farmaceutico SpA (id_dc_upper 1561) >> no meaningful result in internet; nor in Cortellis company 
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
- Institut de Recherche Jouveinal SA (IRJ) (id_dc_upper 1361)
- Leo AB (id_dc_upper 1529)
- Prodotti Formenti Srl (id_dc_upper 2087)
>> no meaningful result in internet; nor in Cortellis company
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
- Allegro Biologics Inc (id_dc_upper 164)
- Auspharm Institute for Mucosal Immunology (AIMI) (id_dc_upper 363)
- Bottu SA (id_dc_upper 530)
- Laboratoires Houde SA (id_dc_upper 1499)
- VaxServe Inc (id_dc_upper 2624)
>> no meaningful result in internet; nor in Cortellis company

- Sanofi Pharma Bristol-Myers Squibb SNC (id_dc_upper 2264)
>> joint venture  
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
- QDose Ltd (id_dc_upper 2142)
- Teva-Handok (id_dc_upper 2503)
>> joint ventures
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

▼ 2024 SMS PDW 제출 전에 전처리하던 중에 발견한 오류
▼ 이번에는 해당 오류들이 발생하지 않음을 확인함 
{
	아래 정보들이 어떻게 되어있는지 확인 (예전 버전 dataset 에서 오류 발견하고 남겨만 둔 것)
	(1) -> checked
	Cortellis company data: A H Robins (1197) become part of Pfizer (152035) in added_year 1996 or 2000.
	However, in M&A data: AH Robins Co Inc become part of American Home Products Corp in 1987.
	>> (2024-08-06) 
		- A H Robins become part of American Home Products Corp in 1987.
		- American Home Products name change to Wyeth in 2002.
		- Wyeth acquired by Pfizer in 2009.
		- In WRDS Subsidiary data, A H Robins became a part of Pfizer from 2013.
		>> year_liner = 2009; year_subsidiary = 2013 if develop_company == A H Robins
		
	
	(2) -> checked
	Cortellis company data: Abgenix (3482) become part of Amgen in added_year 2003.
	However, in M&A data: Abgenix Inc merged to Amgen Inc in 2005.
	>> (2024-08-06)
		- Acquisition year Double-checked in internet (https://cdek.pharmacy.purdue.edu/org/217/) (https://overseas.mofa.go.kr/gh-ko/brd/m_9770/view.do?seq=596450&srchFr=&srchTo=&srchWord=&srchTp=&multi_itm_seq=0&itm_seq_1=0&itm_seq_2=0&company_cd=&company_nm=&page=151)
		- year_liner = 2005; year_subsidiary = 2006 if develop_company = Abgenix

	
	(3) -> checked
	Cortellis company data: Abraxis BioScience Inc (3655) become part of Bristol-Myers Squibb in added_year 2006.
	However, in M&A data and internet source (en.wikipedia.org/wiki/Celgene), Abraxis was acquired by Celgene in 2010. Then, Celgene become part of Bristol-Myers Squibb in 2019.
	>> (2024-08-06)
		- Acquisition year Double-checked in internet (https://cdek.pharmacy.purdue.edu/org/303/) (https://news.bms.com/news/details/2019/Bristol-Myers-Squibb-to-Acquire-Celgene-to-Create-a-Premier-Innovative-Biopharma-Company/default.aspx)
		- year_liner = 2019; year_subsidiary = 2020 if develop_company = Abraxis BioScience Inc
	
	(4) -> checked 
	Cortellis company data: Celgene (various) become part of Bristol-Myers Squibb in added_year 2003, 2010, 2014, 2015, 2016, 2019. However, in M&A data and internet source (en.wikipedia.org/wiki/Celgene), Celgene was acquired by Bristol-Myers Squibb in 2019.
	>> (2024-08-06)
		- Acquisition year Double-checked in internet (https://cdek.pharmacy.purdue.edu/org/788/) (https://news.bms.com/news/details/2019/Bristol-Myers-Squibb-to-Acquire-Celgene-to-Create-a-Premier-Innovative-Biopharma-Company/default.aspx)
		- year_liner = 2019; year_subsidiary = 2020 if develop_company = Celgene

}


*#################FROM HERE 2024-08-07
--> 우선, [200][300] data 다시 만들기 (to-do #0 하는 과정 중에 id_dc_upper 수정했을 가능성 있기 때문)
--> 2024-08-07 Done
*Patent data 에 gvkey_dc 붙이기 --> result files: [200], [300]
{
[200] Patent_gvkey-dc attached (patent ownership).dta
--- (gvkey_dc 기준) number of firms not having patent info.: 343 firms (develop_company 기준 972 firms)
--- (gvkey_dc 기준) number of firms having patent info.:    1416 firms (develop_company 기준 2505 firms)
	--- (gvkey_dc 기준) number of firms having patent with assignee/owner: 1411 firms
{
	clear
	use "E:\ARK\Preprocessing_as of Dec 2023\2024-March\[400] Patent_assignee or owner only.dta"

	gen patent_assignee_owner = 1 if strpos(org_detail, "Patent Assignee/Owner")
	replace patent_assignee_owner = 1 if strpos(org_detail, "Inferred assignee")
	replace patent_assignee_owner = 1 if strpos(org_detail, "Patent assignee of family member")

	gen licensee_develop_marketing = 1 if strpos(org_detail, "Licensee for development and marketin")
	gen licensee_marketing = 1 if strpos(org_detail, "Licensee - marketing only")
	gen patent_owner = 1 if strpos(org_detail, "Patent owner (not assignee)")
	
	label variable patent_assignee_owner "Assignee/Owner; Inferred assignee"
	label variable licensee_develop_marketing "Licensee for development and marketing"
	label variable licensee_marketing "Licensee - marketing only"
	label variable patent_owner "Patent owner (not assignee)"

	drop _j
	save "E:\ARK\Preprocessing_as of Dec 2023\2024-March\[400] Patent_assignee or owner only.dta", replace

	clear
	use "E:\ARK\as of Jul 2024\[105] develop (gvkey) - parent (gvkey).dta"
	keep id_dc develop_company id_dc_upper gvkey_dc upper_develop_company
	duplicates drop
	
	gen org = subinstr(develop_company, "amp;", "", .)
	replace org = subinstr(org, "&gt;", "", .)
	drop id_dc develop_company
	duplicates drop
	
	merge 1:m org using "E:\ARK\Preprocessing_as of Dec 2023\2024-March\[400] Patent_assignee or owner only.dta"
	drop if _merge == 2
	
	save "E:\ARK\as of Jul 2024\[200] Patent_gvkey-dc attached (patent ownership).dta"
	
	
}	


[300] Patent_gvkey-dc attached (patent third party relationship).dta
{
	clear
	use "E:\ARK\as of Jul 2024\[105] develop (gvkey) - parent (gvkey).dta"
	keep id_dc develop_company id_dc_upper gvkey_dc upper_develop_company
	duplicates drop
	
	gen third_party_org = subinstr(develop_company, "amp;", "", .)
	replace third_party_org = subinstr(third_party_org, "&gt;", "", .)
	drop id_dc develop_company
	duplicates drop
	
	merge 1:m third_party_org using "E:\ARK\Preprocessing_as of Dec 2023\2024-March\[500] Patent_third_party.dta"
	drop if _merge == 2
	
	save "E:\ARK\as of Jul 2024\[300] Patent_gvkey-dc attached (patent third party relationship).dta"
	
}	
}



***(To-do #1) Patent data 에 patent priority year 정보 등 patent 기본 정보 붙인 후, 연도에 따른 gvkey_dc 보정 
- use [200] data
**# Bookmark #13
- <gvkey_dc_refine 변수 생성> 연도에 따른 gvkey_dc 보정 (a) Bookmark #2 참고 --> 2024-08-07 Done
{
	clear
	use "E:\ARK\as of Jul 2024\[200] Patent_gvkey-dc attached (patent ownership).dta"
	
	gen gvkey_dc_refine = gvkey_dc
	order gvkey_dc_refine, b(gvkey_dc)
	replace gvkey_dc_refine = 117298 if org == "Genzyme Molecular Oncology"
	replace gvkey_dc_refine = 15708 if org == "Allergan France SA" & priority_year == 2013

	replace gvkey_dc_refine = 15708 if org == "Allergan Inc" & priority_year <= 2014
	replace gvkey_dc_refine = 27845 if org == "Allergan Inc" & priority_year >= 2015 & !missing(priority_year)
	replace gvkey_dc_refine = 15708 if org == "Allergan Pharmaceuticals International Ltd" & priority_year <= 2014
	replace gvkey_dc_refine = 27845 if org == "Allergan Pharmaceuticals International Ltd" & priority_year >= 2015 & !missing(priority_year)
	replace gvkey_dc_refine = 27845 if org == "Allergan plc"
	replace gvkey_dc_refine = 147449 if strpos(upper_develop_company, "ALCON") & !missing(priority_year) & priority_year <= 2010
	replace gvkey_dc_refine = 147449 if strpos(upper_develop_company, "ALCON") & !missing(priority_year) & priority_year >= 2019
	replace gvkey_dc_refine = 6096 if strpos(upper_develop_company, "MALLINCKRODT MEDICAL") & !missing(priority_year) & priority_year <= 2000
	replace gvkey_dc_refine = 18086 if strpos(upper_develop_company, "MALLINCKRODT MEDICAL") & !missing(priority_year) & priority_year >= 2011
	replace gvkey_dc_refine = 13282 if strpos(upper_develop_company, "ORGANOGENESIS") & !missing(priority_year) & priority_year <= 2001
	replace gvkey_dc_refine = 61101 if strpos(upper_develop_company, "VIVENTIA") & !missing(priority_year) & priority_year <= 2004
	replace gvkey_dc_refine = 26412 if strpos(upper_develop_company, "VIVENTIA") & !missing(priority_year) & priority_year >= 2013
	replace gvkey_dc_refine = 205950 if strpos(upper_develop_company, "WARNER CHILCOTT") & !missing(priority_year) & priority_year <= 2004
	replace gvkey_dc_refine = 175163 if strpos(upper_develop_company, "WARNER CHILCOTT") & !missing(priority_year) & priority_year >= 2005
	save "E:\ARK\as of Jul 2024\[200] Patent_gvkey-dc attached (patent ownership).dta", replace

		
}

- <gvkey_dc_refine 변수 생성> 연도에 따른 gvkey_dc 보정 (b) [105] data 에서 어떤 gvkey_dc 가 가진 patent priority year 가 Parent firm의 일부가 된 이후일 경우, 해당 정보 반영하여 gvkey_dc 보정 (Parent firm 의 gvkey_dc 로 보정해야 함)
**# Bookmark #14
* [105] data 에서 added_year_refine 생성 
{
	clear
	use "E:\ARK\as of Jul 2024\[105] develop (gvkey) - parent (gvkey).dta"
	
	gen added_year_refine = .
	replace added_year_refine = year_subsidiary - 1 if !missing(year_subsidiary)
	replace added_year_refine = year_announce if missing(added_year_refine) & !missing(year_announce)
	replace added_year_refine = year_eventdate if missing(added_year_refine) & !missing(year_eventdate)
	replace added_year_refine = year_liner if missing(added_year_refine) & !missing( year_liner )
	** added_year_refine: the year when the develop_company was announced to become a part of parent company
	*as of 2024-08-07
	*3,536: Total observation of [105] data
	*1,646 (46.55%): gvkey_dc == gvkey_parent 인 경우 (애초에 develop_company 와 parent_company 가 같은 경우) | 이 경우는 added_year 정보가 원래 필요없음. 
	*1,890 (53.45%): gvkey_dc != gvkey_parent 인 경우
		*1,357 (71.80%): gvkey_dc != gvkey_parent 인 경우 중 Manually complement 한 added_year_refine 의 개수 
	
	save "E:\ARK\as of Jul 2024\[105] develop (gvkey) - parent (gvkey).dta", replace
}
* [105] data 에서 15 top pharma 를 제외하고 533 개만 더 정보를 채우면 된다는 걸 확인함 (앞서 못 찾은 top 15 pharma 제외하면 좀더 적은 숫자). manually 탐색 후 입력
>>> 2024-08-10 Done
>>> 43개는 인터넷에서 자료를 못 찾음 
{
	clear
	use "E:\ARK\as of Jul 2024\[105] develop (gvkey) - parent (gvkey).dta"
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


### FROM HERE 2024-08-10
*(To-do #1) [200] [300] data 다시 만들기 (이유: [105] data 내용 변경됨) --> Done
{
	*[200] data
	clear
	use "E:\ARK\as of Jul 2024\[105] develop (gvkey) - parent (gvkey).dta"
	keep id_dc develop_company id_dc_upper gvkey_dc upper_develop_company
	duplicates drop
	
	gen org = subinstr(develop_company, "amp;", "", .)
	replace org = subinstr(org, "&gt;", "", .)
	drop id_dc develop_company
	duplicates drop
	
	merge 1:m org using "E:\ARK\Preprocessing_as of Dec 2023\2024-March\[400] Patent_assignee or owner only.dta"
	drop if _merge == 2
	
	save "E:\ARK\as of Jul 2024\[200] Patent_gvkey-dc attached (patent ownership).dta"

	*[300] data
	clear
	use "E:\ARK\as of Jul 2024\[105] develop (gvkey) - parent (gvkey).dta"
	keep id_dc develop_company id_dc_upper gvkey_dc upper_develop_company
	duplicates drop
	
	gen third_party_org = subinstr(develop_company, "amp;", "", .)
	replace third_party_org = subinstr(third_party_org, "&gt;", "", .)
	drop id_dc develop_company
	duplicates drop
	
	merge 1:m third_party_org using "E:\ARK\Preprocessing_as of Dec 2023\2024-March\[500] Patent_third_party.dta"
	drop if _merge == 2
	
	save "E:\ARK\as of Jul 2024\[300] Patent_gvkey-dc attached (patent third party relationship).dta"

	
}


*(To-do #2) [200] Patent data 에 patent priority year 정보 등 patent 기본 정보 붙인 후, 연도에 따른 gvkey_dc 보정 
(Bookmark #13, #14 참고)
{
	clear
	use "E:\ARK\as of Jul 2024\[200] Patent_gvkey-dc attached (patent ownership).dta"
	gen memo = "No patent matched" if _merge == 1
	replace memo = "Patent matched" if _merge == 3
	drop _merge

	merge m:1 PatentNumber using "E:\ARK\as of Jul 2024\[200_1] Patent_priorityyear.dta"
	drop if _merge == 2
	drop _merge
	
	gen gvkey_dc_refine = gvkey_dc
	order gvkey_dc_refine, b(gvkey_dc)
	replace gvkey_dc_refine = 117298 if org == "Genzyme Molecular Oncology"
	replace gvkey_dc_refine = 15708 if org == "Allergan France SA" & priority_year == 2013

	replace gvkey_dc_refine = 15708 if org == "Allergan Inc" & priority_year <= 2014
	replace gvkey_dc_refine = 27845 if org == "Allergan Inc" & priority_year >= 2015 & !missing(priority_year)
	replace gvkey_dc_refine = 15708 if org == "Allergan Pharmaceuticals International Ltd" & priority_year <= 2014
	replace gvkey_dc_refine = 27845 if org == "Allergan Pharmaceuticals International Ltd" & priority_year >= 2015 & !missing(priority_year)
	replace gvkey_dc_refine = 27845 if org == "Allergan plc"
	replace gvkey_dc_refine = 147449 if strpos(upper_develop_company, "ALCON") & !missing(priority_year) & priority_year <= 2010
	replace gvkey_dc_refine = 147449 if strpos(upper_develop_company, "ALCON") & !missing(priority_year) & priority_year >= 2019
	replace gvkey_dc_refine = 6096 if strpos(upper_develop_company, "MALLINCKRODT MEDICAL") & !missing(priority_year) & priority_year <= 2000
	replace gvkey_dc_refine = 18086 if strpos(upper_develop_company, "MALLINCKRODT MEDICAL") & !missing(priority_year) & priority_year >= 2011
	replace gvkey_dc_refine = 13282 if strpos(upper_develop_company, "ORGANOGENESIS") & !missing(priority_year) & priority_year <= 2001
	replace gvkey_dc_refine = 61101 if strpos(upper_develop_company, "VIVENTIA") & !missing(priority_year) & priority_year <= 2004
	replace gvkey_dc_refine = 26412 if strpos(upper_develop_company, "VIVENTIA") & !missing(priority_year) & priority_year >= 2013
	replace gvkey_dc_refine = 205950 if strpos(upper_develop_company, "WARNER CHILCOTT") & !missing(priority_year) & priority_year <= 2004
	replace gvkey_dc_refine = 175163 if strpos(upper_develop_company, "WARNER CHILCOTT") & !missing(priority_year) & priority_year >= 2005
	save "E:\ARK\as of Jul 2024\[200] Patent_gvkey-dc attached (patent ownership).dta", replace

	
}
{
	clear
	use "E:\ARK\as of Jul 2024\[105] develop (gvkey) - parent (gvkey).dta"
	
	gen added_year_refine = .
	replace added_year_refine = year_subsidiary - 1 if !missing(year_subsidiary)
	replace added_year_refine = year_announce if missing(added_year_refine) & !missing(year_announce)
	replace added_year_refine = year_eventdate if missing(added_year_refine) & !missing(year_eventdate)
	replace added_year_refine = year_liner if missing(added_year_refine) & !missing( year_liner )
	
	replace gvkey_dc = . if develop_company == "Elto Pharma Inc"
	replace gvkey_dc = . if develop_company == "Sanofi Pasteur MSD"

	** added_year_refine: the year when the develop_company was announced to become a part of parent company
	*as of 2024-08-07
	*3,536: Total observation of [105] data
	*1,646 (46.55%): gvkey_dc == gvkey_parent 인 경우 (애초에 develop_company 와 parent_company 가 같은 경우) | 이 경우는 added_year 정보가 원래 필요없음. 
	*1,890 (53.45%): gvkey_dc != gvkey_parent 인 경우
		*1,357 (71.80%): gvkey_dc != gvkey_parent 인 경우 중 Manually complement 한 added_year_refine 의 개수 
		
	*as of 2024-08-12
	*3,536: Total observation of [105] data
	*1,737 (49.12%): gvkey_dc == gvkey_parent 인 경우 (애초에 develop_company 와 parent_company 가 같은 경우) | 이 경우는 added_year 정보가 원래 필요없음. 
	*1,799 (50.88%): gvkey_dc != gvkey_parent 인 경우
		*1,723 (95.78%): gvkey_dc != gvkey_parent 인 경우 중 Manually complement 한 added_year_refine 의 개수 (count if (gvkey_dc != gvkey_parent) & !missing(added_year_refine))
		*1,673 (93.00%): gvkey_dc != gvkey_parent 인 경우 중 Manually complement 한 added_year_refine 의 개수 중 joint_venture 가 아닌 것의 개수	
	
	save "E:\ARK\as of Jul 2024\[105_Aug12_ver] develop (gvkey) - parent (gvkey).dta"
	
}

[105_Aug12_ver]
>> 이 데이터에서는 develop_company 가 어떤 parent company 의 일부가 된 것이 몇 년도 부터인지 알 수 있음

[200] 
>> 이 데이터에는 develop_company (org) 가 보유한 특허와 각 특허의 priority year 정보가 있음 

**** drug development summary 에 patent data joinby
{
	clear
	use "E:\ARK\as of Jul 2024\[004] Drug_development summary (history+current)_no dups.dta"
	joinby id_cortellis using  "E:\ARK\Preprocessing_as of Dec 2023\2024-March\[001] id_cortellis_Patent data.dta", unmatched(both)	

	gen extension = 1 if strpos(DrugName, "+")
	replace extension = 1 if strpos(DrugName, "release")
	replace extension = 1 if strpos(DrugName, "formulation")
	replace extension = 1 if strpos(DrugName, "infusion")
	replace extension = 1 if strpos(DrugName, "patch")
	replace extension = 1 if strpos(DrugName, "oral")
	replace extension = 1 if strpos(DrugName, "transdermal")


	replace memo = "Only in Drug Data" if _merge == 1
	drop _merge
	
	merge m:1 develop_company using "E:\ARK\as of Jul 2024\[105_Aug12_ver] develop (gvkey) - parent (gvkey).dta"
	save "E:\ARK\as of Jul 2024\[005] Drug_development summary (CURRENT+HISTORY) + patent.dta", replace
	
	### FROM HERE 2024-08-13
	(2) added_year_refine 정보 활용해서 gvkey_dc_refine 변수 생성 
	- 예전에 만들어놓은 코드 참조 
	
	***** [step 1] Compare added_year_refine (the year when develop_company is announced to become a part of Parent company) and drug development year
	*[When develop_company == ParentCompanyName]
	gen gvkey_dc_refine = gvkey_parent if (gvkey_dc == gvkey_parent) 
		
	*[When develop_company != ParentCompanyName]
		*[step 2] (added_year_refine >= develop_year), 
		*    	  implying that the develop_company developed the drug before adding to the parent company,
		*		  thus, the drug is developed by the develop_company
		*[step 3] (added_year_refine < develop_year),
		*		  implying that the develop_company develops the drug after adding to the parent company,
		*		  thus, the drug is developed by the parent company (==ParentCompanyName)
	
	replace gvkey_dc_refine = gvkey_dc     if (added_year_refine >= develop_year) & !missing(added_year_refine) & !missing(develop_year) & (gvkey_dc != gvkey_parent) 
	replace gvkey_dc_refine = gvkey_parent if (added_year_refine <  develop_year) & !missing(added_year_refine) & !missing(develop_year) & (gvkey_dc != gvkey_parent) 
	save "E:\ARK\as of Jul 2024\[005] Drug_development summary (CURRENT+HISTORY) + patent.dta", replace

	
	clear
	use "E:\ARK\as of Jul 2024\[005] Drug_development summary (CURRENT+HISTORY) + patent.dta"
	
	replace gvkey_dc_refine = gvkey_parent if joint_venture ==1 & missing(gvkey_dc_refine)
	gen tic = 1 if !missing(gvkey_dc_refine)
	 
	drop if tic != 1
	drop tic

	drop develop_original
	duplicates drop
	
	*Bookmark #2 에 적힌 내용 apply
	replace gvkey_dc_refine = . if id_dc_upper == 349
	replace gvkey_dc_refine = 36049 if strpos(upper_develop_company, "PPD")
	replace gvkey_dc_refine = gvkey_parent if develop_company == "Elto Pharma Inc"
	replace gvkey_dc_refine = gvkey_parent if develop_company == "Sanofi Pasteur MSD"
	replace added_year_refine = 2001 if id_dc_upper == 441
	replace added_year_refine = 1990 if id_dc_upper == 675
	replace added_year_refine = 2014 if id_dc_upper == 1257
	replace year_liner = 1990 if id_dc_upper == 675
	replace year_subsidiary = 1994 if develop_company == "McNeil Pharmaceuticals Inc"
	replace year_liner = 1993 if develop_company == "McNeil Pharmaceuticals Inc"
	replace year_subsidiary = 2008 if develop_company == "McNeil Consumer Products Co"
	replace year_liner = 2007 if develop_company == "McNeil Consumer Products Co"
	replace upper_develop_company = "MCNEIL PHARMA" if develop_company == "McNeil Pharmaceuticals Inc"
	replace upper_develop_company = "MCNEIL CONSUMER" if develop_company == "McNeil Consumer Products Co"
	replace id_dc_upper = 2774 if develop_company == "McNeil Consumer Products Co"
	replace gvkey_dc_refine = 12233 if id_dc_upper == 1127 
	replace added_year_refine = 2003 if id_dc_upper == 2599

	replace gvkey_dc_refine = 121742 if strpos(develop_company, "Genzyme Surgical Products")
	replace gvkey_dc_refine = 117298 if strpos(develop_company, "Genzyme Molecular Oncology") & !missing( develop_year) & develop_year < 2002
	replace gvkey_dc_refine = 117298 if strpos(develop_company, "Genzyme Molecular Oncology") & !missing( develop_year) & develop_year <= 2002
	replace gvkey_dc_refine = 12233 if strpos(develop_company, "Genzyme Molecular Oncology") & !missing( develop_year) & develop_year >= 2003
	replace gvkey_dc_refine = 15708 if strpos(develop_company, "Allergan Inc") & !missing( develop_year) & develop_year <= 2014
	replace gvkey_dc_refine = 15708 if strpos(develop_company, "Allergan Pharmaceuticals Ireland") & !missing( develop_year) & develop_year <= 2014
	replace gvkey_dc_refine = 15708 if strpos(develop_company, "Allergan-Lok Productos Farmaceuticos Ltd") & !missing( develop_year) & develop_year <= 2014
	replace gvkey_dc_refine = 15708 if strpos(develop_company, "Allergan France SA") & !missing( develop_year) & develop_year <= 2014
	replace gvkey_dc_refine = 15708 if strpos(develop_company, "Allergan Pharmaceuticals International Ltd") & !missing( develop_year) & develop_year <= 2014
	replace gvkey_dc_refine = 27845 if strpos(develop_company, "Allergan Inc") & !missing( develop_year) & develop_year >= 2015
	replace gvkey_dc_refine = 27845 if strpos(develop_company, "Allergan Pharmaceuticals Ireland") & !missing( develop_year) & develop_year >= 2015
	replace gvkey_dc_refine = 27845 if strpos(develop_company, "Allergan-Lok Productos Farmaceuticos Ltd") & !missing( develop_year) & develop_year >= 2015
	replace gvkey_dc_refine = 27845 if strpos(develop_company, "Allergan France SA") & !missing( develop_year) & develop_year >= 2015
	replace gvkey_dc_refine = 27845 if strpos(develop_company, "Allergan Pharmaceuticals International Ltd") & !missing( develop_year) & develop_year >= 2015
	replace gvkey_dc_refine = 27845 if strpos(develop_company, "Allergan plc")
	replace gvkey_dc_refine = 61952 if strpos(develop_company, "Allergan Ligand Retinoid Therapeutics Inc") & !missing( develop_year) & develop_year <= 1006
	replace gvkey_dc_refine = 61952 if strpos(develop_company, "Allergan Ligand Retinoid Therapeutics Inc") & !missing( develop_year) & develop_year <= 1996
	replace gvkey_dc_refine = . if strpos(develop_company, "Allergan Ligand Retinoid Therapeutics Inc") & !missing( develop_year) & develop_year >= 1997
	replace gvkey_dc_refine = 66616 if strpos(develop_company, "Allergan Specialty Therapeutics Inc") & !missing( develop_year) & develop_year <= 2000
	replace gvkey_dc_refine = 15708 if strpos(develop_company, "Allergan Specialty Therapeutics Inc") & !missing( develop_year) & develop_year >= 2001
	replace gvkey_dc_refine = 6096 if strpos(upper_develop_company, "MALLINCKRODT MEDICAL") & !missing( develop_year) & develop_year <= 2000
	replace gvkey_dc_refine = 18086 if strpos(upper_develop_company, "MALLINCKRODT MEDICAL") & !missing( develop_year) & develop_year >= 2011
	replace gvkey_dc_refine = 13282 if strpos(upper_develop_company, "ORGANOGENESIS") & !missing( develop_year) & develop_year <= 2001
	replace gvkey_dc_refine = 34562 if strpos(upper_develop_company, "ORGANOGENESIS") & !missing( develop_year) & develop_year >= 2015
	replace gvkey_dc_refine = 61101 if strpos(upper_develop_company, "VIVENTIA BIO") & !missing( develop_year) & develop_year <= 2004
	replace gvkey_dc_refine = 26412 if strpos(upper_develop_company, "VIVENTIA BIO") & !missing( develop_year) & develop_year >= 2013
	replace gvkey_dc_refine = 205950 if strpos(upper_develop_company, "WARNER CHILCOTT PLC") & !missing( develop_year) & develop_year <= 2004
	replace gvkey_dc_refine = 175163 if strpos(upper_develop_company, "WARNER CHILCOTT PLC") & !missing( develop_year) & develop_year >= 2005
	replace gvkey_dc_refine = 27845 if strpos(develop_company, "Allergan Pharmaceuticals Ireland") & !missing( develop_year) & develop_year >= 2015

	replace gvkey_dc_refine = 147449 if strpos(upper_develop_company, "ALCON") & !missing( develop_year) & develop_year <= 2010
	replace gvkey_dc_refine = 35056 if strpos(upper_develop_company, "ALCON") & !missing( develop_year) & develop_year >= 2019
	replace gvkey_dc_refine = 101310 if strpos(upper_develop_company, "ALCON") & !missing(develop_year) & develop_year >= 2011 & develop_year <= 2018

	drop if missing(gvkey_dc_refine)

	gen develop_status_num = 1 if strpos(develop_status, "Discovery")
	replace develop_status_num = 2 if strpos(develop_status, "Preclinical")
	replace develop_status_num = 3 if strpos(develop_status, "Phase 1")
	replace develop_status_num = 4 if strpos(develop_status, "Phase 2")
	replace develop_status_num = 5 if strpos(develop_status, "Phase 3")
	replace develop_status_num = 6 if strpos(develop_status, "Pre-registration")
	replace develop_status_num = 7 if strpos(develop_status, "Registered")
	replace develop_status_num = 8 if strpos(develop_status, "Launched")
	
	gen develop_status_num_other = 1 if develop_status == " Clinical"
	replace develop_status_num_other = 2 if strpos(develop_status, "Suspended")
	replace develop_status_num_other = 3 if strpos(develop_status, "No Development Reported")
	replace develop_status_num_other = 4 if strpos(develop_status, "Discontinued")
	replace develop_status_num_other = 5 if strpos(develop_status, "Withdrawn")
	replace develop_status_num_other = 6 if strpos(develop_status, "Outlicensed")
		
	
	bysort gvkey_dc_refine id_cortellis PatentNumber develop_indication  develop_status_num (develop_year ): gen cnt = _n	
	bysort gvkey_dc_refine id_cortellis PatentNumber develop_indication  develop_status_num_other (develop_year ): gen cnt_2 = _n
	
	sort gvkey_dc_refine id_cortellis PatentNumber develop_indication  develop_status_num develop_year cnt
	gen cnt_3 = (cnt == 1 | cnt_2 == 1)
		
	keep if cnt_3 == 1
	drop if upper_Parent == "RECKITT BENCKISER PLC"
	save "E:\ARK\as of Jul 2024\[005_1] (earliest year in each phase only) Drug_development summary (CURRENT+HISTORY) + patent.dta"
}

*특허 말고 id_cortellis 기준으로 해보자  >> [005_2]
{
	clear
	use "E:\ARK\as of Jul 2024\[005_1] (earliest year in each phase only) Drug_development summary (CURRENT+HISTORY) + patent.dta"
	distinct id_cortellis

				  |        Observations
				  |      total   distinct
	--------------+----------------------
	 id_cortellis |     479458      32127

	. distinct id_cortellis if !missing(PatentNumber)

				  |        Observations
				  |      total   distinct
	--------------+----------------------
	 id_cortellis |     399251       8714

	. distinct id_cortellis if missing(PatentNumber)

				  |        Observations
				  |      total   distinct
	--------------+----------------------
	 id_cortellis |      80207      23413

	
	 
	 drop memo PatentNumber Drug_patent_original PatentType DrugsRelationshipType pat_Product_deri pat_Product OwnerCompaniesRelationshipTy FirstPriorityDate yr_priority Drugs_original cnt_2 cnt
	duplicates drop
	
	merge m:1 id_cortellis using "E:\ARK\as of Jul 2024\[006_1] Drug_Failure reason.dta"
	drop if _merge == 2
	drop _merge 
	sort gvkey_dc_refine id_cortellis  develop_indication  develop_status_num develop_year cnt
	
	save "E:\ARK\as of Jul 2024\[005_2] (without patent) (earliest year in each phase only) Drug_development summary (CURRENT+HISTORY).dta"
	
	
	}
*[005_2] expand >> [005_3]
{
	clear
	use "E:\ARK\as of Jul 2024\[005_2] (without patent) (earliest year in each phase only) Drug_development summary (CURRENT+HISTORY).dta"
	
	gen tag = 1 if (added_year_refine >= develop_year) & (gvkey_dc != gvkey_parent)
	order tag 
	expand 2 if tag == 1 
	
	gen tag_expanded = 1 in 166171/198410
	replace gvkey_dc_refine = gvkey_parent if tag_expanded == 1

	gen develop_year_refine = develop_year
	replace develop_year_refine = (added_year_refine + 1) if tag_expanded == 1
	
	gen external = 1 if tag_expanded == 1
	replace external = 0 if missing(external)
	label variable external "Added as a result of M&A"
	
	<Alcon: independent -> part of Novartis (2010~2019) -> independent (2019~)
	- upper_develop_company: ALCON
		- ~2010 : gvkey 147449
		- 2011~2018: part of Novartis
		- 2019~ : gvkey 35056

	gen tag_ALCON = 1 if strpos(upper_develop_company, "ALCON") & !missing(develop_year) & develop_year <= 2010
	expand 2 if tag_ALCON == 1
	
	gen tag_ALCON_expanded = 1 in 198411/~
	replace gvkey_dc_refine = 101310 if tag_ALCON_expanded == 1
	replace develop_year_refine = 2011 if tag_ALCON_expanded == 1
	
	drop tag_ALCON tag_ALCON_expanded
	
	
	
		
	
	sort gvkey_dc_refine id_cortellis develop_indication  develop_status_num develop_status_num_other

	
	
	save "E:\ARK\as of Jul 2024\[005_3] (expanded) (without patent) (earliest year in each phase only) Drug_development summary.dta"

	
}
	


*Drug failure reason
{
	clear
	use "E:\ARK\Original data\Cortellis_Drug original (dta_format).dta"
	keep id_cortellis FirstParagraphofSummary
	duplicates drop

	merge 1:m id_cortellis using "E:\ARK\as of Jul 2024\[004] Drug_development summary (history+current)_no dups.dta"
	tab FirstParagraphofSummary if _merge == 1
	drop if _merge == 1
	
	*Reason of failure // Source: https://www.nature.com/articles/nrd.2016.184
	*"The majority of failures were due to a lack of either efficacy (52%) or safety (24%) ... Strategic (15%), commercial (6%) and operational (3%) reasons were cited for the remainder of the failures"
	*"the highest percentages of failure were in oncology (32%), CNS disease (16%) and musculoskeletal diseases (13%), with addiotional contributions from ..."
	*"Failures for strategic reasons such as a change in therapeutic focus or being dropped owing to mergers..."

	*Strategic reason (pipeline focus, pipeline (de)prioritization // being dropped owing to mergers) 
	gen reason_fail_pipeline =  strpos(FirstParagraphofSummary, "deprioritize") & (develop_status == " Discontinued" | develop_status == " Suspended" | develop_status == " No Development Reported") & !strpos(FirstParagraphofSummary, "Halozyme")
	replace reason_fail_pipeline = 1 if strpos(FirstParagraphofSummary, "focus on") & (develop_status == " Discontinued" | develop_status == " Suspended" | develop_status == " No Development Reported") & !strpos(FirstParagraphofSummary, "pipeline") & reason_fail_pipeline == 0 & !strpos(FirstParagraphofSummary, "Allelix Neuro") & !strpos(FirstParagraphofSummary, "BioCryst") & !strpos(FirstParagraphofSummary, "Biogen , under license from Pfizer ,") & !strpos(FirstParagraphofSummary, "Can-Fite BioPharma ,") & !strpos(FirstParagraphofSummary, "ICOS and Biogen were") & !strpos(FirstParagraphofSummary, "Incyte Co is developing") & !strpos(FirstParagraphofSummary, "Inspire was developing the second-gen") & !strpos(FirstParagraphofSummary, "Kronos Bio , following a drug asset") & !strpos(FirstParagraphofSummary, "Mirati Therapeutics (formerly MethylG")  & !strpos(FirstParagraphofSummary, "PolyMedix was developing delparantag")  & !strpos(FirstParagraphofSummary, "TCR2 Therapeutics was") & !strpos(FirstParagraphofSummary, "Takeda Pharmaceutical and licensees M")
	replace reason_fail_pipeline = 1  if strpos(FirstParagraphofSummary, "in favor of") & (develop_status == " Discontinued" | develop_status == " Suspended" | develop_status == " No Development Reported") & reason_fail_pipeline == 0 & !strpos(FirstParagraphofSummary, "BioCryst Pharmaceuticals , under lice")
	replace reason_fail_pipeline = 1  if strpos(FirstParagraphofSummary, "restruct") & (develop_status == " Discontinued" | develop_status == " Suspended" | develop_status == " No Development Reported") & !strpos(FirstParagraphofSummary, "VDDI")
	replace reason_fail_pipeline = 1 if strpos(FirstParagraphofSummary, "reorgani") & (develop_status == " Discontinued" | develop_status == " Suspended" | develop_status == " No Development Reported") & reason_fail_pipeline == 0 & !strpos(FirstParagraphofSummary, "Promore Pharma")
	replace reason_fail_pipeline = 1 if strpos(FirstParagraphofSummary, "focus on") & (develop_status == " Discontinued" | develop_status == " Suspended" | develop_status == " No Development Reported") & strpos(FirstParagraphofSummary, "pipeline") & reason_fail_pipeline == 0 & !strpos(FirstParagraphofSummary, "Hybridon") & !strpos(FirstParagraphofSummary, "ReNeuron")
	replace reason_fail_pipeline = 1 if strpos(FirstParagraphofSummary, "focus resources on") & reason_fail_pipeline == 0 & !strpos(FirstParagraphofSummary, "Innovation Pharma")
	replace reason_fail_pipeline = 1  if strpos(FirstParagraphofSummary, "focus its resources") & reason_fail_pipeline == 0
	replace reason_fail_pipeline = 1  if strpos( FirstParagraphofSummary, "Jerini was investigating JSM-10292, a")
		
	*market opportunity
	gen reason_fail_market = strpos(FirstParagraphofSummary, "market") & strpos(FirstParagraphofSummary, "oppor") & (develop_status == " Discontinued" | develop_status == " Suspended" | develop_status == " No Development Reported") & !strpos(FirstParagraphofSummary, "Romark , with")
	replace reason_fail_market = 1 if strpos(FirstParagraphofSummary, "ommercial") & strpos(FirstParagraphofSummary, "oppor") & (develop_status == " Discontinued" | develop_status == " Suspended" | develop_status == " No Development Reported") & reason_fail_market == 0 & !strpos(FirstParagraphofSummary, "Antigenics") & !strpos(FirstParagraphofSummary, "Processa Pharma") & !strpos(FirstParagraphofSummary, "Zealand Pharma")
	replace reason_fail_market = 1 if strpos(FirstParagraphofSummary, "Samsung Bioepis, formerly in partners")
	replace reason_fail_market = 1 if strpos(FirstParagraphofSummary, "limited usage")
	replace reason_fail_market = 1 if strpos(FirstParagraphofSummary, "poor sale") & strpos(FirstParagraphofSummary, "GlaxoSmithKline")
	
	*commercial viability (e.g., the costs associated with the development of the drug were not appropriate for a company of its size; costly development project)
	gen reason_fail_cost = strpos(FirstParagraphofSummary, " cost") & (develop_status == " Discontinued" | develop_status == " Suspended" | develop_status == " No Development Reported") & reason_fail_pipeline == 0 & !strpos(FirstParagraphofSummary, "Amgen") & !strpos(FirstParagraphofSummary, "costimula") & !strpos(FirstParagraphofSummary, "Dynavax")
	
	*Operational reason (company bankruptcy)
	gen reason_fail_bankrupt     =  strpos( FirstParagraphofSummary, "ankruptcy") & !strpos(FirstParagraphofSummary, "MultiVir (previously known as p53)") & (develop_status == " Discontinued" | develop_status == " Suspended" | develop_status == " No Development Reported") & !strpos(FirstParagraphofSummary, "Oxandrolone") & !strpos(FirstParagraphofSummary, "Centrexion") & !strpos(FirstParagraphofSummary, "Crealta (now")
	replace reason_fail_bankrupt = 1 if strpos( FirstParagraphofSummary, "liquidate") &  (develop_status == " Discontinued" | develop_status == " Suspended" | develop_status == " No Development Reported") & !strpos(FirstParagraphofSummary, "MultiVir (previously known as p53)") & !strpos(FirstParagraphofSummary, "Norgine")
	replace reason_fail_bankrupt = 1 if strpos(FirstParagraphofSummary, "dissolved") & !strpos(FirstParagraphofSummary, "Leuprorelin acetate")
	replace reason_fail_bankrupt = 1 if strpos(FirstParagraphofSummary, "Portola Pharmaceuticals (now a wholly owned subsidiary of Alexion), under license from Takeda Oncology (formerly known as Millennium Pharmaceuticals), had developed and launched betrixaban (Bevyxxa; Dexxience; PRT-54021; PRT-021; structure shown), ")
	replace reason_fail_bankrupt = 1 if strpos(FirstParagraphofSummary, "NsGene was developing Neublastin (Art") & reason_fail_bankrupt == 0
	replace reason_fail_bankrupt = 1 if strpos(FirstParagraphofSummary, "deCODE genetics (now DGI Resolution)") & reason_fail_bankrupt == 0
	
	*Other reasons
	gen reason_fail_other = strpos(FirstParagraphofSummary, "no longer being manufactured") // no longer manufactured
	
	drop _merge
	rename FirstParagraphofSummary Drug_Summary
	keep id_cortellis Drug_Summary reason_fail_pipeline - reason_fail_other
	duplicates drop
	
	gsort id_cortellis -reason_fail_market
	by id_cortellis: replace reason_fail_market = reason_fail_market[1]
	gsort id_cortellis -reason_fail_pipeline
	by id_cortellis: replace reason_fail_pipeline = reason_fail_pipeline[1]
	gsort id_cortellis -reason_fail_cost
	by id_cortellis: replace reason_fail_cost = reason_fail_cost[1]
	gsort id_cortellis -reason_fail_bankrupt
	by id_cortellis: replace reason_fail_bankrupt = reason_fail_bankrupt[1]
	gsort id_cortellis -reason_fail_other
	by id_cortellis: replace reason_fail_other = reason_fail_other[1]
	duplicates drop
	duplicates report id_cortellis
	
	save "E:\ARK\as of Jul 2024\[006_1] Drug_Failure reason.dta"
	
}



####as of 2024-Aug-15
####as of 2024-Aug-15
####as of 2024-Aug-15
####as of 2024-Aug-15
####as of 2024-Aug-15
####as of 2024-Aug-15
####as of 2024-Aug-15
####as of 2024-Aug-15
####as of 2024-Aug-15
**# Bookmark #6


(Step 1) (Ref: Markou et al. 2023)
We identify the first time a drug-indication project entered a given phase.
After identifying this point, we remove all subsequent, similar drug-indication-phase observations. 
{ 
	clear
	use "E:\ARK\as of Jul 2024\[004] Drug_development summary (history+current)_no dups.dta"
	sort develop_company id_cortellis develop_indication develop_status_num develop_year
	gen develop_status_num_other = 1 if develop_status == " Clinical"
	replace develop_status_num_other = 2 if strpos(develop_status, "Suspended")
	replace develop_status_num_other = 3 if strpos(develop_status, "No Development Reported")
	replace develop_status_num_other = 4 if strpos(develop_status, "Discontinued")
	replace develop_status_num_other = 5 if strpos(develop_status, "Withdrawn")
	replace develop_status_num_other = 6 if strpos(develop_status, "Outlicensed")
	drop develop_date develop_original
	duplicates drop
	
	bysort develop_company id_cortellis  develop_indication  develop_status_num (develop_year ): gen cnt = _n
	bysort develop_company id_cortellis  develop_indication  develop_status_num_other (develop_year ): gen cnt_2 = _n
	
	drop if develop_company == "."
	
	sort develop_company id_cortellis  develop_indication  develop_status_num develop_year cnt
	gen cnt_3 = (cnt == 1 | cnt_2 == 1)
	
	keep if cnt_3 == 1
	drop cnt cnt_2 cnt_3
	duplicates drop
	duplicates report develop_company id_cortellis develop_indication develop_status
	sort develop_company id_cortellis  develop_indication  develop_status_num develop_status_num_other develop_year

	save "E:\ARK\as of Jul 2024\[004_1] Drug_development summary (history+current)_no dups.dta"
}

(Step 2)
We obtain a list of all M&As and subsidiaries of each pharmaceutical, the names of which are available within Cortellis. Using the list of M&As and subsidiaries, we capture whether a drug candidate was originated within the pharmaceuticals (in-house) or was externally acquired through an M&A or a licensing deal. This is captured at the drug level. 
{
	clear
	use "E:\ARK\as of Jul 2024\[004_1] Drug_development summary (history+current)_no dups.dta"
	merge m:1 develop_company using "E:\ARK\as of Jul 2024\[105_Aug12_ver] develop (gvkey) - parent (gvkey).dta"
	
	distinct develop_company if _merge == 3

					 |        Observations
					 |      total   distinct
	-----------------+----------------------
	 develop_company |     185919       3536

	distinct develop_company if _merge == 1

					 |        Observations
					 |      total   distinct
	-----------------+----------------------
	 develop_company |     232412      15905

	drop if _merge == 1
	drop _merge
	save "E:\ARK\as of Jul 2024\[004_2] (merged with 105_Aug12_ver) Drug_development summary.dta"

	gen extension = 1 if strpos(DrugName, "+")
	replace extension = 1 if strpos(DrugName, "release")
	replace extension = 1 if strpos(DrugName, "formulation")
	replace extension = 1 if strpos(DrugName, "infusion")
	replace extension = 1 if strpos(DrugName, "patch")
	replace extension = 1 if strpos(DrugName, "oral")
	replace extension = 1 if strpos(DrugName, "transdermal")
	
	merge m:1 id_cortellis using "E:\ARK\as of Jul 2024\[006_1] Drug_Failure reason.dta"
	drop if _merge == 2
	drop _merge
	sort develop_company id_cortellis  develop_indication  develop_status_num develop_status_num_other develop_year

	merge m:1 develop_indication using "E:\ARK\Preprocessing_as of Dec 2023\Indication_TA_Markou.dta"
	drop if _merge ==2
	drop _merge
	order TA_Markou, a(develop_indication)
	drop if missing(develop_indication)

	merge m:1 id_cortellis develop_indication using "E:\ARK\as of Jul 2024\id_cortellis + TherapyArea_indication.dta"
	drop if _merge ==2
	drop _merge

	*develop_therapy (manual search from ChatGPT)
	{
		***assign therapy area based on indications
***(Step 1) Find unique values of develop_indication within each TherapyArea_indication

levelsof develop_indication if TherapyArea_indication == "Cancer", local(unique_cancer)
levelsof develop_indication if TherapyArea_indication == "Cardiovascular", local(unique_cardio)
levelsof develop_indication if TherapyArea_indication == "Dermatologic", local(unique_derma)
levelsof develop_indication if TherapyArea_indication == "Endocrine/Metabolic", local(unique_endo)
levelsof develop_indication if TherapyArea_indication == "Gastrointestinal", local(unique_gas)
levelsof develop_indication if TherapyArea_indication == "Genitourinary/Sexual Function", local(unique_geni)
levelsof develop_indication if TherapyArea_indication == "Hematologic", local(unique_hema)
levelsof develop_indication if TherapyArea_indication == "Immune", local(unique_immune)
levelsof develop_indication if TherapyArea_indication == "Infection", local(unique_infect)
levelsof develop_indication if TherapyArea_indication == "Inflammatory", local(unique_inflam)
levelsof develop_indication if TherapyArea_indication == "Musculoskeletal", local(unique_musc)
levelsof develop_indication if TherapyArea_indication == "Neurology/Psychiatric", local(unique_neuro)
levelsof develop_indication if TherapyArea_indication == "Ocular", local(unique_ocular)
levelsof develop_indication if TherapyArea_indication == "Other/Miscellaneous", local(unique_other)
levelsof develop_indication if TherapyArea_indication == "Respiratory", local(unique_resp)
levelsof develop_indication if TherapyArea_indication == "Toxicity/Intoxication", local(unique_toxic)
levelsof develop_indication if TherapyArea_indication == "Unknown", local(unique_unknown)


***(Step 2) Generate the variabel of develop_therapy and assign therapy area based on indications

gen develop_therapy = ""

foreach x of local unique_cancer {
  replace develop_therapy = "Cancer" if develop_indication == "`x'"
}

foreach x of local unique_cardio {
  replace develop_therapy = "Cardiovascular" if develop_indication == "`x'"
}

foreach x of local unique_derma {
  replace develop_therapy = "Dermatologic" if develop_indication == "`x'"
}

foreach x of local unique_endo {
  replace develop_therapy = "Endocrine/Metabolic" if develop_indication == "`x'"
}

foreach x of local unique_gas {
  replace develop_therapy = "Gastrointestinal" if develop_indication == "`x'"
}

foreach x of local unique_geni {
  replace develop_therapy = "Genitourinary/Sexual Function" if develop_indication == "`x'"
}

foreach x of local unique_hema {
  replace develop_therapy = "Hematologic" if develop_indication == "`x'"
}

foreach x of local unique_immune {
  replace develop_therapy = "Immune" if develop_indication == "`x'"
}

foreach x of local unique_infect {
  replace develop_therapy = "Infection" if develop_indication == "`x'"
}

foreach x of local unique_inflam {
  replace develop_therapy = "Inflammatory" if develop_indication == "`x'"
}

foreach x of local unique_musc {
  replace develop_therapy = "Musculoskeletal" if develop_indication == "`x'"
}

foreach x of local unique_neuro {
  replace develop_therapy = "Neurology/Psychiatric" if develop_indication == "`x'"
}

foreach x of local unique_ocular {
  replace develop_therapy = "Ocular" if develop_indication == "`x'"
}

foreach x of local unique_other {
  replace develop_therapy = "Other/Miscellaneous" if develop_indication == "`x'"
}

foreach x of local unique_resp {
  replace develop_therapy = "Respiratory" if develop_indication == "`x'"
}

foreach x of local unique_toxic {
  replace develop_therapy = "Toxicity/Intoxication" if develop_indication == "`x'"
}

foreach x of local unique_unknown {
  replace develop_therapy = "Unknown" if develop_indication == "`x'"
}


***(Step 3) Check indications if missing(develop_therapy)
>>> indication that is classified into multiple therapy areas
levelsof develop_indication if missing(develop_therapy), local(no_single_therapy)

*Asked Chat GPT to classify each indication
*First, train Chat GPT with already-classified diseases
levelsof develop_indication if develop_therapy == "Cancer", local(therapy_1)
levelsof develop_indication if develop_therapy == "Cardiovascular", local(therapy_2)
levelsof develop_indication if develop_therapy == "Dermatologic", local(therapy_3)
levelsof develop_indication if develop_therapy == "Endocrine/Metabolic", local(therapy_4)
levelsof develop_indication if develop_therapy == "Gastrointestinal", local(therapy_5)
levelsof develop_indication if develop_therapy == "Genitourinary/Sexual Function", local(therapy_6)
levelsof develop_indication if develop_therapy == "Hematologic", local(therapy_7)
levelsof develop_indication if develop_therapy == "Immune", local(therapy_8)
levelsof develop_indication if develop_therapy == "Infection", local(therapy_9)
levelsof develop_indication if develop_therapy == "Inflammatory", local(therapy_10)
levelsof develop_indication if develop_therapy == "Musculoskeletal", local(therapy_11)
levelsof develop_indication if develop_therapy == "Neurology/Psychiatric", local(therapy_12)
levelsof develop_indication if develop_therapy == "Ocular", local(therapy_13)
levelsof develop_indication if develop_therapy == "Other/Miscellaneous", local(therapy_14)
levelsof develop_indication if develop_therapy == "Respiratory", local(therapy_15)
levelsof develop_indication if develop_therapy == "Toxicity/Intoxication", local(therapy_16)
levelsof develop_indication if develop_therapy == "Unknown", local(therapy_17)

foreach num of numlist 1/17 {
	display "------------------------------"
	display "Result of therapy_`num'"
	foreach x of local therapy_`num' {
	display "`x'"
	}
	display "------------------------------"
}

*Second, give instruction to Chat GPT as follows:
Based on the diseases and classification I gave you, and the internet sources that you can visit, classify the diseases I am going to give you. Each disease I am going to give you must be classified into either of  Cancer, 
Cardiovascular,  Dermatologic, Endocrine/Metabolic, Gastrointestinal, Genitourinary/Sexual Function, Hematologic, Immune, Infection, Inflammatory, Musculoskeletal, Neurology/Psychiatric, Ocular, Other/Miscellaneous, Respiratory, Toxicity/Intoxication.

Do not classify the disease into therapy areas that I did not give you. You must classify the disease I am going to give you to the most appropriate therapy area. And your choice of therapy area must be either of Cancer, 
Cardiovascular,  Dermatologic, Endocrine/Metabolic, Gastrointestinal, Genitourinary/Sexual Function, Hematologic, Immune, Infection, Inflammatory, Musculoskeletal, Neurology/Psychiatric, Ocular, Other/Miscellaneous, Respiratory, Toxicity/Intoxication.

The code format must be:

replace develop_therapy = "the therapy area you are going to enter" if develop_indication == " the disease name I am going to give you"

For each disease name, make sure to enter one space before each disease name.

{
Cancer
Cardiovascular
Dermatologic
Endocrine/Metabolic
Gastrointestinal
Genitourinary/Sexual Function
Hematologic
Immune
Infection
Inflammatory
Musculoskeletal
Neurology/Psychiatric
Ocular
Other/Miscellaneous
Respiratory
Toxicity/Intoxication
Unknown
}
{
replace develop_therapy = "Immune" if develop_indication == " AIDS related complex"
replace develop_therapy = "Hematologic" if develop_indication == " AL amyloidosis"
replace develop_therapy = "Infection" if develop_indication == " Abdominal abscess"
replace develop_therapy = "Cardiovascular" if develop_indication == " Abdominal aortic aneurysm"
replace develop_therapy = "Infection" if develop_indication == " Abscess"
replace develop_therapy = "Neurology/Psychiatric" if develop_indication == " Absence seizure"
replace develop_therapy = "Gastrointestinal" if develop_indication == " Achalasia"
replace develop_therapy = "Musculoskeletal" if develop_indication == " Achondroplasia"
replace develop_therapy = "Inflammatory" if develop_indication == " Acidosis"
replace develop_therapy = "Infection" if develop_indication == " Acinetobacter baumannii infection"
replace develop_therapy = "Infection" if develop_indication == " Acinetobacter infection"
replace develop_therapy = "Neurology/Psychiatric" if develop_indication == " Acromegaly"
replace develop_therapy = "Infection" if develop_indication == " Actinomyces israelii infection"
replace develop_therapy = "Respiratory" if develop_indication == " Acute bronchitis"
replace develop_therapy = "Respiratory" if develop_indication == " Acute chest syndrome"
replace develop_therapy = "Cardiovascular" if develop_indication == " Acute decompensated heart failure"
replace develop_therapy = "Respiratory" if develop_indication == " Acute lung injury"
replace develop_therapy = "Respiratory" if develop_indication == " Acute sinusitis"
replace develop_therapy = "Neurology/Psychiatric" if develop_indication == " Acute stress disorder"
replace develop_therapy = "Infection" if develop_indication == " Adenovirus infection"
replace develop_therapy = "Musculoskeletal" if develop_indication == " Adhesive capsulitis"
replace develop_therapy = "Endocrine/Metabolic" if develop_indication == " Adrenal disease"
replace develop_therapy = "Endocrine/Metabolic" if develop_indication == " Adrenal gland tumor"
replace develop_therapy = "Neurology/Psychiatric" if develop_indication == " Adrenoleukodystrophy"
replace develop_therapy = "Neurology/Psychiatric" if develop_indication == " Adrenomyeloneuropathy"
replace develop_therapy = "Hematologic" if develop_indication == " Adult T-cell lymphoma"
replace develop_therapy = "Inflammatory" if develop_indication == " Adult onset Stills disease"
replace develop_therapy = "Respiratory" if develop_indication == " Adult respiratory distress syndrome"
replace develop_therapy = "Musculoskeletal" if develop_indication == " Aggressive fibromatosis"
replace develop_therapy = "Other/Miscellaneous" if develop_indication == " Aging"
replace develop_therapy = "Immune" if develop_indication == " Albuminuria"
replace develop_therapy = "Toxicity/Intoxication" if develop_indication == " Alcohol withdrawal syndrome"
replace develop_therapy = "Immune" if develop_indication == " Alcoholic hepatitis"
replace develop_therapy = "Immune" if develop_indication == " Alcoholic liver disease"
replace develop_therapy = "Immune" if develop_indication == " Allergy"
replace develop_therapy = "Dermatologic" if develop_indication == " Alopecia"
replace develop_therapy = "Genitourinary/Sexual Function" if develop_indication == " Alpha-1 antitrypsin deficiency"
replace develop_therapy = "Other/Miscellaneous" if develop_indication == " Alport syndrome"
replace develop_therapy = "Gastrointestinal" if develop_indication == " Alternating stool pattern irritable bowel syndrome"
replace develop_therapy = "Infection" if develop_indication == " Amoeba infection"
replace develop_therapy = "Infection" if develop_indication == " Anal dysplasia"
replace develop_therapy = "Hematologic" if develop_indication == " Angioimmunoblastic T-cell lymphoma"
replace develop_therapy = "Other/Miscellaneous" if develop_indication == " Angiomyolipoma"
replace develop_therapy = "Musculoskeletal" if develop_indication == " Ankylosing spondylitis"
replace develop_therapy = "Immune" if develop_indication == " Antiphospholipid syndrome"
replace develop_therapy = "Neurology/Psychiatric" if develop_indication == " Antisocial personality disorder"
replace develop_therapy = "Gastrointestinal" if develop_indication == " Appendicitis"
replace develop_therapy = "Gastrointestinal" if develop_indication == " Appendix adenoma"
replace develop_therapy = "Other/Miscellaneous" if develop_indication == " Appetite loss"
replace develop_therapy = "Cardiovascular" if develop_indication == " Arterial thrombosis"
replace develop_therapy = "Cardiovascular" if develop_indication == " Artery disease"
replace develop_therapy = "Gastrointestinal" if develop_indication == " Ascites"
replace develop_therapy = "Neurology/Psychiatric" if develop_indication == " Asperger syndrome"
replace develop_therapy = "Genitourinary/Sexual Function" if develop_indication == " Atrophic vaginitis"
replace develop_therapy = "Musculoskeletal" if develop_indication == " Atrophy"
replace develop_therapy = "Other/Miscellaneous" if develop_indication == " Atypical hemolytic uremic syndrome"
replace develop_therapy = "Neurology/Psychiatric" if develop_indication == " Autoimmune encephalomyelitis"

replace develop_therapy = "Immune" if develop_indication == " Autoinflammatory disease"
replace develop_therapy = "Other/Miscellaneous" if develop_indication == " Autosomal dominant disorder"
replace develop_therapy = "Other/Miscellaneous" if develop_indication == " Autosomal recessive polycystic kidney disease"
replace develop_therapy = "Musculoskeletal" if develop_indication == " Back pain"
replace develop_therapy = "Cardiovascular" if develop_indication == " Bacterial endocarditis"
replace develop_therapy = "Ocular" if develop_indication == " Bacterial eye infection"
replace develop_therapy = "Infection" if develop_indication == " Bacteroides caccae infection"
replace develop_therapy = "Infection" if develop_indication == " Bacteroides fragilis infection"
replace develop_therapy = "Infection" if develop_indication == " Bacteroides infection"
replace develop_therapy = "Infection" if develop_indication == " Bacteroides thetaiotaomicron infection"
replace develop_therapy = "Infection" if develop_indication == " Bacteroides uniformis infection"
replace develop_therapy = "Infection" if develop_indication == " Bacteroides vulgatus infection"
replace develop_therapy = "Gastrointestinal" if develop_indication == " Barretts esophagus"
replace develop_therapy = "Other/Miscellaneous" if develop_indication == " Barth syndrome"
replace develop_therapy = "Infection" if develop_indication == " Bartonella bacilliformis infection"
replace develop_therapy = "Dermatologic" if develop_indication == " Basal cell carcinoma"
replace develop_therapy = "Other/Miscellaneous" if develop_indication == " Basal cell nevus syndrome"
replace develop_therapy = "Neurology/Psychiatric" if develop_indication == " Becker muscular dystrophy"
replace develop_therapy = "Immune" if develop_indication == " Behcets disease"
replace develop_therapy = "Genitourinary/Sexual Function" if develop_indication == " Bladder pain"
replace develop_therapy = "Ocular" if develop_indication == " Blepharitis"
replace develop_therapy = "Ocular" if develop_indication == " Blepharospasm"
replace develop_therapy = "Musculoskeletal" if develop_indication == " Bone and joint infection"
replace develop_therapy = "Hematologic" if develop_indication == " Bone marrow depression"
replace develop_therapy = "Hematologic" if develop_indication == " Bone marrow disease"
replace develop_therapy = "Hematologic" if develop_indication == " Bone marrow transplantation"
replace develop_therapy = "Musculoskeletal" if develop_indication == " Bone resorption"
replace develop_therapy = "Infection" if develop_indication == " Borrelia burgdorferi infection"
replace develop_therapy = "Infection" if develop_indication == " Borrelia recurrentis infection"
replace develop_therapy = "Neurology/Psychiatric" if develop_indication == " Brain injury"
replace develop_therapy = "Neurology/Psychiatric" if develop_indication == " Brain ischemia"
replace develop_therapy = "Cancer" if develop_indication == " Breast disease"
replace develop_therapy = "Respiratory" if develop_indication == " Bronchiolitis"
replace develop_therapy = "Respiratory" if develop_indication == " Bronchitis"
replace develop_therapy = "Respiratory" if develop_indication == " Bronchus disease"
replace develop_therapy = "Infection" if develop_indication == " Brucella infection"
replace develop_therapy = "Other/Miscellaneous" if develop_indication == " Bulimia nervosa"
replace develop_therapy = "Dermatologic" if develop_indication == " Bullous pemphigoid"
replace develop_therapy = "Infection" if develop_indication == " Burkholderia infection"

replace develop_therapy = "Immune" if develop_indication == " C3 glomerulopathy"
replace develop_therapy = "Cardiovascular" if develop_indication == " Cachexia"
replace develop_therapy = "Musculoskeletal" if develop_indication == " Calcification"
replace develop_therapy = "Infection" if develop_indication == " Campylobacter fetus infection"
replace develop_therapy = "Infection" if develop_indication == " Campylobacter jejuni infection"
replace develop_therapy = "Infection" if develop_indication == " Candida albicans infection"
replace develop_therapy = "Toxicity/Intoxication" if develop_indication == " Cannabis dependence"
replace develop_therapy = "Endocrine/Metabolic" if develop_indication == " Carbohydrate metabolism disorder"
replace develop_therapy = "Cancer" if develop_indication == " Carcinoid syndrome"
replace develop_therapy = "Cancer" if develop_indication == " Carcinosarcoma"
replace develop_therapy = "Cardiovascular" if develop_indication == " Cardiac hypertrophy"
replace develop_therapy = "Cardiovascular" if develop_indication == " Carditis"
replace develop_therapy = "Immune" if develop_indication == " Castleman's disease"
replace develop_therapy = "Gastrointestinal" if develop_indication == " Celiac disease"
replace develop_therapy = "Other/Miscellaneous" if develop_indication == " Cellulite"
replace develop_therapy = "Infection" if develop_indication == " Cellulitis"
replace develop_therapy = "Neurology/Psychiatric" if develop_indication == " Cerebral hemorrhage"
replace develop_therapy = "Genitourinary/Sexual Function" if develop_indication == " Cervical dysplasia"
replace develop_therapy = "Musculoskeletal" if develop_indication == " Cervical dystonia"
replace develop_therapy = "Infection" if develop_indication == " Charcot Marie Tooth disease"
replace develop_therapy = "Infection" if develop_indication == " Chlamydia infection"
replace develop_therapy = "Infection" if develop_indication == " Chlamydia pneumoniae infection"
replace develop_therapy = "Infection" if develop_indication == " Chlamydia trachomatis infection"
replace develop_therapy = "Hematologic" if develop_indication == " Cholestasis"
replace develop_therapy = "Cancer" if develop_indication == " Choriocarcinoma"
replace develop_therapy = "Ocular" if develop_indication == " Chorioretinitis"
replace develop_therapy = "Ocular" if develop_indication == " Choroiditis"
replace develop_therapy = "Neurology/Psychiatric" if develop_indication == " Chronic fatigue syndrome"
replace develop_therapy = "Neurology/Psychiatric" if develop_indication == " Chronic inflammatory demyelinating polyneuropathy"
replace develop_therapy = "Hematologic" if develop_indication == " Chronic leukemia"
replace develop_therapy = "Respiratory" if develop_indication == " Chronic sinusitis"
replace develop_therapy = "Immune" if develop_indication == " Churg-Strauss syndrome"
replace develop_therapy = "Infection" if develop_indication == " Citrobacter infection"
replace develop_therapy = "Infection" if develop_indication == " Clostridiaceae infection"
replace develop_therapy = "Infection" if develop_indication == " Clostridium infection"
replace develop_therapy = "Hematologic" if develop_indication == " Coagulation factor X deficiency"
replace develop_therapy = "Infection" if develop_indication == " Cold agglutinin disease"
replace develop_therapy = "Infection" if develop_indication == " Common cold"
replace develop_therapy = "Other/Miscellaneous" if develop_indication == " Compensated liver cirrhosis"
replace develop_therapy = "Neurology/Psychiatric" if develop_indication == " Complex partial seizure"
replace develop_therapy = "Neurology/Psychiatric" if develop_indication == " Complex regional pain syndrome"
replace develop_therapy = "Infection" if develop_indication == " Complicated urinary tract infection"
replace develop_therapy = "Neurology/Psychiatric" if develop_indication == " Compulsive gambling"
replace develop_therapy = "Endocrine/Metabolic" if develop_indication == " Congenital adrenal hyperplasia"
replace develop_therapy = "Cardiovascular" if develop_indication == " Congenital heart defect"
replace develop_therapy = "Ocular" if develop_indication == " Conjunctival neoplasm"
replace develop_therapy = "Ocular" if develop_indication == " Connective tissue disease"
replace develop_therapy = "Ocular" if develop_indication == " Corneal transplant rejection"
replace develop_therapy = "Cardiovascular" if develop_indication == " Coronary atherosclerosis"
replace develop_therapy = "Cardiovascular" if develop_indication == " Coronary thrombosis"
replace develop_therapy = "Infection" if develop_indication == " Corynebacterium infection"
replace develop_therapy = "Infection" if develop_indication == " Coxsackie virus infection"
replace develop_therapy = "Immune" if develop_indication == " Cryopyrin associated periodic syndrome"
replace develop_therapy = "Infection" if develop_indication == " Cryptococcus neoformans infection"
replace develop_therapy = "Infection" if develop_indication == " Cryptococcus neoformans meningitis"
replace develop_therapy = "Infection" if develop_indication == " Cryptosporidium infection"
replace develop_therapy = "Endocrine/Metabolic" if develop_indication == " Cushings disease"
replace develop_therapy = "Endocrine/Metabolic" if develop_indication == " Cushings syndrome"
replace develop_therapy = "Dermatologic" if develop_indication == " Cutaneous lupus erythematosus"
}
{
replace develop_therapy = "Respiratory" if develop_indication == " Chronic thromboembolic pulmonary hypertension"
replace develop_therapy = "Hepatologic" if develop_indication == " Decompensated liver cirrhosis"
replace develop_therapy = "Dermatologic" if develop_indication == " Decubitus ulcer"
replace develop_therapy = "Cardiovascular" if develop_indication == " Deep vein thrombosis"
replace develop_therapy = "Neurology/Psychiatric" if develop_indication == " Demyelinating disease"
replace develop_therapy = "Ocular" if develop_indication == " Dermatofibrosarcoma"
replace develop_therapy = "Dermatologic" if develop_indication == " Dermatological disease"
replace develop_therapy = "Infection" if develop_indication == " Dermatomycosis"
replace develop_therapy = "Autoimmune" if develop_indication == " Dermatomyositis"
replace develop_therapy = "Dermatologic" if develop_indication == " Dermatophytosis"
replace develop_therapy = "Genetic disorder" if develop_indication == " DiGeorge syndrome"
replace develop_therapy = "Endocrine/Metabolic" if develop_indication == " Diabetic complication"
replace develop_therapy = "Renal" if develop_indication == " Diabetic nephropathy"
replace develop_therapy = "Gastrointestinal" if develop_indication == " Diarrhea"
replace develop_therapy = "Cardiovascular" if develop_indication == " Diastolic heart failure"
replace develop_therapy = "Autoimmune" if develop_indication == " Discoid lupus erythematosus"
replace develop_therapy = "Gastrointestinal" if develop_indication == " Diverticulosis"
replace develop_therapy = "Other/Miscellaneous" if develop_indication == " Down syndrome"
replace develop_therapy = "Other/Miscellaneous" if develop_indication == " Drug withdrawal syndrome"
replace develop_therapy = "Gastrointestinal" if develop_indication == " Dumping syndrome"
replace develop_therapy = "Musculoskeletal" if develop_indication == " Dupuytren contracture"
replace develop_therapy = "Gynecological" if develop_indication == " Dysmenorrhea"
replace develop_therapy = "Otic" if develop_indication == " Ear disease"
replace develop_therapy = "Genetic disorder" if develop_indication == " Ehlers Danlos syndrome"
replace develop_therapy = "Respiratory" if develop_indication == " Empyema"
replace develop_therapy = "Neurology/Psychiatric" if develop_indication == " Encephalitis"
replace develop_therapy = "Renal" if develop_indication == " End stage renal disease"
replace develop_therapy = "Cardiovascular" if develop_indication == " Endocarditis"
replace develop_therapy = "Endocrine/Metabolic" if develop_indication == " Endocrine disease"
replace develop_therapy = "Endocrine/Metabolic" if develop_indication == " Endocrine tumor"
replace develop_therapy = "Toxicity/Intoxication" if develop_indication == " Endotoxic shock"
replace develop_therapy = "Infection" if develop_indication == " Entamoeba histolytica infection"
replace develop_therapy = "Infection" if develop_indication == " Enterobacter aerogenes infection"
replace develop_therapy = "Infection" if develop_indication == " Enterobacter cloacae infection"
replace develop_therapy = "Infection" if develop_indication == " Enterobacter infection"
replace develop_therapy = "Infection" if develop_indication == " Enterococcus infection"
replace develop_therapy = "Gastrointestinal" if develop_indication == " Enterocolitis"
replace develop_therapy = "Hematologic" if develop_indication == " Eosinophilia"
replace develop_therapy = "Gastrointestinal" if develop_indication == " Eosinophilic esophagitis"
replace develop_therapy = "Immune" if develop_indication == " Erythema multiforme"
replace develop_therapy = "Immune" if develop_indication == " Erythema nodosum leprae"
replace develop_therapy = "Dermatologic" if develop_indication == " Erythematosquamous skin disease"
replace develop_therapy = "Dermatologic" if develop_indication == " Erythromelalgia"
replace develop_therapy = "Hematologic" if develop_indication == " Erythropoietic protoporphyria"
replace develop_therapy = "Infection" if develop_indication == " Escherichia coli infection"
replace develop_therapy = "Gastrointestinal" if develop_indication == " Esophageal varices"
replace develop_therapy = "Neurology/Psychiatric" if develop_indication == " Essential tremor"
replace develop_therapy = "Endocrine/Metabolic" if develop_indication == " Estrogen deficiency"
replace develop_therapy = "Gastrointestinal" if develop_indication == " Familial adenomatous polyposis"
replace develop_therapy = "Neurology/Psychiatric" if develop_indication == " Familial amyloid neuropathy"
replace develop_therapy = "Immune" if develop_indication == " Familial cold autoinflammatory syndrome"
replace develop_therapy = "Immune" if develop_indication == " Familial mediterranean fever"
replace develop_therapy = "Other/Miscellaneous" if develop_indication == " Fatigue"
replace develop_therapy = "Metabolic" if develop_indication == " Fatty acid oxidation disorder"
replace develop_therapy = "Gynecological" if develop_indication == " Female genital tract infection"
replace develop_therapy = "Gynecological" if develop_indication == " Female infertility"
replace develop_therapy = "Other/Miscellaneous" if develop_indication == " Fever"
replace develop_therapy = "Musculoskeletal" if develop_indication == " Fibrodysplasia ossificans progressiva"
replace develop_therapy = "Musculoskeletal" if develop_indication == " Fibromyalgia"
replace develop_therapy = "Other/Miscellaneous" if develop_indication == " Fibrosis"
replace develop_therapy = "Infection" if develop_indication == " Filovirus infection"
replace develop_therapy = "Renal" if develop_indication == " Focal segmental glomerulosclerosis"
replace develop_therapy = "Metabolic" if develop_indication == " Folic acid deficiency"
replace develop_therapy = "Dermatologic" if develop_indication == " Folliculitis"
replace develop_therapy = "Other/Miscellaneous" if develop_indication == " Food hypersensitivity"
replace develop_therapy = "Neurology/Psychiatric" if develop_indication == " Friedreich ataxia"
replace develop_therapy = "Neurology/Psychiatric" if develop_indication == " Frontotemporal dementia"
replace develop_therapy = "Respiratory" if develop_indication == " Fungal respiratory tract infection"
replace develop_therapy = "Infection" if develop_indication == " Fusobacterium infection"

replace develop_therapy = "Neurology/Psychiatric" if develop_indication == " GM1 gangliosidosis"
replace develop_therapy = "Neurology/Psychiatric" if develop_indication == " GM2 gangliosidosis"
replace develop_therapy = "Cancer" if develop_indication == " Ganglioneuroblastoma"
replace develop_therapy = "Gastrointestinal" if develop_indication == " Gastrointestinal function disorder"
replace develop_therapy = "Gastrointestinal" if develop_indication == " Gastrointestinal motility disorder"
replace develop_therapy = "Gastrointestinal" if develop_indication == " Gastrointestinal pain"
replace develop_therapy = "Gynecological" if develop_indication == " Genital tract infection"
replace develop_therapy = "Gynecological" if develop_indication == " Genital tract inflammation"
replace develop_therapy = "Gynecological" if develop_indication == " Genital ulcer"
replace develop_therapy = "Genitourinary/Sexual Function" if develop_indication == " Genitourinary disease"
replace develop_therapy = "Genitourinary/Sexual Function" if develop_indication == " Genitourinary tract tumor"
replace develop_therapy = "Musculoskeletal" if develop_indication == " Giant cell bone tumor"
replace develop_therapy = "Dental/Oral" if develop_indication == " Gingivitis"
replace develop_therapy = "Neurology/Psychiatric" if develop_indication == " Globoid cell leukodystrophy"
replace develop_therapy = "Renal" if develop_indication == " Glomerular disease"
replace develop_therapy = "Renal" if develop_indication == " Glomerulonephritis"
replace develop_therapy = "Inflammatory" if develop_indication == " Granuloma"
replace develop_therapy = "Cancer" if develop_indication == " Granulosa cell tumor"
replace develop_therapy = "Endocrine/Metabolic" if develop_indication == " Graves disease"
replace develop_therapy = "Neurology/Psychiatric" if develop_indication == " Guillain Barre syndrome"
replace develop_therapy = "Endocrine/Metabolic" if develop_indication == " Gynecomastia"
replace develop_therapy = "Neurology/Psychiatric" if develop_indication == " HIV associated dementia"
replace develop_therapy = "Metabolic" if develop_indication == " HIV-associated lipodystrophy"
replace develop_therapy = "Infection" if develop_indication == " Haemophilus ducreyi infection"
replace develop_therapy = "Infection" if develop_indication == " Haemophilus infection"
replace develop_therapy = "Infection" if develop_indication == " Haemophilus parainfluenzae infection"
replace develop_therapy = "Dermatologic" if develop_indication == " Hair disease"
replace develop_therapy = "Neurology/Psychiatric" if develop_indication == " Hallervorden-Spatz syndrome"
replace develop_therapy = "Otic" if develop_indication == " Hearing disorder"
replace develop_therapy = "Cardiovascular" if develop_indication == " Heart transplantation"
replace develop_therapy = "Toxicity/Intoxication" if develop_indication == " Heavy metal poisoning"
replace develop_therapy = "Neurology/Psychiatric" if develop_indication == " Hemiplegia"
replace develop_therapy = "Metabolic" if develop_indication == " Hemochromatosis"
replace develop_therapy = "Hematologic" if develop_indication == " Hemolytic anemia"
replace develop_therapy = "Hematologic" if develop_indication == " Hemophagocytic lymphohistiocytosis"
replace develop_therapy = "Cardiovascular" if develop_indication == " Hemorrhagic shock"
replace develop_therapy = "Hematologic" if develop_indication == " Heparin induced thrombocytopenia"
replace develop_therapy = "Hepatologic" if develop_indication == " Hepatic encephalopathy"
replace develop_therapy = "Infection" if develop_indication == " Hepatitis D virus infection"
replace develop_therapy = "Hepatologic" if develop_indication == " Hepatobiliary system tumor"
replace develop_therapy = "Renal" if develop_indication == " Hepatorenal syndrome"
replace develop_therapy = "Genetic disorder" if develop_indication == " Hereditary hemorrhagic telangiectasia"
replace develop_therapy = "Ocular" if develop_indication == " Hermansky-Pudlak syndrome"
replace develop_therapy = "Ocular" if develop_indication == " Herpetic keratitis"
replace develop_therapy = "Ocular" if develop_indication == " Herpetic stromal keratitis"
replace develop_therapy = "Dermatologic" if develop_indication == " Hidradenitis"
replace develop_therapy = "Dermatologic" if develop_indication == " Hidradenitis suppurativa"
replace develop_therapy = "Cancer" if develop_indication == " Histiocytosis"
replace develop_therapy = "Infection" if develop_indication == " Histoplasma infection"
replace develop_therapy = "Endocrine/Metabolic" if develop_indication == " Hormone deficiency"
replace develop_therapy = "Infection" if develop_indication == " Human T cell leukemia virus 1 infection"
replace develop_therapy = "Genetic disorder" if develop_indication == " Hutchinson Gilford progeria syndrome"
replace develop_therapy = "Immune" if develop_indication == " Hypereosinophilic syndrome"
replace develop_therapy = "Endocrine/Metabolic" if develop_indication == " Hyperparathyroidism"
replace develop_therapy = "Endocrine/Metabolic" if develop_indication == " Hyperprolactinemia"
replace develop_therapy = "Toxicity/Intoxication" if develop_indication == " Hyperthermia"
replace develop_therapy = "Metabolic" if develop_indication == " Hyperuricemia"
replace develop_therapy = "Electrolyte imbalance" if develop_indication == " Hypocalcemia"
replace develop_therapy = "Metabolic" if develop_indication == " Hypoglycemia"
replace develop_therapy = "Electrolyte imbalance" if develop_indication == " Hypomagnesemia"
replace develop_therapy = "Cardiovascular" if develop_indication == " Hyponatremia"
replace develop_therapy = "Cardiovascular" if develop_indication == " Hypotension"
replace develop_therapy = "Respiratory" if develop_indication == " Hypoxia"

replace develop_therapy = "Dermatologic" if develop_indication == " Ichthyosis"
replace develop_therapy = "Dermatologic" if develop_indication == " Ichthyosis vulgaris"
replace develop_therapy = "Cardiovascular" if develop_indication == " Idiopathic pulmonary arterial hypertension"
replace develop_therapy = "Renal" if develop_indication == " IgA nephropathy"
replace develop_therapy = "Hematologic" if develop_indication == " Immune thrombocytopenic purpura"
replace develop_therapy = "Infection" if develop_indication == " Immunization"
replace develop_therapy = "Dermatologic" if develop_indication == " Impetigo"
replace develop_therapy = "Endocrine/Metabolic" if develop_indication == " Inappropriate ADH syndrome"
replace develop_therapy = "Musculoskeletal" if develop_indication == " Inclusion body myositis"
replace develop_therapy = "Neurology/Psychiatric" if develop_indication == " Infantile spasms"
replace develop_therapy = "Injury" if develop_indication == " Infectious keratoconjunctivitis"
replace develop_therapy = "Injury" if develop_indication == " Injury"
replace develop_therapy = "Otic" if develop_indication == " Inner ear disease"
replace develop_therapy = "Cardiovascular" if develop_indication == " Intermittent claudication"
replace develop_therapy = "Respiratory" if develop_indication == " Interstitial lung disease"
replace develop_therapy = "Gastrointestinal" if develop_indication == " Intestine disease"
replace develop_therapy = "Neurology/Psychiatric" if develop_indication == " Intracranial hemorrhage"
replace develop_therapy = "Cardiovascular" if develop_indication == " Intracranial vasospasm"
replace develop_therapy = "Ocular" if develop_indication == " Iritis"
replace develop_therapy = "Musculoskeletal" if develop_indication == " Joint disease"
replace develop_therapy = "Musculoskeletal" if develop_indication == " Joint infection"
replace develop_therapy = "Musculoskeletal" if develop_indication == " Joint injury"
replace develop_therapy = "Cardiovascular" if develop_indication == " Kawasaki disease"
replace develop_therapy = "Transplantation" if develop_indication == " Kidney transplantation"
replace develop_therapy = "Infection" if develop_indication == " Klebsiella granulomatis infection"
replace develop_therapy = "Infection" if develop_indication == " Klebsiella infection"
replace develop_therapy = "Infection" if develop_indication == " Klebsiella oxytoca infection"
replace develop_therapy = "Infection" if develop_indication == " Klebsiella pneumoniae infection"
replace develop_therapy = "Musculoskeletal" if develop_indication == " Knee injury"
replace develop_therapy = "Gastrointestinal" if develop_indication == " Lactose intolerance"
replace develop_therapy = "Otic" if develop_indication == " Larynx tumor"
replace develop_therapy = "Ocular" if develop_indication == " Lebers hereditary optic atrophy"
replace develop_therapy = "Cardiovascular" if develop_indication == " Left heart disease pulmonary hypertension"
replace develop_therapy = "Infection" if develop_indication == " Legionella infection"
replace develop_therapy = "Infection" if develop_indication == " Legionella pneumophila infection"
replace develop_therapy = "Neurology/Psychiatric" if develop_indication == " Leigh disease"
replace develop_therapy = "Infection" if develop_indication == " Leishmania infection"
replace develop_therapy = "Infection" if develop_indication == " Leishmania tropica infection"
replace develop_therapy = "Neurology/Psychiatric" if develop_indication == " Lesch Nyhan syndrome"
replace develop_therapy = "Hematologic" if develop_indication == " Leukopenia drug induced"
replace develop_therapy = "Dental/Oral" if develop_indication == " Leukoplakia"
replace develop_therapy = "Neurology/Psychiatric" if develop_indication == " Lewy body dementia"
replace develop_therapy = "Dermatologic" if develop_indication == " Lichen"
replace develop_therapy = "Cardiovascular" if develop_indication == " Lipotoxic cardiomyopathy"
replace develop_therapy = "Hepatologic" if develop_indication == " Liver cirrhosis"
replace develop_therapy = "Hepatologic" if develop_indication == " Liver disease"
replace develop_therapy = "Hepatologic" if develop_indication == " Liver failure"
replace develop_therapy = "Hepatologic" if develop_indication == " Liver fibrosis"
replace develop_therapy = "Hepatologic" if develop_indication == " Liver injury"
replace develop_therapy = "Transplantation" if develop_indication == " Liver transplantation"
replace develop_therapy = "Musculoskeletal" if develop_indication == " Lower limb fracture"
replace develop_therapy = "Respiratory" if develop_indication == " Lower respiratory tract infection"
replace develop_therapy = "Respiratory" if develop_indication == " Lung disease"
replace develop_therapy = "Cardiovascular" if develop_indication == " Lung disease pulmonary hypertension"
replace develop_therapy = "Respiratory" if develop_indication == " Lung failure"
replace develop_therapy = "Respiratory" if develop_indication == " Lung inflammation"
replace develop_therapy = "Respiratory" if develop_indication == " Lung injury"
replace develop_therapy = "Transplantation" if develop_indication == " Lung transplantation"
replace develop_therapy = "Renal" if develop_indication == " Lupus nephritis"
replace develop_therapy = "Respiratory" if develop_indication == " Lymphangioleiomyomatosis"
replace develop_therapy = "Vascular" if develop_indication == " Lymphedema"
replace develop_therapy = "Hematologic" if develop_indication == " Lymphoblastic leukemia"

replace develop_therapy = "Neurology/Psychiatric" if develop_indication == " MELAS syndrome"
replace develop_therapy = "Neurology/Psychiatric" if develop_indication == " Machado-Joseph disease"
replace develop_therapy = "Hematologic" if develop_indication == " Macroglobulinemia"
replace develop_therapy = "Ocular" if develop_indication == " Macular degeneration"
replace develop_therapy = "Genitourinary/Sexual Function" if develop_indication == " Male genital tract tumor"
replace develop_therapy = "Endocrine/Metabolic" if develop_indication == " Male hypogonadism"
replace develop_therapy = "Genitourinary/Sexual Function" if develop_indication == " Male sexual dysfunction"
replace develop_therapy = "Nutritional/Metabolic" if develop_indication == " Malnutrition"
replace develop_therapy = "Oncology" if develop_indication == " Mastalgia"
replace develop_therapy = "Hematologic" if develop_indication == " Mastocytosis"
replace develop_therapy = "Musculoskeletal" if develop_indication == " Metabolic bone disease"
replace develop_therapy = "Endocrine/Metabolic" if develop_indication == " Metabolic syndrome X"
replace develop_therapy = "Oncology" if develop_indication == " Metastatic urinary tract cancer"
replace develop_therapy = "Cardiovascular" if develop_indication == " Microangiopathy"
replace develop_therapy = "Infection" if develop_indication == " Micrococcaceae infection"
replace develop_therapy = "Infection" if develop_indication == " Micrococcus luteus infection"
replace develop_therapy = "Renal" if develop_indication == " Minimal change disease"
replace develop_therapy = "Neurology/Psychiatric" if develop_indication == " Mitochondrial disease"
replace develop_therapy = "Neurology/Psychiatric" if develop_indication == " Mitochondrial myopathy"
replace develop_therapy = "Dermatologic" if develop_indication == " Molluscum contagiosum infection"
replace develop_therapy = "Infection" if develop_indication == " Moraxella catarrhalis infection"
replace develop_therapy = "Infection" if develop_indication == " Moraxella infection"
replace develop_therapy = "Infection" if develop_indication == " Morganella infection"
replace develop_therapy = "Immunology" if develop_indication == " Muckle Wells syndrome"
replace develop_therapy = "Genetic Disorder" if develop_indication == " Mucolipidosis"
replace develop_therapy = "Genetic Disorder" if develop_indication == " Mucopolysaccharidosis type I"
replace develop_therapy = "Infection" if develop_indication == " Mucor infection"
replace develop_therapy = "Oncology" if develop_indication == " Multiple hamartoma sydrome"
replace develop_therapy = "Other/Miscellaneous" if develop_indication == " Multiple organ failure"
replace develop_therapy = "Musculoskeletal" if develop_indication == " Muscle disease"
replace develop_therapy = "Musculoskeletal" if develop_indication == " Muscle injury"
replace develop_therapy = "Musculoskeletal" if develop_indication == " Muscle wasting disease"
replace develop_therapy = "Musculoskeletal" if develop_indication == " Muscle weakness"
replace develop_therapy = "Musculoskeletal" if develop_indication == " Musculoskeletal pain"
replace develop_therapy = "Musculoskeletal" if develop_indication == " Myalgia"
replace develop_therapy = "Infection" if develop_indication == " Mycobacterium avium infection"
replace develop_therapy = "Infection" if develop_indication == " Mycoplasma infection"
replace develop_therapy = "Oncology" if develop_indication == " Mycosis fungoides"
replace develop_therapy = "Hematologic" if develop_indication == " Myelofibrosis"
replace develop_therapy = "Cardiovascular" if develop_indication == " Myocarditis"
replace develop_therapy = "Musculoskeletal" if develop_indication == " Myositis"
replace develop_therapy = "Otorhinolaryngologic" if develop_indication == " Nasal polyps"
replace develop_therapy = "Oncology" if develop_indication == " Nasopharynx tumor"
replace develop_therapy = "Infection" if develop_indication == " Neisseria infection"
replace develop_therapy = "Endocrine/Metabolic" if develop_indication == " Nelson syndrome"
replace develop_therapy = "Infection" if develop_indication == " Nematode infection"
replace develop_therapy = "Renal" if develop_indication == " Nephritis"
replace develop_therapy = "Renal" if develop_indication == " Nephropathic cystinosis"
replace develop_therapy = "Renal" if develop_indication == " Nephrotic syndrome"
replace develop_therapy = "Neurology/Psychiatric" if develop_indication == " Nerve injury"
replace develop_therapy = "Neurology/Psychiatric" if develop_indication == " Nervous system inflammation"
replace develop_therapy = "Oncology" if develop_indication == " Nervous system tumor"
replace develop_therapy = "Neurology/Psychiatric" if develop_indication == " Neuritis"
replace develop_therapy = "Neurology/Psychiatric" if develop_indication == " Neurofibromatosis"
replace develop_therapy = "Oncology" if develop_indication == " Neuroma"
replace develop_therapy = "Neurology/Psychiatric" if develop_indication == " Neuromyelitis optica"
replace develop_therapy = "Neurology/Psychiatric" if develop_indication == " Neuropathy"
replace develop_therapy = "Other/Miscellaneous" if develop_indication == " Neurotoxicity drug-induced"
replace develop_therapy = "Genetic Disorder" if develop_indication == " Niemann Pick disease type C"
replace develop_therapy = "Otorhinolaryngologic" if develop_indication == " Noise induced hearing loss"
replace develop_therapy = "Hepatologic" if develop_indication == " Non alcoholic fatty liver disease"
replace develop_therapy = "Dermatologic" if develop_indication == " Non segmental vitiligo"
replace develop_therapy = "Cardiovascular" if develop_indication == " Occlusive coronary artery disease"
replace develop_therapy = "Ocular" if develop_indication == " Ocular melanoma"
replace develop_therapy = "Oncology" if develop_indication == " Odontogenic tumor"
replace develop_therapy = "Ocular" if develop_indication == " Optic neuritis"
replace develop_therapy = "Oral" if develop_indication == " Oral mucositis"
replace develop_therapy = "Immunology" if develop_indication == " Orbital inflammatory disease"
replace develop_therapy = "Oncology" if develop_indication == " Organ transplant rejection"
replace develop_therapy = "Oncology" if develop_indication == " Organ transplantation"
replace develop_therapy = "Musculoskeletal" if develop_indication == " Orthomyxovirus infection"
replace develop_therapy = "Cardiovascular" if develop_indication == " Orthostatic hypotension"
replace develop_therapy = "Musculoskeletal" if develop_indication == " Ostealgia"
replace develop_therapy = "Genetic Disorder" if develop_indication == " Osteogenesis imperfecta"
replace develop_therapy = "Infection" if develop_indication == " Osteomyelitis"

replace develop_therapy = "Gastrointestinal" if develop_indication == " Pancreatitis"
replace develop_therapy = "Endocrine/Metabolic" if develop_indication == " Paraganglioma"
replace develop_therapy = "Hematologic" if develop_indication == " Paroxysmal nocturnal hemoglobinuria"
replace develop_therapy = "Other/Miscellaneous" if develop_indication == " Peanut hypersensitivity"
replace develop_therapy = "Genitourinary/Sexual Function" if develop_indication == " Pelvic inflammatory disease"
replace develop_therapy = "Dermatologic" if develop_indication == " Pemphigoid"
replace develop_therapy = "Dermatologic" if develop_indication == " Pemphigus"
replace develop_therapy = "Genitourinary/Sexual Function" if develop_indication == " Penile induration"
replace develop_therapy = "Genitourinary/Sexual Function" if develop_indication == " Penis disease"
replace develop_therapy = "Genitourinary/Sexual Function" if develop_indication == " Penis tumor"
replace develop_therapy = "Infection" if develop_indication == " Peptostreptococcus infection"
replace develop_therapy = "Respiratory" if develop_indication == " Perennial allergic rhinitis"
replace develop_therapy = "Cardiovascular" if develop_indication == " Pericarditis"
replace develop_therapy = "Dental" if develop_indication == " Periodontal disease"
replace develop_therapy = "Dental" if develop_indication == " Periodontitis"
replace develop_therapy = "Abdominal" if develop_indication == " Peritonitis"
replace develop_therapy = "Hematologic" if develop_indication == " Pernicious anemia"
replace develop_therapy = "Neurology/Psychiatric" if develop_indication == " Pervasive child developmental disorder"
replace develop_therapy = "Otorhinolaryngologic" if develop_indication == " Pharyngitis"
replace develop_therapy = "Endocrine/Metabolic" if develop_indication == " Pheochromocytoma"
replace develop_therapy = "Cardiovascular" if develop_indication == " Phlebothrombosis"
replace develop_therapy = "Musculoskeletal" if develop_indication == " Pigmented villonodular synovitis"
replace develop_therapy = "Genetic Disorder" if develop_indication == " Pitt Hopkins syndrome"
replace develop_therapy = "Endocrine/Metabolic" if develop_indication == " Pituitary disease"
replace develop_therapy = "Endocrine/Metabolic" if develop_indication == " Pituitary tumor"
replace develop_therapy = "Dermatologic" if develop_indication == " Pityriasis"
replace develop_therapy = "Reproductive Health" if develop_indication == " Planned abortion"
replace develop_therapy = "Pulmonary" if develop_indication == " Pleural disease"
replace develop_therapy = "Infection" if develop_indication == " Pneumocystis carinii infection"
replace develop_therapy = "Respiratory" if develop_indication == " Pneumonia"
replace develop_therapy = "Vascular" if develop_indication == " Polyarteritis nodosa"
replace develop_therapy = "Rheumatologic" if develop_indication == " Polychondritis"
replace develop_therapy = "Genitourinary/Sexual Function" if develop_indication == " Polycystic kidney disease"
replace develop_therapy = "Endocrine/Metabolic" if develop_indication == " Polycystic ovary syndrome"
replace develop_therapy = "Hematologic" if develop_indication == " Polycythemia"
replace develop_therapy = "Hematologic" if develop_indication == " Polycythemia vera"
replace develop_therapy = "Rheumatologic" if develop_indication == " Polymyalgia rheumatica"
replace develop_therapy = "Rheumatologic" if develop_indication == " Polymyositis"
replace develop_therapy = "Genetic Disorder" if develop_indication == " Polyostotic fibrous dysplasia"
replace develop_therapy = "Genetic Disorder" if develop_indication == " Pompes disease"
replace develop_therapy = "Hepatologic" if develop_indication == " Portal hypertension"
replace develop_therapy = "Oncology" if develop_indication == " Post transplant lymphoproliferative disease"
replace develop_therapy = "Gastrointestinal" if develop_indication == " Pouchitis"
replace develop_therapy = "Infection" if develop_indication == " Pox virus infection"
replace develop_therapy = "Oncology" if develop_indication == " Precancer"
replace develop_therapy = "Endocrine/Metabolic" if develop_indication == " Precocious puberty"
replace develop_therapy = "Genitourinary/Sexual Function" if develop_indication == " Premature ejaculation"
replace develop_therapy = "Hepatologic" if develop_indication == " Primary biliary cholangitis"
replace develop_therapy = "Hepatologic" if develop_indication == " Primary sclerosing cholangitis"
replace develop_therapy = "Gastrointestinal" if develop_indication == " Proctitis"
replace develop_therapy = "Neurology/Psychiatric" if develop_indication == " Progressive multifocal leukoencephalopathy"
replace develop_therapy = "Hematologic" if develop_indication == " Progressive supranuclear palsy"
replace develop_therapy = "Ophthalmological" if develop_indication == " Proliferative diabetic retinopathy"
replace develop_therapy = "Hematologic" if develop_indication == " Prolymphocytic leukemia"
replace develop_therapy = "Other/Miscellaneous" if develop_indication == " Prophylaxis"
replace develop_therapy = "Microbial" if develop_indication == " Propionibacterium acnes infection"
replace develop_therapy = "Renal" if develop_indication == " Proteinuria"
replace develop_therapy = "Enteric" if develop_indication == " Proteus infection"
replace develop_therapy = "Enteric" if develop_indication == " Proteus mirabilis infection"
replace develop_therapy = "Infection" if develop_indication == " Protozoal infection"
replace develop_therapy = "Enteric" if develop_indication == " Providencia infection"
replace develop_therapy = "Dermatologic" if develop_indication == " Prurigo nodularis"
replace develop_therapy = "Dermatologic" if develop_indication == " Pruritus"
replace develop_therapy = "Gastrointestinal" if develop_indication == " Pseudomembranous colitis"
replace develop_therapy = "Respiratory" if develop_indication == " Pseudomonas aeruginosa infection"
replace develop_therapy = "Infection" if develop_indication == " Pseudomonas infection"
replace develop_therapy = "Rheumatologic" if develop_indication == " Psoriatic arthritis"
replace develop_therapy = "Cardiovascular" if develop_indication == " Pulmonary artery hypertension"
replace develop_therapy = "Pulmonary" if develop_indication == " Pulmonary fibrosis"
replace develop_therapy = "Pulmonary" if develop_indication == " Pulmonary hypertension"
replace develop_therapy = "Cardiovascular" if develop_indication == " Pulmonary stenosis"
replace develop_therapy = "Hematologic" if develop_indication == " Purpura"
replace develop_therapy = "Renal" if develop_indication == " Pyelonephritis"
replace develop_therapy = "Dermatologic" if develop_indication == " Pyoderma gangrenosum"
replace develop_therapy = "Rheumatologic" if develop_indication == " Raynauds disease"
replace develop_therapy = "Renal" if develop_indication == " Renal disease"
replace develop_therapy = "Renal" if develop_indication == " Renal failure"
replace develop_therapy = "Renal" if develop_indication == " Renal injury"
replace develop_therapy = "Renal" if develop_indication == " Renal osteodystrophy"
replace develop_therapy = "Cardiovascular" if develop_indication == " Resistant hypertension"
replace develop_therapy = "Respiratory" if develop_indication == " Respiratory disorder"
replace develop_therapy = "Respiratory" if develop_indication == " Respiratory failure"
replace develop_therapy = "Respiratory" if develop_indication == " Respiratory tract infection"
replace develop_therapy = "Vaccine" if develop_indication == " Rhabdovirus infection"
replace develop_therapy = "Microbial" if develop_indication == " Rickettsia infection"
replace develop_therapy = "Infection" if develop_indication == " Rocky mountain spotted fever"
replace develop_therapy = "Infection" if develop_indication == " SARS coronavirus infection"
replace develop_therapy = "Genetic Disorder" if develop_indication == " Sandhoff disease"
replace develop_therapy = "Immunology" if develop_indication == " Sarcoidosis"
replace develop_therapy = "Dermatologic" if develop_indication == " Scar tissue"
replace develop_therapy = "Microbial" if develop_indication == " Schistosomiasis"
replace develop_therapy = "Ocular" if develop_indication == " Scleritis"
replace develop_therapy = "Rheumatologic" if develop_indication == " Scleroderma"
replace develop_therapy = "Respiratory" if develop_indication == " Seasonal allergic rhinitis"
replace develop_therapy = "Dermatologic" if develop_indication == " Seborrheic dermatitis"
replace develop_therapy = "Cardiovascular" if develop_indication == " Secondary pulmonary arterial hypertension"
replace develop_therapy = "Cardiovascular" if develop_indication == " Septic shock"
replace develop_therapy = "Microbial" if develop_indication == " Serratia infection"
replace develop_therapy = "Microbial" if develop_indication == " Serratia marcescens infection"
replace develop_therapy = "Immunology" if develop_indication == " Serum sickness"
replace develop_therapy = "Oncology" if develop_indication == " Sezary syndrome"
replace develop_therapy = "Enteric" if develop_indication == " Shigella boydii infection"
replace develop_therapy = "Enteric" if develop_indication == " Shigella dysenteriae infection"
replace develop_therapy = "Enteric" if develop_indication == " Shigella flexneri infection"
replace develop_therapy = "Enteric" if develop_indication == " Shigella sonnei infection"
replace develop_therapy = "Cardiovascular" if develop_indication == " Shock"
replace develop_therapy = "Hematologic" if develop_indication == " Sickle beta 0 thalassemia"
replace develop_therapy = "Hematologic" if develop_indication == " Sickle cell crisis"
replace develop_therapy = "Otorhinolaryngologic" if develop_indication == " Sinusitis"
replace develop_therapy = "Oncology" if develop_indication == " Skin cancer"
replace develop_therapy = "Dermatologic" if develop_indication == " Skin rash"
replace develop_therapy = "Oncology" if develop_indication == " Skin tumor"
replace develop_therapy = "Dermatologic" if develop_indication == " Skin ulcer"
replace develop_therapy = "Respiratory" if develop_indication == " Sleep apnea"
replace develop_therapy = "Gastrointestinal" if develop_indication == " Small intestine cancer"
replace develop_therapy = "Neurology/Psychiatric" if develop_indication == " Spinal and bulbar muscular atrophy"
replace develop_therapy = "Neurology/Psychiatric" if develop_indication == " Spinal cord disease"
replace develop_therapy = "Neurology/Psychiatric" if develop_indication == " Spinal cord tumor"
replace develop_therapy = "Neurology/Psychiatric" if develop_indication == " Spinocerebellar ataxia"
replace develop_therapy = "Rheumatologic" if develop_indication == " Spondylarthritis"
replace develop_therapy = "Neurology/Psychiatric" if develop_indication == " Sporadic inclusion body myositis"
replace develop_therapy = "Microbial" if develop_indication == " Staphylococcus epidermidis infection"
replace develop_therapy = "Microbial" if develop_indication == " Staphylococcus saprophyticus infection"
replace develop_therapy = "Hematologic" if develop_indication == " Stem cell transplantation"
replace develop_therapy = "Microbial" if develop_indication == " Stenotrophomonas maltophilia infection"
replace develop_therapy = "Dermatologic" if develop_indication == " Stevens Johnson syndrome"
replace develop_therapy = "Ophthalmological" if develop_indication == " Strabismus"
replace develop_therapy = "Microbial" if develop_indication == " Streptococcus anginosus infection"
replace develop_therapy = "Microbial" if develop_indication == " Streptococcus constellatus infection"
replace develop_therapy = "Microbial" if develop_indication == " Streptococcus intermedius infection"
replace develop_therapy = "Microbial" if develop_indication == " Streptococcus pneumoniae infection"
replace develop_therapy = "Genitourinary/Sexual Function" if develop_indication == " Stress urinary incontinence"
replace develop_therapy = "Neurology/Psychiatric" if develop_indication == " Sturge-Weber syndrome"
replace develop_therapy = "Neurology/Psychiatric" if develop_indication == " Stutter"
replace develop_therapy = "Dermatologic" if develop_indication == " Sunburn"
replace develop_therapy = "Surgical" if develop_indication == " Surgical procedure"
replace develop_therapy = "Infection" if develop_indication == " Systemic inflammatory response syndrome"
replace develop_therapy = "Hematologic" if develop_indication == " Systemic mastocytosis"
replace develop_therapy = "Cardiovascular" if develop_indication == " Systolic heart failure"


replace develop_therapy = "Hematologic" if develop_indication == " T-cell lymphoma"
replace develop_therapy = "Genetic Disorder" if develop_indication == " Tay Sachs disease"
replace develop_therapy = "Vascular" if develop_indication == " Temporal arteritis"
replace develop_therapy = "Musculoskeletal" if develop_indication == " Temporomandibular joint syndrome"
replace develop_therapy = "Musculoskeletal" if develop_indication == " Tendon disease"
replace develop_therapy = "Oncology" if develop_indication == " Teratoma"
replace develop_therapy = "Injury" if develop_indication == " Thermal injury"
replace develop_therapy = "Hematologic" if develop_indication == " Thrombocytopenic purpura"
replace develop_therapy = "Hematologic" if develop_indication == " Thrombotic microangiopathy"
replace develop_therapy = "Ophthalmological" if develop_indication == " Thyroid associated ophthalmopathy"
replace develop_therapy = "Otorhinolaryngologic" if develop_indication == " Tinnitus"
replace develop_therapy = "Abdominal" if develop_indication == " Tissue adhesions"
replace develop_therapy = "Otorhinolaryngologic" if develop_indication == " Tonsillitis"
replace develop_therapy = "Dental" if develop_indication == " Tooth disease"
replace develop_therapy = "Toxicity/Intoxication" if develop_indication == " Toxicity"
replace develop_therapy = "Cardiovascular" if develop_indication == " Transient ischemic attack"
replace develop_therapy = "Oncology" if develop_indication == " Transplantation"
replace develop_therapy = "Infection" if develop_indication == " Treponema infection"
replace develop_therapy = "Infection" if develop_indication == " Treponema pallidum infection"
replace develop_therapy = "Neurology/Psychiatric" if develop_indication == " Tropical spastic paraparesis"
replace develop_therapy = "Parasitic" if develop_indication == " Trypanosomiasis"
replace develop_therapy = "Gastrointestinal" if develop_indication == " Ulcer"
replace develop_therapy = "Infection" if develop_indication == " Ureaplasma urealyticum infection"
replace develop_therapy = "Genitourinary/Sexual Function" if develop_indication == " Urethritis"
replace develop_therapy = "Genitourinary/Sexual Function" if develop_indication == " Urge urinary incontinence"
replace develop_therapy = "Genitourinary/Sexual Function" if develop_indication == " Urinary retention"
replace develop_therapy = "Genitourinary/Sexual Function" if develop_indication == " Urinary tract tumor"
replace develop_therapy = "Genitourinary/Sexual Function" if develop_indication == " Urolithiasis"
replace develop_therapy = "Immunology" if develop_indication == " Urticaria"
replace develop_therapy = "Ophthalmological" if develop_indication == " Usher syndrome"
replace develop_therapy = "Gynecological" if develop_indication == " Uterine hemorrhage"
replace develop_therapy = "Gynecological" if develop_indication == " Vagina disease"
replace develop_therapy = "Gynecological" if develop_indication == " Vaginal intraepithelial neoplasia"
replace develop_therapy = "Gynecological" if develop_indication == " Vaginal tumor"
replace develop_therapy = "Vascular" if develop_indication == " Vascular disease"
replace develop_therapy = "Oncology" if develop_indication == " Vascular neoplasm"
replace develop_therapy = "Vascular" if develop_indication == " Vascular occlusive disease"
replace develop_therapy = "Rheumatologic" if develop_indication == " Vasculitis"
replace develop_therapy = "Dermatologic" if develop_indication == " Verruca vulgaris"
replace develop_therapy = "Respiratory" if develop_indication == " Vibrio cholerae infection"
replace develop_therapy = "Infection" if develop_indication == " Viral pneumonia"
replace develop_therapy = "Nutritional/Metabolic" if develop_indication == " Vitamin B12 deficiency"
replace develop_therapy = "Gynecological" if develop_indication == " Vulva disease"
replace develop_therapy = "Gynecological" if develop_indication == " Vulvar intraepithelial neoplasia"
replace develop_therapy = "Rheumatologic" if develop_indication == " Wegener granulomatosis"
replace develop_therapy = "Other/Miscellaneous" if develop_indication == " Weight gain"
replace develop_therapy = "Viral Infections" if develop_indication == " West Nile virus infection"

replace develop_therapy = "Hepatologic" if develop_indication == " Wilson disease"
replace develop_therapy = "Otorhinolaryngologic" if develop_indication == " Xerostomia"
replace develop_therapy = "Viral" if develop_indication == " Zika virus infection"
replace develop_therapy = "Gastrointestinal" if develop_indication == " Zollinger-Ellison syndrome"
replace develop_therapy = "Infection" if develop_indication == " viridans group Streptococcus infection"

}
{
replace develop_therapy = "Hematologic" if develop_indication == " Lymphoproliferative disease"
replace develop_therapy = "Infection" if develop_indication == " Mycoplasma pneumoniae infection"
replace develop_therapy = "Hematologic" if develop_indication == " Myeloproliferative disorder"
replace develop_therapy = "Musculoskeletal" if develop_indication == " Non-alcoholic steatohepatitis"
replace develop_therapy = "Musculoskeletal" if develop_indication == " Osteonecrosis"
replace develop_therapy = "Respiratory" if develop_indication == " Viral respiratory tract infection"

replace develop_therapy = "Inflammatory" if develop_indication == " Peritonitis"
replace develop_therapy = "Other/Miscellaneous" if develop_indication == " Tissue adhesions"

replace develop_therapy = "Immune" if develop_indication == " Dermatomyositis"
replace develop_therapy = "Immune" if develop_indication == " Discoid lupus erythematosus"

replace develop_therapy = "Dermatologic" if develop_indication == " Periodontal disease"
replace develop_therapy = "Dermatologic" if develop_indication == " Periodontitis"
replace develop_therapy = "Dermatologic" if develop_indication == " Tooth disease"
replace develop_therapy = "Dermatologic" if develop_indication == " Gingivitis"
replace develop_therapy = "Dermatologic" if develop_indication == " Leukoplakia"

replace develop_therapy = "Endocrine/Metabolic" if develop_indication == " Hypocalcemia"
replace develop_therapy = "Endocrine/Metabolic" if develop_indication == " Hypomagnesemia"
replace develop_therapy = "Infection" if develop_indication == " Proteus infection"
replace develop_therapy = "Infection" if develop_indication == " Proteus mirabilis infection"
replace develop_therapy = "Infection" if develop_indication == " Providencia infection"
replace develop_therapy = "Infection" if develop_indication == " Shigella boydii infection"
replace develop_therapy = "Infection" if develop_indication == " Shigella dysenteriae infection"
replace develop_therapy = "Infection" if develop_indication == " Shigella flexneri infection"
replace develop_therapy = "Infection" if develop_indication == " Shigella sonnei infection"

replace develop_therapy = "Infection" if develop_indication == " West Nile virus infection"
replace develop_therapy = "Infection" if develop_indication == " Zika virus infection"
replace develop_therapy = "Infection" if develop_indication == " Rhabdovirus infection"
replace develop_therapy = "Other/Miscellaneous" if develop_indication == " Lymphedema"
replace develop_therapy = "Cardiovascular" if develop_indication == " Polyarteritis nodosa"
replace develop_therapy = "Cardiovascular" if develop_indication == " Temporal arteritis"
replace develop_therapy = "Cardiovascular" if develop_indication == " Vascular disease"
replace develop_therapy = "Cardiovascular" if develop_indication == " Vascular occlusive disease"

replace develop_therapy = "Other/Miscellaneous" if develop_indication == " Mucolipidosis"
replace develop_therapy = "Other/Miscellaneous" if develop_indication == " Mucopolysaccharidosis type I"
replace develop_therapy = "Other/Miscellaneous" if develop_indication == " Niemann Pick disease type C"
replace develop_therapy = "Musculoskeletal" if develop_indication == " Osteogenesis imperfecta"
replace develop_therapy = "Neurology/Psychiatric" if develop_indication == " Pitt Hopkins syndrome"
replace develop_therapy = "Musculoskeletal" if develop_indication == " Polyostotic fibrous dysplasia"
replace develop_therapy = "Other/Miscellaneous" if develop_indication == " Pompes disease"
replace develop_therapy = "Neurology/Psychiatric" if develop_indication == " Sandhoff disease"
replace develop_therapy = "Neurology/Psychiatric" if develop_indication == " Tay Sachs disease"
replace develop_therapy = "Other/Miscellaneous" if develop_indication == " DiGeorge syndrome"
replace develop_therapy = "Other/Miscellaneous" if develop_indication == " Ehlers Danlos syndrome"
replace develop_therapy = "Cardiovascular" if develop_indication == " Hereditary hemorrhagic telangiectasia"
replace develop_therapy = "Other/Miscellaneous" if develop_indication == " Hutchinson Gilford progeria syndrome"
replace develop_therapy = "Genitourinary/Sexual Function" if develop_indication == " Female genital tract infection"
replace develop_therapy = "Genitourinary/Sexual Function" if develop_indication == " Female infertility"
replace develop_therapy = "Genitourinary/Sexual Function" if develop_indication == " Genital tract infection"
replace develop_therapy = "Genitourinary/Sexual Function" if develop_indication == " Genital tract inflammation"
replace develop_therapy = "Genitourinary/Sexual Function" if develop_indication == " Genital ulcer"
replace develop_therapy = "Genitourinary/Sexual Function" if develop_indication == " Uterine hemorrhage"
replace develop_therapy = "Genitourinary/Sexual Function" if develop_indication == " Vagina disease"
replace develop_therapy = "Genitourinary/Sexual Function" if develop_indication == " Vaginal intraepithelial neoplasia"
replace develop_therapy = "Genitourinary/Sexual Function" if develop_indication == " Vaginal tumor"
replace develop_therapy = "Genitourinary/Sexual Function" if develop_indication == " Vulva disease"
replace develop_therapy = "Genitourinary/Sexual Function" if develop_indication == " Vulvar intraepithelial neoplasia"

replace develop_therapy = "Musculoskeletal" if develop_indication == " Dysmenorrhea"
replace develop_therapy = "Gastrointestinal" if develop_indication == " Decompensated liver cirrhosis"
replace develop_therapy = "Neurology/Psychiatric" if develop_indication == " Hepatic encephalopathy"
replace develop_therapy = "Gastrointestinal" if develop_indication == " Hepatobiliary system tumor"
replace develop_therapy = "Gastrointestinal" if develop_indication == " Liver cirrhosis"
replace develop_therapy = "Gastrointestinal" if develop_indication == " Liver disease"
replace develop_therapy = "Gastrointestinal" if develop_indication == " Liver failure"
replace develop_therapy = "Gastrointestinal" if develop_indication == " Liver fibrosis"
replace develop_therapy = "Gastrointestinal" if develop_indication == " Liver injury"
replace develop_therapy = "Gastrointestinal" if develop_indication == " Non alcoholic fatty liver disease"
replace develop_therapy = "Cardiovascular" if develop_indication == " Portal hypertension"
replace develop_therapy = "Gastrointestinal" if develop_indication == " Primary biliary cholangitis"
replace develop_therapy = "Gastrointestinal" if develop_indication == " Primary sclerosing cholangitis"
replace develop_therapy = "Gastrointestinal" if develop_indication == " Wilson disease"

replace develop_therapy = "Other/Miscellaneous" if develop_indication == " Muckle Wells syndrome"
replace develop_therapy = "Ocular" if develop_indication == " Orbital inflammatory disease"
replace develop_therapy = "Other/Miscellaneous" if develop_indication == " Sarcoidosis"
replace develop_therapy = "Other/Miscellaneous" if develop_indication == " Serum sickness"
replace develop_therapy = "Immune" if develop_indication == " Urticaria"

replace develop_therapy = "Ocular" if develop_indication == " Infectious keratoconjunctivitis"
replace develop_therapy = "Musculoskeletal" if develop_indication == " Injury"
replace develop_therapy = "Musculoskeletal" if develop_indication == " Thermal injury"
replace develop_therapy = "Endocrine/Metabolic" if develop_indication == " Fatty acid oxidation disorder"
replace develop_therapy = "Hematologic" if develop_indication == " Folic acid deficiency"
replace develop_therapy = "Endocrine/Metabolic" if develop_indication == " HIV-associated lipodystrophy"
replace develop_therapy = "Hematologic" if develop_indication == " Hemochromatosis"
replace develop_therapy = "Other/Miscellaneous" if develop_indication == " Hyperuricemia"
replace develop_therapy = "Endocrine/Metabolic" if develop_indication == " Hypoglycemia"
replace develop_therapy = "Infection" if develop_indication == " Propionibacterium acnes infection"
replace develop_therapy = "Infection" if develop_indication == " Rickettsia infection"
replace develop_therapy = "Infection" if develop_indication == " Schistosomiasis"
replace develop_therapy = "Infection" if develop_indication == " Serratia infection"
replace develop_therapy = "Infection" if develop_indication == " Serratia marcescens infection"
replace develop_therapy = "Infection" if develop_indication == " Staphylococcus epidermidis infection"
replace develop_therapy = "Infection" if develop_indication == " Staphylococcus saprophyticus infection"
replace develop_therapy = "Infection" if develop_indication == " Stenotrophomonas maltophilia infection"
replace develop_therapy = "Infection" if develop_indication == " Streptococcus anginosus infection"
replace develop_therapy = "Infection" if develop_indication == " Streptococcus constellatus infection"
replace develop_therapy = "Infection" if develop_indication == " Streptococcus intermedius infection"
replace develop_therapy = "Infection" if develop_indication == " Streptococcus pneumoniae infection"

replace develop_therapy = "Other/Miscellaneous" if develop_indication == " Malnutrition"
replace develop_therapy = "Endocrine/Metabolic" if develop_indication == " Vitamin B12 deficiency"
replace develop_therapy = "Musculoskeletal" if develop_indication == " Mastalgia"
replace develop_therapy = "Cancer" if develop_indication == " Metastatic urinary tract cancer"
replace develop_therapy = "Other/Miscellaneous" if develop_indication == " Multiple hamartoma sydrome"
replace develop_therapy = "Dermatologic" if develop_indication == " Mycosis fungoides"
replace develop_therapy = "Genitourinary/Sexual Function" if develop_indication == " Nasopharynx tumor"
replace develop_therapy = "Neurology/Psychiatric" if develop_indication == " Nervous system tumor"
replace develop_therapy = "Other/Miscellaneous" if develop_indication == " Neuroma"
replace develop_therapy = "Other/Miscellaneous" if develop_indication == " Odontogenic tumor"
replace develop_therapy = "Other/Miscellaneous" if develop_indication == " Organ transplant rejection"
replace develop_therapy = "Other/Miscellaneous" if develop_indication == " Organ transplantation"
replace develop_therapy = "Other/Miscellaneous" if develop_indication == " Post transplant lymphoproliferative disease"
replace develop_therapy = "Other/Miscellaneous" if develop_indication == " Precancer"
replace develop_therapy = "Other/Miscellaneous" if develop_indication == " Sezary syndrome"
replace develop_therapy = "Dermatologic" if develop_indication == " Skin cancer"
replace develop_therapy = "Other/Miscellaneous" if develop_indication == " Skin tumor"
replace develop_therapy = "Other/Miscellaneous" if develop_indication == " Teratoma"
replace develop_therapy = "Other/Miscellaneous" if develop_indication == " Transplantation"
replace develop_therapy = "Other/Miscellaneous" if develop_indication == " Vascular neoplasm"
replace develop_therapy = "Ocular" if develop_indication == " Proliferative diabetic retinopathy"
replace develop_therapy = "Ocular" if develop_indication == " Strabismus"
replace develop_therapy = "Endocrine/Metabolic" if develop_indication == " Thyroid associated ophthalmopathy"
replace develop_therapy = "Other/Miscellaneous" if develop_indication == " Usher syndrome"
replace develop_therapy = "Ocular" if develop_indication == " Oral mucositis"

replace develop_therapy = "Ocular" if develop_indication == " Ear disease"
replace develop_therapy = "Ocular" if develop_indication == " Hearing disorder"
replace develop_therapy = "Ocular" if develop_indication == " Inner ear disease"
replace develop_therapy = "Ocular" if develop_indication == " Larynx tumor"
replace develop_therapy = "Respiratory" if develop_indication == " Nasal polyps"
replace develop_therapy = "Ocular" if develop_indication == " Noise induced hearing loss"
replace develop_therapy = "Respiratory" if develop_indication == " Pharyngitis"
replace develop_therapy = "Respiratory" if develop_indication == " Sinusitis"
replace develop_therapy = "Ocular" if develop_indication == " Tinnitus"
replace develop_therapy = "Respiratory" if develop_indication == " Tonsillitis"
replace develop_therapy = "Other/Miscellaneous" if develop_indication == " Xerostomia"
replace develop_therapy = "Infection" if develop_indication == " Trypanosomiasis"
replace develop_therapy = "Respiratory" if develop_indication == " Pleural disease"
replace develop_therapy = "Respiratory" if develop_indication == " Pulmonary fibrosis"
replace develop_therapy = "Respiratory" if develop_indication == " Pulmonary hypertension"
replace develop_therapy = "Genitourinary/Sexual Function" if develop_indication == " Diabetic nephropathy"
replace develop_therapy = "Genitourinary/Sexual Function" if develop_indication == " End stage renal disease"
replace develop_therapy = "Genitourinary/Sexual Function" if develop_indication == " Focal segmental glomerulosclerosis"
replace develop_therapy = "Genitourinary/Sexual Function" if develop_indication == " Glomerular disease"
replace develop_therapy = "Genitourinary/Sexual Function" if develop_indication == " Glomerulonephritis"
replace develop_therapy = "Genitourinary/Sexual Function" if develop_indication == " Hepatorenal syndrome"
replace develop_therapy = "Genitourinary/Sexual Function" if develop_indication == " IgA nephropathy"
replace develop_therapy = "Genitourinary/Sexual Function" if develop_indication == " Lupus nephritis"
replace develop_therapy = "Genitourinary/Sexual Function" if develop_indication == " Minimal change disease"
replace develop_therapy = "Genitourinary/Sexual Function" if develop_indication == " Nephritis"
replace develop_therapy = "Genitourinary/Sexual Function" if develop_indication == " Nephropathic cystinosis"
replace develop_therapy = "Genitourinary/Sexual Function" if develop_indication == " Nephrotic syndrome"
replace develop_therapy = "Genitourinary/Sexual Function" if develop_indication == " Proteinuria"
replace develop_therapy = "Genitourinary/Sexual Function" if develop_indication == " Pyelonephritis"
replace develop_therapy = "Genitourinary/Sexual Function" if develop_indication == " Renal disease"
replace develop_therapy = "Genitourinary/Sexual Function" if develop_indication == " Renal failure"
replace develop_therapy = "Genitourinary/Sexual Function" if develop_indication == " Renal injury"
replace develop_therapy = "Genitourinary/Sexual Function" if develop_indication == " Renal osteodystrophy"
replace develop_therapy = "Other/Miscellaneous" if develop_indication == " Planned abortion"
replace develop_therapy = "Other/Miscellaneous" if develop_indication == " Polychondritis"
replace develop_therapy = "Inflammatory" if develop_indication == " Polymyalgia rheumatica"
replace develop_therapy = "Inflammatory" if develop_indication == " Polymyositis"
replace develop_therapy = "Inflammatory" if develop_indication == " Psoriatic arthritis"
replace develop_therapy = "Inflammatory" if develop_indication == " Raynauds disease"
replace develop_therapy = "Inflammatory" if develop_indication == " Scleroderma"
replace develop_therapy = "Inflammatory" if develop_indication == " Spondylarthritis"
replace develop_therapy = "Inflammatory" if develop_indication == " Vasculitis"
replace develop_therapy = "Inflammatory" if develop_indication == " Wegener granulomatosis"
replace develop_therapy = "Other/Miscellaneous" if develop_indication == " Surgical procedure"
replace develop_therapy = "Genitourinary/Sexual Function" if develop_indication == " Kidney transplantation"
replace develop_therapy = "Genitourinary/Sexual Function" if develop_indication == " Liver transplantation"
replace develop_therapy = "Respiratory" if develop_indication == " Lung transplantation"
replace develop_therapy = "Neurology/Psychiatric" if develop_indication == " Alcohol withdrawal syndrome"
replace develop_therapy = "Other/Miscellaneous" if develop_indication == " Alcoholism"
replace develop_therapy = "Neurology/Psychiatric" if develop_indication == " Amphetamine dependence"
replace develop_therapy = "Neurology/Psychiatric" if develop_indication == " Cannabis dependence"
replace develop_therapy = "Cardiovascular" if develop_indication == " Cardiotoxicity drug-induced"
replace develop_therapy = "Other/Miscellaneous" if develop_indication == " Chemotherapy induced nausea and vomiting"
replace develop_therapy = "Neurology/Psychiatric" if develop_indication == " Cocaine addiction"
replace develop_therapy = "Neurology/Psychiatric" if develop_indication == " Drug dependence"
replace develop_therapy = "Other/Miscellaneous" if develop_indication == " Drug overdose"
replace develop_therapy = "Other/Miscellaneous" if develop_indication == " Endotoxic shock"
replace develop_therapy = "Other/Miscellaneous" if develop_indication == " Heavy metal poisoning"
replace develop_therapy = "Other/Miscellaneous" if develop_indication == " Hyperthermia"
replace develop_therapy = "Renal" if develop_indication == " Nephrotoxicity"
replace develop_therapy = "Cardiovascular" if develop_indication == " Nicotine dependence"
replace develop_therapy = "Neurology/Psychiatric" if develop_indication == " Opiate dependence"
replace develop_therapy = "Other/Miscellaneous" if develop_indication == " Poison intoxication"
replace develop_therapy = "Other/Miscellaneous" if develop_indication == " Radiation sickness"
replace develop_therapy = "Genitourinary/Sexual Function" if develop_indication == "Nephrotoxicity"
}







	}
	
	merge m:1 develop_indication using  "E:\ARK\as of Jul 2024\id_cortellis + TherapyArea_indication (no dups).dta", update replace
	drop if _merge == 2
	drop _merge
	
	merge m:1 develop_indication using "E:\ARK\as of Jul 2024\develop_therapy_byChatGPT.dta", update replace
	drop if _merge == 2
	drop _merge
	replace develop_therapy = "Endocrine/Metabolic" if strpos(develop_indication, "Carbamoyl phosphate synthase I defic")
	replace develop_therapy = "Endocrine/Metabolic" if strpos(develop_indication, "Central nervous system development d")
	replace develop_therapy = "Endocrine/Metabolic" if strpos(develop_indication, "Fragile X-associated tremor ataxia s")
	replace develop_therapy = "Hematologic" if strpos(develop_indication, "Human T cell leukemia virus 2 infect")
	replace develop_therapy = "Cardiovascular" if strpos(develop_indication, "Lecithin cholesterol acetyltransfera")
	replace develop_therapy = "Infection" if strpos(develop_indication, "Pediatric varicella zoster virus inf")
	replace develop_therapy = "Immune" if strpos(develop_indication, "Severe combined immunodeficiency syn")
	replace develop_therapy = "Infection" if strpos(develop_indication, "Tick borne encephalitis virus infect")
	replace develop_therapy = "Endocrine/Metabolic" if strpos(develop_indication, "Transmissible spongiform encephalopa")
	replace develop_therapy = "Endocrine/Metabolic" if strpos(develop_indication, "Umbilical cord stem cell transplanta")
	replace develop_therapy = "Infection" if strpos(develop_indication, "Western equine encephalitis virus in")

	merge m:1 develop_indication using "E:\ARK\as of Jul 2024\develop_therapy_byChatGPT_2.dta", update replace
	drop _merge
	
	save "E:\ARK\as of Jul 2024\[004_2] (merged with 105_Aug12_ver) Drug_development summary.dta", replace
}

Pre-M&A experience of other firms are added to the acquiror firm's drug development history, regarding that the acquiror may have access to the clinical information accumulated in the target firm's experience. 
The year is the (M&A announcement year + 1)
We generate a variable "dev_history_bf_MnA" that tags this incidence (i.e., the development history of subsidiary before M&A).

- dev_history_bf_MnA == other firm's previous drug development experience which is acquired through M&A, before M&A happens
- external == other firm's development record acquired through M&A, after M&A happens

*gvkey_dc_refine 생성 
{
	clear
	use "E:\ARK\as of Jul 2024\[004_2] (merged with 105_Aug12_ver) Drug_development summary.dta"

	***** [step 1] Compare added_year_refine (the year when develop_company is announced to become a part of Parent company) and drug development year
	*[When develop_company == ParentCompanyName]
	gen gvkey_dc_refine = gvkey_parent if (gvkey_dc == gvkey_parent) 
		
	*[When develop_company != ParentCompanyName]
		*[step 2] (added_year_refine >= develop_year), 
		*    	  implying that the develop_company developed the drug before adding to the parent company,
		*		  thus, the drug is developed by the develop_company
		*[step 3] (added_year_refine < develop_year),
		*		  implying that the develop_company develops the drug after adding to the parent company,
		*		  thus, the drug is developed by the parent company (==ParentCompanyName)
	
	replace gvkey_dc_refine = gvkey_dc     if (added_year_refine >= develop_year) & !missing(added_year_refine) & !missing(develop_year) & (gvkey_dc != gvkey_parent) 
	
	replace gvkey_dc_refine = gvkey_parent if (added_year_refine <  develop_year) & !missing(added_year_refine) & !missing(develop_year) & (gvkey_dc != gvkey_parent) 
	gen external = 1 if (added_year_refine <  develop_year) & !missing(added_year_refine) & !missing(develop_year) & (gvkey_dc != gvkey_parent)
	

	replace gvkey_dc_refine = gvkey_parent if missing(gvkey_dc_refine) & joint_venture == 1
	
	replace gvkey_dc_refine = . if id_dc_upper == 349
	replace gvkey_dc_refine = 36049 if strpos(upper_develop_company, "PPD")
	replace gvkey_dc_refine = gvkey_parent if develop_company == "Elto Pharma Inc"
	replace gvkey_dc_refine = gvkey_parent if develop_company == "Sanofi Pasteur MSD"
	replace added_year_refine = 2001 if id_dc_upper == 441
	replace added_year_refine = 1990 if id_dc_upper == 675
	replace added_year_refine = 2014 if id_dc_upper == 1257
	replace year_liner = 1990 if id_dc_upper == 675
	replace year_subsidiary = 1994 if develop_company == "McNeil Pharmaceuticals Inc"
	replace year_liner = 1993 if develop_company == "McNeil Pharmaceuticals Inc"
	replace year_subsidiary = 2008 if develop_company == "McNeil Consumer Products Co"
	replace year_liner = 2007 if develop_company == "McNeil Consumer Products Co"
	replace upper_develop_company = "MCNEIL PHARMA" if develop_company == "McNeil Pharmaceuticals Inc"
	replace upper_develop_company = "MCNEIL CONSUMER" if develop_company == "McNeil Consumer Products Co"
	replace id_dc_upper = 2774 if develop_company == "McNeil Consumer Products Co"
	replace gvkey_dc_refine = 12233 if id_dc_upper == 1127 
	replace added_year_refine = 2003 if id_dc_upper == 2599

	replace gvkey_dc_refine = 121742 if strpos(develop_company, "Genzyme Surgical Products")
	replace gvkey_dc_refine = 117298 if strpos(develop_company, "Genzyme Molecular Oncology") & !missing( develop_year) & develop_year < 2002
	replace gvkey_dc_refine = 117298 if strpos(develop_company, "Genzyme Molecular Oncology") & !missing( develop_year) & develop_year <= 2002
	replace gvkey_dc_refine = 12233 if strpos(develop_company, "Genzyme Molecular Oncology") & !missing( develop_year) & develop_year >= 2003
	replace gvkey_dc_refine = 15708 if strpos(develop_company, "Allergan Inc") & !missing( develop_year) & develop_year <= 2014
	replace gvkey_dc_refine = 15708 if strpos(develop_company, "Allergan Pharmaceuticals Ireland") & !missing( develop_year) & develop_year <= 2014
	replace gvkey_dc_refine = 15708 if strpos(develop_company, "Allergan-Lok Productos Farmaceuticos Ltd") & !missing( develop_year) & develop_year <= 2014
	replace gvkey_dc_refine = 15708 if strpos(develop_company, "Allergan France SA") & !missing( develop_year) & develop_year <= 2014
	replace gvkey_dc_refine = 15708 if strpos(develop_company, "Allergan Pharmaceuticals International Ltd") & !missing( develop_year) & develop_year <= 2014
	replace gvkey_dc_refine = 27845 if strpos(develop_company, "Allergan Inc") & !missing( develop_year) & develop_year >= 2015
	replace gvkey_dc_refine = 27845 if strpos(develop_company, "Allergan Pharmaceuticals Ireland") & !missing( develop_year) & develop_year >= 2015
	replace gvkey_dc_refine = 27845 if strpos(develop_company, "Allergan-Lok Productos Farmaceuticos Ltd") & !missing( develop_year) & develop_year >= 2015
	replace gvkey_dc_refine = 27845 if strpos(develop_company, "Allergan France SA") & !missing( develop_year) & develop_year >= 2015
	replace gvkey_dc_refine = 27845 if strpos(develop_company, "Allergan Pharmaceuticals International Ltd") & !missing( develop_year) & develop_year >= 2015
	replace gvkey_dc_refine = 27845 if strpos(develop_company, "Allergan plc")
	replace gvkey_dc_refine = 61952 if strpos(develop_company, "Allergan Ligand Retinoid Therapeutics Inc") & !missing( develop_year) & develop_year <= 1006
	replace gvkey_dc_refine = 61952 if strpos(develop_company, "Allergan Ligand Retinoid Therapeutics Inc") & !missing( develop_year) & develop_year <= 1996
	replace gvkey_dc_refine = . if strpos(develop_company, "Allergan Ligand Retinoid Therapeutics Inc") & !missing( develop_year) & develop_year >= 1997
	replace gvkey_dc_refine = 66616 if strpos(develop_company, "Allergan Specialty Therapeutics Inc") & !missing( develop_year) & develop_year <= 2000
	replace gvkey_dc_refine = 15708 if strpos(develop_company, "Allergan Specialty Therapeutics Inc") & !missing( develop_year) & develop_year >= 2001
	replace gvkey_dc_refine = 6096 if strpos(upper_develop_company, "MALLINCKRODT MEDICAL") & !missing( develop_year) & develop_year <= 2000
	replace gvkey_dc_refine = 18086 if strpos(upper_develop_company, "MALLINCKRODT MEDICAL") & !missing( develop_year) & develop_year >= 2011
	replace gvkey_dc_refine = 13282 if strpos(upper_develop_company, "ORGANOGENESIS") & !missing( develop_year) & develop_year <= 2001
	replace gvkey_dc_refine = 34562 if strpos(upper_develop_company, "ORGANOGENESIS") & !missing( develop_year) & develop_year >= 2015
	replace gvkey_dc_refine = 61101 if strpos(upper_develop_company, "VIVENTIA BIO") & !missing( develop_year) & develop_year <= 2004
	replace gvkey_dc_refine = 26412 if strpos(upper_develop_company, "VIVENTIA BIO") & !missing( develop_year) & develop_year >= 2013
	replace gvkey_dc_refine = 205950 if strpos(upper_develop_company, "WARNER CHILCOTT PLC") & !missing( develop_year) & develop_year <= 2004
	replace gvkey_dc_refine = 175163 if strpos(upper_develop_company, "WARNER CHILCOTT PLC") & !missing( develop_year) & develop_year >= 2005
	replace gvkey_dc_refine = 27845 if strpos(develop_company, "Allergan Pharmaceuticals Ireland") & !missing( develop_year) & develop_year >= 2015

	replace gvkey_dc_refine = 147449 if strpos(upper_develop_company, "ALCON") & !missing( develop_year) & develop_year <= 2010
	replace gvkey_dc_refine = 35056 if strpos(upper_develop_company, "ALCON") & !missing( develop_year) & develop_year >= 2019
	replace gvkey_dc_refine = 101310 if strpos(upper_develop_company, "ALCON") & !missing(develop_year) & develop_year >= 2011 & develop_year <= 2018
	
	drop if missing(gvkey_dc_refine) /// 여기서 	drop if missing(gvkey_parent) 을 하고 drop if missing(gvkey_dc_refine) 은 나중에 해야하지 않았나? 예를 들어 Pfizer 의 subsidiary 인 GD Searle 은 gvkey_dc_refine 이 없음. 이 회사는 Pfizer 에 2003년부터 일부가 됨. 그렇다면 이 회사의 2003년 이전의 정보는 expand 되어서 Pfizer 의 정보로 들어가야 할 듯 한데..!)
	
	
	gen tag = 1 if (added_year_refine >= develop_year) & (gvkey_dc != gvkey_parent)
	order tag 
	expand 2 if tag == 1 
	
	gen tag_expanded = 1 in 167956/200267
	replace gvkey_dc_refine = gvkey_parent if tag_expanded == 1

	gen develop_year_refine = develop_year
	replace develop_year_refine = (added_year_refine + 1) if tag_expanded == 1
	
	gen dev_history_bf_MnA = 1 if tag_expanded == 1	
	replace dev_history_bf_MnA = 0 if missing(dev_history_bf_MnA)
	label variable dev_history_bf_MnA "development history of subsidiary before M&A"
	label variable external "development history of subsidiary after M&A"
	
	<Alcon: independent -> part of Novartis (2010~2019) -> independent (2019~)
	- upper_develop_company: ALCON
		- ~2010 : gvkey 147449
		- 2011~2018: part of Novartis
		- 2019~ : gvkey 35056

	replace external = 1 if strpos(upper_develop_company, "ALCON") &   develop_year >= 2011 & develop_year <= 2018
	save "E:\ARK\as of Jul 2024\[004_3] (gvkey_dc_refine) (merged with 105_Aug12_ver) Drug_development summary.dta"
			
	gen tag_ALCON = 1 if strpos(upper_develop_company, "ALCON") & !missing(develop_year) & develop_year <= 2010
	expand 2 if tag_ALCON == 1
	
	gen tag_ALCON_expanded = 1 in 200268/200524
	replace gvkey_dc_refine = 101310 if tag_ALCON_expanded == 1
	replace develop_year_refine = 2011 if tag_ALCON_expanded == 1
	replace dev_history_bf_MnA = 1 if tag_ALCON_expanded == 1
	
	drop tag_ALCON tag_ALCON_expanded
	
	gen tag_ALCON = 1 if strpos(upper_develop_company, "ALCON") & gvkey_dc_refine == 101310 & !missing(develop_year) & develop_year >= 2011 & develop_year <= 2018
	expand 2 if tag_ALCON == 1
	
	gen tag_ALCON_expanded = 1 in 200525/200649
	replace gvkey_dc_refine = 35056 if tag_ALCON_expanded == 1
	replace develop_year_refine = 2019 if tag_ALCON_expanded == 1
	replace dev_history_bf_MnA = 1 if tag_ALCON_expanded == 1
	
	drop tag_ALCON tag_ALCON_expanded
	
	sort gvkey_dc_refine id_cortellis develop_indication  develop_status_num develop_status_num_other develop_year_refine	
	
	save "E:\ARK\as of Jul 2024\[004_3] (gvkey_dc_refine) (merged with 105_Aug12_ver) Drug_development summary.dta"
	
	encode develop_status, gen(int_develop_status)
	bysort gvkey_dc_refine id_cortellis  develop_indication int_develop_status (develop_year_refine): gen cnt = _n
	keep if cnt == 1
	duplicates report gvkey_dc_refine id_cortellis  develop_indication develop_status
	
	merge m:1 develop_indication using "E:\ARK\as of Jul 2024\develop_therapy_byChatGPT_3.dta", replace update
	drop _merge tag
	drop if upper_Parent == "RECKITT BENCKISER PLC"
	
	save "E:\ARK\as of Jul 2024\[004_4] (unique values by develop_status) (gvkey_dc_refine) (merged with 105_Aug12_ver) Drug_development summary.dta"
**# Bookmark #2
	
	
}




*(To-do #4) Final dataset 구축 (DV, IDV, control variable 생성) - refer to Data construction procedure (last update_May 17).do

- id_cortellis 기준

[DV: Redeployment]
	REFERENCE (Chang & Matsumoto working paper): "the dependent variable for individual inventor's redeployment decision is a dichotomous variable that is one if a focal inventor changes her research group membership from period t-1 to t, and zero if not"
	-----> the dependent variable for technology (drug candidate) to be redeployed is a dichotomous variable that is one if a focal technology (drug candidate)'s therapeutic area is changed from period t-k to t, and zero if not

	- DV: 1 whether or not a drug candidate is redeployed to the different therapy area, otherwise 0
	- DV: 1 whether or not a drug candidate is redeployed to the same therapy area (different indication)
	
{
	clear
	use  "E:\ARK\as of Jul 2024\[004_4] (unique values by develop_status) (gvkey_dc_refine) (merged with 105_Aug12_ver) Drug_development summary.dta"

	replace develop_indication = subinstr(develop_indication, ".", "", .)
	replace develop_therapy = "Genitourinary/Sexual Function" if strpos(develop_indication, " Vulvar intraepithelial neoplasia")

	sort gvkey_dc_refine id_cortellis develop_indication  develop_status_num develop_status_num_other develop_year_refine	

	bysort gvkey_dc_refine id_cortellis develop_indication (develop_status_num develop_status_num_other develop_year_refine): gen diff_indi = _n == 1
	bysort gvkey_dc_refine id_cortellis develop_therapy (develop_status_num develop_status_num_other develop_year_refine): gen diff_TA = _n == 1
	
	gen fail = 1 if (develop_status == " No Development Reported" | develop_status == " Discontinued" | develop_status == " Suspended" | develop_status == " Withdrawn")
	replace fail = 0 if missing(fail)
	gen withdrawn = 1 if develop_status == " Withdrawn"
	replace withdrawn = 0 if missing(withdrawn)
	
	bysort gvkey_dc_refine id_cortellis (develop_status_num develop_status_num_other develop_year_refine): gen first_attempt = ( _n == 1 )


	gen DV_diff_indi = 1 if diff_indi == 1   & first_attempt != 1
	gen DV_diff_TA   = 1 if diff_TA   == 1   & first_attempt != 1
	order fail withdrawn, a(DV_diff_TA)	
	

	* develop_year_refine 이 missing 인 경우
	**--> 완전 추정 불가인 경우 (1) 어떤 id_cortellis 에 있는 모든 obs. 의 develop_year_refine 이 missing 인 경우 
	gen missing_year = missing(develop_year_refine)
	by gvkey_dc_refine id_cortellis: egen cnt_missing_year = total(missing_year)
	by gvkey_dc_refine id_cortellis: gen cnt_id_cortellis = _N
	drop if (cnt_id_cortellis == cnt_missing_year)
	
	**--> 완전 추정 불가인 경우(2) 어떤 id_cortellis 의 어떤 develop_indication에 있는 모든 obs. 의 develop_year_refine 이 missing 인 경우 
	sort gvkey_dc_refine id_cortellis develop_indication  develop_status_num develop_status_num_other develop_year_refine
	by gvkey_dc_refine id_cortellis develop_indication: egen cnt_missing_year = total(missing_year)
	by gvkey_dc_refine id_cortellis develop_indication: gen cnt_id_cortellis = _N
	drop if (cnt_id_cortellis == cnt_missing_year)
	save "E:\ARK\as of Jul 2024\[004_5] (drop missing dv_yr) Drug_development summary.dta"

	clear
	use  "E:\ARK\as of Jul 2024\[004_5] (drop missing dv_yr) Drug_development summary.dta"

	sort gvkey_dc_refine id_cortellis develop_indication fail develop_year_refine
	by gvkey_dc_refine id_cortellis develop_indication fail: gen early_fail = _n if fail == 1	
	drop if early_fail == 4
	drop if early_fail == 3
	drop if early_fail == 2
	save "E:\ARK\as of Jul 2024\[004_6] (kept earliest fail) Drug_development summary.dta"
	
	gsort gvkey_dc_refine id_cortellis develop_indication -missing_year
	by gvkey_dc_refine id_cortellis develop_indication: replace missing_year = missing_year[1]
	drop if missing_year == 1
	save "E:\ARK\as of Jul 2024\[004_7] (kept no_missing develop_year_refine) Drug_development summary.dta"
	
	sort gvkey_dc_refine id_cortellis develop_indication  develop_year_refine develop_status_num develop_status_num_other 
	
	***FROM HERE 2024-08-16
	*(To-do #1) develop_status 순서 정리 필요 (예: develop_year_refine 기준으로 Phase 2 가 Phase 1 보다 앞에 위치한 경우)
		---> before_Discovery , Phase_3_next 와 같은  변수 구축 
		bysort gvkey_dc_refine id_cortellis develop_indication (develop_year_refine): gen Phase_3_next = develop_status[_n+1]  if develop_status == " Phase 3 Clinical"
		---> 예를 들어, Phase_3_next 다음에 Phase 2 가 오는 거면 이상한 것임. 이런 경우, 그 다음에 오는 Phase 2 를 삭제 
		---> 예를 들어, Discovery 이전 (before_Discovery)에 다른 phase 가 있으면 이상한 것임. 이런 경우, 해당 Discovery 를 삭제 
		**** before_Discovery, before_Phase_1 과 같이 "before ~ " 로 먼저 처리해보자 
	
	by gvkey_dc_refine id_cortellis develop_indication: gen before_Discovery = develop_status[_n-1]  if develop_status == " Discovery"
	order before_Discovery, b(Phase_3_next)
	tab before_Discovery
	///
	
	*** MnA 시점으로 development year 를 맞추니 other firms' experience 를 가져오는데 이상한 시점 차이가 생겨버림
	*** 예를 들어, added_year_refine == 2015 인 경우, other firms' experience 는 2016년 시점으로 되게 만들었음 
	*** 그런데, other firm 이 2014년까지 해당 약을 develop 하고, MnA 이후 해당 약이 2015년에 Launch 되는 경우가 있음 
	*** develop_year_refine2 을 다시 만듬
	gen develop_year_refine2 = develop_year_refine
	replace develop_year_refine2 = develop_year if dev_history_bf_MnA == 1
	
	* discovery 이전에 다른 phase 가 나올 수가 없음. 
	* 다른 기업에게서 MnA 이후 가져온 기술이더라도 예를 들어, clinical 2 이후에 Discovery 가 나오는 건 이상함. 
	* 그러므로 Discovery 직전에 다른 phase 가 존재하는 경우, 해당 Discovery observation 을 삭제 
	by gvkey_dc_refine id_cortellis develop_indication: gen before_Discovery2 = develop_status[_n-1] if develop_status == " Discovery"
	drop if !missing(before_Discovery2)
	drop before_Discovery2
	
	* Preclinical 이전에 clincial, phase 1,2,3, launch 가 나오는 경우 삭제 
	by gvkey_dc_refine id_cortellis develop_indication: gen before_Preclini = develop_status[_n-1] if develop_status == " Preclinical"
	order before_Preclini, a(develop_status)
	gen delete = 0, b(develop_status)
	replace delete = 1 if strpos(before_Preclini, "Clinical")
	replace delete = 1 if strpos(before_Preclini, "Launched")
	drop if delete == 1
	drop before_Preclini
	
	*Clinical 이전에 launch 가 나오는 경우 삭제 
	by gvkey_dc_refine id_cortellis develop_indication: gen before_Clini = develop_status[_n-1] if strpos(develop_status, "Clinical")
	replace delete = 1 if before_Clini == " Launched"
	drop if delete == 1
	drop before_Clini
	
	*Phase 1 이전에 Phase 2,3, 가 나오는 경우 삭제 
	by gvkey_dc_refine id_cortellis develop_indication: gen before_P1 = develop_status[_n-1] if strpos(develop_status, "Phase 1")
	replace delete = 1 if before_P1 == " Phase 2 Clinical"
	replace delete = 1 if before_P1 == " Phase 3 Clinical"
	replace delete = 1 if before_P1 == " Launched"
	drop if delete == 1
	drop before_P1
	
	*Phase 2 이전에 Phase 3 가 나오는 경우 삭제 
	by gvkey_dc_refine id_cortellis develop_indication: gen before_P2 = develop_status[_n-1] if strpos(develop_status, "Phase 2")
	replace delete = 1 if before_P2 == " Launched"
	replace delete = 1 if before_P2 == " Phase 3 Clinical"
	drop if delete == 1
	drop before_P2
	
	by gvkey_dc_refine id_cortellis develop_indication: gen before_Launch = develop_status[_n-1] if strpos(develop_status, "Launched")
	drop if before_Launch == " Withdrawn"
	drop before_Launch
	
	by gvkey_dc_refine id_cortellis develop_indication: gen before_Regi = develop_status[_n-1] if strpos(develop_status, "Registered")
	drop if before_Regi == " No Development Reported"
	drop if before_Regi == " Discontinued"
	drop if before_Regi == " Withdrawn"
	drop before_Regi
	
	by gvkey_dc_refine id_cortellis develop_indication: gen before_Preregi = develop_status[_n-1] if strpos(develop_status, "Pre-registration")
	drop if before_Preregi == " Registered"
	drop if before_Preregi == " Discontinued"
	drop if before_Preregi == " Withdrawn"
	drop if before_Preregi == " No Development Reported"
	drop before_Preregi

	by gvkey_dc_refine id_cortellis develop_indication: gen before_P3 = develop_status[_n-1] if strpos(develop_status, "Phase 3 Clinical")
	drop if before_P3 == " Discontinued"
	drop if before_P3 == " No Development Reported"
	drop if before_P3 == " Withdrawn"
	drop before_P3
	
	by gvkey_dc_refine id_cortellis develop_indication: gen before_Preregi2 = develop_status[_n-1] if strpos(develop_status, "Pre-registration")
	drop if before_Preregi2 == " Registered"
	drop if before_Preregi2 == " Withdrawn"
	drop before_Preregi2
	
	by gvkey_dc_refine id_cortellis develop_indication: gen before_Preclini = develop_status[_n-1] if strpos(develop_status, "Preclinical")
	drop if before_Preclini == " Withdrawn"
	drop if before_Preclini == " Launched"
	drop if before_Preclini == " Discontinued"
	drop if before_Preclini == " No Development Reported" 
	drop before_Preclini
	
	save "E:\ARK\as of Jul 2024\[004_8] (develop_status_refine) Drug_development summary.dta"
	
	
	###FROM HERE 2024-08-16 Variable construction: Level of analysis: firm - drug candidate - year
	*(To-do #2) first_attempt 에서 연도가 동일한 게 여러개 일 경우. 여러 개 모두 first-attempt 로 처리.
	 (develop_year_refine2 기준? develop_year_refine 기준?)
	 
	 bysort gvkey_dc_refine id_cortellis (develop_year_refine2 develop_status_num develop_status_num_other): gen first_attempt = (_n == 1)
	 order first_attempt, a(tic) 
	 
	 gen first_attempt2 = first_attempt, a(first_attempt)
	 
	 bysort gvkey_dc_refine id_cortellis (develop_year_refine2 develop_status_num develop_status_num_other): replace first_attempt2 = first_attempt2[_n-1] if develop_year_refine2 == develop_year_refine2[_n-1]
	 
	---> 그 후, redeploy 변수 재구축  
	
	bysort gvkey_dc_refine id_cortellis develop_indication ( develop_status_num develop_status_num_other ): gen diff_indi = _n == 1
	bysort gvkey_dc_refine id_cortellis develop_therapy (develop_year_refine2 develop_status_num develop_status_num_other): gen diff_TA = _n == 1

	gen DV_diff_indi = 1 if diff_indi == 1   & first_attempt2 != 1
	gen DV_diff_TA   = 1 if diff_TA   == 1   & first_attempt2 != 1 
	gen DV_redeploy  = 1 if DV_diff_indi == 1 | DV_diff_TA == 1
	 
	local DV "DV_diff_indi DV_diff_TA DV_redeploy"
	foreach x of local DV {
		replace `x' = 0 if missing(`x')
	}
	
	
	
	
}


gen tic = 0
replace tic = 1 if develop_status == " Launched" | develop_status == " Discontinued" | develop_status == " Suspended" | develop_status == " No Development Reported" | develop_status == " Withdrawn"
gsort gvkey_dc_refine id_cortellis develop_indication -tic
by gvkey_dc_refine id_cortellis develop_indication: replace tic = tic[1]



	- IDV: failure 
{
	tag failure
	fail in which development stage
	>> fail 직전 phase 
	sort gvkey_dc_refine id_cortellis develop_indication develop_year_refine2 develop_status_num develop_status_num_other
	by gvkey_dc_refine id_cortellis develop_indication: gen fail_t_1 = develop_status[_n-1] if fail == 1
	by gvkey_dc_refine id_cortellis develop_indication: gen fail_t_2 = develop_status[_n-2] if fail == 1
	
	*Suspended 는 개발중단이므로, 명확한 실패라고 분류가 안 될 수 있음
	*No dev. reported 는 Cortellis 에서 임의로 부여한 것이므로, 명확한 실패라고 분류가 안 될 수 있음
	*각각에 대한 변수 생성
	
	*failure reasons 
	gen reason_fail_RnD = (reason_fail_pipeline == 0) & (reason_fail_market == 0) & (reason_fail_cost == 0) & (reason_fail_bankrupt == 0) & (reason_fail_other == 0)

	
	gen fail_DNSW = 1 if (develop_status == " No Development Reported" | develop_status == " Discontinued" | develop_status == " Suspended" | develop_status == " Withdrawn")
	replace fail_DNSW = 0 if missing(fail_DNSW)

	gen fail_DNSW_year = develop_year_refine2 if fail_DNSW == 1, a(fail_DNSW)

	gen fail_DNW = 1 if (develop_status == " No Development Reported" | develop_status == " Discontinued" | develop_status == " Withdrawn"), a(fail_DNSW_year)
	gen fail_DNW_year = develop_year_refine2 if fail_DNW == 1, a(fail_DNW)

	gen fail_DW = 1 if (develop_status == " Discontinued" | develop_status == " Withdrawn"), a(fail_DNW_year)
	gen fail_DW_year = develop_year_refine2 if fail_DW == 1, a(fail_DW)
	
	gen fail_D = 1 if (develop_status == " Discontinued" | develop_status == " Withdrawn"), a(fail_DW_year)
	gen fail_D_year = develop_year_refine2 if fail_D == 1, a(fail_D)

	*
	gen fail_DNSW_2 = 1 if (develop_status == " No Development Reported" | develop_status == " Discontinued" | develop_status == " Suspended" | develop_status == " Withdrawn") & (reason_fail_RnD == 1)
	gen fail_DNSW_2_year = develop_year_refine2 if fail_DNSW == 1 & (reason_fail_RnD == 1)

	gen fail_DNW_2 = 1 if (develop_status == " No Development Reported" | develop_status == " Discontinued" | develop_status == " Withdrawn") & (reason_fail_RnD == 1)
	gen fail_DNW_2_year = develop_year_refine2 if fail_DNW == 1 & (reason_fail_RnD == 1)

	gen fail_DW_2 = 1 if (develop_status == " Discontinued" | develop_status == " Withdrawn") & (reason_fail_RnD == 1)
	gen fail_DW_2_year = develop_year_refine2 if fail_DW == 1 & (reason_fail_RnD == 1)
	
	gen fail_D_2 = 1 if (develop_status == " Discontinued" | develop_status == " Withdrawn") & (reason_fail_RnD == 1)
	gen fail_D_2_year = develop_year_refine2 if fail_D == 1 & (reason_fail_RnD == 1)
	
	local fail "fail_DNSW fail_DNW fail_DW fail_D"
	local fail_2 "fail_DNSW_2 fail_DNW_2 fail_DW_2 fail_D_2"
	local DV "DV_redeploy DV_diff_indi DV_diff_TA"
	foreach x of local fail_2 {
		bysort gvkey_dc_refine id_cortellis develop_year_refine2 (develop_status_num develop_status_num_other): egen cnt_`x' = total(`x')
	}
	
	
	cnt_DV_redeploy cnt_DV_diff_indi cnt_DV_diff_TA
	>> number of redeployment by year, id_cortellis (drug candidate), firm 
	
	cnt_fail_DNSW cnt_fail_DNW cnt_fail_DW cnt_fail_D cnt_fail_DNSW_2 cnt_fail_DNW_2 cnt_fail_DW_2 cnt_fail_D_2
	>>> number of failures by year, id_cortellis (drug candidate), firm 
	
	local fail "fail_DNSW fail_DNW fail_DW fail_D"
	local fail_2 "fail_DNSW_2 fail_DNW_2 fail_DW_2 fail_D_2"

	foreach x of local fail_2 {
		bysort gvkey_dc_refine id_cortellis (develop_year_refine2 develop_status_num develop_status_num_other): gen seq_`x' = sum(`x')
		gen `x'_year_recent = develop_year_refine2 if seq_`x'
		bysort gvkey_dc_refine id_cortellis (develop_year_refine2 develop_status_num develop_status_num_other): replace `x'_year_recent = `x'_year_recent[_n-1] if seq_`x' == seq_`x'[_n-1] & seq_`x' != 0
		drop seq_`x' 
	}
	order fail_DNSW_year_recent fail_DNW_year_recent fail_DW_year_recent fail_D_year_recent, a(cnt_fail_D)
	
	
	local fail "fail_DNSW fail_DNW fail_DW fail_D"
	local fail_2 "fail_DNSW_2 fail_DNW_2 fail_DW_2 fail_D_2"

	foreach x of local fail_2 {
		bysort gvkey_dc_refine id_cortellis (develop_year_refine2 develop_status_num develop_status_num_other): gen seq_`x' = sum(`x')
		gen `x'_status_recent = fail_t_1 if seq_`x'
		bysort gvkey_dc_refine id_cortellis (develop_year_refine2 develop_status_num develop_status_num_other): replace `x'_status_recent = `x'_status_recent[_n-1] if seq_`x' == seq_`x'[_n-1] & seq_`x' != 0
		drop seq_`x' 
	}
	order fail_DNSW_status_recent fail_DNW_status_recent fail_DW_status_recent fail_D_status_recent, a(develop_status)
	
	fail_DNSW_year_recent fail_DNW_year_recent fail_DW_year_recent fail_D_year_recent fail_DNSW_2_year_recent fail_DNW_2_year_recent fail_DW_2_year_recent fail_D_2_year_recent
	>>> year of the most recent failure 
	
	
	fail_DNSW_status_recent fail_DNW_status_recent fail_DW_status_recent fail_D_status_recent fail_DNSW_2_status_recent fail_DNW_2_status_recent fail_DW_2_status_recent fail_D_2_status_recent
	>>> development status of the most recent failure 
	
	
	*****drop if dev_history_bf_MnA == 1 를 한 이후의 DV, IDV
	{
		clear
		use "E:\ARK\as of Jul 2024\[004_8] (develop_status_refine) Drug_development summary.dta"
		
		drop if dev_history_bf_MnA == 1
		bysort gvkey_dc_refine id_cortellis (develop_year_refine2 develop_status_num develop_status_num_other): gen first_attempt_v2 = (_n == 1)
		
		bysort gvkey_dc_refine id_cortellis (develop_year_refine2 develop_status_num develop_status_num_other): replace first_attempt_v2 = first_attempt_v2[_n-1] if develop_year_refine2 == develop_year_refine2[_n-1]
		
		bysort gvkey_dc_refine id_cortellis develop_indication ( develop_status_num develop_status_num_other ): gen diff_indi_v2 = _n == 1
		bysort gvkey_dc_refine id_cortellis develop_therapy (develop_year_refine2 develop_status_num develop_status_num_other): gen diff_TA_v2 = _n == 1
		gen DV_diff_indi_v2 = 1 if diff_indi_v2 == 1   & first_attempt_v2 != 1
		gen DV_diff_TA_v2   = 1 if diff_TA_v2   == 1   & first_attempt_v2 != 1 
		gen DV_redeploy_v2  = 1 if DV_diff_indi_v2 == 1 | DV_diff_TA_v2 == 1
		local DV " DV_diff_indi_v2 DV_diff_TA_v2 DV_redeploy_v2 "
		foreach x of local DV {
			replace `x' = 0 if missing(`x')
			}

		sort gvkey_dc_refine id_cortellis develop_indication develop_year_refine2 develop_status_num develop_status_num_other
		gen fail = 1 if (develop_status == " No Development Reported" | develop_status == " Discontinued" | develop_status == " Suspended" | develop_status == " Withdrawn")
		replace fail = 0 if missing(fail)
		by gvkey_dc_refine id_cortellis develop_indication: gen fail_t_1 = develop_status[_n-1] if fail == 1
		by gvkey_dc_refine id_cortellis develop_indication: gen fail_t_2 = develop_status[_n-2] if fail == 1	
		
		gen fail_DNSW_v2 = 1 if (develop_status == " No Development Reported" | develop_status == " Discontinued" | develop_status == " Suspended" | develop_status == " Withdrawn")
		replace fail_DNSW_v2 = 0 if missing(fail_DNSW_v2)
		gen fail_DNSW_year_v2 = develop_year_refine2 if fail_DNSW_v2 == 1
		gen fail_DNW_v2 = 1 if (develop_status == " No Development Reported" | develop_status == " Discontinued" | develop_status == " Withdrawn")
		gen fail_DNW_year_v2 = develop_year_refine2 if fail_DNW_v2 == 1
		gen fail_DW_v2 = 1 if (develop_status == " Discontinued" | develop_status == " Withdrawn")
		gen fail_DW_year_v2 = develop_year_refine2 if fail_DW_v2 == 1
		gen fail_D_v2 = 1 if (develop_status == " Discontinued" | develop_status == " Withdrawn")
		gen fail_D_year_v2 = develop_year_refine2 if fail_D_v2 == 1

		gen fail_DNSW_2_v2 = 1 if (develop_status == " No Development Reported" | develop_status == " Discontinued" | develop_status == " Suspended" | develop_status == " Withdrawn") & (reason_fail_RnD == 1)
		gen fail_DNSW_2_year_v2 = develop_year_refine2 if fail_DNSW_v2 == 1 & (reason_fail_RnD == 1)
		gen fail_DNW_2_v2 = 1 if (develop_status == " No Development Reported" | develop_status == " Discontinued" | develop_status == " Withdrawn") & (reason_fail_RnD == 1)
		gen fail_DNW_2_year_v2 = develop_year_refine2 if fail_DNW_v2 == 1 & (reason_fail_RnD == 1)
		gen fail_DW_2_v2 = 1 if (develop_status == " Discontinued" | develop_status == " Withdrawn") & (reason_fail_RnD == 1)
		gen fail_DW_2_year_v2 = develop_year_refine2 if fail_DW_v2 == 1 & (reason_fail_RnD == 1)
		gen fail_D_2_v2 = 1 if (develop_status == " Discontinued" | develop_status == " Withdrawn") & (reason_fail_RnD == 1)
		gen fail_D_2_year_v2 = develop_year_refine2 if fail_D_v2 == 1 & (reason_fail_RnD == 1)
		
		local fail "fail_DNSW_v2 fail_DNW_v2 fail_DW_v2 fail_D_v2 fail_DNSW_2_v2 fail_DNW_2_v2 fail_DW_2_v2 fail_D_2_v2"
		foreach x of local fail {
			bysort gvkey_dc_refine id_cortellis develop_year_refine2 (develop_status_num develop_status_num_other): egen cnt_`x' = total(`x')
		}

		local DV "DV_diff_indi_v2 DV_diff_TA_v2 DV_redeploy_v2"
		foreach x of local DV {
			bysort gvkey_dc_refine id_cortellis develop_year_refine2 (develop_status_num develop_status_num_other): egen cnt_`x' = total(`x')
		}
		
		local fail "fail_DNSW_v2 fail_DNW_v2 fail_DW_v2 fail_D_v2 fail_DNSW_2_v2 fail_DNW_2_v2 fail_DW_2_v2 fail_D_2_v2"
		foreach x of local fail {
			bysort gvkey_dc_refine id_cortellis (develop_year_refine2 develop_status_num develop_status_num_other): gen seq_`x' = sum(`x')
			gen `x'_year_recent = develop_year_refine2 if seq_`x'
			bysort gvkey_dc_refine id_cortellis (develop_year_refine2 develop_status_num develop_status_num_other): replace `x'_year_recent = `x'_year_recent[_n-1] if seq_`x' == seq_`x'[_n-1] & seq_`x' != 0
			drop seq_`x' 
		}
		foreach x of local fail {
			bysort gvkey_dc_refine id_cortellis (develop_year_refine2 develop_status_num develop_status_num_other): gen seq_`x' = sum(`x')
			gen `x'_status_recent = before_fail if seq_`x'
			bysort gvkey_dc_refine id_cortellis (develop_year_refine2 develop_status_num develop_status_num_other): replace `x'_status_recent = `x'_status_recent[_n-1] if seq_`x' == seq_`x'[_n-1] & seq_`x' != 0
			drop seq_`x' 
		}
		bysort gvkey_dc_refine id_cortellis develop_indication (develop_year_refine2 develop_status_num develop_status_num_other): gen cnt_v2 = _N
		
		save "E:\ARK\as of Jul 2024\[004_8_dev_bf_MnA zero] (develop_status_refine) Drug_development summary.dta"
		
		clear
		use "E:\ARK\as of Jul 2024\[004_8_dev_bf_MnA zero] (develop_status_refine) Drug_development summary.dta"
		
		local change "fail_DNSW_v2_year_recent fail_DNW_v2_year_recent fail_DW_v2_year_recent fail_D_v2_year_recent fail_DNSW_2_v2_year_recent fail_DNW_2_v2_year_recent fail_DW_2_v2_year_recent fail_D_2_v2_year_recent fail_DNSW_v2_status_recent fail_DNW_v2_status_recent fail_DW_v2_status_recent fail_D_v2_status_recent fail_DNSW_2_v2_status_recent fail_DNW_2_v2_status_recent fail_DW_2_v2_status_recent fail_D_2_v2_status_recent"
		foreach x of local change {
		gsort gvkey_dc_refine id_cortellis develop_year_refine2  -`x'
		by gvkey_dc_refine id_cortellis develop_year_refine2: replace `x' = `x'[1]
		}
		
		keep gvkey_dc_refine id_cortellis DrugName develop_year_refine2  cnt_fail_DNSW_v2 cnt_fail_DNW_v2 cnt_fail_DW_v2 cnt_fail_D_v2 cnt_fail_DNSW_2_v2 cnt_fail_DNW_2_v2 cnt_fail_DW_2_v2 cnt_fail_D_2_v2 cnt_DV_diff_indi_v2 cnt_DV_diff_TA_v2 cnt_DV_redeploy_v2 fail_DNSW_v2_year_recent fail_DNW_v2_year_recent fail_DW_v2_year_recent fail_D_v2_year_recent fail_DNSW_2_v2_year_recent fail_DNW_2_v2_year_recent fail_DW_2_v2_year_recent fail_D_2_v2_year_recent fail_DNSW_v2_status_recent fail_DNW_v2_status_recent fail_DW_v2_status_recent fail_D_v2_status_recent fail_DNSW_2_v2_status_recent fail_DNW_2_v2_status_recent fail_DW_2_v2_status_recent fail_D_2_v2_status_recent first_attempt_v2 		
		duplicates drop
		duplicates report gvkey_dc_refine id_cortellis develop_year_refine2
		rename cnt_DV_redeploy_v2 DV_v1_redeploy_v2
		rename cnt_DV_diff_indi_v2 DV_v2_diff_indi_v2
		rename cnt_DV_diff_TA_v2 DV_v3_diff_TA_v2
		
		local fail "DNSW DNW DW D DNSW_2 DNW_2 DW_2 D_2"
		foreach x of local fail {
			rename cnt_fail_`x'_v2 IDV1_cnt_fail_`x'_v2
		}
		
		local IDV "DNSW DNW DW D DNSW_2 DNW_2 DW_2 D_2"
		foreach x of local IDV {
			gen IDV2_v1_red_timing_`x'_v2 = develop_year_refine2 - fail_`x'_v2_year_recent if !missing( fail_`x'_v2_year_recent ) & DV_v1_redeploy_v2 != 0
		}
		foreach x of local IDV {
			gen IDV2_v2_red_timing_`x'_v2 = develop_year_refine2 - fail_`x'_v2_year_recent if !missing( fail_`x'_v2_year_recent ) & DV_v2_diff_indi_v2 != 0
		}
		foreach x of local IDV {
			gen IDV2_v3_red_timing_`x'_v2 = develop_year_refine2 - fail_`x'_v2_year_recent if !missing( fail_`x'_v2_year_recent ) & DV_v3_diff_TA_v2 != 0
		}
		foreach x of local IDV {
			gen CTR_no_fail_`x'_v2_dum = (IDV1_cnt_fail_`x'_v2 == 0)
		}
		
		local IDV "DNSW DNW DW D DNSW_2 DNW_2 DW_2 D_2"
		foreach x of local IDV {
			gen IDV3_fail_tim_v0_`x'_v2     = 1 if fail_`x'_v2_status_recent == " Discovery"
			replace IDV3_fail_tim_v0_`x'_v2     = 1 if fail_`x'_v2_status_recent == " Preclinical"
			replace IDV3_fail_tim_v0_`x'_v2     = 2 if fail_`x'_v2_status_recent == " Clinical"
			replace IDV3_fail_tim_v0_`x'_v2     = 2 if fail_`x'_v2_status_recent == " Phase 1 Clinical"
			replace IDV3_fail_tim_v0_`x'_v2     = 2 if fail_`x'_v2_status_recent == " Phase 2 Clinical"
			replace IDV3_fail_tim_v0_`x'_v2     = 2 if fail_`x'_v2_status_recent == " Phase 3 Clinical"
			replace IDV3_fail_tim_v0_`x'_v2     = 3 if fail_`x'_v2_status_recent == " Pre-registration"
			replace IDV3_fail_tim_v0_`x'_v2     = 3 if fail_`x'_v2_status_recent == " Registered"
			replace IDV3_fail_tim_v0_`x'_v2     = 3 if fail_`x'_v2_status_recent == " Launched"
			
			gen IDV3_fail_tim_v1_`x'_v2     = 1 if fail_`x'_v2_status_recent == " Discovery"
			replace IDV3_fail_tim_v1_`x'_v2 = 2 if fail_`x'_v2_status_recent == " Preclinical"
			replace IDV3_fail_tim_v1_`x'_v2 = 3 if fail_`x'_v2_status_recent == " Clinical"
			replace IDV3_fail_tim_v1_`x'_v2 = 3 if fail_`x'_v2_status_recent == " Phase 1 Clinical"
			replace IDV3_fail_tim_v1_`x'_v2 = 3 if fail_`x'_v2_status_recent == " Phase 2 Clinical"
			replace IDV3_fail_tim_v1_`x'_v2 = 3 if fail_`x'_v2_status_recent == " Phase 3 Clinical"
			replace IDV3_fail_tim_v1_`x'_v2 = 4 if fail_`x'_v2_status_recent == " Pre-registration"
			replace IDV3_fail_tim_v1_`x'_v2 = 5 if fail_`x'_v2_status_recent == " Registered"
			replace IDV3_fail_tim_v1_`x'_v2 = 6 if fail_`x'_v2_status_recent == " Launched"
			
			gen IDV3_fail_tim_v2_`x'_v2     = 1 if fail_`x'_v2_status_recent == " Discovery"
			replace IDV3_fail_tim_v2_`x'_v2 = 2 if fail_`x'_v2_status_recent == " Preclinical"
			replace IDV3_fail_tim_v2_`x'_v2 = 3 if fail_`x'_v2_status_recent == " Clinical"
			replace IDV3_fail_tim_v2_`x'_v2 = 4 if fail_`x'_v2_status_recent == " Phase 1 Clinical"
			replace IDV3_fail_tim_v2_`x'_v2 = 5 if fail_`x'_v2_status_recent == " Phase 2 Clinical"
			replace IDV3_fail_tim_v2_`x'_v2 = 6 if fail_`x'_v2_status_recent == " Phase 3 Clinical"
			replace IDV3_fail_tim_v2_`x'_v2 = 7 if fail_`x'_v2_status_recent == " Pre-registration"
			replace IDV3_fail_tim_v2_`x'_v2 = 8 if fail_`x'_v2_status_recent == " Registered"
			replace IDV3_fail_tim_v2_`x'_v2 = 9 if fail_`x'_v2_status_recent == " Launched"
			
			gen IDV3_fail_tim_v3_`x'_v2     = 1 if fail_`x'_v2_status_recent == " Discovery"
			replace IDV3_fail_tim_v3_`x'_v2 = 2 if fail_`x'_v2_status_recent == " Preclinical"
			replace IDV3_fail_tim_v3_`x'_v2 = 3 if fail_`x'_v2_status_recent == " Phase 1 Clinical"
			replace IDV3_fail_tim_v3_`x'_v2 = 4 if fail_`x'_v2_status_recent == " Clinical"
			replace IDV3_fail_tim_v3_`x'_v2 = 5 if fail_`x'_v2_status_recent == " Phase 2 Clinical"
			replace IDV3_fail_tim_v3_`x'_v2 = 6 if fail_`x'_v2_status_recent == " Phase 3 Clinical"
			replace IDV3_fail_tim_v3_`x'_v2 = 7 if fail_`x'_v2_status_recent == " Pre-registration"
			replace IDV3_fail_tim_v3_`x'_v2 = 8 if fail_`x'_v2_status_recent == " Registered"
			replace IDV3_fail_tim_v3_`x'_v2 = 9 if fail_`x'_v2_status_recent == " Launched"
			
			gen IDV3_fail_tim_v4_`x'_v2     = 1 if fail_`x'_v2_status_recent == " Discovery"
			replace IDV3_fail_tim_v4_`x'_v2 = 2 if fail_`x'_v2_status_recent == " Preclinical"
			replace IDV3_fail_tim_v4_`x'_v2 = 3 if fail_`x'_v2_status_recent == " Phase 1 Clinical"
			replace IDV3_fail_tim_v4_`x'_v2 = 4 if fail_`x'_v2_status_recent == " Phase 2 Clinical"
			replace IDV3_fail_tim_v4_`x'_v2 = 5 if fail_`x'_v2_status_recent == " Clinical"
			replace IDV3_fail_tim_v4_`x'_v2 = 6 if fail_`x'_v2_status_recent == " Phase 3 Clinical"
			replace IDV3_fail_tim_v4_`x'_v2 = 7 if fail_`x'_v2_status_recent == " Pre-registration"
			replace IDV3_fail_tim_v4_`x'_v2 = 8 if fail_`x'_v2_status_recent == " Registered"
			replace IDV3_fail_tim_v4_`x'_v2 = 9 if fail_`x'_v2_status_recent == " Launched"
			
			gen IDV3_fail_tim_v5_`x'_v2     = 1 if fail_`x'_v2_status_recent == " Discovery"
			replace IDV3_fail_tim_v5_`x'_v2 = 2 if fail_`x'_v2_status_recent == " Preclinical"
			replace IDV3_fail_tim_v5_`x'_v2 = 3 if fail_`x'_v2_status_recent == " Phase 1 Clinical"
			replace IDV3_fail_tim_v5_`x'_v2 = 4 if fail_`x'_v2_status_recent == " Phase 2 Clinical"
			replace IDV3_fail_tim_v5_`x'_v2 = 5 if fail_`x'_v2_status_recent == " Phase 3 Clinical"
			replace IDV3_fail_tim_v5_`x'_v2 = 6 if fail_`x'_v2_status_recent == " Clinical"
			replace IDV3_fail_tim_v5_`x'_v2 = 7 if fail_`x'_v2_status_recent == " Pre-registration"
			replace IDV3_fail_tim_v5_`x'_v2 = 8 if fail_`x'_v2_status_recent == " Registered"
			replace IDV3_fail_tim_v5_`x'_v2 = 9 if fail_`x'_v2_status_recent == " Launched"
		}

		gen DV_v1_redeploy_v2_dum = ( DV_v1_redeploy_v2 != 0)
		gen DV_v2_diff_indi_v2_dum = ( DV_v2_diff_indi_v2 != 0)
		gen DV_v3_diff_TA_v2_dum = ( DV_v3_diff_TA_v2 != 0)
		
		local fail "IDV1_cnt_fail_DNSW_v2 IDV1_cnt_fail_DNW_v2 IDV1_cnt_fail_DW_v2 IDV1_cnt_fail_D_v2 IDV1_cnt_fail_DNSW_2_v2 IDV1_cnt_fail_DNW_2_v2 IDV1_cnt_fail_DW_2_v2 IDV1_cnt_fail_D_2_v2"
		foreach x of local fail {
			gen `x'_dum = (`x' > 0)
		}
		
		save "E:\ARK\as of Jul 2024\[004_9_dev_bf_MnA zero] (develop_status_refine) Drug_development summary.dta"
		
		}
	
	
	
	**discontinue, no development reported 가 redeploy 로 잡힌 경우가 있음
	**--> Cortellis 에는 기록되지 않았지만, 해당 indication / therapy area 로 약 후보물질을 개발하고 있었음을 의미
	bysort gvkey_dc_refine id_cortellis develop_indication (develop_year_refine2 develop_status_num develop_status_num_other): gen cnt = _N
	**--> 어떤 indication / therapeutic area 의 
	*****유일한 기록이 "Discontinued" "Withdrawn" "Suspended" "No Dev. Reported" 인 경우가 있음
	*****유일한 기록이 Discontinued 인 경우: 1,367 건
	*****유일한 기록이 No Dev Reported 인 경우: 2,370건
	*****유일한 기록이 Withdrawn 인 경우: 39건
	*****유일한 기록이 Suspended 인 경우: 106건
		
	**--> 유일한 기록이 이렇게 failure 일 경우, failure 가 어떤 단계에서 일어났는지 알 수가 없음.
	**--> timing of failure 가 missing 처리 될 수 밖에 없음 
	save "E:\ARK\as of Jul 2024\[004_8] (develop_status_refine) Drug_development summary.dta"
}


****나중에 patent 기준 dataset 만들 때, [004_8] 에 patent info. 붙인 이후, [004_9] dataset 만드는 것과 동일한 방법으로 변수 구축 
*Create Dataset: [004_9] unique value by gvkey_dc_refine, id_cortellis, develop_year_refine2

{	
	clear 
	use "E:\ARK\as of Jul 2024\[004_8] (develop_status_refine) Drug_development summary.dta"
	
	local change "fail_DNSW_status_recent fail_DNW_status_recent fail_DW_status_recent fail_D_status_recent fail_DNSW_year_recent fail_DNW_year_recent fail_DW_year_recent fail_D_year_recent fail_DNSW_2_year_recent fail_DNW_2_year_recent fail_DW_2_year_recent fail_D_2_year_recent fail_DNSW_2_status_recent fail_DNW_2_status_recent fail_DW_2_status_recent fail_D_2_status_recent"
	foreach x of local change {
		gsort gvkey_dc_refine id_cortellis develop_year_refine2  -`x'
		by gvkey_dc_refine id_cortellis develop_year_refine2: replace `x' = `x'[1]
		
	}
	
	gsort gvkey_dc_refine id_cortellis develop_year_refine2 -external
	by gvkey_dc_refine id_cortellis develop_year_refine2: replace external = external[1]
	
	gsort gvkey_dc_refine id_cortellis develop_year_refine2 -dev_history_bf_MnA
	by gvkey_dc_refine id_cortellis develop_year_refine2: replace dev_history_bf_MnA = dev_history_bf_MnA[1]

	keep gvkey_dc_refine external dev_history_bf_MnA extension id_cortellis DrugName develop_year_refine2 fail_DNSW_status_recent fail_DNW_status_recent fail_DW_status_recent fail_D_status_recent cnt_DV_redeploy cnt_DV_diff_indi cnt_DV_diff_TA  cnt_fail_DNSW cnt_fail_DNW cnt_fail_DW cnt_fail_D fail_DNSW_year_recent fail_DNW_year_recent fail_DW_year_recent fail_D_year_recent
	duplicates drop
	duplicates report gvkey_dc_refine id_cortellis develop_year_refine2
	
	*DV
	rename cnt_DV_redeploy DV_v1_redeploy
	rename cnt_DV_diff_indi DV_v2_diff_indi
	rename cnt_DV_diff_TA DV_v3_diff_TA

	*IDV1: number of failures (or incident of failure) // ~_2: excluding failure reasons related to pipeline prioritization, bankruptcy, cost (not related to R&D failures)
	rename cnt_fail_DNSW IDV1_cnt_fail_DNSW
	rename cnt_fail_DNW IDV1_cnt_fail_DNW
	rename cnt_fail_DW IDV1_cnt_fail_DW
	rename cnt_fail_D IDV1_cnt_fail_D

	rename cnt_fail_DNSW_2 IDV1_cnt_fail_DNSW_2
	rename cnt_fail_DNW_2 IDV1_cnt_fail_DNW_2
	rename cnt_fail_DW_2 IDV1_cnt_fail_DW_2
	rename cnt_fail_D_2 IDV1_cnt_fail_D_2

	
	*IDV2: Redeployment timing
	local IDV "DNSW DNW DW D"
	foreach x of local IDV {
		gen IDV2_v1_red_timing_`x' = develop_year_refine2 - fail_`x'_year_recent if !missing( fail_`x'_year_recent ) & DV_v1_redeploy != 0
	}
	foreach x of local IDV {
		gen IDV2_v2_red_timing_`x' = develop_year_refine2 - fail_`x'_year_recent if !missing( fail_`x'_year_recent ) & DV_v2_diff_indi != 0
	}
	foreach x of local IDV {
		gen IDV2_v3_red_timing_`x' = develop_year_refine2 - fail_`x'_year_recent if !missing( fail_`x'_year_recent ) & DV_v3_diff_TA != 0
	}
	
	foreach x of local IDV {
		gen CTR_no_fail_`x'_dummy = (IDV1_cnt_fail_`x' == 0)
	}
	
		/////  ~_2: excluding failure reasons related to pipeline prioritization, bankruptcy, cost (not related to R&D failures)
	foreach x of local IDV {
		gen IDV2_v1_red_timing_`x'_2 = develop_year_refine2 - fail_`x'_2_year_recent if !missing( fail_`x'_2_year_recent ) & DV_v1_redeploy != 0
	}
	foreach x of local IDV {
		gen IDV2_v2_red_timing_`x'_2 = develop_year_refine2 - fail_`x'_2_year_recent if !missing( fail_`x'_2_year_recent ) & DV_v2_diff_indi != 0
	}
	foreach x of local IDV {
		gen IDV2_v3_red_timing_`x'_2 = develop_year_refine2 - fail_`x'_2_year_recent if !missing( fail_`x'_2_year_recent ) & DV_v3_diff_TA != 0
	}
	
	foreach x of local IDV {
		gen CTR_no_fail_`x'_2_dummy = (IDV1_cnt_fail_`x'_2 == 0)
	}

	*IDV3: Failure timing
	timing (ver0) Discovery/Preclinical (1) -> Clinical/P1/P2/P3 (2) -> Pre-regi/Registered/Launched (3)
	timing (ver1) Discovery(1) -> Preclinical(2) -> Clinical/P1/P2/P3 (3) -> Pre-registration(4) -> Registration(5) -> Launched(6)
	timing (ver2) Discovery(1) -> Preclinical(2) -> Clinical (3) -> P1(4) -> P2(5) -> P3(6) -> Pre-registration(7) -> Registration(8) Launched(9)
	timing (ver3) Discovery(1) -> Preclinical(2) -> P1(3) -> Clinical(4) -> P2(5) -> P3(6) -> Pre-registration(7) -> Registration(8) Launched(9)
	timing (ver4) Discovery(1) -> Preclinical(2) -> P1(3) -> P2(4) -> Clinical(5) -> P3(6) -> Pre-registration(7) -> Registration(8) Launched(9)
	timing (ver5) Discovery(1) -> Preclinical(2) -> P1(3) -> P2(4) -> P3(5) -> Clinical(6) -> Pre-registration(7) -> Registration(8) Launched(9)
	(?? Outlicensed)
	
	local IDV "DNSW DNW DW D DNSW_2 DNW_2 DW_2 D_2"
	foreach x of local IDV {
		gen IDV3_fail_timing_v0_`x'     = 1 if fail_`x'_status_recent == " Discovery"
		replace IDV3_fail_timing_v0_`x'     = 1 if fail_`x'_status_recent == " Preclinical"
		replace IDV3_fail_timing_v0_`x'     = 2 if fail_`x'_status_recent == " Clinical"
		replace IDV3_fail_timing_v0_`x'     = 2 if fail_`x'_status_recent == " Phase 1 Clinical"
		replace IDV3_fail_timing_v0_`x'     = 2 if fail_`x'_status_recent == " Phase 2 Clinical"
		replace IDV3_fail_timing_v0_`x'     = 2 if fail_`x'_status_recent == " Phase 3 Clinical"
		replace IDV3_fail_timing_v0_`x'     = 3 if fail_`x'_status_recent == " Pre-registration"
		replace IDV3_fail_timing_v0_`x'     = 3 if fail_`x'_status_recent == " Registered"
		replace IDV3_fail_timing_v0_`x'     = 3 if fail_`x'_status_recent == " Launched"
		
		gen IDV3_fail_timing_v1_`x'     = 1 if fail_`x'_status_recent == " Discovery"
		replace IDV3_fail_timing_v1_`x' = 2 if fail_`x'_status_recent == " Preclinical"
		replace IDV3_fail_timing_v1_`x' = 3 if fail_`x'_status_recent == " Clinical"
		replace IDV3_fail_timing_v1_`x' = 3 if fail_`x'_status_recent == " Phase 1 Clinical"
		replace IDV3_fail_timing_v1_`x' = 3 if fail_`x'_status_recent == " Phase 2 Clinical"
		replace IDV3_fail_timing_v1_`x' = 3 if fail_`x'_status_recent == " Phase 3 Clinical"
		replace IDV3_fail_timing_v1_`x' = 4 if fail_`x'_status_recent == " Pre-registration"
		replace IDV3_fail_timing_v1_`x' = 5 if fail_`x'_status_recent == " Registered"
		replace IDV3_fail_timing_v1_`x' = 6 if fail_`x'_status_recent == " Launched"

		gen IDV3_fail_timing_v2_`x'     = 1 if fail_`x'_status_recent == " Discovery"
		replace IDV3_fail_timing_v2_`x' = 2 if fail_`x'_status_recent == " Preclinical"
		replace IDV3_fail_timing_v2_`x' = 3 if fail_`x'_status_recent == " Clinical"
		replace IDV3_fail_timing_v2_`x' = 4 if fail_`x'_status_recent == " Phase 1 Clinical"
		replace IDV3_fail_timing_v2_`x' = 5 if fail_`x'_status_recent == " Phase 2 Clinical"
		replace IDV3_fail_timing_v2_`x' = 6 if fail_`x'_status_recent == " Phase 3 Clinical"
		replace IDV3_fail_timing_v2_`x' = 7 if fail_`x'_status_recent == " Pre-registration"
		replace IDV3_fail_timing_v2_`x' = 8 if fail_`x'_status_recent == " Registered"
		replace IDV3_fail_timing_v2_`x' = 9 if fail_`x'_status_recent == " Launched"
	
		gen IDV3_fail_timing_v3_`x'     = 1 if fail_`x'_status_recent == " Discovery"
		replace IDV3_fail_timing_v3_`x' = 2 if fail_`x'_status_recent == " Preclinical"
		replace IDV3_fail_timing_v3_`x' = 3 if fail_`x'_status_recent == " Phase 1 Clinical"
		replace IDV3_fail_timing_v3_`x' = 4 if fail_`x'_status_recent == " Clinical"
		replace IDV3_fail_timing_v3_`x' = 5 if fail_`x'_status_recent == " Phase 2 Clinical"
		replace IDV3_fail_timing_v3_`x' = 6 if fail_`x'_status_recent == " Phase 3 Clinical"
		replace IDV3_fail_timing_v3_`x' = 7 if fail_`x'_status_recent == " Pre-registration"
		replace IDV3_fail_timing_v3_`x' = 8 if fail_`x'_status_recent == " Registered"
		replace IDV3_fail_timing_v3_`x' = 9 if fail_`x'_status_recent == " Launched"
		
		gen IDV3_fail_timing_v4_`x'     = 1 if fail_`x'_status_recent == " Discovery"
		replace IDV3_fail_timing_v4_`x' = 2 if fail_`x'_status_recent == " Preclinical"
		replace IDV3_fail_timing_v4_`x' = 3 if fail_`x'_status_recent == " Phase 1 Clinical"
		replace IDV3_fail_timing_v4_`x' = 4 if fail_`x'_status_recent == " Phase 2 Clinical"
		replace IDV3_fail_timing_v4_`x' = 5 if fail_`x'_status_recent == " Clinical"
		replace IDV3_fail_timing_v4_`x' = 6 if fail_`x'_status_recent == " Phase 3 Clinical"
		replace IDV3_fail_timing_v4_`x' = 7 if fail_`x'_status_recent == " Pre-registration"
		replace IDV3_fail_timing_v4_`x' = 8 if fail_`x'_status_recent == " Registered"
		replace IDV3_fail_timing_v4_`x' = 9 if fail_`x'_status_recent == " Launched"

		gen IDV3_fail_timing_v5_`x'     = 1 if fail_`x'_status_recent == " Discovery"
		replace IDV3_fail_timing_v5_`x' = 2 if fail_`x'_status_recent == " Preclinical"
		replace IDV3_fail_timing_v5_`x' = 3 if fail_`x'_status_recent == " Phase 1 Clinical"
		replace IDV3_fail_timing_v5_`x' = 4 if fail_`x'_status_recent == " Phase 2 Clinical"
		replace IDV3_fail_timing_v5_`x' = 5 if fail_`x'_status_recent == " Phase 3 Clinical"
		replace IDV3_fail_timing_v5_`x' = 6 if fail_`x'_status_recent == " Clinical"
		replace IDV3_fail_timing_v5_`x' = 7 if fail_`x'_status_recent == " Pre-registration"
		replace IDV3_fail_timing_v5_`x' = 8 if fail_`x'_status_recent == " Registered"
		replace IDV3_fail_timing_v5_`x' = 9 if fail_`x'_status_recent == " Launched"
	
}
	
	
	save "E:\ARK\as of Jul 2024\[004_9] by gvkey_dc_refine id_cortellis develop_year_refine2.dta"
	
}

****put patent data to [004_9]
{
	clear
	use "E:\ARK\as of Jul 2024\[200] Patent_gvkey-dc attached (patent ownership).dta"
	drop if missing(gvkey_dc_refine)
	drop upper_develop_company org patent_owner_detail id_dc_upper org_detail gvkey_dc
	duplicates drop

	gsort gvkey_dc_refine PatentNumber priority_year -patent_owner
	by gvkey_dc_refine PatentNumber priority_year: replace patent_owner = patent_owner[1]
	
	gsort gvkey_dc_refine PatentNumber priority_year -licensee_develop_marketing
	by gvkey_dc_refine PatentNumber priority_year: replace licensee_develop_marketing = licensee_develop_marketing[1]
	
	gsort gvkey_dc_refine PatentNumber priority_year -licensee_marketing
	by gvkey_dc_refine PatentNumber priority_year: replace licensee_marketing = licensee_marketing[1]
	
	gsort gvkey_dc_refine PatentNumber priority_year -patent_assignee_owner
	by gvkey_dc_refine PatentNumber priority_year: replace patent_assignee_owner = patent_assignee_owner[1]
	
	duplicates drop
	
	sort gvkey_dc_refine priority_year PatentNumber
	
	gen cnt = 1 if !missing(PatentNumber)
	replace cnt = 0 if missing(cnt)
	tab memo cnt
	drop memo
	
	by gvkey_dc_refine priority_year: egen total_ptn = total(cnt)
	drop if missing(priority_year)
	tab cnt
	
	by gvkey_dc_refine priority_year: egen total_ptn_assignee_owner = total( patent_assignee_owner )
	by gvkey_dc_refine priority_year: egen total_ptn_licen_DM = total( licensee_develop_marketing )
	by gvkey_dc_refine priority_year: egen total_ptn_licen_M = total( licensee_marketing )
	by gvkey_dc_refine priority_year: egen total_ptn_owner = total( patent_owner )
	
	merge m:1 PatentNumber using "E:\ARK\Preprocessing_as of Dec 2023\2024-March\[703] Patent_patent type.dta"
	drop if _merge == 2
	drop _merge
	replace New_use = 1 if PatentNumber == "WO-2019089080"
	replace New_use = 1 if PatentNumber == "WO-2018209255"
	replace Product = 1 if PatentNumber == "WO-2018209255"
	replace Product_pure = 1 if PatentNumber == "WO-2018209255"
	replace Secondary = 1 if PatentNumber == "WO-2018209255"
	replace Secondary = 1 if PatentNumber == "WO-2019089080"
	
	local change " Product Product_derivative Formulation New_use Compo_of_Compo Process Diag Drug_combination Delivery Product_pure Secondary "
	foreach x of local change {
	replace `x' = 0 if missing(`x')
	}
	
	merge m:1 PatentNumber using  "E:\ARK\Preprocessing_as of Dec 2023\2024-March\[702] Patent_only university patents.dta"
	drop if _merge == 2
	replace PATENT_university = 0 if missing( PATENT_university)
	
	drop _merge
	merge m:1 PatentNumber using "E:\ARK\as of Jul 2024\[400] Patent_unique_IPCcodes.dta"
	drop if _merge == 2
	gen missing_IPCcodes = (_merge == 1)
	drop _merge
	
	gen Secondary_assignee = patent_assignee_owner * Secondary
	replace Secondary_assignee = 0 if missing(Secondary_assignee)
	
	gen Product_pure_assignee = patent_assignee_owner * Product_pure
	replace Product_pure_assignee = 0 if missing(Product_pure_assignee)
	
	gen univeristy_assignee = patent_assignee_owner * PATENT_university
	replace univeristy_assignee = 0 if missing(univeristy_assignee)
	
	local total "Product Product_derivative Formulation New_use Compo_of_Compo Process Diag Drug_combination Delivery Product_pure Secondary PATENT_university Secondary_assignee Product_pure_assignee univeristy_assignee"
	foreach x of local total {
		bysort gvkey_dc_refine priority_year: egen total_`x' = total(`x')
	}
	save "E:\ARK\as of Jul 2024\[200_2] Patent_type_university_IPC.dta"
	
	clear
	use "E:\ARK\as of Jul 2024\[200_2] Patent_type_university_IPC.dta"
	
	keep gvkey_dc_refine priority_year total_ptn total_ptn_assignee_owner total_ptn_licen_DM total_ptn_licen_M total_ptn_owner total_Product total_Product_derivative total_Formulation total_New_use total_Compo_of_Compo total_Process total_Diag total_Drug_combination total_Delivery total_Product_pure total_Secondary total_PATENT_university
	duplicates drop
	duplicates report gvkey_dc_refine priority_year
	
	gen log_total_ptn = log(1+total_ptn)
	gen log_total_Product_pure = log(1+total_Product_pure)
	gen log_total_Secondary = log(1+total_Secondary)
	gen log_total_university = log(1+total_PATENT_university)

	gen ratio_Product_pure = total_Product_pure / total_ptn
	replace ratio_Product_pure = 0 if total_ptn == 0

	gen ratio_Secondary = total_Secondary / total_ptn
	replace ratio_Secondary = 0 if total_ptn == 0

	gen ratio_Secondary_2 = (total_Product_pure - total_Secondary) / total_ptn
	replace ratio_Secondary_2 = 0 if total_ptn == 0

	gen ratio_Secondary_3 = (total_Secondary) / total_Product_pure
	replace ratio_Secondary_3 = 0 if total_Product_pure == 0
	
	gen ratio_university = total_PATENT_university / total_ptn 
	replace ratio_university = 0 if total_ptn == 0

	gen log_total_ptn_assign = log(1+total_ptn_assignee_owner)
	gen log_total_Product_pure_assign = log(1+total_Product_pure_assignee)
	gen log_total_Secon_assign = log(1+total_Secondary_assignee)
	gen log_total_univ_assign = log(1+total_univeristy_assignee)
	
	gen ratio_Product_pure_assign = total_Product_pure_assignee / total_ptn_assignee_owner
	replace ratio_Product_pure_assign = 0 if total_ptn_assignee_owner == 0

	gen ratio_Secondary_assign = total_Secondary_assignee / total_ptn_assignee_owner
	replace ratio_Secondary_assign = 0 if total_ptn_assignee_owner == 0
	
	gen ratio_Secondary_2_assign = (total_Product_pure_assignee - total_Secondary_assignee) / total_ptn_assignee_owner
	replace ratio_Secondary_2_assign = 0 if total_ptn_assignee_owner == 0
	
	gen ratio_Secondary_3_assign = (total_Secondary_assignee) / total_Product_pure_assignee
	replace ratio_Secondary_3_assign = 0 if total_Product_pure_assignee == 0
	
	gen ratio_univeristy_assign = total_univeristy_assignee / total_ptn_assignee_owner 
	replace ratio_univeristy_assign = 0 if total_ptn_assignee_owner == 0

	save "E:\ARK\as of Jul 2024\[200_3] (by gvkey_dc_refine priority_year) Patent_type_university_IPC.dta"	
	
	clear
	use "E:\ARK\as of Jul 2024\[004_9] by gvkey_dc_refine id_cortellis develop_year_refine2.dta"
	
	merge m:1 gvkey_dc_refine develop_year_refine2 using "E:\ARK\as of Jul 2024\[200_3] (by gvkey_dc_refine priority_year) Patent_type_university_IPC.dta"
	drop if _merge == 2 
	
	local change "total_ptn total_ptn_assignee_owner total_ptn_licen_DM total_ptn_licen_M total_ptn_owner total_Product total_Product_derivative total_Formulation total_New_use total_Compo_of_Compo total_Process total_Diag total_Drug_combination total_Delivery total_Product_pure total_Secondary total_PATENT_university"
	foreach x of local change {
		replace `x' = 0 if _merge == 1
	}
	drop _merge 
	save "E:\ARK\as of Jul 2024\[004_9] by gvkey_dc_refine id_cortellis develop_year_refine2.dta"
}

**# Bookmark #19

****put compustat data to [004_9]
{
	clear
	use "E:\ARK\as of Jul 2024\[004_9] by gvkey_dc_refine id_cortellis develop_year_refine2.dta"
	
	rename gvkey_dc_refine gvkey
	rename develop_year_refine2 year
	
	merge m:1 gvkey year using "E:\ARK\Original data\Compustat_1990_2023.dta"
	drop if _merge ==2
	
	rename gvkey gvkey_dc_refine
	rename year develop_year_refine2
	order conm, a(gvkey_dc_refine)
	
	//control variables from ECSR paper history
	gen mrkcap = csho*prcc_f
	gen wrkcap = act - lct
	gen sales = sale / (cshpri * ajex)
				
	lnskew0 FIRM_ln_emp = emp
	lnskew0 FIRM_ln_at  = at
	lnskew0 FIRM_ln_sale = sale
	lnskew0 FIRM_ln_mrkcap = mrkcap
	lnskew0 FIRM_ln_sales = sales

	//Researchers have measured organizational slack using various accoungting data.
	// Tyler & Caner (2016) created a composite slack index consisting of 
	// three categories of slack: available slack, absorbed slack, and potential slack.

	// (1) Avilable Slack: measures the liquid resources uncommitted to liabilities
	// 				  == current asset / current liabilities
		gen FIRM_slack_avai = act / lct
	// (2) Absorbed Slack: is related to capital utilization
	// 				  == working capital-to-sales ratio (기존에 만든 orgslack1 과 동일함)
		gen FIRM_slack_absor = wrkcap / sales
	// (3) Potential Slack: reflects the ability of firms to borrow further
	//				  == equity-to-debt ratio (total asset - total liabilities / total long-term debt)
		gen FIRM_slack_poten = (at - lt )/ dltt

	// Tyler & Caner (2016) calculated each slack category, standardize, and sum these categories to create a slack index.

	// (4) Standardize three categories of slack (reference: https://stats.idre.ucla.edu/stata/faq/how-do-i-standardize-variables-in-stata/)
		egen FIRM_st_slack_avai = std(FIRM_slack_avai)
		egen FIRM_st_slack_absorb = std(FIRM_slack_absor)
		egen FIRM_st_slack_poten = std(FIRM_slack_poten)

	// (5) sum three standardized slack categories to create a slack index
		gen FIRM_slack_index = st_slack_avai + st_slack_absorb + st_slack_poten

		gen FIRM_tobinQ = (at + (csho*prcc_f) - ceq) / at
		gen FIRM_ROA = ni/at
		gen FIRM_ROE = ni/(csho*prcc_f)
		gen FIRM_ROI = ni/icapt
		gen FIRM_EPS = ni/csho

		gen FIRM_RnDinten = xrd / emp
		gen FIRM_RnDinten2 = xrd / at

		gen FIRM_astspec = ppent / emp
				
		lnskew0 FIRM_ln_slack_avai = FIRM_slack_avai
		lnskew0 FIRM_ln_slack_absor = FIRM_slack_absor
		lnskew0 FIRM_ln_slack_poten = FIRM_slack_poten

		lnskew0 FIRM_ln_tobinQ = FIRM_tobinQ
		lnskew0 FIRM_ln_ROA = FIRM_ROA
		lnskew0 FIRM_ln_ROE = FIRM_ROE
		lnskew0 FIRM_ln_ROI = FIRM_ROI
		lnskew0 FIRM_ln_EPS = FIRM_EPS
		lnskew0 FIRM_ln_RnDinten = FIRM_RnDinten
		lnskew0 FIRM_ln_RnDinten2 = FIRM_RnDinten2
		lnskew0 FIRM_ln_astspec = FIRM_astspec
		*market to book ratio = mkvalt / bkvlps
		*market value = mkvalt OR csho & prcc_f
		*payout ratio = (dvp + dvc + prstkc) / ib
		*tangibility = ppent/at
		*total equity = pstkc + csho
		*(reference: https://www.wiwi.uni-muenster.de/uf/sites/uf/files/2017_10_12_wrds_data_items.pdf)

}

***Other control variables
{
	clear
	use "E:\ARK\as of Jul 2024\[004_8] (develop_status_refine) Drug_development summary.dta"
	keep gvkey_dc_refine develop_year_refine2 id_cortellis DrugName develop_status develop_indication develop_therapy
	duplicates drop

	keep if develop_status == " Launched"
	bysort gvkey_dc_refine develop_year_refine2 : gen CTR_cnt_launched = _N
	drop id_cortellis develop_indication DrugName
	duplicates drop
	bysort gvkey_dc_refine develop_year_refine2 : gen cnt = (_n == 1)
	drop cnt
	bysort gvkey_dc_refine develop_year_refine2 develop_therapy: gen cnt = (_n == 1)
	bysort gvkey_dc_refine develop_year_refine2 : egen CTR_cnt_launched_therapy = total(cnt)
	drop cnt
	keep gvkey_dc_refine develop_year_refine2 CTR_cnt_launched CTR_cnt_launched_therapy
	duplicates drop
	save "E:\ARK\as of Jul 2024\[004_8a] (develop_status_refine) launched_drugs_by gvkey year.dta"
	
	clear
	use "E:\ARK\as of Jul 2024\[004_9] by gvkey_dc_refine id_cortellis develop_year_refine2.dta"
	
	drop _merge
	merge m:1 gvkey_dc_refine develop_year_refine2 using "E:\ARK\as of Jul 2024\[004_8a] (develop_status_refine) launched_drugs_by gvkey year.dta"
	replace CTR_cnt_launched = 0 if _merge == 1
	replace CTR_cnt_launched_therapy = 0 if _merge == 1
	drop _merge
	drop *_fn
	drop *_dc
	
	gen CTR_avg_launched_therapy = CTR_cnt_launched_therapy / CTR_cnt_launched
	replace CTR_avg_launched_therapy = 0 if CTR_cnt_launched == 0
	
	CTR_cnt_launched (number of launched id_cortellis by gvkey_dc_refine, develop_year_refine2)
	CTR_cnt_launched_therapy (number of unique launched therapeutic area by gvkey_dc_refine, develop_year_refine2)
	CTR_avg_launched_therapy (CTR_cnt_launched_therapy / CTR_cnt_launched) <- average number of therapeutic area where firms launched the drug
	
	save "E:\ARK\as of Jul 2024\[004_9] by gvkey_dc_refine id_cortellis develop_year_refine2.dta"	
	
}

*** FIRM_level control variable moving average . Firm-level 변수만 따로 dataset 구축
{
	clear
	use "E:\ARK\as of Jul 2024\[004_9] by gvkey_dc_refine id_cortellis develop_year_refine2.dta"
	keep gvkey_dc_refine develop_year_refine2 total_ptn - CTR_avg_launched_therapy
	duplicates drop
	save "E:\ARK\as of Jul 2024\[004_9a] (for moving average) by gvkey_dc_refine id_cortellis develop_year_refine2.dta"
	
	clear
	use "E:\ARK\as of Jul 2024\[004_9a] (for moving average) by gvkey_dc_refine id_cortellis develop_year_refine2.dta"
	xtset gvkey_dc_refine develop_year_refine2

	
	local logg "emp at sale mrkcap sales FIRM_slack_avai FIRM_slack_absor FIRM_slack_poten  FIRM_tobinQ FIRM_ROA FIRM_ROE FIRM_ROI FIRM_EPS FIRM_RnDinten FIRM_RnDinten2  FIRM_astspec"
	
	foreach x of local logg {
		gen log_`x' = log(1+`x')
	}
	
	local change "total_ptn total_ptn_assignee_owner total_ptn_licen_DM total_ptn_licen_M total_ptn_owner total_Product total_Product_derivative total_Formulation total_New_use total_Compo_of_Compo total_Process total_Diag total_Drug_combination total_Delivery total_Product_pure total_Secondary total_PATENT_university FIRM_ln_emp FIRM_ln_at FIRM_ln_sale FIRM_ln_mrkcap FIRM_slack_avai FIRM_slack_absor FIRM_slack_poten FIRM_st_slack_avai FIRM_st_slack_absorb FIRM_st_slack_poten FIRM_tobinQ FIRM_ROA FIRM_ROE FIRM_ROI FIRM_EPS FIRM_RnDinten FIRM_RnDinten2 FIRM_astspec FIRM_ln_slack_avai FIRM_ln_slack_absor FIRM_ln_slack_poten FIRM_ln_tobinQ FIRM_ln_ROA FIRM_ln_ROE FIRM_ln_ROI FIRM_ln_EPS FIRM_ln_RnDinten FIRM_ln_astspec CTR_cnt_launched CTR_cnt_launched_therapy CTR_avg_launched_therapy log_total_ptn log_total_Secondary log_emp log_at log_sale log_mrkcap log_sales log_FIRM_slack_avai log_FIRM_slack_absor log_FIRM_slack_poten log_FIRM_tobinQ log_FIRM_ROA log_FIRM_ROE log_FIRM_ROI log_FIRM_EPS log_FIRM_RnDinten log_FIRM_RnDinten2 log_FIRM_astspec"	
	foreach x of local change {
		tssmooth ma `x'_ma3 = `x', window(3 0 0)
		tssmooth ma `x'_ma5 = `x', window(5 0 0)
		tssmooth ma `x'_ma7 = `x', window(7 0 0)
		tssmooth ma `x'_ma9 = `x', window(9 0 0)
	}
	save "E:\ARK\as of Jul 2024\[004_9a] (for moving average) by gvkey_dc_refine id_cortellis develop_year_refine2.dta"
	
	clear
	use "E:\ARK\as of Jul 2024\[004_9] by gvkey_dc_refine id_cortellis develop_year_refine2.dta"
	merge m:1 gvkey_dc_refine develop_year_refine2 using "E:\ARK\as of Jul 2024\[004_9a] (for moving average) by gvkey_dc_refine id_cortellis develop_year_refine2.dta"
	drop _merge
	save "E:\ARK\as of Jul 2024\[004_9] by gvkey_dc_refine id_cortellis develop_year_refine2.dta"
	
	}

***DV construction
{
	clear
	use "E:\ARK\as of Jul 2024\[004_9] by gvkey_dc_refine id_cortellis develop_year_refine2.dta"

	
	gen DV_v1_redeploy_dum = ( DV_v1_redeploy != 0)
	gen DV_v2_diff_indi_dum = ( DV_v2_diff_indi != 0)
	gen DV_v3_diff_TA_dum = ( DV_v3_diff_TA != 0)
	gen DV_v4_same_TA_dum = (DV_v3_diff_TA_dum == 0 & DV_v2_diff_indi != 0)
	
	gen external_dum = (external == 1)
	gen extension_dum = (extension == 1)
	
	local fail "IDV1_cnt_fail_DNSW IDV1_cnt_fail_DNW IDV1_cnt_fail_DW IDV1_cnt_fail_D IDV1_cnt_fail_DNSW_2 IDV1_cnt_fail_DNW_2 IDV1_cnt_fail_DW_2 IDV1_cnt_fail_D_2"
	foreach x of local fail {
		gen `x'_dum = (`x' > 0)
	}

	**tag top 15 pharma firm (from Markou et al. 2023)
	gen top15 = 0
	foreach num of numlist 16101 1602 28272 100080 2403 6730 24856 5180 6266 7257 101310 8530 25648 101204 14538  {
		replace top15 = 1 if gvkey_dc_refine == `num'
	}
	
	gen top17 = top15
	replace top17 = 1 if gvkey_dc_refine == 100718 
	replace top17 = 1 if gvkey_dc_refine == 8020 
	
	local lagg "IDV2_v1_red_timing_DNSW IDV2_v1_red_timing_DNW IDV2_v1_red_timing_DW IDV2_v1_red_timing_D IDV2_v2_red_timing_DNSW IDV2_v2_red_timing_DNW IDV2_v2_red_timing_DW IDV2_v2_red_timing_D IDV2_v3_red_timing_DNSW IDV2_v3_red_timing_DNW IDV2_v3_red_timing_DW IDV2_v3_red_timing_D IDV2_v1_red_timing_DNSW_2 IDV2_v1_red_timing_DNW_2 IDV2_v1_red_timing_DW_2 IDV2_v1_red_timing_D_2 IDV2_v2_red_timing_DNSW_2 IDV2_v2_red_timing_DNW_2 IDV2_v2_red_timing_DW_2 IDV2_v2_red_timing_D_2 IDV2_v3_red_timing_DNSW_2 IDV2_v3_red_timing_DNW_2 IDV2_v3_red_timing_DW_2 IDV2_v3_red_timing_D_2 IDV3_fail_timing_v0_DNSW IDV3_fail_timing_v1_DNSW IDV3_fail_timing_v2_DNSW IDV3_fail_timing_v3_DNSW IDv4_fail_timing_v4_DNSW IDv5_fail_timing_v5_DNSW IDV3_fail_timing_v0_DNW IDV3_fail_timing_v1_DNW IDV3_fail_timing_v2_DNW IDV3_fail_timing_v3_DNW IDv4_fail_timing_v4_DNW IDv5_fail_timing_v5_DNW IDV3_fail_timing_v0_DW IDV3_fail_timing_v1_DW IDV3_fail_timing_v2_DW IDV3_fail_timing_v3_DW IDv4_fail_timing_v4_DW IDv5_fail_timing_v5_DW IDV3_fail_timing_v0_D IDV3_fail_timing_v1_D IDV3_fail_timing_v2_D IDV3_fail_timing_v3_D IDv4_fail_timing_v4_D IDv5_fail_timing_v5_D IDV3_fail_timing_v0_DNSW_2 IDV3_fail_timing_v1_DNSW_2 IDV3_fail_timing_v2_DNSW_2 IDV3_fail_timing_v3_DNSW_2 IDv4_fail_timing_v4_DNSW_2 IDv5_fail_timing_v5_DNSW_2 IDV3_fail_timing_v0_DNW_2 IDV3_fail_timing_v1_DNW_2 IDV3_fail_timing_v2_DNW_2 IDV3_fail_timing_v3_DNW_2 IDv4_fail_timing_v4_DNW_2 IDv5_fail_timing_v5_DNW_2 IDV3_fail_timing_v0_DW_2 IDV3_fail_timing_v1_DW_2 IDV3_fail_timing_v2_DW_2 IDV3_fail_timing_v3_DW_2 IDv4_fail_timing_v4_DW_2 IDv5_fail_timing_v5_DW_2 IDV3_fail_timing_v0_D_2 IDV3_fail_timing_v1_D_2 IDV3_fail_timing_v2_D_2 IDV3_fail_timing_v3_D_2 IDv4_fail_timing_v4_D_2 IDv5_fail_timing_v5_D_2"
	foreach x of local lagg {
		gen k`x'= `x'
		replace k`x' = !missing(`x')
		bysort gvkey_dc_refine PatentNumber (develop_year_refine2): gen k`x'_t_1 = k`x'[_n-1]
		
	}
	
	
	probit DV_v3_diff_TA_dum  IDV1_cnt_fail_DNSW_2_dum_t_1 kIDV2_v1_red_timing_DNSW_t_1 kIDV3_fail_timing_v0_DNSW_2_t_1 ratio_Secondary_ma3 ratio_university_ma3 external_dum extension_dum log_FIRM_RnDinten_ma3 CTR_avg_launched_therapy_ma3   i.gvkey_dc_refine i.develop_year_refine2 if top15 == 1 & develop_year_refine2 > 1998 , cluster(gvkey_dc_refine) robust
	
	probit DV_v3_diff_TA_dum i.IDV1_cnt_fail_DNSW_2_dum_t_1##c.kIDV2_v1_red_timing_DNSW_t_1  kIDV3_fail_timing_v0_DNSW_2_t_1  ratio_Secondary_ma3 ratio_university_ma3 external_dum extension_dum log_FIRM_RnDinten_ma3 CTR_avg_launched_therapy_ma3   i.gvkey_dc_refine i.develop_year_refine2 if top15 == 1 & develop_year_refine2 > 1998 , cluster(gvkey_dc_refine) robust

	probit DV_v3_diff_TA_dum i.IDV1_cnt_fail_DNSW_2_dum_t_1##c.kIDV2_v1_red_timing_DNSW_t_1  i.IDV1_cnt_fail_DNSW_2_dum_t_1##c.kIDV3_fail_timing_v0_DNSW_2_t_1  ratio_Secondary_ma3 ratio_university_ma3 external_dum extension_dum log_FIRM_RnDinten_ma3 CTR_avg_launched_therapy_ma3   i.gvkey_dc_refine i.develop_year_refine2 if top15 == 1 & develop_year_refine2 > 1998 , cluster(gvkey_dc_refine) robust

	foreach num of numlist 3 5 7 9 {
		probit DV_v3_diff_TA_dum  IDV1_cnt_fail_DNSW_2_dum_t_1 kIDV2_v1_red_timing_DNSW_t_1 kIDV3_fail_timing_v0_DNSW_2_t_1 ratio_Secondary_ma`num' ratio_university_ma`num' external_dum extension_dum log_FIRM_RnDinten_ma`num' CTR_avg_launched_therapy_ma`num'   i.gvkey_dc_refine i.develop_year_refine2 if top15 == 1 & develop_year_refine2 > 1998 , cluster(gvkey_dc_refine) robust
	}

	probit DV_v3_diff_TA_dum  IDV1_cnt_fail_DNSW_2_dum_t_1 kIDV2_v1_red_timing_DNSW_t_1 kIDV3_fail_timing_v0_DNSW_2_t_1 ratio_Secondary_ma3 ratio_university_ma3 dev_history_bf_MnA external_dum extension_dum log_FIRM_RnDinten_ma3 CTR_avg_launched_therapy_ma3 cnt_TbA cnt_Tech  i.gvkey_dc_refine i.develop_year_refine2 if top15 == 1 & develop_year_refine2 > 1998  & dev_history_bf_MnA_t_1 == 0, cluster(gvkey_dc_refine) robust
	
}	

*Drug data --> cnt_TbA ; cnt_Tech 
{
	clear
	use "E:\ARK\Original data\Cortellis_Drug original (dta_format).dta"
	keep id_cortellis DrugName TherapyArea ActiveIndications TargetbasedActions RegulatoryDesignations Technologies SMILES EphMRACodes InactiveIndications OtherActions
	duplicates drop
	save "E:\ARK\as of Jul 2024\[500] id_cortellis_uniquevalues.dta"

	*Target-based actions
	clear
	use "E:\ARK\as of Jul 2024\[500] id_cortellis_uniquevalues.dta"
	keep id_cortellis DrugName TargetbasedActions
	keep if !missing(TargetbasedActions)
	split TargetbasedActions, p("; ")
	drop TargetbasedActions
	greshape long TargetbasedActions,  by(id_cortellis)
	drop if missing( TargetbasedActions )
	drop _j
	sort id_cortellis TargetbasedActions
	order id_cortellis DrugName TargetbasedActions
	by id_cortellis: gen cnt_TbA = _N
	save "E:\ARK\as of Jul 2024\[501] id_cortellis_target_based_actions.dta"
	
	clear
	use "E:\ARK\as of Jul 2024\[501] id_cortellis_target_based_actions.dta"
	keep id_cortellis DrugName cnt_TbA
	duplicates drop
	merge 1:1 id_cortellis using "E:\ARK\as of Jul 2024\[500] id_cortellis_uniquevalues.dta"
	drop if _merge == 2
	keep id_cortellis DrugName cnt_TbA TargetbasedActions
	compress
	save "E:\ARK\as of Jul 2024\[501a] (unique) id_cortellis_target_based_actions.dta"
		
	*Technologies
	clear
	use "E:\ARK\as of Jul 2024\[500] id_cortellis_uniquevalues.dta"
	keep id_cortellis DrugName Technologies
	split Technologies , p("; ")
	drop Technologies
	greshape long Technologies,  by(id_cortellis)
	drop if missing( Technologies )
	drop _j
	sort id_cortellis Technologies
	order id_cortellis DrugName Technologies
	by id_cortellis: gen cnt_Tech = _N
	save "E:\ARK\as of Jul 2024\[502] id_cortellis_Technologies.dta"
	
	clear
	use "E:\ARK\as of Jul 2024\[502] id_cortellis_Technologies.dta"
	duplicates drop
	merge 1:1 id_cortellis using "E:\ARK\as of Jul 2024\[500] id_cortellis_uniquevalues.dta"
	drop if _merge == 2
	keep id_cortellis DrugName cnt_Tech Technologies
	save "E:\ARK\as of Jul 2024\[502a] (unique) id_cortellis_Technologies.dta"
	
	*EphMRACodes
	clear
	use "E:\ARK\as of Jul 2024\[500] id_cortellis_uniquevalues.dta"
	keep id_cortellis DrugName EphMRACodes
	split EphMRACodes, p("; ")
	drop EphMRACodes
	greshape long EphMRACodes ,  by(id_cortellis)
	drop if missing( EphMRACodes )
	drop _j
	sort id_cortellis EphMRACodes
	order id_cortellis DrugName EphMRACodes
	split EphMRACodes, p(" (")
	replace EphMRACodes2 = "Vitamin B6 (pyridoxine), plain)" if EphMRACodes3 == "pyridoxine), plain)"
	replace EphMRACodes2 = "GP IIb/IIIa (glycoprotein) antagonist platelet aggregation inhibitors)" if EphMRACodes3 == "glycoprotein) antagonist platelet aggregation inhibitors)"
	replace EphMRACodes2 = "BPH (benign prostatic hypertrophy) products)" if EphMRACodes3 == "benign prostatic hypertrophy) products)"
	replace EphMRACodes2 = "Statins (HMG-CoA reductase inhibitors))" if EphMRACodes3 == "HMG-CoA reductase inhibitors))"
	drop EphMRACodes3
	
	rename EphMRACodes EphMRACodes_original
	rename EphMRACodes1 EphMRACodes
	rename EphMRACodes2 EphMRACodes_explain
	save "E:\ARK\as of Jul 2024\[503] id_cortellis_EphMRA.dta"
	
	
}

*year_expand: 예를 들어, develop_year_refine2 에 2001, 2008년 밖에 없으면 그 사이 연도를 새로 삽입 
{
	clear
	use "E:\ARK\as of Jul 2024\[004_9] by gvkey_dc_refine id_cortellis develop_year_refine2.dta"
	keep top17 top15 gvkey_dc_refine conm id_cortellis DrugName develop_year_refine2
	
	gen id = _n
	bysort gvkey_dc_refine id_cortellis (develop_year_refine2): gen next_year = develop_year_refine2[_n+1]
	gen current_year = develop_year_refine2
		
	order next_year current_year, b(develop_year_refine2)

	gen diff = next_year - current_year, b(next_year)
	expand diff
	
	sort gvkey_dc_refine id_cortellis id 		

	by gvkey_dc_refine id_cortellis id: gen year_expand = current_year + _n - 1
	order year_expand, b(develop_year_refine2)

	*tag expanded observation
	gen tag = 1 if year_expand != develop_year_refine2
	order tag
	drop next_year diff current_year
	
	rename gvkey_dc_refine gvkey 
	rename year_expand year
	
	merge m:1 gvkey year using "E:\ARK\Original data\Compustat_1990_2023.dta"
	drop if _merge == 2
	drop _merge next_year diff current_year
	rename gvkey gvkey_dc_refine 
	rename year year_expand  

	gen mrkcap = csho*prcc_f
	gen wrkcap = act - lct
	gen sales = sale / (cshpri * ajex)
	gen FIRM_slack_avai = act / lct
	gen FIRM_slack_absor = wrkcap / sales
	gen FIRM_slack_poten = (at - lt )/ dltt
	egen FIRM_st_slack_avai = std(FIRM_slack_avai)
	egen FIRM_st_slack_absorb = std(FIRM_slack_absor)
	egen FIRM_st_slack_poten = std(FIRM_slack_poten)
	gen FIRM_slack_index =  FIRM_st_slack_avai + FIRM_st_slack_absorb + FIRM_st_slack_poten
	
	gen FIRM_tobinQ = (at + (csho*prcc_f) - ceq) / at
	gen FIRM_ROA = ni/at
	gen FIRM_ROE = ni/(csho*prcc_f)
	gen FIRM_ROI = ni/icapt
	gen FIRM_EPS = ni/csho
	gen FIRM_RnDinten = xrd / emp
	gen FIRM_RnDinten2 = xrd / at
	gen FIRM_astspec = ppent / emp
	sort gvkey_dc_refine id_cortellis year_expand
	duplicates report gvkey_dc_refine id_cortellis year_expand
	local logg "emp at sale mrkcap sales FIRM_slack_avai FIRM_slack_absor FIRM_slack_poten  FIRM_tobinQ FIRM_ROA FIRM_ROE FIRM_ROI FIRM_EPS FIRM_RnDinten FIRM_RnDinten2  FIRM_astspec"
	foreach x of local logg {
	gen log_`x' = log(1+`x')
	}
	
	*drug-level data
	merge m:1 id_cortellis using "E:\ARK\as of Jul 2024\[501a] (unique) id_cortellis_target_based_actions.dta"
	drop if _merge == 2
	drop _merge
	rename cnt_TbA cnt_TbA_original
	gen cnt_TbA = cnt_TbA_original
	replace cnt_TbA = 0 if missing(cnt_TbA)
	
	merge m:1 id_cortellis using "E:\ARK\as of Jul 2024\[502a] (unique) id_cortellis_Technologies.dta"
	drop if _merge == 2
	drop _merge
	rename cnt_Tech cnt_Tech_original
	gen cnt_Tech = cnt_Tech_original
	replace cnt_Tech = 0 if missing(cnt_Tech)
	
	gen biologic = 1 if strpos(Technologies, "Biological therapeutic")
	replace biologic = 0 if strpos(Technologies, "Small molecule")

	
	*firm-level data (patent)
	rename year_expand priority_year
	merge m:1 gvkey_dc_refine priority_year using "E:\ARK\as of Jul 2024\[200_3] (by gvkey_dc_refine priority_year) Patent_type_university_IPC.dta"
	drop if _merge ==2
	local change "total_ptn total_ptn_assignee_owner total_ptn_licen_DM total_ptn_licen_M total_ptn_owner total_Product total_Product_derivative total_Formulation total_New_use total_Compo_of_Compo total_Process total_Diag total_Drug_combination total_Delivery total_Product_pure total_Secondary total_PATENT_university total_Secondary_assignee total_Product_pure_assignee total_univeristy_assignee log_total_ptn log_total_Product_pure log_total_Secondary log_total_university ratio_Product_pure ratio_Secondary ratio_Secondary_2 ratio_Secondary_3 ratio_university log_total_ptn_assign log_total_Product_pure_assign log_total_Secon_assign log_total_univ_assign ratio_Product_pure_assign ratio_Secondary_assign ratio_Secondary_2_assign ratio_Secondary_3_assign ratio_univeristy_assign"
	foreach x of local change {
	replace `x' = 0 if _merge == 1
	}
	drop _merge
	rename priority_year year_expand
	sort gvkey_dc_refine id_cortellis year_expand
	
	drop *_dc
	drop *_fn
	
	*firm_level data (drug launched)
	merge m:1 gvkey_dc_refine year_expand using "E:\ARK\as of Jul 2024\[004_8a] (develop_status_refine) launched_drugs_by gvkey year.dta"
	replace CTR_cnt_launched = 0 if _merge == 1
	replace CTR_cnt_launched_therapy = 0 if _merge == 1
	gen CTR_avg_launched_therapy = CTR_cnt_launched_therapy / CTR_cnt_launched
	replace CTR_avg_launched_therapy = 0 if CTR_cnt_launched == 0
	drop _merge 
	
	
	*** DV, IDV
	{
	clear
	use "E:\ARK\as of Jul 2024\[004_9] by gvkey_dc_refine id_cortellis develop_year_refine2.dta"
	keep gvkey_dc_refine - IDv5_fail_timing_v5_D_2  DV_v1_redeploy_dum - IDV1_cnt_fail_D_2_dum
	duplicates drop
	save "E:\ARK\as of Jul 2024\[004_9b] (before expanded) by gvkey_dc_refine id_cortellis develop_year_refine2.dta"
	}
	
	{
		clear
		use "E:\ARK\as of Jul 2024\[004_8] (develop_status_refine) Drug_development summary.dta"
		gen launched = 1 if develop_status == " Launched"
		bysort gvkey_dc_refine id_cortellis develop_year_refine2 (develop_status_num develop_status_num_other): egen cnt_launched = total(launched)
		local success "launched"
		foreach x of local success {
		bysort gvkey_dc_refine id_cortellis (develop_year_refine2 develop_status_num develop_status_num_other): gen seq_`x' = sum(`x')
		gen `x'_year_recent = develop_year_refine2 if seq_`x'
		bysort gvkey_dc_refine id_cortellis (develop_year_refine2 develop_status_num develop_status_num_other): replace `x'_year_recent = `x'_year_recent[_n-1] if seq_`x' == seq_`x'[_n-1] & seq_`x' != 0
		drop seq_`x' 
		}
		gsort gvkey_dc_refine id_cortellis develop_year_refine2  -launched_year_recent 
		by gvkey_dc_refine id_cortellis develop_year_refine2: replace launched_year_recent = launched_year_recent[1]
		keep gvkey_dc_refine id_cortellis DrugName develop_year_refine2  cnt_launched launched_year_recent cnt_DV_redeploy cnt_DV_diff_indi cnt_DV_diff_TA
		duplicates drop
		duplicates report gvkey_dc_refine id_cortellis develop_year_refine2
		rename cnt_DV_redeploy DV_v1_redeploy
		rename cnt_DV_diff_indi DV_v2_diff_indi
		rename cnt_DV_diff_TA DV_v3_diff_TA
		rename cnt_launched CTR_cnt_launched
		gen CTR_v1_red_timing_launch = develop_year_refine2 - launched_year_recent if !missing( launched_year_recent ) & DV_v1_redeploy != 0
		gen CTR_v2_red_timing_launch  = develop_year_refine2 - launched_year_recent if !missing( launched_year_recent ) & DV_v2_diff_indi != 0
		gen CTR_v3_red_timing_launch = develop_year_refine2 - launched_year_recent if !missing( launched_year_recent ) & DV_v3_diff_TA != 0
		gen CTR_no_success_dummy = ( CTR_cnt_launched == 0)
		tab CTR_cnt_launched
		rename CTR_cnt_launched CTR_cnt_launched_by_drug
		save "E:\ARK\as of Jul 2024\[004_8_1] launched by id_cortellis.dta"
	}
	
	
	merge 1:1 gvkey_dc_refine id_cortellis year_expand using "E:\ARK\as of Jul 2024\[004_9b] (before expanded) by gvkey_dc_refine id_cortellis develop_year_refine2.dta"	
	
	drop extension extension_dum
	gen extension = 1 if strpos(DrugName, "+"), a(dev_history_bf_MnA)
	replace extension = 1 if strpos(DrugName, "release")
	replace extension = 1 if strpos(DrugName, "formulation")
	replace extension = 1 if strpos(DrugName, "infusion")
	replace extension = 1 if strpos(DrugName, "patch")
	replace extension = 1 if strpos(DrugName, "oral")
	replace extension = 1 if strpos(DrugName, "transdermal")
	gen extension_dum = (extension == 1)
		
	*external_N: development history of subsidiary AFTER M&A
	*dev_history_bf_MnA_N: development history of subsidiary BEFORE M&A
	*external_N 과 dev_history_bf_MnA_N 은 모두 다음과 같이 처리함 
	*예를 들어, 원래의 external 이 1999 년에서 1, 2002년에서 1이었고, year_expand 가 그 사이에 추가되었다면 external_N 은 1999년부터 2002년까지 모두 1로 처리.
	*또한, (gvkey_dc_refine 1078, id_cortellis 5267)의 예시와 같이, 원래의 external 이 1995, 1999, 2008년에만 1이고 2003년에는 missing 값이고,  추가된 year_expand 가 1996~1998, 2000~2002, 2004~2007년일 경우, external_N 은 1996~1998, 2000~2002만 1 로 처리. Parent firm 에서 external 이 1 이 아닌 시점 이후부터는 external_N 도 1 로 처리하지 않음
	gen external_N = external, b(external)
	by gvkey_dc_refine id_cortellis: replace external_N = 1 if external_N[_n-1] == 1 & missing(external_N) & tag == 1
	gen external_N_dum = (external_N == 1)
	
	gen dev_history_bf_MnA_N = dev_history_bf_MnA, b( dev_history_bf_MnA)
	by gvkey_dc_refine id_cortellis: replace dev_history_bf_MnA_N = 0 if dev_history_bf_MnA_N[_n-1] == 0 & missing( dev_history_bf_MnA_N) & tag == 1
	by gvkey_dc_refine id_cortellis: replace dev_history_bf_MnA_N = 1 if dev_history_bf_MnA_N[_n-1] == 1 & missing( dev_history_bf_MnA_N) & tag == 1
	
	*DV IDV 모두 새롭게 추가된 expand year (tag == 1) 에서 0 의 값을 가짐 
	***DV 
	gen DV_v4_same_TA_dum_N = (DV_v3_diff_TA_dum == 0 & DV_v2_diff_indi_dum != 0)
	
	
	local change "DV_v1_redeploy DV_v2_diff_indi DV_v3_diff_TA DV_v1_redeploy_dum DV_v2_diff_indi_dum DV_v3_diff_TA_dum"
	local change "IDV1_cnt_fail_DNSW IDV1_cnt_fail_DNW IDV1_cnt_fail_DW IDV1_cnt_fail_D  IDV1_cnt_fail_DNSW_2 IDV1_cnt_fail_DNW_2 IDV1_cnt_fail_DW_2 IDV1_cnt_fail_D_2  IDV2_v1_red_timing_DNSW IDV2_v1_red_timing_DNW IDV2_v1_red_timing_DW IDV2_v1_red_timing_D IDV2_v2_red_timing_DNSW IDV2_v2_red_timing_DNW IDV2_v2_red_timing_DW IDV2_v2_red_timing_D IDV2_v3_red_timing_DNSW IDV2_v3_red_timing_DNW IDV2_v3_red_timing_DW IDV2_v3_red_timing_D IDV2_v1_red_timing_DNSW_2 IDV2_v1_red_timing_DNW_2 IDV2_v1_red_timing_DW_2 IDV2_v1_red_timing_D_2 IDV2_v2_red_timing_DNSW_2 IDV2_v2_red_timing_DNW_2 IDV2_v2_red_timing_DW_2 IDV2_v2_red_timing_D_2 IDV2_v3_red_timing_DNSW_2 IDV2_v3_red_timing_DNW_2 IDV2_v3_red_timing_DW_2 IDV2_v3_red_timing_D_2 IDV3_fail_timing_v0_DNSW IDV3_fail_timing_v1_DNSW IDV3_fail_timing_v2_DNSW IDV3_fail_timing_v3_DNSW IDv4_fail_timing_v4_DNSW IDv5_fail_timing_v5_DNSW IDV3_fail_timing_v0_DNW IDV3_fail_timing_v1_DNW IDV3_fail_timing_v2_DNW IDV3_fail_timing_v3_DNW IDv4_fail_timing_v4_DNW IDv5_fail_timing_v5_DNW IDV3_fail_timing_v0_DW IDV3_fail_timing_v1_DW IDV3_fail_timing_v2_DW IDV3_fail_timing_v3_DW IDv4_fail_timing_v4_DW IDv5_fail_timing_v5_DW IDV3_fail_timing_v0_D IDV3_fail_timing_v1_D IDV3_fail_timing_v2_D IDV3_fail_timing_v3_D IDv4_fail_timing_v4_D IDv5_fail_timing_v5_D IDV3_fail_timing_v0_DNSW_2 IDV3_fail_timing_v1_DNSW_2 IDV3_fail_timing_v2_DNSW_2 IDV3_fail_timing_v3_DNSW_2 IDv4_fail_timing_v4_DNSW_2 IDv5_fail_timing_v5_DNSW_2 IDV3_fail_timing_v0_DNW_2 IDV3_fail_timing_v1_DNW_2 IDV3_fail_timing_v2_DNW_2 IDV3_fail_timing_v3_DNW_2 IDv4_fail_timing_v4_DNW_2 IDv5_fail_timing_v5_DNW_2 IDV3_fail_timing_v0_DW_2 IDV3_fail_timing_v1_DW_2 IDV3_fail_timing_v2_DW_2 IDV3_fail_timing_v3_DW_2 IDv4_fail_timing_v4_DW_2 IDv5_fail_timing_v5_DW_2 IDV3_fail_timing_v0_D_2 IDV3_fail_timing_v1_D_2 IDV3_fail_timing_v2_D_2 IDV3_fail_timing_v3_D_2 IDv4_fail_timing_v4_D_2 IDv5_fail_timing_v5_D_2  IDV1_cnt_fail_DNSW_dum IDV1_cnt_fail_DNW_dum IDV1_cnt_fail_DW_dum IDV1_cnt_fail_D_dum IDV1_cnt_fail_DNSW_2_dum IDV1_cnt_fail_DNW_2_dum IDV1_cnt_fail_DW_2_dum IDV1_cnt_fail_D_2_dum"
	foreach x of local change {
		gen `x'_N = `x'
		replace `x'_N = 0 if tag == 1 
	}
	
	*_v2 : dev_history_bf_MnA == 0 인 것으로만 dataset 구축 다시 해서 DV, IDV 를 다시 만든 것 
	{
		merge 1:1 gvkey_dc_refine id_cortellis year_expand using "E:\ARK\as of Jul 2024\[004_9_dev_bf_MnA zero] (develop_status_refine) Drug_development summary.dta"
		local change "DV_v1_redeploy_v2 DV_v2_diff_indi_v2 DV_v3_diff_TA_v2 DV_v1_redeploy_v2_dum DV_v2_diff_indi_v2_dum DV_v3_diff_TA_v2_dum"
		foreach x of local change {
			gen `x'_N = `x'
			replace `x'_N = 0 if tag == 1 
		}
		local change "DV_v1_redeploy_v2_N DV_v2_diff_indi_v2_N DV_v3_diff_TA_v2_N DV_v1_redeploy_v2_dum_N DV_v2_diff_indi_v2_dum_N DV_v3_diff_TA_v2_dum_N"
		foreach x of local change {
			replace `x' = 0 if missing(`x')
	}

		local fail "DNSW DNW DW D DNSW_2 DNW_2 DW_2 D_2"
		foreach x of local fail {
			rename IDV2_v1_red_timing_`x'_v2 IDV2_v1_red_tim_`x'_v2
			rename IDV2_v2_red_timing_`x'_v2 IDV2_v2_red_tim_`x'_v2
			rename IDV2_v3_red_timing_`x'_v2 IDV2_v3_red_tim_`x'_v2
		}
		
		local change "IDV1_cnt_fail_DNSW_v2 IDV1_cnt_fail_DNW_v2 IDV1_cnt_fail_DW_v2 IDV1_cnt_fail_D_v2  IDV1_cnt_fail_DNSW_2_v2 IDV1_cnt_fail_DNW_2_v2 IDV1_cnt_fail_DW_2_v2 IDV1_cnt_fail_D_2_v2  IDV2_v1_red_tim_DNSW_v2 IDV2_v1_red_tim_DNW_v2 IDV2_v1_red_tim_DW_v2 IDV2_v1_red_tim_D_v2 IDV2_v2_red_tim_DNSW_v2 IDV2_v2_red_tim_DNW_v2 IDV2_v2_red_tim_DW_v2 IDV2_v2_red_tim_D_v2 IDV2_v3_red_tim_DNSW_v2 IDV2_v3_red_tim_DNW_v2 IDV2_v3_red_tim_DW_v2 IDV2_v3_red_tim_D_v2 IDV2_v1_red_tim_DNSW_2_v2 IDV2_v1_red_tim_DNW_2_v2 IDV2_v1_red_tim_DW_2_v2 IDV2_v1_red_tim_D_2_v2 IDV2_v2_red_tim_DNSW_2_v2 IDV2_v2_red_tim_DNW_2_v2 IDV2_v2_red_tim_DW_2_v2 IDV2_v2_red_tim_D_2_v2 IDV2_v3_red_tim_DNSW_2_v2 IDV2_v3_red_tim_DNW_2_v2 IDV2_v3_red_tim_DW_2_v2 IDV2_v3_red_tim_D_2_v2 IDV3_fail_tim_v0_DNSW_v2 IDV3_fail_tim_v1_DNSW_v2 IDV3_fail_tim_v2_DNSW_v2 IDV3_fail_tim_v3_DNSW_v2 IDV3_fail_tim_v4_DNSW_v2 IDV3_fail_tim_v5_DNSW_v2 IDV3_fail_tim_v0_DNW_v2 IDV3_fail_tim_v1_DNW_v2 IDV3_fail_tim_v2_DNW_v2 IDV3_fail_tim_v3_DNW_v2 IDV3_fail_tim_v4_DNW_v2 IDV3_fail_tim_v5_DNW_v2 IDV3_fail_tim_v0_DW_v2 IDV3_fail_tim_v1_DW_v2 IDV3_fail_tim_v2_DW_v2 IDV3_fail_tim_v3_DW_v2 IDV3_fail_tim_v4_DW_v2 IDV3_fail_tim_v5_DW_v2 IDV3_fail_tim_v0_D_v2 IDV3_fail_tim_v1_D_v2 IDV3_fail_tim_v2_D_v2 IDV3_fail_tim_v3_D_v2 IDV3_fail_tim_v4_D_v2 IDV3_fail_tim_v5_D_v2 IDV3_fail_tim_v0_DNSW_2_v2 IDV3_fail_tim_v1_DNSW_2_v2 IDV3_fail_tim_v2_DNSW_2_v2 IDV3_fail_tim_v3_DNSW_2_v2 IDV3_fail_tim_v4_DNSW_2_v2 IDV3_fail_tim_v5_DNSW_2_v2 IDV3_fail_tim_v0_DNW_2_v2 IDV3_fail_tim_v1_DNW_2_v2 IDV3_fail_tim_v2_DNW_2_v2 IDV3_fail_tim_v3_DNW_2_v2 IDV3_fail_tim_v4_DNW_2_v2 IDV3_fail_tim_v5_DNW_2_v2 IDV3_fail_tim_v0_DW_2_v2 IDV3_fail_tim_v1_DW_2_v2 IDV3_fail_tim_v2_DW_2_v2 IDV3_fail_tim_v3_DW_2_v2 IDV3_fail_tim_v4_DW_2_v2 IDV3_fail_tim_v5_DW_2_v2 IDV3_fail_tim_v0_D_2_v2 IDV3_fail_tim_v1_D_2_v2 IDV3_fail_tim_v2_D_2_v2 IDV3_fail_tim_v3_D_2_v2 IDV3_fail_tim_v4_D_2_v2 IDV3_fail_tim_v5_D_2_v2  IDV1_cnt_fail_DNSW_v2_dum IDV1_cnt_fail_DNW_v2_dum IDV1_cnt_fail_DW_v2_dum IDV1_cnt_fail_D_v2_dum IDV1_cnt_fail_DNSW_2_v2_dum IDV1_cnt_fail_DNW_2_v2_dum IDV1_cnt_fail_DW_2_v2_dum IDV1_cnt_fail_D_2_dum"
		foreach x of local change {
			gen `x'_N = `x'
			replace `x'_N = 0 if tag == 1 
		}

		
		
		local acc "IDV1_cnt_fail_DNSW_v2 IDV1_cnt_fail_DNW_v2 IDV1_cnt_fail_DW_v2 IDV1_cnt_fail_D_v2 IDV1_cnt_fail_DNSW_2_v2 IDV1_cnt_fail_DNW_2_v2 IDV1_cnt_fail_DW_2_v2 IDV1_cnt_fail_D_2_v2"
		foreach x of local acc {
			bysort gvkey_dc_refine id_cortellis (year_expand): gen s_`x' = sum(`x')
		}
		local acc2 "s_IDV1_cnt_fail_DNSW_v2 s_IDV1_cnt_fail_DNW_v2 s_IDV1_cnt_fail_DW_v2 s_IDV1_cnt_fail_D_v2 s_IDV1_cnt_fail_DNSW_2_v2 s_IDV1_cnt_fail_DNW_2_v2 s_IDV1_cnt_fail_DW_2_v2 s_IDV1_cnt_fail_D_2_v2"
		foreach x of local acc2 {
			gen `x'_dum = (`x' != 0)
		}
		local lagg "s_IDV1_cnt_fail_DNSW_v2 s_IDV1_cnt_fail_DNW_v2 s_IDV1_cnt_fail_DW_v2 s_IDV1_cnt_fail_D_v2 s_IDV1_cnt_fail_DNSW_2_v2 s_IDV1_cnt_fail_DNW_2_v2 s_IDV1_cnt_fail_DW_2_v2 s_IDV1_cnt_fail_D_2_v2 s_IDV1_cnt_fail_DNSW_v2_dum s_IDV1_cnt_fail_DNW_v2_dum s_IDV1_cnt_fail_DW_v2_dum s_IDV1_cnt_fail_D_v2_dum s_IDV1_cnt_fail_DNSW_2_v2_dum s_IDV1_cnt_fail_DNW_2_v2_dum s_IDV1_cnt_fail_DW_2_v2_dum s_IDV1_cnt_fail_D_2_v2_dum"
		foreach x of local lagg {
			bysort gvkey_dc_refine id_cortellis (year_expand): gen `x'_1 = `x'[_n-1]
		}
	
		*failure timing
		local fail "DNSW DNW DW D DNSW_2 DNW_2 DW_2 D_2"
		foreach x of local fail {
			gen tic_`x' =  fail_`x'_v2_year_recent
			by gvkey_dc_refine id_cortellis: replace tic_`x' = tic_`x'[_n-1] if !missing(tic_`x'[_n-1]) & missing(tic_`x')
			by gvkey_dc_refine id_cortellis: gen tic_`x'_t_1 = tic_`x'[_n-1]
			
			gen IDV2_red_timingA_`x'_v2 = year_expand - tic_`x'_t_1 

			gen IDV2_red_timingB_v1_`x'_v2 = IDV2_red_timingA_`x'_v2 if DV_v1_redeploy_v2_dum_N != 0
			gen IDV2_red_timingB_v2_`x'_v2 = IDV2_red_timingA_`x'_v2 if DV_v2_diff_indi_v2_dum_N != 0
			gen IDV2_red_timingB_v3_`x'_v2 = IDV2_red_timingA_`x'_v2 if DV_v3_diff_TA_v2_dum_N != 0
			
			drop tic_`x' tic_`x'_t_1 
		}

			
	*** failure timing
		drop IDV3_fail_tim_v0_DNSW_v2_N IDV3_fail_tim_v1_DNSW_v2_N IDV3_fail_tim_v2_DNSW_v2_N IDV3_fail_tim_v3_DNSW_v2_N IDV3_fail_tim_v4_DNSW_v2_N IDV3_fail_tim_v5_DNSW_v2_N IDV3_fail_tim_v0_DNW_v2_N IDV3_fail_tim_v1_DNW_v2_N IDV3_fail_tim_v2_DNW_v2_N IDV3_fail_tim_v3_DNW_v2_N IDV3_fail_tim_v4_DNW_v2_N IDV3_fail_tim_v5_DNW_v2_N IDV3_fail_tim_v0_DW_v2_N IDV3_fail_tim_v1_DW_v2_N IDV3_fail_tim_v2_DW_v2_N IDV3_fail_tim_v3_DW_v2_N IDV3_fail_tim_v4_DW_v2_N IDV3_fail_tim_v5_DW_v2_N IDV3_fail_tim_v0_D_v2_N IDV3_fail_tim_v1_D_v2_N IDV3_fail_tim_v2_D_v2_N IDV3_fail_tim_v3_D_v2_N IDV3_fail_tim_v4_D_v2_N IDV3_fail_tim_v5_D_v2_N IDV3_fail_tim_v0_DNSW_2_v2_N IDV3_fail_tim_v1_DNSW_2_v2_N IDV3_fail_tim_v2_DNSW_2_v2_N IDV3_fail_tim_v3_DNSW_2_v2_N IDV3_fail_tim_v4_DNSW_2_v2_N IDV3_fail_tim_v5_DNSW_2_v2_N IDV3_fail_tim_v0_DNW_2_v2_N IDV3_fail_tim_v1_DNW_2_v2_N IDV3_fail_tim_v2_DNW_2_v2_N IDV3_fail_tim_v3_DNW_2_v2_N IDV3_fail_tim_v4_DNW_2_v2_N IDV3_fail_tim_v5_DNW_2_v2_N IDV3_fail_tim_v0_DW_2_v2_N IDV3_fail_tim_v1_DW_2_v2_N IDV3_fail_tim_v2_DW_2_v2_N IDV3_fail_tim_v3_DW_2_v2_N IDV3_fail_tim_v4_DW_2_v2_N IDV3_fail_tim_v5_DW_2_v2_N IDV3_fail_tim_v0_D_2_v2_N IDV3_fail_tim_v1_D_2_v2_N IDV3_fail_tim_v2_D_2_v2_N IDV3_fail_tim_v3_D_2_v2_N IDV3_fail_tim_v4_D_2_v2_N IDV3_fail_tim_v5_D_2_v2_N
		local fail "DNSW DNW DW D DNSW_2 DNW_2 DW_2 D_2"
		foreach x of local fail {
		foreach num of numlist 0/5{
			gen IDV3_fail_tim_v`num'_`x'_v2_N = IDV3_fail_tim_v`num'_`x'_v2
				bysort gvkey_dc_refine id_cortellis (year_expand): replace IDV3_fail_tim_v`num'_`x'_v2_N= IDV3_fail_tim_v`num'_`x'_v2_N[_n-1] if !missing(IDV3_fail_tim_v`num'_`x'_v2_N[_n-1]) & missing(IDV3_fail_tim_v`num'_`x'_v2_N)
			
		}
	}

	
	local change "IDV3_fail_tim_v0_DNSW_v2_N IDV3_fail_tim_v1_DNSW_v2_N IDV3_fail_tim_v2_DNSW_v2_N IDV3_fail_tim_v3_DNSW_v2_N IDV3_fail_tim_v4_DNSW_v2_N IDV3_fail_tim_v5_DNSW_v2_N IDV3_fail_tim_v0_DNW_v2_N IDV3_fail_tim_v1_DNW_v2_N IDV3_fail_tim_v2_DNW_v2_N IDV3_fail_tim_v3_DNW_v2_N IDV3_fail_tim_v4_DNW_v2_N IDV3_fail_tim_v5_DNW_v2_N IDV3_fail_tim_v0_DW_v2_N IDV3_fail_tim_v1_DW_v2_N IDV3_fail_tim_v2_DW_v2_N IDV3_fail_tim_v3_DW_v2_N IDV3_fail_tim_v4_DW_v2_N IDV3_fail_tim_v5_DW_v2_N IDV3_fail_tim_v0_D_v2_N IDV3_fail_tim_v1_D_v2_N IDV3_fail_tim_v2_D_v2_N IDV3_fail_tim_v3_D_v2_N IDV3_fail_tim_v4_D_v2_N IDV3_fail_tim_v5_D_v2_N IDV3_fail_tim_v0_DNSW_2_v2_N IDV3_fail_tim_v1_DNSW_2_v2_N IDV3_fail_tim_v2_DNSW_2_v2_N IDV3_fail_tim_v3_DNSW_2_v2_N IDV3_fail_tim_v4_DNSW_2_v2_N IDV3_fail_tim_v5_DNSW_2_v2_N IDV3_fail_tim_v0_DNW_2_v2_N IDV3_fail_tim_v1_DNW_2_v2_N IDV3_fail_tim_v2_DNW_2_v2_N IDV3_fail_tim_v3_DNW_2_v2_N IDV3_fail_tim_v4_DNW_2_v2_N IDV3_fail_tim_v5_DNW_2_v2_N IDV3_fail_tim_v0_DW_2_v2_N IDV3_fail_tim_v1_DW_2_v2_N IDV3_fail_tim_v2_DW_2_v2_N IDV3_fail_tim_v3_DW_2_v2_N IDV3_fail_tim_v4_DW_2_v2_N IDV3_fail_tim_v5_DW_2_v2_N IDV3_fail_tim_v0_D_2_v2_N IDV3_fail_tim_v1_D_2_v2_N IDV3_fail_tim_v2_D_2_v2_N IDV3_fail_tim_v3_D_2_v2_N IDV3_fail_tim_v4_D_2_v2_N IDV3_fail_tim_v5_D_2_v2_N"
	foreach x of local change {
		replace `x' = 0 if missing(`x')
	}

	local change "IDV2_red_timingA_DNSW_v2 IDV2_red_timingA_DNW_v2 IDV2_red_timingA_DW_v2 IDV2_red_timingA_D_v2 IDV2_red_timingA_DNSW_2_v2 IDV2_red_timingA_DNW_2_v2 IDV2_red_timingA_DW_2_v2 IDV2_red_timingA_D_2_v2"
	foreach x of local change {
		replace `x' = 0 if missing(`x')
	}

	
	
	}
	
	gen being_developed = (tag == 1)
	egen double_cluster_firm_drug =group( gvkey_dc_refine id_cortellis )
	
	rename log_total_ptn l_total_ptn
	rename log_total_Product_pure l_total_Product_pure
	rename log_total_Secondary l_total_Secondary
	rename log_total_university l_total_university
	rename log_total_ptn_assign l_total_ptn_assign
	rename log_total_Product_pure_assign l_total_Product_pure_assign
	rename log_total_Secon_assign l_total_Secon_assign
	rename log_total_univ_assign l_total_univ_assign
	rename log_emp l_emp
	rename log_at l_at 
	rename log_sale l_sale 
	rename log_mrkcap l_mrkcap 
	rename log_sales l_sales 
	rename log_FIRM_slack_avai l_slack_avai 
	rename log_FIRM_slack_absor l_slack_absor 
	rename log_FIRM_slack_poten l_slack_poten 
	rename log_FIRM_tobinQ l_tobinQ 
	rename log_FIRM_ROA l_ROA 
	rename log_FIRM_ROE l_ROE 
	rename log_FIRM_ROI l_ROI 
	rename log_FIRM_EPS l_EPS 
	rename log_FIRM_RnDinten l_RnDinten 
	rename log_FIRM_RnDinten2 l_RnDinten2 
	rename log_FIRM_astspec l_astspec
	
	local lagg "l_total_ptn l_total_Product_pure l_total_Secondary l_total_university ratio_Product_pure ratio_Secondary ratio_Secondary_2 ratio_Secondary_3 ratio_university l_total_ptn_assign l_total_Product_pure_assign l_total_Secon_assign l_total_univ_assign ratio_Product_pure_assign ratio_Secondary_assign ratio_Secondary_2_assign ratio_Secondary_3_assign ratio_univeristy_assign CTR_cnt_launched CTR_cnt_launched_therapy CTR_avg_launched_therapy external_N_dum dev_history_bf_MnA_N l_emp l_at l_sale l_mrkcap l_sales l_slack_avai l_slack_absor l_slack_poten l_tobinQ l_ROA l_ROE l_ROI l_EPS l_RnDinten l_RnDinten2 l_astspec FIRM_slack_index  "
	foreach x of local lagg {
		bysort gvkey_dc_refine id_cortellis (year_expand): gen `x'_t_1 = `x'[_n-1]
	}

	**failure variable - frequency, incident
	*** 어떤 연도까지 failure 누적 횟수 변수 생성 
	local acc "IDV1_cnt_fail_DNSW IDV1_cnt_fail_DNW IDV1_cnt_fail_DW IDV1_cnt_fail_D IDV1_cnt_fail_DNSW_2 IDV1_cnt_fail_DNW_2 IDV1_cnt_fail_DW_2 IDV1_cnt_fail_D_2 CTR_cnt_launched_by_drug"
	foreach x of local acc {
		bysort gvkey_dc_refine id_cortellis (year_expand): gen s_`x' = sum(`x')
	}
	
	*** s_IDV1_dum: t 년도를 포함하여 t 년도까지 failure 가 과거에 있으면 1 아니면 0 
	local acc2 "s_IDV1_cnt_fail_DNSW s_IDV1_cnt_fail_DNW s_IDV1_cnt_fail_DW s_IDV1_cnt_fail_D s_IDV1_cnt_fail_DNSW_2 s_IDV1_cnt_fail_DNW_2 s_IDV1_cnt_fail_DW_2 s_IDV1_cnt_fail_D_2 s_CTR_cnt_launched_by_drug_dum"
	foreach x of local acc2 {
		gen `x'_dum = (`x' != 0)
	}
	
	local lagg "s_IDV1_cnt_fail_DNSW s_IDV1_cnt_fail_DNW s_IDV1_cnt_fail_DW s_IDV1_cnt_fail_D s_IDV1_cnt_fail_DNSW_2 s_IDV1_cnt_fail_DNW_2 s_IDV1_cnt_fail_DW_2 s_IDV1_cnt_fail_D_2 s_IDV1_cnt_fail_DNSW_dum s_IDV1_cnt_fail_DNW_dum s_IDV1_cnt_fail_DW_dum s_IDV1_cnt_fail_D_dum s_IDV1_cnt_fail_DNSW_2_dum s_IDV1_cnt_fail_DNW_2_dum s_IDV1_cnt_fail_DW_2_dum s_IDV1_cnt_fail_D_2_dum"
	foreach x of local lagg {
		bysort gvkey_dc_refine id_cortellis (year_expand): gen `x'_t_1 = `x'[_n-1]
	}

	local change " CTR_cnt_launched_by_drug CTR_v1_red_timing_launch CTR_v2_red_timing_launch CTR_v3_red_timing_launch "
		foreach x of local change {
			gen `x'_N = `x'
			replace `x'_N = 0 if tag == 1 
		}

		

		
	bysort gvkey_dc_refine id_cortellis (year_expand): gen s_CTR_cnt_launched_by_drug_dum_1 = s_CTR_cnt_launched_by_drug_dum[_n-1]
	bysort gvkey_dc_refine id_cortellis (year_expand): gen s_CTR_cnt_launched_by_drug_t_1 = s_CTR_cnt_launched_by_drug[_n-1]
	
	*** redeployment timing
	*(a) time gap between the focal year and the most recent failure
	*(b) time gap between the redeployment and the most recent failure
	local fail "DNSW DNW DW D DNSW_2 DNW_2 DW_2 D_2"
	foreach x of local fail {
		gen tic_`x' =  fail_`x'_year_recent, b(fail_`x'_year_recent)
		by gvkey_dc_refine id_cortellis: replace tic_`x' = tic_`x'[_n-1] if !missing(tic_`x'[_n-1]) & missing(tic_`x')
		by gvkey_dc_refine id_cortellis: gen tic_`x'_t_1 = tic_`x'[_n-1]
		
		gen IDV2_red_timingA_`x' = year_expand - tic_`x'_t_1 

		gen IDV2_red_timingB_v1_`x' = IDV2_red_timingA_`x' if DV_v1_redeploy_dum_N != 0
		gen IDV2_red_timingB_v2_`x' = IDV2_red_timingA_`x' if DV_v2_diff_indi_dum_N != 0
		gen IDV2_red_timingB_v3_`x' = IDV2_red_timingA_`x' if DV_v3_diff_TA_dum_N != 0
		gen IDV2_red_timingB_v4_`x' = IDV2_red_timingA_`x' if DV_v4_same_TA_dum_N != 0
		
		drop tic_`x' tic_`x'_t_1 
	}
	gen tic_succ =  launched_year_recent
	by gvkey_dc_refine id_cortellis: replace tic_succ = tic_succ[_n-1] if !missing(tic_succ[_n-1]) & missing(tic_succ)
	by gvkey_dc_refine id_cortellis: gen tic_succ_t_1 = tic_succ[_n-1]
	gen CTR_red_timingA_launch = year_expand - tic_succ_t_1 
	gen CTR_red_timingB_v1_lau = CTR_red_timingA_launch if DV_v1_redeploy_dum_N != 0
	gen CTR_red_timingB_v2_lau = CTR_red_timingA_launch if DV_v2_diff_indi_dum_N != 0
	gen CTR_red_timingB_v3_lau = CTR_red_timingA_launch if DV_v3_diff_TA_dum_N != 0
	gen CTR_red_timingB_v4_lau = CTR_red_timingA_launch if DV_v4_same_TA_dum_N != 0
	drop tic_succ tic_succ_t_1
		
		
	*** failure timing
	local fail "DNSW DNW DW D DNSW_2 DNW_2 DW_2 D_2"
	foreach x of local fail {
	foreach num of numlist 0/5{
		gen IDV3_fail_timing_v`num'_`x'_N = IDV3_fail_timing_v`num'_`x'
		bysort gvkey_dc_refine id_cortellis (year_expand): replace IDV3_fail_timing_v`num'_`x'_N= IDV3_fail_timing_v`num'_`x'_N[_n-1] if !missing(IDV3_fail_timing_v`num'_`x'_N[_n-1]) & missing(IDV3_fail_timing_v`num'_`x'_N)
		
	}
	}
	
	
	*** missing -> 0 으로 처리 (failure 에 dependent 한 variables)
	*** 대신에 failure_dummy 를 control variable 로 넣어줄 것 
	local change "IDV3_fail_timing_v0_DNSW_2_N IDV3_fail_timing_v1_DNSW_2_N IDV3_fail_timing_v2_DNSW_2_N IDV3_fail_timing_v3_DNSW_2_N IDV3_fail_timing_v4_DNSW_2_N IDV3_fail_timing_v5_DNSW_2_N IDV3_fail_timing_v0_DNW_2_N IDV3_fail_timing_v1_DNW_2_N IDV3_fail_timing_v2_DNW_2_N IDV3_fail_timing_v3_DNW_2_N IDV3_fail_timing_v4_DNW_2_N IDV3_fail_timing_v5_DNW_2_N IDV3_fail_timing_v0_DW_2_N IDV3_fail_timing_v1_DW_2_N IDV3_fail_timing_v2_DW_2_N IDV3_fail_timing_v3_DW_2_N IDV3_fail_timing_v4_DW_2_N IDV3_fail_timing_v5_DW_2_N IDV3_fail_timing_v0_D_2_N IDV3_fail_timing_v1_D_2_N IDV3_fail_timing_v2_D_2_N IDV3_fail_timing_v3_D_2_N IDV3_fail_timing_v4_D_2_N IDV3_fail_timing_v5_D_2_N IDV2_red_timingA_DNSW IDV2_red_timingA_DNW IDV2_red_timingA_DW IDV2_red_timingA_D IDV2_red_timingA_DNSW_2 IDV2_red_timingA_DNW_2 IDV2_red_timingA_DW_2 IDV2_red_timingA_D_2"
	foreach x of local change {
		replace `x' = 0 if missing(`x')
	}
	
	replace CTR_red_timingA_launch = 0 if missing( CTR_red_timingA_launch )
	
	save "E:\ARK\as of Jul 2024\[004_91] (expanded) by gvkey_dc_refine id_cortellis develop_year_refine2.dta"

}

*[004_91] Unique number of drug candidates (id_cortellis): 31,015
*(*어떤 회사의 어떤 약의 development history 가 Cortellis 상에 1개밖에 record 되지 않은 경우가 있음.
*1개만 record 된 unique drug candidates 6,300 | 2개 이상 record된 unique drug candidate 26,496)
*-->1개만 record 된 경우 애초에 redeployment 가 될 가능성 자체가 주어지지 않음
*-->Cortellis 에 보고된 drug development record 가 2개 이상인 경우로만 dataset 만들기?
*(Is this selection bias?)
==> Cortellis 에 보고된 drug development record 가 2개 이상인 경우로만 만든 dataset: [004_91_ver2]
▼ 만든 과정 (starting from [004_8], ending with [004_91_ver2] )
{
clear
use "E:\ARK\as of Jul 2024\[004_8] (develop_status_refine) Drug_development summary.dta"

gen top15 = 0
foreach num of numlist 16101 1602 28272 100080 2403 6730 24856 5180 6266 7257 101310 8530 25648 101204 14538  {
replace top15 = 1 if gvkey_dc_refine == `num'
}
gen top17 = top15
replace top17 = 1 if gvkey_dc_refine == 100718 
replace top17 = 1 if gvkey_dc_refine == 8020

bysort gvkey_dc_refine id_cortellis : gen check_cnt = _N
keep if check_cnt != 1
local change "fail_DNSW_status_recent fail_DNW_status_recent fail_DW_status_recent fail_D_status_recent fail_DNSW_year_recent fail_DNW_year_recent fail_DW_year_recent fail_D_year_recent fail_DNSW_2_year_recent fail_DNW_2_year_recent fail_DW_2_year_recent fail_D_2_year_recent fail_DNSW_2_status_recent fail_DNW_2_status_recent fail_DW_2_status_recent fail_D_2_status_recent"
foreach x of local change {
gsort gvkey_dc_refine id_cortellis develop_year_refine2  -`x'
by gvkey_dc_refine id_cortellis develop_year_refine2: replace `x' = `x'[1]
}
gsort gvkey_dc_refine id_cortellis develop_year_refine2 -external
by gvkey_dc_refine id_cortellis develop_year_refine2: replace external = external[1]
gsort gvkey_dc_refine id_cortellis develop_year_refine2 -dev_history_bf_MnA
by gvkey_dc_refine id_cortellis develop_year_refine2: replace dev_history_bf_MnA = dev_history_bf_MnA[1]
keep gvkey_dc_refine external dev_history_bf_MnA extension id_cortellis DrugName develop_year_refine2 fail_DNSW_status_recent fail_DNW_status_recent fail_DW_status_recent fail_D_status_recent cnt_DV_redeploy cnt_DV_diff_indi cnt_DV_diff_TA  cnt_fail_DNSW cnt_fail_DNW cnt_fail_DW cnt_fail_D fail_DNSW_year_recent fail_DNW_year_recent fail_DW_year_recent fail_D_year_recent  fail_DNSW_2_status_recent fail_DNW_2_status_recent fail_DW_2_status_recent fail_D_2_status_recent fail_DNSW_2_year_recent fail_DNW_2_year_recent fail_DW_2_year_recent fail_D_2_year_recent cnt_fail_DNSW_2 cnt_fail_DNW_2 cnt_fail_DW_2 cnt_fail_D_2
duplicates drop
duplicates report gvkey_dc_refine id_cortellis develop_year_refine2
*DV
rename cnt_DV_redeploy DV_v1_redeploy
rename cnt_DV_diff_indi DV_v2_diff_indi
rename cnt_DV_diff_TA DV_v3_diff_TA
*IDV1: number of failures (or incident of failure) // ~_2: excluding failure reasons related to pipeline prioritization, bankruptcy, cost (not related to R&D failures)
rename cnt_fail_DNSW IDV1_cnt_fail_DNSW
rename cnt_fail_DNW IDV1_cnt_fail_DNW
rename cnt_fail_DW IDV1_cnt_fail_DW
rename cnt_fail_D IDV1_cnt_fail_D
rename cnt_fail_DNSW_2 IDV1_cnt_fail_DNSW_2
rename cnt_fail_DNW_2 IDV1_cnt_fail_DNW_2
rename cnt_fail_DW_2 IDV1_cnt_fail_DW_2
rename cnt_fail_D_2 IDV1_cnt_fail_D_2
*IDV2: Redeployment timing
local IDV "DNSW DNW DW D"
foreach x of local IDV {
gen IDV2_v1_red_timing_`x' = develop_year_refine2 - fail_`x'_year_recent if !missing( fail_`x'_year_recent ) & DV_v1_redeploy != 0
}
foreach x of local IDV {
gen IDV2_v2_red_timing_`x' = develop_year_refine2 - fail_`x'_year_recent if !missing( fail_`x'_year_recent ) & DV_v2_diff_indi != 0
}
foreach x of local IDV {
gen IDV2_v3_red_timing_`x' = develop_year_refine2 - fail_`x'_year_recent if !missing( fail_`x'_year_recent ) & DV_v3_diff_TA != 0
}
foreach x of local IDV {
gen CTR_no_fail_`x'_dummy = (IDV1_cnt_fail_`x' == 0)
}
foreach x of local IDV {
gen IDV2_v1_red_timing_`x'_2 = develop_year_refine2 - fail_`x'_2_year_recent if !missing( fail_`x'_2_year_recent ) & DV_v1_redeploy != 0
}
foreach x of local IDV {
gen IDV2_v2_red_timing_`x'_2 = develop_year_refine2 - fail_`x'_2_year_recent if !missing( fail_`x'_2_year_recent ) & DV_v2_diff_indi != 0
}
foreach x of local IDV {
gen IDV2_v3_red_timing_`x'_2 = develop_year_refine2 - fail_`x'_2_year_recent if !missing( fail_`x'_2_year_recent ) & DV_v3_diff_TA != 0
}
foreach x of local IDV {
gen CTR_no_fail_`x'_2_dummy = (IDV1_cnt_fail_`x'_2 == 0)
}
local IDV "DNSW DNW DW D DNSW_2 DNW_2 DW_2 D_2"
foreach x of local IDV {
gen IDV3_fail_timing_v0_`x'     = 1 if fail_`x'_status_recent == " Discovery"
replace IDV3_fail_timing_v0_`x'     = 1 if fail_`x'_status_recent == " Preclinical"
replace IDV3_fail_timing_v0_`x'     = 2 if fail_`x'_status_recent == " Clinical"
replace IDV3_fail_timing_v0_`x'     = 2 if fail_`x'_status_recent == " Phase 1 Clinical"
replace IDV3_fail_timing_v0_`x'     = 2 if fail_`x'_status_recent == " Phase 2 Clinical"
replace IDV3_fail_timing_v0_`x'     = 2 if fail_`x'_status_recent == " Phase 3 Clinical"
replace IDV3_fail_timing_v0_`x'     = 3 if fail_`x'_status_recent == " Pre-registration"
replace IDV3_fail_timing_v0_`x'     = 3 if fail_`x'_status_recent == " Registered"
replace IDV3_fail_timing_v0_`x'     = 3 if fail_`x'_status_recent == " Launched"
gen IDV3_fail_timing_v1_`x'     = 1 if fail_`x'_status_recent == " Discovery"
replace IDV3_fail_timing_v1_`x' = 2 if fail_`x'_status_recent == " Preclinical"
replace IDV3_fail_timing_v1_`x' = 3 if fail_`x'_status_recent == " Clinical"
replace IDV3_fail_timing_v1_`x' = 3 if fail_`x'_status_recent == " Phase 1 Clinical"
replace IDV3_fail_timing_v1_`x' = 3 if fail_`x'_status_recent == " Phase 2 Clinical"
replace IDV3_fail_timing_v1_`x' = 3 if fail_`x'_status_recent == " Phase 3 Clinical"
replace IDV3_fail_timing_v1_`x' = 4 if fail_`x'_status_recent == " Pre-registration"
replace IDV3_fail_timing_v1_`x' = 5 if fail_`x'_status_recent == " Registered"
replace IDV3_fail_timing_v1_`x' = 6 if fail_`x'_status_recent == " Launched"
gen IDV3_fail_timing_v2_`x'     = 1 if fail_`x'_status_recent == " Discovery"
replace IDV3_fail_timing_v2_`x' = 2 if fail_`x'_status_recent == " Preclinical"
replace IDV3_fail_timing_v2_`x' = 3 if fail_`x'_status_recent == " Clinical"
replace IDV3_fail_timing_v2_`x' = 4 if fail_`x'_status_recent == " Phase 1 Clinical"
replace IDV3_fail_timing_v2_`x' = 5 if fail_`x'_status_recent == " Phase 2 Clinical"
replace IDV3_fail_timing_v2_`x' = 6 if fail_`x'_status_recent == " Phase 3 Clinical"
replace IDV3_fail_timing_v2_`x' = 7 if fail_`x'_status_recent == " Pre-registration"
replace IDV3_fail_timing_v2_`x' = 8 if fail_`x'_status_recent == " Registered"
replace IDV3_fail_timing_v2_`x' = 9 if fail_`x'_status_recent == " Launched"
gen IDV3_fail_timing_v3_`x'     = 1 if fail_`x'_status_recent == " Discovery"
replace IDV3_fail_timing_v3_`x' = 2 if fail_`x'_status_recent == " Preclinical"
replace IDV3_fail_timing_v3_`x' = 3 if fail_`x'_status_recent == " Phase 1 Clinical"
replace IDV3_fail_timing_v3_`x' = 4 if fail_`x'_status_recent == " Clinical"
replace IDV3_fail_timing_v3_`x' = 5 if fail_`x'_status_recent == " Phase 2 Clinical"
replace IDV3_fail_timing_v3_`x' = 6 if fail_`x'_status_recent == " Phase 3 Clinical"
replace IDV3_fail_timing_v3_`x' = 7 if fail_`x'_status_recent == " Pre-registration"
replace IDV3_fail_timing_v3_`x' = 8 if fail_`x'_status_recent == " Registered"
replace IDV3_fail_timing_v3_`x' = 9 if fail_`x'_status_recent == " Launched"
gen IDV3_fail_timing_v4_`x'     = 1 if fail_`x'_status_recent == " Discovery"
replace IDV3_fail_timing_v4_`x' = 2 if fail_`x'_status_recent == " Preclinical"
replace IDV3_fail_timing_v4_`x' = 3 if fail_`x'_status_recent == " Phase 1 Clinical"
replace IDV3_fail_timing_v4_`x' = 4 if fail_`x'_status_recent == " Phase 2 Clinical"
replace IDV3_fail_timing_v4_`x' = 5 if fail_`x'_status_recent == " Clinical"
replace IDV3_fail_timing_v4_`x' = 6 if fail_`x'_status_recent == " Phase 3 Clinical"
replace IDV3_fail_timing_v4_`x' = 7 if fail_`x'_status_recent == " Pre-registration"
replace IDV3_fail_timing_v4_`x' = 8 if fail_`x'_status_recent == " Registered"
replace IDV3_fail_timing_v4_`x' = 9 if fail_`x'_status_recent == " Launched"
gen IDV3_fail_timing_v5_`x'     = 1 if fail_`x'_status_recent == " Discovery"
replace IDV3_fail_timing_v5_`x' = 2 if fail_`x'_status_recent == " Preclinical"
replace IDV3_fail_timing_v5_`x' = 3 if fail_`x'_status_recent == " Phase 1 Clinical"
replace IDV3_fail_timing_v5_`x' = 4 if fail_`x'_status_recent == " Phase 2 Clinical"
replace IDV3_fail_timing_v5_`x' = 5 if fail_`x'_status_recent == " Phase 3 Clinical"
replace IDV3_fail_timing_v5_`x' = 6 if fail_`x'_status_recent == " Clinical"
replace IDV3_fail_timing_v5_`x' = 7 if fail_`x'_status_recent == " Pre-registration"
replace IDV3_fail_timing_v5_`x' = 8 if fail_`x'_status_recent == " Registered"
replace IDV3_fail_timing_v5_`x' = 9 if fail_`x'_status_recent == " Launched"
}

save "E:\ARK\as of Jul 2024\[004_9_ver2] by gvkey_dc_refine id_cortellis develop_year_refine2.dta"


*put patent data to 004_9_ver2
{
rename develop_year_refine2 priority_year
merge m:1 gvkey_dc_refine priority_year using "E:\ARK\as of Jul 2024\[200_3] (by gvkey_dc_refine priority_year) Patent_type_university_IPC.dta"
drop if _merge == 2
local change "total_ptn total_ptn_assignee_owner total_ptn_licen_DM total_ptn_licen_M total_ptn_owner total_Product total_Product_derivative total_Formulation total_New_use total_Compo_of_Compo total_Process total_Diag total_Drug_combination total_Delivery total_Product_pure total_Secondary total_PATENT_university"
foreach x of local change {
replace `x' = 0 if _merge == 1
}
drop _merge
rename  priority_year develop_year_refine2

save "E:\ARK\as of Jul 2024\[004_9_ver2] by gvkey_dc_refine id_cortellis develop_year_refine2.dta"
}

*put compustat data to 004_9_ver2
{
rename gvkey_dc_refine gvkey
rename develop_year_refine2 year
merge m:1 gvkey year using "E:\ARK\Original data\Compustat_1990_2023.dta"
drop if _merge ==2
rename gvkey gvkey_dc_refine
rename year develop_year_refine2
order conm, a(gvkey_dc_refine)
gen mrkcap = csho*prcc_f
gen wrkcap = act - lct
gen sales = sale / (cshpri * ajex)
gen FIRM_slack_avai = act / lct
gen FIRM_slack_absor = wrkcap / sales
gen FIRM_slack_poten = (at - lt )/ dltt
egen FIRM_st_slack_avai = std(FIRM_slack_avai)
egen FIRM_st_slack_absorb = std(FIRM_slack_absor)
egen FIRM_st_slack_poten = std(FIRM_slack_poten)
gen FIRM_tobinQ = (at + (csho*prcc_f) - ceq) / at
gen FIRM_ROA = ni/at
gen FIRM_ROE = ni/(csho*prcc_f)
gen FIRM_ROI = ni/icapt
gen FIRM_EPS = ni/csho
gen FIRM_RnDinten = xrd / emp
gen FIRM_RnDinten2 = xrd / at
gen FIRM_astspec = ppent / emp
gen FIRM_slack_index = FIRM_slack_avai + FIRM_slack_absor + FIRM_slack_poten
tab _merge
drop _merge
merge m:1 gvkey_dc_refine develop_year_refine2 using "E:\ARK\as of Jul 2024\[004_8a] (develop_status_refine) launched_drugs_by gvkey year.dta"
drop if _merge == 2
replace CTR_cnt_launched = 0 if _merge == 1
replace CTR_cnt_launched_therapy = 0 if _merge == 1
drop _merge
drop *_fn
drop *_dc
gen CTR_avg_launched_therapy = CTR_cnt_launched_therapy / CTR_cnt_launched
replace CTR_avg_launched_therapy = 0 if CTR_cnt_launched == 0
save "E:\ARK\as of Jul 2024\[004_9_ver2] by gvkey_dc_refine id_cortellis develop_year_refine2.dta", replace
}

*generate DV, IDV
{
	gen DV_v1_redeploy_dum = ( DV_v1_redeploy != 0)
gen DV_v2_diff_indi_dum = ( DV_v2_diff_indi != 0)
gen DV_v3_diff_TA_dum = ( DV_v3_diff_TA != 0)
gen DV_v4_same_TA_dum = (DV_v3_diff_TA_dum == 0 & DV_v2_diff_indi != 0)
gen external_dum = (external == 1)
gen extension_dum = (extension == 1)
local fail "IDV1_cnt_fail_DNSW IDV1_cnt_fail_DNW IDV1_cnt_fail_DW IDV1_cnt_fail_D IDV1_cnt_fail_DNSW_2 IDV1_cnt_fail_DNW_2 IDV1_cnt_fail_DW_2 IDV1_cnt_fail_D_2"
foreach x of local fail {
gen `x'_dum = (`x' > 0)
}
gen top15 = 0
foreach num of numlist 16101 1602 28272 100080 2403 6730 24856 5180 6266 7257 101310 8530 25648 101204 14538  {
replace top15 = 1 if gvkey_dc_refine == `num'
}
gen top17 = top15
replace top17 = 1 if gvkey_dc_refine == 100718 
replace top17 = 1 if gvkey_dc_refine == 8020

local lagg "IDV2_v1_red_timing_DNSW IDV2_v1_red_timing_DNW IDV2_v1_red_timing_DW IDV2_v1_red_timing_D IDV2_v2_red_timing_DNSW IDV2_v2_red_timing_DNW IDV2_v2_red_timing_DW IDV2_v2_red_timing_D IDV2_v3_red_timing_DNSW IDV2_v3_red_timing_DNW IDV2_v3_red_timing_DW IDV2_v3_red_timing_D IDV2_v1_red_timing_DNSW_2 IDV2_v1_red_timing_DNW_2 IDV2_v1_red_timing_DW_2 IDV2_v1_red_timing_D_2 IDV2_v2_red_timing_DNSW_2 IDV2_v2_red_timing_DNW_2 IDV2_v2_red_timing_DW_2 IDV2_v2_red_timing_D_2 IDV2_v3_red_timing_DNSW_2 IDV2_v3_red_timing_DNW_2 IDV2_v3_red_timing_DW_2 IDV2_v3_red_timing_D_2 IDV3_fail_timing_v0_DNSW IDV3_fail_timing_v1_DNSW IDV3_fail_timing_v2_DNSW IDV3_fail_timing_v3_DNSW IDV3_fail_timing_v4_DNSW IDV3_fail_timing_v5_DNSW IDV3_fail_timing_v0_DNW IDV3_fail_timing_v1_DNW IDV3_fail_timing_v2_DNW IDV3_fail_timing_v3_DNW IDV3_fail_timing_v4_DNW IDV3_fail_timing_v5_DNW IDV3_fail_timing_v0_DW IDV3_fail_timing_v1_DW IDV3_fail_timing_v2_DW IDV3_fail_timing_v3_DW IDV3_fail_timing_v4_DW IDV3_fail_timing_v5_DW IDV3_fail_timing_v0_D IDV3_fail_timing_v1_D IDV3_fail_timing_v2_D IDV3_fail_timing_v3_D IDV3_fail_timing_v4_D IDV3_fail_timing_v5_D IDV3_fail_timing_v0_DNSW_2 IDV3_fail_timing_v1_DNSW_2 IDV3_fail_timing_v2_DNSW_2 IDV3_fail_timing_v3_DNSW_2 IDV3_fail_timing_v4_DNSW_2 IDV3_fail_timing_v5_DNSW_2 IDV3_fail_timing_v0_DNW_2 IDV3_fail_timing_v1_DNW_2 IDV3_fail_timing_v2_DNW_2 IDV3_fail_timing_v3_DNW_2 IDV3_fail_timing_v4_DNW_2 IDV3_fail_timing_v5_DNW_2 IDV3_fail_timing_v0_DW_2 IDV3_fail_timing_v1_DW_2 IDV3_fail_timing_v2_DW_2 IDV3_fail_timing_v3_DW_2 IDV3_fail_timing_v4_DW_2 IDV3_fail_timing_v5_DW_2 IDV3_fail_timing_v0_D_2 IDV3_fail_timing_v1_D_2 IDV3_fail_timing_v2_D_2 IDV3_fail_timing_v3_D_2 IDV3_fail_timing_v4_D_2 IDV3_fail_timing_v5_D_2"

foreach x of local lagg {
gen k`x'= `x'
replace k`x' = !missing(`x')
bysort gvkey_dc_refine id_cortellis (develop_year_refine2): gen k`x'_t_1 = k`x'[_n-1]
}
}

*put drug-level info. to 004_9_ver2
{
	merge m:1 id_cortellis using "E:\ARK\as of Jul 2024\[501a] (unique) id_cortellis_target_based_actions.dta"
drop if _merge ==2
drop _merge
merge m:1 id_cortellis using "E:\ARK\as of Jul 2024\[502a] (unique) id_cortellis_Technologies.dta"
drop if _merge == 2
	rename cnt_TbA cnt_TbA_original
gen cnt_TbA = cnt_TbA_original
replace cnt_TbA = 1 if missing(cnt_TbA)
rename cnt_Tech cnt_Tech_original
gen cnt_Tech = cnt_Tech_original
replace cnt_Tech = 1 if missing( cnt_Tech )
drop _merge
distinct id_cortellis
save "E:\ARK\as of Jul 2024\[004_9_ver2] by gvkey_dc_refine id_cortellis develop_year_refine2.dta", replace
}

*year_expand --> 004_91_ver2 생성 
{
	clear
	use "E:\ARK\as of Jul 2024\[004_9_ver2] by gvkey_dc_refine id_cortellis develop_year_refine2.dta"
	keep top17 top15 gvkey_dc_refine conm id_cortellis DrugName develop_year_refine2
	gen id = _n
	bysort gvkey_dc_refine id_cortellis (develop_year_refine2): gen next_year = develop_year_refine2[_n+1]
	gen current_year = develop_year_refine2
	order next_year current_year, b(develop_year_refine2)
	gen diff = next_year - current_year, b(next_year)
	expand diff
	sort gvkey_dc_refine id_cortellis id 
	by gvkey_dc_refine id_cortellis id: gen year_expand = current_year + _n - 1
	order year_expand, b(develop_year_refine2)
	gen tag = 1 if year_expand != develop_year_refine2
	order tag
	drop next_year diff current_year
	rename gvkey_dc_refine gvkey
	rename  year_expand year

	merge m:1 gvkey year using "E:\ARK\Original data\Compustat_1990_2023.dta"
	drop if _merge == 2
	drop _merge  
	rename gvkey gvkey_dc_refine 
	rename year year_expand  
	gen mrkcap = csho*prcc_f
	gen wrkcap = act - lct
	gen sales = sale / (cshpri * ajex)
	gen FIRM_slack_avai = act / lct
	gen FIRM_slack_absor = wrkcap / sales
	gen FIRM_slack_poten = (at - lt )/ dltt
	egen FIRM_st_slack_avai = std(FIRM_slack_avai)
	egen FIRM_st_slack_absorb = std(FIRM_slack_absor)
	egen FIRM_st_slack_poten = std(FIRM_slack_poten)
	gen FIRM_slack_index =  FIRM_st_slack_avai + FIRM_st_slack_absorb + FIRM_st_slack_poten
	gen FIRM_tobinQ = (at + (csho*prcc_f) - ceq) / at
	gen FIRM_ROA = ni/at
	gen FIRM_ROE = ni/(csho*prcc_f)
	gen FIRM_ROI = ni/icapt
	gen FIRM_EPS = ni/csho
	gen FIRM_RnDinten = xrd / emp
	gen FIRM_RnDinten2 = xrd / at
	gen FIRM_astspec = ppent / emp
	sort gvkey_dc_refine id_cortellis year_expand
	duplicates report gvkey_dc_refine id_cortellis year_expand
	local logg "emp at sale mrkcap sales FIRM_slack_avai FIRM_slack_absor FIRM_slack_poten  FIRM_tobinQ FIRM_ROA FIRM_ROE FIRM_ROI FIRM_EPS FIRM_RnDinten FIRM_RnDinten2  FIRM_astspec"
	foreach x of local logg {
	gen log_`x' = log(1+`x')
}
	
	*drug-level data
	drop _merge
	merge m:1 id_cortellis using "E:\ARK\as of Jul 2024\[501a] (unique) id_cortellis_target_based_actions.dta"
	drop if _merge == 2
	drop _merge
	rename cnt_TbA cnt_TbA_original
	gen cnt_TbA = cnt_TbA_original
	replace cnt_TbA = 0 if missing(cnt_TbA)
	merge m:1 id_cortellis using "E:\ARK\as of Jul 2024\[502a] (unique) id_cortellis_Technologies.dta"
	drop if _merge == 2
	drop _merge
	rename cnt_Tech cnt_Tech_original
	gen cnt_Tech = cnt_Tech_original
	replace cnt_Tech = 0 if missing(cnt_Tech)
	gen biologic = 1 if strpos(Technologies, "Biological therapeutic")
	replace biologic = 0 if strpos(Technologies, "Small molecule")
	
	*firm-level data (patent)
	rename year_expand priority_year
	merge m:1 gvkey_dc_refine priority_year using "E:\ARK\as of Jul 2024\[200_3] (by gvkey_dc_refine priority_year) Patent_type_university_IPC.dta"
	drop if _merge ==2
	local change "total_ptn total_ptn_assignee_owner total_ptn_licen_DM total_ptn_licen_M total_ptn_owner total_Product total_Product_derivative total_Formulation total_New_use total_Compo_of_Compo total_Process total_Diag total_Drug_combination total_Delivery total_Product_pure total_Secondary total_PATENT_university total_Secondary_assignee total_Product_pure_assignee total_univeristy_assignee log_total_ptn log_total_Product_pure log_total_Secondary log_total_university ratio_Product_pure ratio_Secondary ratio_Secondary_2 ratio_Secondary_3 ratio_university log_total_ptn_assign log_total_Product_pure_assign log_total_Secon_assign log_total_univ_assign ratio_Product_pure_assign ratio_Secondary_assign ratio_Secondary_2_assign ratio_Secondary_3_assign ratio_univeristy_assign"
	foreach x of local change {
	replace `x' = 0 if _merge == 1
	}
	drop _merge
	rename priority_year year_expand
	sort gvkey_dc_refine id_cortellis year_expand
	drop *_dc
	drop *_fn
	
	*firm_level data (drug launched)
	merge m:1 gvkey_dc_refine year_expand using "E:\ARK\as of Jul 2024\[004_8a] (develop_status_refine) launched_drugs_by gvkey year.dta"
	replace CTR_cnt_launched = 0 if _merge == 1
	replace CTR_cnt_launched_therapy = 0 if _merge == 1
	gen CTR_avg_launched_therapy = CTR_cnt_launched_therapy / CTR_cnt_launched
	replace CTR_avg_launched_therapy = 0 if CTR_cnt_launched == 0
	drop _merge

	*** DV, IDV
	{
		clear
	use "E:\ARK\as of Jul 2024\[004_9_ver2] by gvkey_dc_refine id_cortellis develop_year_refine2.dta"
	keep gvkey_dc_refine - IDV3_fail_timing_v5_D_2  DV_v1_redeploy_dum - IDV1_cnt_fail_D_2_dum
 save "E:\ARK\as of Jul 2024\[004_9b_ver2] (before expanded) by gvkey_dc_refine id_cortellis develop_year_refine2.dta"
		
	}
	
	merge 1:1 gvkey_dc_refine id_cortellis year_expand using "E:\ARK\as of Jul 2024\[004_9b_ver2] (before expanded) by gvkey_dc_refine id_cortellis develop_year_refine2.dta"
	drop extension extension_dum
	gen extension = 1 if strpos(DrugName, "+"), a(dev_history_bf_MnA)
	replace extension = 1 if strpos(DrugName, "release")
	replace extension = 1 if strpos(DrugName, "formulation")
	replace extension = 1 if strpos(DrugName, "infusion")
	replace extension = 1 if strpos(DrugName, "patch")
	replace extension = 1 if strpos(DrugName, "oral")
	replace extension = 1 if strpos(DrugName, "transdermal")
	gen extension_dum = (extension == 1)
	
	gen external_N = external, b(external)
	by gvkey_dc_refine id_cortellis: replace external_N = 1 if external_N[_n-1] == 1 & missing(external_N) & tag == 1
	gen external_N_dum = (external_N == 1)
	gen dev_history_bf_MnA_N = dev_history_bf_MnA, b( dev_history_bf_MnA)
	by gvkey_dc_refine id_cortellis: replace dev_history_bf_MnA_N = 0 if dev_history_bf_MnA_N[_n-1] == 0 & missing( dev_history_bf_MnA_N) & tag == 1
	by gvkey_dc_refine id_cortellis: replace dev_history_bf_MnA_N = 1 if dev_history_bf_MnA_N[_n-1] == 1 & missing( dev_history_bf_MnA_N) & tag == 1
	*DV IDV 모두 새롭게 추가된 expand year (tag == 1) 에서 0 의 값을 가짐 
	***DV 
	gen DV_v4_same_TA_dum_N = (DV_v3_diff_TA_dum == 0 & DV_v2_diff_indi_dum != 0)
	
	local change "DV_v1_redeploy DV_v2_diff_indi DV_v3_diff_TA DV_v1_redeploy_dum DV_v2_diff_indi_dum DV_v3_diff_TA_dum"
	local change "IDV1_cnt_fail_DNSW IDV1_cnt_fail_DNW IDV1_cnt_fail_DW IDV1_cnt_fail_D  IDV1_cnt_fail_DNSW_2 IDV1_cnt_fail_DNW_2 IDV1_cnt_fail_DW_2 IDV1_cnt_fail_D_2  IDV2_v1_red_timing_DNSW IDV2_v1_red_timing_DNW IDV2_v1_red_timing_DW IDV2_v1_red_timing_D IDV2_v2_red_timing_DNSW IDV2_v2_red_timing_DNW IDV2_v2_red_timing_DW IDV2_v2_red_timing_D IDV2_v3_red_timing_DNSW IDV2_v3_red_timing_DNW IDV2_v3_red_timing_DW IDV2_v3_red_timing_D IDV2_v1_red_timing_DNSW_2 IDV2_v1_red_timing_DNW_2 IDV2_v1_red_timing_DW_2 IDV2_v1_red_timing_D_2 IDV2_v2_red_timing_DNSW_2 IDV2_v2_red_timing_DNW_2 IDV2_v2_red_timing_DW_2 IDV2_v2_red_timing_D_2 IDV2_v3_red_timing_DNSW_2 IDV2_v3_red_timing_DNW_2 IDV2_v3_red_timing_DW_2 IDV2_v3_red_timing_D_2 IDV3_fail_timing_v0_DNSW IDV3_fail_timing_v1_DNSW IDV3_fail_timing_v2_DNSW IDV3_fail_timing_v3_DNSW IDV3_fail_timing_v4_DNSW IDV3_fail_timing_v5_DNSW IDV3_fail_timing_v0_DNW IDV3_fail_timing_v1_DNW IDV3_fail_timing_v2_DNW IDV3_fail_timing_v3_DNW IDV3_fail_timing_v4_DNW IDV3_fail_timing_v5_DNW IDV3_fail_timing_v0_DW IDV3_fail_timing_v1_DW IDV3_fail_timing_v2_DW IDV3_fail_timing_v3_DW IDV3_fail_timing_v4_DW IDV3_fail_timing_v5_DW IDV3_fail_timing_v0_D IDV3_fail_timing_v1_D IDV3_fail_timing_v2_D IDV3_fail_timing_v3_D IDV3_fail_timing_v4_D IDV3_fail_timing_v5_D IDV3_fail_timing_v0_DNSW_2 IDV3_fail_timing_v1_DNSW_2 IDV3_fail_timing_v2_DNSW_2 IDV3_fail_timing_v3_DNSW_2 IDV3_fail_timing_v4_DNSW_2 IDV3_fail_timing_v5_DNSW_2 IDV3_fail_timing_v0_DNW_2 IDV3_fail_timing_v1_DNW_2 IDV3_fail_timing_v2_DNW_2 IDV3_fail_timing_v3_DNW_2 IDV3_fail_timing_v4_DNW_2 IDV3_fail_timing_v5_DNW_2 IDV3_fail_timing_v0_DW_2 IDV3_fail_timing_v1_DW_2 IDV3_fail_timing_v2_DW_2 IDV3_fail_timing_v3_DW_2 IDV3_fail_timing_v4_DW_2 IDV3_fail_timing_v5_DW_2 IDV3_fail_timing_v0_D_2 IDV3_fail_timing_v1_D_2 IDV3_fail_timing_v2_D_2 IDV3_fail_timing_v3_D_2 IDV3_fail_timing_v4_D_2 IDV3_fail_timing_v5_D_2  IDV1_cnt_fail_DNSW_dum IDV1_cnt_fail_DNW_dum IDV1_cnt_fail_DW_dum IDV1_cnt_fail_D_dum IDV1_cnt_fail_DNSW_2_dum IDV1_cnt_fail_DNW_2_dum IDV1_cnt_fail_DW_2_dum IDV1_cnt_fail_D_2_dum"

	foreach x of local change {
	gen `x'_N = `x'
	replace `x'_N = 0 if tag == 1 
	}
	drop _merge
	
	gen being_developed = (tag == 1)
	egen double_cluster_firm_drug =group( gvkey_dc_refine id_cortellis )
	rename log_total_ptn l_total_ptn
	rename log_total_Product_pure l_total_Product_pure
	rename log_total_Secondary l_total_Secondary
	rename log_total_university l_total_university
	rename log_total_ptn_assign l_total_ptn_assign
	rename log_total_Product_pure_assign l_total_Product_pure_assign
	rename log_total_Secon_assign l_total_Secon_assign
	rename log_total_univ_assign l_total_univ_assign
	rename log_emp l_emp
	rename log_at l_at 
	rename log_sale l_sale 
	rename log_mrkcap l_mrkcap 
	rename log_sales l_sales 
	rename log_FIRM_slack_avai l_slack_avai 
	rename log_FIRM_slack_absor l_slack_absor 
	rename log_FIRM_slack_poten l_slack_poten 
	rename log_FIRM_tobinQ l_tobinQ 
	rename log_FIRM_ROA l_ROA 
	rename log_FIRM_ROE l_ROE 
	rename log_FIRM_ROI l_ROI 
	rename log_FIRM_EPS l_EPS 
	rename log_FIRM_RnDinten l_RnDinten 
	rename log_FIRM_RnDinten2 l_RnDinten2 
	rename log_FIRM_astspec l_astspec
	local lagg "l_total_ptn l_total_Product_pure l_total_Secondary l_total_university ratio_Product_pure ratio_Secondary ratio_Secondary_2 ratio_Secondary_3 ratio_university l_total_ptn_assign l_total_Product_pure_assign l_total_Secon_assign l_total_univ_assign ratio_Product_pure_assign ratio_Secondary_assign ratio_Secondary_2_assign ratio_Secondary_3_assign ratio_univeristy_assign CTR_cnt_launched CTR_cnt_launched_therapy CTR_avg_launched_therapy external_N_dum dev_history_bf_MnA_N l_emp l_at l_sale l_mrkcap l_sales l_slack_avai l_slack_absor l_slack_poten l_tobinQ l_ROA l_ROE l_ROI l_EPS l_RnDinten l_RnDinten2 l_astspec FIRM_slack_index  "
	foreach x of local lagg {
	bysort gvkey_dc_refine id_cortellis (year_expand): gen `x'_t_1 = `x'[_n-1]
	}
	**failure variable - frequency, incident
	*** 어떤 연도까지 failure 누적 횟수 변수 생성 
	local acc "IDV1_cnt_fail_DNSW IDV1_cnt_fail_DNW IDV1_cnt_fail_DW IDV1_cnt_fail_D IDV1_cnt_fail_DNSW_2 IDV1_cnt_fail_DNW_2 IDV1_cnt_fail_DW_2 IDV1_cnt_fail_D_2 "
	foreach x of local acc {
	bysort gvkey_dc_refine id_cortellis (year_expand): gen s_`x' = sum(`x')
	}
	*** s_IDV1_dum: t 년도를 포함하여 t 년도까지 failure 가 과거에 있으면 1 아니면 0 
	local acc2 "s_IDV1_cnt_fail_DNSW s_IDV1_cnt_fail_DNW s_IDV1_cnt_fail_DW s_IDV1_cnt_fail_D s_IDV1_cnt_fail_DNSW_2 s_IDV1_cnt_fail_DNW_2 s_IDV1_cnt_fail_DW_2 s_IDV1_cnt_fail_D_2"
	foreach x of local acc2 {
	gen `x'_dum = (`x' != 0)
	}
	local lagg "s_IDV1_cnt_fail_DNSW s_IDV1_cnt_fail_DNW s_IDV1_cnt_fail_DW s_IDV1_cnt_fail_D s_IDV1_cnt_fail_DNSW_2 s_IDV1_cnt_fail_DNW_2 s_IDV1_cnt_fail_DW_2 s_IDV1_cnt_fail_D_2 s_IDV1_cnt_fail_DNSW_dum s_IDV1_cnt_fail_DNW_dum s_IDV1_cnt_fail_DW_dum s_IDV1_cnt_fail_D_dum s_IDV1_cnt_fail_DNSW_2_dum s_IDV1_cnt_fail_DNW_2_dum s_IDV1_cnt_fail_DW_2_dum s_IDV1_cnt_fail_D_2_dum"
	foreach x of local lagg {
	bysort gvkey_dc_refine id_cortellis (year_expand): gen `x'_t_1 = `x'[_n-1]
	}
	
	
	*** redeployment timing
	*(a) time gap between the focal year and the most recent failure
	*(b) time gap between the redeployment and the most recent failure
	local fail "DNSW DNW DW D DNSW_2 DNW_2 DW_2 D_2"
	foreach x of local fail {
		gen tic_`x' =  fail_`x'_year_recent, b(fail_`x'_year_recent)
		by gvkey_dc_refine id_cortellis: replace tic_`x' = tic_`x'[_n-1] if !missing(tic_`x'[_n-1]) & missing(tic_`x')
		by gvkey_dc_refine id_cortellis: gen tic_`x'_t_1 = tic_`x'[_n-1]
		
		gen IDV2_red_timingA_`x' = year_expand - tic_`x'_t_1 

		gen IDV2_red_timingB_v1_`x' = IDV2_red_timingA_`x' if DV_v1_redeploy_dum_N != 0
		gen IDV2_red_timingB_v2_`x' = IDV2_red_timingA_`x' if DV_v2_diff_indi_dum_N != 0
		gen IDV2_red_timingB_v3_`x' = IDV2_red_timingA_`x' if DV_v3_diff_TA_dum_N != 0
		gen IDV2_red_timingB_v4_`x' = IDV2_red_timingA_`x' if DV_v4_same_TA_dum_N != 0
		
		drop tic_`x' tic_`x'_t_1 
	}
	
	drop IDV3_fail_timing_v0_DNSW_N IDV3_fail_timing_v1_DNSW_N IDV3_fail_timing_v2_DNSW_N IDV3_fail_timing_v3_DNSW_N IDV3_fail_timing_v4_DNSW_N IDV3_fail_timing_v5_DNSW_N IDV3_fail_timing_v0_DNW_N IDV3_fail_timing_v1_DNW_N IDV3_fail_timing_v2_DNW_N IDV3_fail_timing_v3_DNW_N IDV3_fail_timing_v4_DNW_N IDV3_fail_timing_v5_DNW_N IDV3_fail_timing_v0_DW_N IDV3_fail_timing_v1_DW_N IDV3_fail_timing_v2_DW_N IDV3_fail_timing_v3_DW_N IDV3_fail_timing_v4_DW_N IDV3_fail_timing_v5_DW_N IDV3_fail_timing_v0_D_N IDV3_fail_timing_v1_D_N IDV3_fail_timing_v2_D_N IDV3_fail_timing_v3_D_N IDV3_fail_timing_v4_D_N IDV3_fail_timing_v5_D_N IDV3_fail_timing_v0_DNSW_2_N IDV3_fail_timing_v1_DNSW_2_N IDV3_fail_timing_v2_DNSW_2_N IDV3_fail_timing_v3_DNSW_2_N IDV3_fail_timing_v4_DNSW_2_N IDV3_fail_timing_v5_DNSW_2_N IDV3_fail_timing_v0_DNW_2_N IDV3_fail_timing_v1_DNW_2_N IDV3_fail_timing_v2_DNW_2_N IDV3_fail_timing_v3_DNW_2_N IDV3_fail_timing_v4_DNW_2_N IDV3_fail_timing_v5_DNW_2_N IDV3_fail_timing_v0_DW_2_N IDV3_fail_timing_v1_DW_2_N IDV3_fail_timing_v2_DW_2_N IDV3_fail_timing_v3_DW_2_N IDV3_fail_timing_v4_DW_2_N IDV3_fail_timing_v5_DW_2_N IDV3_fail_timing_v0_D_2_N IDV3_fail_timing_v1_D_2_N IDV3_fail_timing_v2_D_2_N IDV3_fail_timing_v3_D_2_N IDV3_fail_timing_v4_D_2_N IDV3_fail_timing_v5_D_2_N
	*** failure timing
	local fail "DNSW DNW DW D DNSW_2 DNW_2 DW_2 D_2"
	foreach x of local fail {
	foreach num of numlist 0/5{
	gen IDV3_fail_timing_v`num'_`x'_N = IDV3_fail_timing_v`num'_`x'
	bysort gvkey_dc_refine id_cortellis (year_expand): replace IDV3_fail_timing_v`num'_`x'_N= IDV3_fail_timing_v`num'_`x'_N[_n-1] if !missing(IDV3_fail_timing_v`num'_`x'_N[_n-1]) & missing(IDV3_fail_timing_v`num'_`x'_N)
	}
	}
	
	bysort gvkey_dc_refine id_cortellis (year_expand): gen first_attempt_N = ( _n == 1 )	
	bysort gvkey_dc_refine id_cortellis (year_expand): gen first_attempt_N_t_1 = first_attempt_N[_n-1]
	bysort gvkey_dc_refine id_cortellis (year_expand): gen being_developed_t_1 = being_developed[_n-1]
	
	save "E:\ARK\as of Jul 2024\[004_91_ver2] (expanded) by gvkey_dc_refine id_cortellis develop_year_refine2.dta"
	
	}

}

	


####FROM HERE 2024-08-20

--- Non-parametric analysis
{

distinct gvkey_dc_refine if dev_history_bf_MnA == 0

                 |        Observations
                 |      total   distinct
-----------------+----------------------
 gvkey_dc_refine |      89740       1643

 
distinct gvkey_dc_refine if dev_history_bf_MnA == 0 & develop_year_refine2 > 1998

                 |        Observations
                 |      total   distinct
-----------------+----------------------
 gvkey_dc_refine |      81596       1620


distinct gvkey_dc_refine if develop_year_refine2 > 1998 & top15 == 1 & dev_history_bf_MnA == 0

                 |        Observations
                 |      total   distinct
-----------------+----------------------
 gvkey_dc_refine |      28117         15



distinct id_cortellis if dev_history_bf_MnA == 0

              |        Observations
              |      total   distinct
--------------+----------------------
 id_cortellis |      89740      31012



distinct id_cortellis if develop_year_refine2 > 1998 & dev_history_bf_MnA == 0

              |        Observations
              |      total   distinct
--------------+----------------------
 id_cortellis |      81596      30257


 
distinct id_cortellis if develop_year_refine2 > 1998 & top15 == 1 & dev_history_bf_MnA == 0

              |        Observations
              |      total   distinct
--------------+----------------------
 id_cortellis |      28117      12125
}
***---> 1620개 기업 중 15개 기업(0.93%)이 30,257 drug 중 12,125 (40.07%) drug development 


--- Non-parametric analysis
--- result file: E:\ARK\as of Jul 2024\non_parametric.xlsx
{
clear
use "E:\ARK\as of Jul 2024\[004_91] (expanded) by gvkey_dc_refine id_cortellis develop_year_refine2.dta"

** 전체 (아무 조건 없음)
preserve
keep top15 year_expand DV_v1_redeploy_N  DV_v3_diff_TA_N DV_v1_redeploy_v2_N DV_v2_diff_indi_v2_N DV_v3_diff_TA_v2_N IDV1_cnt_fail_DNSW_2 IDV1_cnt_fail_DNW_2 IDV1_cnt_fail_DW_2 IDV1_cnt_fail_D_2 IDV1_cnt_fail_DNSW_2_v2 IDV1_cnt_fail_DNW_2_v2 IDV1_cnt_fail_DW_2_v2 IDV1_cnt_fail_D_2_v2 first_attempt_N first_attempt_v2 dev_history_bf_MnA_N CTR_cnt_launched_by_drug

bysort year_expand: gen total_drug = _N
local total " first_attempt_N DV_v1_redeploy_N DV_v3_diff_TA_N IDV1_cnt_fail_DNSW_2 IDV1_cnt_fail_DNW_2 IDV1_cnt_fail_DW_2 IDV1_cnt_fail_D_2 CTR_cnt_launched_by_drug "
foreach x of local total {
bysort year_expand: egen t_`x' = total(`x')
}
foreach x of local total {
bysort year_expand: gen r_`x' = t_`x' / total_drug
}

keep year_expand total_drug t_first_attempt_N t_DV_v1_redeploy_N t_DV_v3_diff_TA_N t_IDV1_cnt_fail_DNSW_2 t_IDV1_cnt_fail_DNW_2 t_IDV1_cnt_fail_DW_2 t_IDV1_cnt_fail_D_2 t_CTR_cnt_launched_by_drug r_first_attempt_N r_DV_v1_redeploy_N r_DV_v3_diff_TA_N r_IDV1_cnt_fail_DNSW_2 r_IDV1_cnt_fail_DNW_2 r_IDV1_cnt_fail_DW_2 r_IDV1_cnt_fail_D_2 r_CTR_cnt_launched_by_drug

duplicates drop
duplicates report year_expand
export excel using "E:\ARK\as of Jul 2024\non_parametric.xlsx", sheet("all_firms") firstrow(variables)
restore

** top 15 firms
preserve
keep top15 year_expand DV_v1_redeploy_N  DV_v3_diff_TA_N DV_v1_redeploy_v2_N DV_v2_diff_indi_v2_N DV_v3_diff_TA_v2_N IDV1_cnt_fail_DNSW_2 IDV1_cnt_fail_DNW_2 IDV1_cnt_fail_DW_2 IDV1_cnt_fail_D_2 IDV1_cnt_fail_DNSW_2_v2 IDV1_cnt_fail_DNW_2_v2 IDV1_cnt_fail_DW_2_v2 IDV1_cnt_fail_D_2_v2 first_attempt_N first_attempt_v2 dev_history_bf_MnA_N CTR_cnt_launched_by_drug

keep if top15 == 1
bysort year_expand: gen total_drug = _N
local total " first_attempt_N DV_v1_redeploy_N DV_v3_diff_TA_N IDV1_cnt_fail_DNSW_2 IDV1_cnt_fail_DNW_2 IDV1_cnt_fail_DW_2 IDV1_cnt_fail_D_2 CTR_cnt_launched_by_drug "
foreach x of local total {
bysort year_expand: egen t_`x' = total(`x')
}
foreach x of local total {
bysort year_expand: gen r_`x' = t_`x' / total_drug
}
keep year_expand total_drug t_first_attempt_N t_DV_v1_redeploy_N t_DV_v3_diff_TA_N t_IDV1_cnt_fail_DNSW_2 t_IDV1_cnt_fail_DNW_2 t_IDV1_cnt_fail_DW_2 t_IDV1_cnt_fail_D_2 t_CTR_cnt_launched_by_drug r_first_attempt_N r_DV_v1_redeploy_N r_DV_v3_diff_TA_N r_IDV1_cnt_fail_DNSW_2 r_IDV1_cnt_fail_DNW_2 r_IDV1_cnt_fail_DW_2 r_IDV1_cnt_fail_D_2 r_CTR_cnt_launched_by_drug
duplicates drop
duplicates report year_expand
export excel using "E:\ARK\as of Jul 2024\non_parametric.xlsx", sheet("top15_firms") firstrow(variables)
restore


** non-top 15 firms



** bf_MnA == 0 variables, all firms
preserve
keep top15 year_expand DV_v1_redeploy_N  DV_v3_diff_TA_N DV_v1_redeploy_v2_N DV_v2_diff_indi_v2_N DV_v3_diff_TA_v2_N IDV1_cnt_fail_DNSW_2 IDV1_cnt_fail_DNW_2 IDV1_cnt_fail_DW_2 IDV1_cnt_fail_D_2 IDV1_cnt_fail_DNSW_2_v2 IDV1_cnt_fail_DNW_2_v2 IDV1_cnt_fail_DW_2_v2 IDV1_cnt_fail_D_2_v2 first_attempt_N first_attempt_v2 dev_history_bf_MnA_N CTR_cnt_launched_by_drug

keep if dev_history_bf_MnA_N == 0
bysort year_expand: gen total_drug = _N
local total " first_attempt_v2 DV_v1_redeploy_v2_N DV_v3_diff_TA_v2_N IDV1_cnt_fail_DNSW_2_v2 IDV1_cnt_fail_DNW_2_v2 IDV1_cnt_fail_DW_2_v2 IDV1_cnt_fail_D_2_v2 "
foreach x of local total {
bysort year_expand: egen t_`x' = total(`x')
}
foreach x of local total {
bysort year_expand: gen r_`x' = t_`x' / total_drug
}
keep year_expand total_drug t_first_attempt_v2 t_DV_v1_redeploy_v2_N t_DV_v3_diff_TA_v2_N t_IDV1_cnt_fail_DNSW_2_v2 t_IDV1_cnt_fail_DNW_2_v2 t_IDV1_cnt_fail_DW_2_v2 t_IDV1_cnt_fail_D_2_v2 r_first_attempt_v2 r_DV_v1_redeploy_v2_N r_DV_v3_diff_TA_v2_N r_IDV1_cnt_fail_DNSW_2_v2 r_IDV1_cnt_fail_DNW_2_v2 r_IDV1_cnt_fail_DW_2_v2 r_IDV1_cnt_fail_D_2_v2
duplicates drop
duplicates report year_expand
export excel using "E:\ARK\as of Jul 2024\non_parametric.xlsx", sheet("all_firms_bf_MnA_zero") firstrow(variables)
restore


** bf_MnA == 0 variables, top 15 firms
preserve
keep top15 year_expand DV_v1_redeploy_N  DV_v3_diff_TA_N DV_v1_redeploy_v2_N DV_v2_diff_indi_v2_N DV_v3_diff_TA_v2_N IDV1_cnt_fail_DNSW_2 IDV1_cnt_fail_DNW_2 IDV1_cnt_fail_DW_2 IDV1_cnt_fail_D_2 IDV1_cnt_fail_DNSW_2_v2 IDV1_cnt_fail_DNW_2_v2 IDV1_cnt_fail_DW_2_v2 IDV1_cnt_fail_D_2_v2 first_attempt_N first_attempt_v2 dev_history_bf_MnA_N CTR_cnt_launched_by_drug

keep if dev_history_bf_MnA_N == 0
keep if top15 == 1
bysort year_expand: gen total_drug = _N
local total " first_attempt_v2 DV_v1_redeploy_v2_N DV_v3_diff_TA_v2_N IDV1_cnt_fail_DNSW_2_v2 IDV1_cnt_fail_DNW_2_v2 IDV1_cnt_fail_DW_2_v2 IDV1_cnt_fail_D_2_v2 "
foreach x of local total {
bysort year_expand: egen t_`x' = total(`x')
}
foreach x of local total {
bysort year_expand: gen r_`x' = t_`x' / total_drug
}
keep year_expand total_drug t_first_attempt_v2 t_DV_v1_redeploy_v2_N t_DV_v3_diff_TA_v2_N t_IDV1_cnt_fail_DNSW_2_v2 t_IDV1_cnt_fail_DNW_2_v2 t_IDV1_cnt_fail_DW_2_v2 t_IDV1_cnt_fail_D_2_v2 r_first_attempt_v2 r_DV_v1_redeploy_v2_N r_DV_v3_diff_TA_v2_N r_IDV1_cnt_fail_DNSW_2_v2 r_IDV1_cnt_fail_DNW_2_v2 r_IDV1_cnt_fail_DW_2_v2 r_IDV1_cnt_fail_D_2_v2
duplicates drop
duplicates report year_expand
export excel using "E:\ARK\as of Jul 2024\non_parametric.xlsx", sheet("top15_firms_bf_MnA_zero") firstrow(variables)
restore


** external == 0, extension == 0, all firms
preserve
keep top15 year_expand DV_v1_redeploy_N  DV_v3_diff_TA_N DV_v1_redeploy_v2_N DV_v2_diff_indi_v2_N DV_v3_diff_TA_v2_N IDV1_cnt_fail_DNSW_2 IDV1_cnt_fail_DNW_2 IDV1_cnt_fail_DW_2 IDV1_cnt_fail_D_2  dev_history_bf_MnA_N CTR_cnt_launched_by_drug external_N extension_dum first_attempt_N

keep if extension_dum == 0
drop if external_N == 1

bysort year_expand: gen total_drug = _N
local total " first_attempt_N DV_v1_redeploy_N DV_v3_diff_TA_N IDV1_cnt_fail_DNSW_2 IDV1_cnt_fail_DNW_2 IDV1_cnt_fail_DW_2 IDV1_cnt_fail_D_2 CTR_cnt_launched_by_drug "
foreach x of local total {
bysort year_expand: egen t_`x' = total(`x')
}
foreach x of local total {
bysort year_expand: gen r_`x' = t_`x' / total_drug
}

keep year_expand total_drug t_first_attempt_N t_DV_v1_redeploy_N t_DV_v3_diff_TA_N t_IDV1_cnt_fail_DNSW_2 t_IDV1_cnt_fail_DNW_2 t_IDV1_cnt_fail_DW_2 t_IDV1_cnt_fail_D_2 t_CTR_cnt_launched_by_drug r_first_attempt_N r_DV_v1_redeploy_N r_DV_v3_diff_TA_N r_IDV1_cnt_fail_DNSW_2 r_IDV1_cnt_fail_DNW_2 r_IDV1_cnt_fail_DW_2 r_IDV1_cnt_fail_D_2 r_CTR_cnt_launched_by_drug

duplicates drop
duplicates report year_expand
export excel using "E:\ARK\as of Jul 2024\non_parametric.xlsx", sheet("all_firms_no_external_extension") firstrow(variables)
restore


** external == 0, extension == 0, top 15 firms
preserve
keep top15 year_expand DV_v1_redeploy_N  DV_v3_diff_TA_N DV_v1_redeploy_v2_N DV_v2_diff_indi_v2_N DV_v3_diff_TA_v2_N IDV1_cnt_fail_DNSW_2 IDV1_cnt_fail_DNW_2 IDV1_cnt_fail_DW_2 IDV1_cnt_fail_D_2  dev_history_bf_MnA_N CTR_cnt_launched_by_drug external_N extension_dum first_attempt_N

keep if top15 == 1
keep if extension_dum == 0
drop if external_N == 1

bysort year_expand: gen total_drug = _N
local total " first_attempt_N DV_v1_redeploy_N DV_v3_diff_TA_N IDV1_cnt_fail_DNSW_2 IDV1_cnt_fail_DNW_2 IDV1_cnt_fail_DW_2 IDV1_cnt_fail_D_2 CTR_cnt_launched_by_drug "
foreach x of local total {
bysort year_expand: egen t_`x' = total(`x')
}
foreach x of local total {
bysort year_expand: gen r_`x' = t_`x' / total_drug
}
keep year_expand total_drug t_first_attempt_N t_DV_v1_redeploy_N t_DV_v3_diff_TA_N t_IDV1_cnt_fail_DNSW_2 t_IDV1_cnt_fail_DNW_2 t_IDV1_cnt_fail_DW_2 t_IDV1_cnt_fail_D_2 t_CTR_cnt_launched_by_drug r_first_attempt_N r_DV_v1_redeploy_N r_DV_v3_diff_TA_N r_IDV1_cnt_fail_DNSW_2 r_IDV1_cnt_fail_DNW_2 r_IDV1_cnt_fail_DW_2 r_IDV1_cnt_fail_D_2 r_CTR_cnt_launched_by_drug
duplicates drop
duplicates report year_expand
export excel using "E:\ARK\as of Jul 2024\non_parametric.xlsx", sheet("top_firms_no_external_extension") firstrow(variables)



** bf_MnA == 0 variables, external == 0, extension == 0, all firms
keep top15 year_expand DV_v1_redeploy_N  DV_v3_diff_TA_N DV_v1_redeploy_v2_N DV_v2_diff_indi_v2_N DV_v3_diff_TA_v2_N IDV1_cnt_fail_DNSW_2 IDV1_cnt_fail_DNW_2 IDV1_cnt_fail_DW_2 IDV1_cnt_fail_D_2 IDV1_cnt_fail_DNSW_2_v2 IDV1_cnt_fail_DNW_2_v2 IDV1_cnt_fail_DW_2_v2 IDV1_cnt_fail_D_2_v2 first_attempt_N first_attempt_v2 dev_history_bf_MnA_N CTR_cnt_launched_by_drug  extension_dum  external_N

keep if dev_history_bf_MnA_N == 0
keep if extension_dum == 0
drop if external_N == 1

bysort year_expand: gen total_drug = _N
local total " first_attempt_v2 DV_v1_redeploy_v2_N DV_v3_diff_TA_v2_N IDV1_cnt_fail_DNSW_2_v2 IDV1_cnt_fail_DNW_2_v2 IDV1_cnt_fail_DW_2_v2 IDV1_cnt_fail_D_2_v2 "
foreach x of local total {
bysort year_expand: egen t_`x' = total(`x')
}
foreach x of local total {
bysort year_expand: gen r_`x' = t_`x' / total_drug
}
keep year_expand total_drug t_first_attempt_v2 t_DV_v1_redeploy_v2_N t_DV_v3_diff_TA_v2_N t_IDV1_cnt_fail_DNSW_2_v2 t_IDV1_cnt_fail_DNW_2_v2 t_IDV1_cnt_fail_DW_2_v2 t_IDV1_cnt_fail_D_2_v2 r_first_attempt_v2 r_DV_v1_redeploy_v2_N r_DV_v3_diff_TA_v2_N r_IDV1_cnt_fail_DNSW_2_v2 r_IDV1_cnt_fail_DNW_2_v2 r_IDV1_cnt_fail_DW_2_v2 r_IDV1_cnt_fail_D_2_v2
duplicates drop
duplicates report year_expand
export excel using "E:\ARK\as of Jul 2024\non_parametric.xlsx", sheet("all_firms_bf_exten_exter_zero") firstrow(variables)
restore


** bf_MnA == 0 variables, external == 0, extension == 0, top 15 firms
preserve
keep top15 year_expand DV_v1_redeploy_N  DV_v3_diff_TA_N DV_v1_redeploy_v2_N DV_v2_diff_indi_v2_N DV_v3_diff_TA_v2_N IDV1_cnt_fail_DNSW_2 IDV1_cnt_fail_DNW_2 IDV1_cnt_fail_DW_2 IDV1_cnt_fail_D_2 IDV1_cnt_fail_DNSW_2_v2 IDV1_cnt_fail_DNW_2_v2 IDV1_cnt_fail_DW_2_v2 IDV1_cnt_fail_D_2_v2 first_attempt_N first_attempt_v2 dev_history_bf_MnA_N CTR_cnt_launched_by_drug  extension_dum  external_N

keep if dev_history_bf_MnA_N == 0
keep if top15 == 1
keep if extension_dum == 0
drop if external_N == 1

bysort year_expand: gen total_drug = _N
local total " first_attempt_v2 DV_v1_redeploy_v2_N DV_v3_diff_TA_v2_N IDV1_cnt_fail_DNSW_2_v2 IDV1_cnt_fail_DNW_2_v2 IDV1_cnt_fail_DW_2_v2 IDV1_cnt_fail_D_2_v2 "
foreach x of local total {
bysort year_expand: egen t_`x' = total(`x')
}
foreach x of local total {
bysort year_expand: gen r_`x' = t_`x' / total_drug
}
keep year_expand total_drug t_first_attempt_v2 t_DV_v1_redeploy_v2_N t_DV_v3_diff_TA_v2_N t_IDV1_cnt_fail_DNSW_2_v2 t_IDV1_cnt_fail_DNW_2_v2 t_IDV1_cnt_fail_DW_2_v2 t_IDV1_cnt_fail_D_2_v2 r_first_attempt_v2 r_DV_v1_redeploy_v2_N r_DV_v3_diff_TA_v2_N r_IDV1_cnt_fail_DNSW_2_v2 r_IDV1_cnt_fail_DNW_2_v2 r_IDV1_cnt_fail_DW_2_v2 r_IDV1_cnt_fail_D_2_v2
duplicates drop
duplicates report year_expand
export excel using "E:\ARK\as of Jul 2024\non_parametric.xlsx", sheet("all_firms_bf_exten_exter_zero") firstrow(variables)
restore


}





if develop_year_refine2 > 1998 & top15 == 1 & dev_history_bf_MnA == 0





--- Regression model 






*** 걸어야 할 조건
(0) being_developed (정확한 t-1 을 하기 위해 expand 한 incidence 를 tagging)
(1) develop_year_refine2 > 1998
?? (2) dev_history_bf_MnA_t_1 == 0
?? two-way clustering? 
---> egen double_cluster_firm_drug =group( gvkey_dc_refine id_cortellis )

*** DEPENDENT VARIABLE 
redeployment to different TA (DV_v3_diff_TA_dum)
redeployment to same TA (DV_v4_same_TA_dum)
redeployment (DV_v1_redeploy_dum)


*** INDEPENDENT VARIABLE

number of failure 
---> (s_IDV1_cnt_fail_DNSW s_IDV1_cnt_fail_DNW s_IDV1_cnt_fail_DW s_IDV1_cnt_fail_D s_IDV1_cnt_fail_DNSW_2 s_IDV1_cnt_fail_DNW_2 s_IDV1_cnt_fail_DW_2 s_IDV1_cnt_fail_D_2)


incidence of failure // (lagg 해야됨)
---> (s_IDV1_cnt_fail_DNSW_dum s_IDV1_cnt_fail_DNW_dum s_IDV1_cnt_fail_DW_dum s_IDV1_cnt_fail_D_dum s_IDV1_cnt_fail_DNSW_2_dum s_IDV1_cnt_fail_DNW_2_dum s_IDV1_cnt_fail_DW_2_dum s_IDV1_cnt_fail_D_2_dum)


redeployment timing (여기 적힌 v1,v2,v3 는 redeployment 의 v1,v2,v3 와 연결됨)/// (lagg 하면 안됨)
*** timingA: year_expand - year of the most recent failure (dependent on failure)
*** timingB: year of redeployment - year of the most recent failure (dependent on redeployment, failure)
---> (IDV2_red_timingA_DNSW IDV2_red_timingB_v1_DNSW IDV2_red_timingB_v2_DNSW IDV2_red_timingB_v3_DNSW IDV2_red_timingB_v4_DNSW IDV2_red_timingA_DNW IDV2_red_timingB_v1_DNW IDV2_red_timingB_v2_DNW IDV2_red_timingB_v3_DNW IDV2_red_timingB_v4_DNW IDV2_red_timingA_DW IDV2_red_timingB_v1_DW IDV2_red_timingB_v2_DW IDV2_red_timingB_v3_DW IDV2_red_timingB_v4_DW IDV2_red_timingA_D IDV2_red_timingB_v1_D IDV2_red_timingB_v2_D IDV2_red_timingB_v3_D IDV2_red_timingB_v4_D)
---> (IDV2_red_timingA_DNSW_2 IDV2_red_timingB_v1_DNSW_2 IDV2_red_timingB_v2_DNSW_2 IDV2_red_timingB_v3_DNSW_2 IDV2_red_timingB_v4_DNSW_2 IDV2_red_timingA_DNW_2 IDV2_red_timingB_v1_DNW_2 IDV2_red_timingB_v2_DNW_2 IDV2_red_timingB_v3_DNW_2 IDV2_red_timingB_v4_DNW_2 IDV2_red_timingA_DW_2 IDV2_red_timingB_v1_DW_2 IDV2_red_timingB_v2_DW_2 IDV2_red_timingB_v3_DW_2 IDV2_red_timingB_v4_DW_2 IDV2_red_timingA_D_2 IDV2_red_timingB_v1_D_2 IDV2_red_timingB_v2_D_2 IDV2_red_timingB_v3_D_2 IDV2_red_timingB_v4_D_2)


timing of failure (여기 적힌 v0,v1,v2,v3,v4,v5 는 redeployment 와 연결되지 않음) // (lagg 해야됨)
---> (IDV3_fail_timing_v0_DNSW_N IDV3_fail_timing_v1_DNSW_N IDV3_fail_timing_v2_DNSW_N IDV3_fail_timing_v3_DNSW_N IDV3_fail_timing_v4_DNSW_N IDV3_fail_timing_v5_DNSW_N IDV3_fail_timing_v0_DNW_N IDV3_fail_timing_v1_DNW_N IDV3_fail_timing_v2_DNW_N IDV3_fail_timing_v3_DNW_N IDV3_fail_timing_v4_DNW_N IDV3_fail_timing_v5_DNW_N IDV3_fail_timing_v0_DW_N IDV3_fail_timing_v1_DW_N IDV3_fail_timing_v2_DW_N IDV3_fail_timing_v3_DW_N IDV3_fail_timing_v4_DW_N IDV3_fail_timing_v5_DW_N IDV3_fail_timing_v0_D_N IDV3_fail_timing_v1_D_N IDV3_fail_timing_v2_D_N IDV3_fail_timing_v3_D_N IDV3_fail_timing_v4_D_N IDV3_fail_timing_v5_D_N)
---> (IDV3_fail_timing_v0_DNSW_2_N IDV3_fail_timing_v1_DNSW_2_N IDV3_fail_timing_v2_DNSW_2_N IDV3_fail_timing_v3_DNSW_2_N IDV3_fail_timing_v4_DNSW_2_N IDV3_fail_timing_v5_DNSW_2_N IDV3_fail_timing_v0_DNW_2_N IDV3_fail_timing_v1_DNW_2_N IDV3_fail_timing_v2_DNW_2_N IDV3_fail_timing_v3_DNW_2_N IDV3_fail_timing_v4_DNW_2_N IDV3_fail_timing_v5_DNW_2_N IDV3_fail_timing_v0_DW_2_N IDV3_fail_timing_v1_DW_2_N IDV3_fail_timing_v2_DW_2_N IDV3_fail_timing_v3_DW_2_N IDV3_fail_timing_v4_DW_2_N IDV3_fail_timing_v5_DW_2_N IDV3_fail_timing_v0_D_2_N IDV3_fail_timing_v1_D_2_N IDV3_fail_timing_v2_D_2_N IDV3_fail_timing_v3_D_2_N IDV3_fail_timing_v4_D_2_N IDV3_fail_timing_v5_D_2_N)


*** CONTROL VARIABLE: drug-level 
cnt_Tech_original
cnt_TbA_original
extension_dum 
external_dum (== Acquired variable of Markou et al. 2023)

biologic (follwing Markou et al. 2023)
gen biologic = 1 if strpos(Technologies, "Biological therapeutic")
replace biologic = 0 if strpos(Technologies, "Small molecule")

*** CONTROL VARIABLE: firm-level
ratio_university (university patent / total number of patents)
firm size (emp at sale mrkcap sales)
financial perf. (tobinQ ROA ROE ROI EPS)
R&D intensity (RnDinten RnDinten2)
slack resources (slack_avai slack_absor slack_poten)

----> as of Aug 2024_regression.do 파일로 이동 


--- 교수님께 보고 



** ALCON 은 나중에 후처리 필요. gvkey_dc_refine 147449 AND 35056 are the same company.



**** id_cortellis 기준으로 생성한 데이터셋에 특허 정보 붙여서 변수 구축 해보자 
- Patent number 기준 











+++ (생각 1)
- Originator 와 develop_company 가 다른 경우
---> Originator 가 추후에 develop_company 의 parent 가 되는 경우있음
---> (예) develop_company "Amersham International", Originator "GE HEALTHCARE LIMITED": 1997~2003년까지 develop_year 존재 
---> "Amersham International" became a subsidiary of "GE HEALTHCARE LIMITED" from 2007

+++ (Cortellis 오류: 아직 교정안했음)
develop_company "Synlogic Inc"
Parent company "MIRNA THERAPEUTICS INC"
--> According to Synlogic webpage, two firms merged in 2017 and has operated as name Synlogic, not Mirna.
(https://investor.synlogictx.com/news-releases/news-release-details/synlogic-and-mirna-therapeutics-agree-merger)

develop_company "ICN Hungary"
Parent_company "MYLAN NV"
--> According to Sun Pharma webpage, ICT Hungary was acquired by Sun Pharma India in 2005.
(https://sunpharma.com/milestones-recognitions/)

develop_company "Emmaus Life Sciences Inc"
Parent company "MYND ANALYTICS INC"
--> According to newspaper article, two firms merged in 2019 and has operated as name Emmaus, not MYnd.

develop_company "Yumanity Therapeutics"
Parent company "PROTEOSTASIS THERAPEUTICS INC"
--> According to newspaper article, two firms merged in 2020 and has operated as name Yumanity, not PROTEOSTASIS.
(www.prnewswire.com/news-releases/proteostasis-therapeutics-inc-stockholders-approve-business-combination-with-yumanity-therapeutics-inc-board-sets-reverse-stock-split-ratio-301197618.html) 

develop_company "SciVac Ltd"
Parent company "VBI VACCINES INC"
--> According to newspaper article, SciVac acquired VBI Vaccines in 2015, not the reverse way. (www.fiercepharma.com/vaccines/scivac-therapeutics-agrees-to-acquire-vbi-vaccines)

develop_company "LakePharma Inc"
Parent company "SYMYX TECHNOLOGIES INC"
--> According to newspaper article, LakePharma was acquired by Curia in 2021. And Curia acquired Integrity Bio from SYMYX TECHNOLOGIES. (mergr.com/curia-acquires-integrity-bio)


develop_company "Anchiano Therapeutics"
Parent company "TIKCRO TECHNOLOGIES LTD"
--> BioCanCell (==Anchiano Therapeutics)'s largest owner is TICKRO TECHNOLOGIES. Not explicitly mentioned as a subsidiary 
(www.biospace.com/tikcro-technologies-closes-funding-into-biocancell-therapeutics)




***Drug data 에 연도 정보 붙인 이후, Manually gvkey_dc 부여
**# Bookmark #2
***Patent data 도 동일? 
	- develop_company: Genzyme Surgical Products
		- 1999: gvkey 121742
		
	- develop_company: Genzyme Molecular Oncology
		- 1995~2002: gvkey 117298
		- 2003~    : gvkey 12233

		
	<Allergan: Allergan Inc -> Allergan plc from 2015>
	- develop_company: 
	Allergan Inc (acquired by Actavis plc and renamed as Allergan plc)
	Allergan Pharmaceuticals Ireland
	Allergan-Lok Productos Farmaceuticos Ltda
	Allergan France SA
	Allergan Pharmaceuticals International Ltd
		- 1990~2014: gvkey 15708
		- 2015~    : gvkey 27845
		
	
	- develop_company: Allergan plc 
		- gvkey 27845

	
	- develop_company: Allergan Ligand Retinoid Therapeutics Inc (id_dc_upper: 169)
		- 1995~1996: gvkey 61952
		- 1997~    : gvkey missing (become part of LIGAND PHARMA from 1997/1998)
		
	- develop_company: Allergan Specialty Therapeutics Inc
		- 1998~2000: gvkey 66616
		- 2001~    : gvkey 15708
	
	
	<Alcon: independent -> part of Novartis (2010~2019) -> independent (2019~)
	- upper_develop_company: ALCON
		- ~2010 : gvkey 147449
		- 2011~2018: part of Novartis
		- 2019~ : gvkey 35056
	
	- upper_develop_company: MALLINCKRODT MEDICAL (id_dc_upper: 1583)
		- 1990~2000: gvkey 6096
		- 2011~2022: gvkey 18086
	
	- upper_develop_company: ORGANOGENESIS (id_dc_upper: 1915)
		- 1990~2001: gvkey 13282
		- 2015~2022: gvkey 34562
	
	- upper_develop_company: VIVENTIA BIO (id_dc_upper: 2683)
		- 1995~2004: gvkey 61101
		- 2013~2014: gvkey 26412
		
	- upper_develop_company: WARNER CHILCOTT PLC (id_dc_upper: 2697)
		- 1998~2004: gvkey 205950
		- 2005~2012: gvkey 175163
	
	- Concordia Pharmaceuticals Inc; same company as Advanze pharma

	replace gvkey_dc = . if id_dc_upper == 349
	*>> Atlantic Technology Ventures ~ gvkey incorrectly matched
	
	replace gvkey_dc = 36049 if strpos(upper_develop_company, "PPD")
	*>> PPD Inc

	replace gvkey_dc = . if develop_company == "Elto Pharma Inc"
	replace gvkey_dc = . if develop_company == "Sanofi Pasteur MSD"
	*>> both firms are joint ventures
	
	replace added_year_refine = 2001 if id_dc_upper == 441
	replace added_year_refine = 1990 if id_dc_upper == 675
	replace year_liner = 1990 if id_dc_upper == 675
	replace added_year_refine = 2014 if id_dc_upper == 1257
	replace year_subsidiary = 1994 if develop_company == "McNeil Pharmaceuticals Inc"
	replace year_liner = 1993 if develop_company == "McNeil Pharmaceuticals Inc"
	replace year_subsidiary = 2008 if develop_company == "McNeil Consumer Products Co"
	replace year_liner = 2007 if develop_company == "McNeil Consumer Products Co"
	replace upper_develop_company = "MCNEIL PHARMA" if develop_company == "McNeil Pharmaceuticals Inc"
	replace upper_develop_company = "MCNEIL CONSUMER" if develop_company == "McNeil Consumer Products Co"
	replace id_dc_upper = 2774 if develop_company == "McNeil Consumer Products Co"
	replace gvkey_dc = 12233 if id_dc_upper == 1127 
	replace added_year_refine = 2003 if id_dc_upper == 2599
	
	
	- Neuro Therapeutics is recorded as a subsidiary of Circadian Technologies from 2006

	
	
*이 경우 어떻게 할지 고민 (1) previous histories of develop_company_2
- For example, Pharmacia and Upjohn merged in 1995. And then, in 2002, Pharmacia & Upjohn was acquired by Pfizer.
- For example, Powderject was acquired by Chiron in 2003. And then, in 2006, Chiron was acquired by Novartis.
- For example, Hoechst and Rhone-Poulenc merged and formed Aventis in 1999. Aventis was merged with Sanofi-Synthelabo and become Sanofi-Aventis in 2004.
- For example, Neozyme II corporation was acquired by Genzyme in 1996, and Genzyme was acquired by Sanofi in 2011.


*이 경우 어떻게 할지 고민 (2) joint venture 
- Joint venture as a separate entity 
-(as of Aug 14) Cortellis 에서 붙여놓은 parent company 의 gvkey를 gvkey_dc_refine 에 붙여놓음


//

clear
use  "E:\ARK\as of Jul 2024\[102] Company_list of develop company name_gvkey exist.dta"
keep id_dc_ori develop_company_original develop_company develop_company_2 id_dc id_firm_CORT CompanyName gvkey id_parent_firm_CORT ParentCompanyName






>> 최종 목표:
(a) Final dataset 구축 (redeployment variable, failure variable by firm, patent, year - ver1; by firm, id_cortellis, year - ver2)





	
	
	
	