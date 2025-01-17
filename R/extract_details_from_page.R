

extract_details_from_page = function( property_page, row_number)  {

	attributes = list(
		address=    '/html/body/div/div[3]/div[3]/div[1]/div/div/div[1]/div/div[1]/div[1]/h1'
		, bedrooms =  '/html/body/div/div[3]/div[3]/div[1]/div/div/div[1]/div/div[1]/div[2]/div/div[1]/div[1]/p'
		, bathrooms = '/html/body/div/div[3]/div[3]/div[1]/div/div/div[1]/div/div[1]/div[2]/div/div[1]/div[2]'
		, parking =   '/html/body/div/div[3]/div[3]/div[1]/div/div/div[1]/div/div[1]/div[2]/div/div[1]/div[3]'
		, size =      '/html/body/div/div[3]/div[3]/div[1]/div/div/div[1]/div/div[1]/div[2]/div/div[2]'
		, category=   '/html/body/div/div[3]/div[3]/div[1]/div/div/div[1]/div/div[1]/div[2]/span'
		, price=      '/html/body/div/div[3]/div[3]/div[1]/div/div/div[1]/div/div[2]/span[1]'
		, sold_date=  '/html/body/div/div[3]/div[3]/div[1]/div/div/div[1]/div/div[2]/span[2]'
		, description='/html/body/div/div[3]/div[3]/div[2]/div[1]/div/div/article/div'
	)

	print( row_number)

	# # use xpath to extract the last script section from the html file
	# # extract the json from the html file
	# property_page %>%
	# 	stringr::str_match('<script>(window.ArgonautExchange=(.*));</script>') %>%
	# 	nth(3) %>%
	# 	jsonlite::fromJSON() %>%
	# 	nth(1) %>%
	# 	nth(1) %>%
	# 	jsonlite::fromJSON() %>%
	# 	nth(1) %>%
	# 	nth(1) %>%
	# 	jsonlite::fromJSON() %>%
	# 	rrapply::rrapply(
	# 		condition = \(x) !is.na(x),
	# 		how = "flatten"
	# 	) %>%
	# 	enframe() %>%
	# 	mutate( name = str_c('from_json_', name )) %>%
	# pivot_wider( values_fn=list) %>%
	# { . } -> extracted_from_json

	if (property_page =='') return(tibble())
	pph = property_page %>% rvest::read_html()


	attributes %>%
		enframe( value='xpath_selector') %>%
		mutate( xpath_selector = unlist( xpath_selector)) %>%
		mutate( value = map2_chr( xpath_selector, name, function( x, y ) {
			# print(y)
			pph %>%
				rvest::html_nodes( xpath=x) %>%
				rvest::html_text() %>%
			{ . } -> rv
			if( length(rv)==0)
			rv=NA
			rv
		})) %>%
		select( name, value ) %>%
		mutate( name = str_c('specified_', name )) %>%
		pivot_wider( ) %>%
	{ . } -> specific_attributes

	# bind_cols( specific_attributes, extracted_from_json)
	specific_attributes

}





