$(function () {
  $('.2nd_target').change(function () {                
     $('#target_2').toggle(this.checked);
  }).change(); //ensure visible state matches initially
});

$('#tradeModal').modal({
				backdrop: false
})