$(function () {
  $('.2nd_target').change(function () {                
     $('#target_2').toggle(this.checked);
  }).change(); //ensure visible state matches initially
});


$(document).ready(function() {
	$('select#my_select').on('change',function() {
		var v = $(this).find('option:selected').val();
		$('input[name=get_spread]').val("get_spread");
		this.form.submit();
		
	});
});