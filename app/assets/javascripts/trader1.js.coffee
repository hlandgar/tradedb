jQuery ->
	$('form').find("a.rentry:first").hide()


selectform = (tags_id) ->
	cat_id = tags_id.replace /tags/, "category"
	$(tags_id).hide()
	tags = $(tags_id).html()
	$(cat_id).change ->
		category = $("#{cat_id} :selected").text()
		escaped_category = category.replace(/([ #;&,.+*~\':"!^$[\]()=>|\/@])/g, '\\$1')
		options = $(tags).filter("optgroup[label=#{escaped_category}]").html()
		console.log(options)
		if options
			$(tags_id).html(options)
			$(tags_id).show()
		else
			$(tags_id).empty
			$(tags_id).hide()






$ ->
	
		
	test = $('.tags').map ->
		return "#" + this.id
	console.log test

	selectform(tags_id) for tags_id in test
	

	
	$(document).on "nested:fieldAdded", (event) ->
		field = event.field		
		tags_id = '#' + field.find('.tags').attr('id')
		console.log(tags_id)
		selectform(tags_id)


			


			


	