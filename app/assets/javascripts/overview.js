
console.log('main js working........');

function set_partial_merger(){
	$('#rework_info_reason').removeAttr("required");
	$('#rework_start_step').removeAttr("required");
	$('#merge_back_partial_with_parent').val('merge_back_partial_with_parent');
	$('#myPleaseWait').modal('show');
}

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
		return false;
	}else{
		if ($("#rework_modal_popup #rework_modal_from").valid() == true){
			$('#myPleaseWait').modal('show');
		}
		return true;
	}
}
function width3(){
	return 250 + 342 + 523 ;
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
function resetReportSearch(){
	$('.form-control').removeAttr("value")
	$('#search_form').trigger("reset");
}


$(document).ready(function() {

	if (Cookies.get('project_ia') && Cookies.get('projectform') ){
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
				var detail_data = container_width() - 342 ;
				$('#detail_data').width(detail_data);	
			}
			else{
				var detail_data = container_width() - 342 - 533 ;
				$('#detail_data').width(detail_data);

			}
		}
		else
		{

			if($('#project_ia').hasClass('collapsed'))
			{
				var detail_data = container_width() -250 - 342 ;
				$('#detail_data').width(detail_data);	
			}
			else{
				var detail_data = container_width() - 342 - 533 - 250 ;
				$('#detail_data').width(detail_data);

			}
		}
	}
		var report_data = container_width() - 250 -20 ;
		$('#report_data').width(report_data);
});

$(document).ready(function() {
		
	$('.datepicker_only').datepicker({format: 'mm/dd/yyyy' , autoclose: true });
	$('.modal-dialog').draggable({
	    handle: ".modal-header"
	});

});

function handoff_show_hide()
{
     var className = $('#handoff_projectform').attr('class');

      if (className=='handoff-project-data'){
      	$('#handoff_projectform').addClass('collapsed');
		$('#handoff_report_data').width('100%');
	  }else{
	  	$('#handoff_projectform').removeClass('collapsed'); 
		var handoff_report_data = $('#handoff_report_data').width() - 250 ;
		$('#handoff_report_data').width(handoff_report_data);
	  }
}

function update_all_etas(){
	$('#myPleaseWait').modal('show');
	return true;
}

function toggle_lang(comp_type_value, workflow_name){
	if (comp_type_value=='CGL' && workflow_name=='ldp' ){
		$('#lang').hide();
		$('#lang input').removeAttr("value");
	}else{
		$('#lang').show();
	}	
}

function show_waiting_bar_search_side(){
	//$('#myPleaseWait').modal('show');
}

function show_waiting_bar_addInfo(){
	$('#myPleaseWait').modal('show');
}

function selectOnlyThis(thisBox){
  set_to_uncheck = ''
  if ($('#'+thisBox.id+':checkbox:checked').length == 0){
  	  set_to_uncheck = 'set_to_uncheck'
  }

  var myCheckbox = $(".searchCheckbox");
  Array.prototype.forEach.call(myCheckbox,function(el){
  	el.checked = false;
  });

  if (set_to_uncheck == ''){
  	thisBox.checked = true;
  }
}

function check_password_length(){
	if ($('#user_password').val().length > 0 && $('#user_password').val().length < 8){
		$( "<div class='password_error_length'>Minimum 8 character password required!</div>" ).insertBefore( "#user_password" );
		return false;
	}else{
		return true;
	}
}

if($("#admin_user_list").length){
		$('#admin_user_list').DataTable({
		"order": [[ 0, "asc" ]],
		"iDisplayLength" : 50
	});
}

$(document).ready(function() {
	if($("#user_password").length){
		$('#user_password').val('');
	}

	if($("#new_user").length){	
	  $('#new_user').validate();
	}

});


function confirm_action(e){
	var confrm = confirm('Are you sure?');
    if (confrm == true) {
    	return true;
    } else {
    	e.preventDefault();
    	return false;
    }
}

function toggleAdmin(chkbox, usr_id){
	if($(chkbox).is(':checked')){
		window.top.location = '/admin/users/'+usr_id+'/set-admin'
	}else{
		window.top.location = '/admin/users/'+usr_id+'/unset-admin'
	}
	console.log(chkbox);
}

