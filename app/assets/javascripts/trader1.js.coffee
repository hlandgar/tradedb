jQuery ->
	$('form').find("a.rentry:first").hide()

	$('#trade_entries_attributes_0_tags').hide()
	tags = $('#trade_entries_attributes_0_tags').html()
	$('#trade_entries_attributes_0_category').change ->
		category = $('#trade_entries_attributes_0_category :selected').text()
		escaped_category = category.replace(/([ #;&,.+*~\':"!^$[\]()=>|\/@])/g, '\\$1')
		options = $(tags).filter("optgroup[label=#{escaped_category}]").html()
		console.log(options)
		if options
			$('#trade_entries_attributes_0_tags').html(options)
			$('#trade_entries_attributes_0_tags').show()
		else
			$('#trade_entries_attributes_0_tags').empty()
			$('#trade_entries_attributes_0_tags').hide()

	$(document).on "nested:fieldAdded", (event) ->
		field = event.field
		cat_id = '#' + field.find('.category').attr('id')
		tags_id = '#' + field.find('.tags').attr('id')
		console.log(cat_id)
		console.log(tags_id)
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

			


			


	