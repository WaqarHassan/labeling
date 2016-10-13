
$(document).ready(function() {
	var handoff_report_data = $('.data-main').width() - 250 ;
  console.log($('.data-main').width());
  

	$('#handoff_report_data').width(handoff_report_data);
//Following Lines of code applys Jquery DataTable plugin to the reports 
	 if($("#current_status_report").length){
  		$('#current_status_report').DataTable({
    		"order": [[ 5, "asc" ]],
    		"iDisplayLength" : 50,
    		"bFilter" : false,
    		"bLengthChange": false
  	});
}
if($("#entire_history_report").length){
  		$('#entire_history_report').DataTable({
    		"order": [[ 3, "asc" ]],
    		"iDisplayLength" : 50,
    		"bFilter" : false,
    		"bLengthChange": false
  	});
}
if($("#daily_activity_report").length){
  		$('#daily_activity_report').DataTable({
    		"order": [[ 3, "asc" ]],
    		"iDisplayLength" : 50,
    		"bFilter" : false,
    		"bLengthChange": false
  	});
}


});	

