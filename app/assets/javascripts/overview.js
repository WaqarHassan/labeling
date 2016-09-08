
console.log('main js working........');

function can_be_full_rework(){
	selected_num_comp = $('#selected_num_comp').val();
	total_num_component = $('#total_num_component').val();
	component_already_in_rework = $('#component_already_in_rework').val();

	if (component_already_in_rework > 0 && selected_num_comp == total_num_component){
		dataHTMLREWORK = '<div class="alert-info alert alert-dismissable">';
		dataHTMLREWORK += '<button aria-hidden class="close" data-dismiss="alert">&times;</button>';
		dataHTMLREWORK += 'Full Rework is not allowed because it has already open reworks';
		dataHTMLREWORK += '</div>';
		$('#full_rework_not_possible').html(dataHTMLREWORK);
		console.log('not');
		return false;
	}else{
		console.log('yes');
		return true;
	}
}

function updateprojectstatusSubmit(){
	$("form#update_project_status_form").submit();
	$('#modal').modal('toggle');
}

function set_current_timestamp(){
	$('#datetimepicker_now').val(moment().format('MM/DD/YYYY hh:mm A'));
}

function set_current_timestamp_rework(){
	$('#datetimepicker_now_rework').val(moment().format('MM/DD/YYYY hh:mm A'));
}

function about_existing_confirmartion(val){
	dataHTML = '';
	if (val != ""){
		dataHTML += '<label class="col-lg-4 control-label">What to do with existing confirmations on Original Record?</label>';
	    dataHTML += '<div class="col-lg-6" id= "get_steps_div">';
	    dataHTML += '<select class = "form-control" id="" name="reset_type" required >';
	    dataHTML += '<option value="reset_all">Reset ALL steps after Move Back step</option>';
	    dataHTML += '<option value="keep_all">Keep ALL confirmations</option>';
	    dataHTML += '</select>';
	    dataHTML += '</div>';
	}
    $('#move_riginal_record_back_div').html(dataHTML);
}

function resetSearchResult(){
	$('.form-control').removeAttr("value")
	$('#search_form').trigger("reset");
	dataHtml = '<ul class="ia-list" search_result_div>';
	dataHtml += '<span style="color:green">Search result we be display here: </span>';
	dataHtml += '</ul>';
	dataHtml += '<div class="row">';
	dataHtml +=	'<div class="col-lg-7">';
	dataHtml += '</div>';
	dataHtml += '<div class="col-lg-5">';
 	dataHtml += '<a href="/overview/show_all_db" data-remote="true">Show all from DB</a>';
	dataHtml += '</div>';
	dataHtml += '</div>';
	$('#search_result_div').html(dataHtml);
}

$(document).ready(function() {

	console.log('inside overview js')
	if (Cookies.get('project_ia') && Cookies.get('projectform') ){
		console.log('Cookie present and gonna get them');
		project_ia_classes = Cookies.get('project_ia'); 	 
		projectform_classes = Cookies.get('projectform'); 
		
		$('#project_ia').removeClass();
		$('#projectform').removeClass();
		$('#project_ia').addClass(project_ia_classes);
		$('#projectform').addClass(projectform_classes);
		if($('#projectform').hasClass('collapsed'))
		{
			if($('#project_ia').hasClass('collapsed'))
			{
				var detail_data = container_width() - 300 ;
				$('#detail_data').width(detail_data);	
			}
			else{
				var detail_data = container_width() - 300 - 600 ;
				$('#detail_data').width(detail_data);

			}


		}
		else
		{

			if($('#project_ia').hasClass('collapsed'))
			{
				var detail_data = container_width() -250 - 300 ;
				$('#detail_data').width(detail_data);	
			}
			else{
				var detail_data = container_width() - 300 - 600 - 250 ;
				$('#detail_data').width(detail_data);

			}

		}
	}
});

$(document).ready(function() {

	$('.modal-dialog').draggable({
	    handle: ".modal-header"
	});

});


