
console.log('main js working........');
//This function removes required field status of rework form whenever merge Back happens to facilitates form submission
function set_partial_merger(){
	$('#rework_info_reason').removeAttr("required");
	$('#rework_start_step').removeAttr("required");
	$('#rework_info_station').removeAttr("required");
	$('#merge_back_partial_with_parent').val('merge_back_partial_with_parent');
	$('#myPleaseWait').modal('show');
}
// This function checks whether L3-Rx can be merged back to its parent by comparing current no of components 
//with parent's

	

function remove_reason_code_children(){
	sub_reason_valid = 'valid';
	$('.sub_error').empty();
	$('#sub_reason_list_div .child_mandatory').each(function(){
		div_id = $(this).attr('id');
		selected = $(this).val();
		if ($('#sub_reasons_div_'+div_id).css('display') == 'block') {
			if (selected){
				if (selected[0] != ''){
			 		 sub_reason_valid = 'valid';
				}else{
					$( "<div style='color: red;' class='sub_error'>This field is required.</div>" ).insertAfter(this);
					sub_reason_valid = '';
					return false;
				}
			}else{
			  	$( "<div style='color: red;' class='sub_error'>This field is required.</div>" ).insertAfter(this);
			  	sub_reason_valid = '';
			  	return false;
			}
		}	
	});
	if (sub_reason_valid == 'valid'){
		return true;
	}
	else
	{
		console.log('submit false');
		return false;
	}
}
function can_be_full_rework(){
	sub_reason_valid = 'valid';
	$('.sub_error').empty();
	$('#sub_reason_list_div .child_mandatory').each(function(){
		div_id = $(this).attr('id');
		selected = $(this).val();
		if ($('#sub_reasons_div_'+div_id).css('display') == 'block') {
			if (selected){
				if (selected[0] != ''){
			 		 sub_reason_valid = 'valid'
				}else{
					$( "<div style='color: red;' class='sub_error'>This field is required.</div>" ).insertAfter(this);
					sub_reason_valid = '';
					return false;
				}
			}else{
			  	$( "<div style='color: red;' class='sub_error'>This field is required.</div>" ).insertAfter(this);
			  	sub_reason_valid = '';
			  	return false;
			}
		}	
	});

	if (sub_reason_valid == 'valid'){
		selected_num_comp = $('#selected_num_comp').val();
		total_num_component = $('#total_num_component').val();
		component_already_in_rework = $('#component_already_in_rework').val();
		if (selected_num_comp <= 0 || selected_num_comp > (total_num_component - component_already_in_rework))
		{
			dataHTMLREWORK = '<div class="alert-info alert alert-dismissable">';
			dataHTMLREWORK += '<button aria-hidden class="close" data-dismiss="alert">&times;</button>';
			dataHTMLREWORK += 'Rework is not allowed because components are out of range';
			dataHTMLREWORK += '</div>';
			$('#full_rework_not_possible').html(dataHTMLREWORK);
			return false;
		}
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
	}else{
		console.log('false');
		return false;
	}
} 

function rework_validation(){

}
//This function speaks for itself :) 
function width3(){
	return 250 + 342 + 523 ;
}
// This Function submits form with given id and close down pop-up
function updateprojectstatusSubmit(){
	$("form#update_project_status_form").submit();
	$('#modal').modal('toggle');
}
// This function set current time to the date field
function set_current_timestamp(){
	$('#datetimepicker_now').val(moment().format('MM/DD/YYYY hh:mm A'));
}
// This function set current time to the date field of rework pop-up
function set_current_timestamp_rework(){
	$('#datetimepicker_now_rework').val(moment().format('MM/DD/YYYY hh:mm A'));
}
// this function embeds drop down to the rework pop-up when 'move original back to' field has a value
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
// This Function clears search results from search panel
function resetSearchResult(){
	$('.form-control').removeAttr("value")
	$('#search_form').trigger("reset");
	dataHtml = '<ul class="ia-list" search_result_div>';
	dataHtml += '<span style="color:green">Search result we be display here: </span>';
	dataHtml += '</ul>';
	dataHtml += '<div class="row">';
	dataHtml +=	'<div class="col-lg-7">';
	dataHtml += '</div>';
	dataHtml += '</div>';
	$('#search_result_div').html(dataHtml);
	$('#search_ecr').focus();
}
//This Fiunction clears values in the form fields of search panel of Reports
function resetReportSearch(){
	$('.form-control').removeAttr("value")
	$('#search_form').trigger("reset");
}


$(document).ready(function() {

	$('.project-data2 td').each (function() {

		var avg_width = 5.7; //5.3
		var td_width = $(this).width();
		//console.log("td_width = " + td_width);
		var td_width2 = td_width*2;
		//console.log("td_width2 = " + td_width2);

		var text = $(this).text();
		text = text.trim();
		var text_length = text.length;
		var text_length5 = text_length * avg_width;
		
		if (text_length5 > td_width2)
		{
			td_width2 = td_width2 / avg_width ;
			text = text.slice(0,(td_width2 - 2));
			text = text.concat('...');
			$(this).children('a').text(text);
		}
	});

	  

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
//This Function adjusts conatainer width whenever search panel is collapsed or expanded In hand-off report container
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

//This Function displays progress bar pop-up 
function update_all_etas(e){
	var confrm = confirm("You selected a time-consuming task that \n will consume significant server resources. \n Do you want to continue?");
    if (confrm == true) {
		$('#myPleaseWait').modal('show');
		return true;
    } else {
    	e.preventDefault();
    	return false;
    }

}
// This function hides Lang component whenever worflwo is 'ldp' and com_type_value is = 'CGL' ans shows otherwise
function toggle_lang(comp_type_value, workflow_name){
	if (comp_type_value!='Multi-Lingual IFUs' && workflow_name=='ldp' ){
		$('#lang').hide();
		$('#lang input').removeAttr("value");
	}else{
		$('#lang').show();
	}	
}
//This Function displays progress bar pop-up
function show_waiting_bar(){
	$('#myPleaseWait').modal('show');
}

function show_waiting_bar_search_all(){
	detail_data_width = $('#detail_data').width();
	Cookies.set('show_all_detail_data_width', detail_data_width, { expires: 7 });
	$('#myPleaseWait_search_all').modal('show');
}

//This Function displays progress bar pop-up
function show_waiting_bar_addInfo(){

	sub_reason_valid = 'valid';
	if($("#sub_reason_list_div").length){
		$('.sub_error').empty();
		$('#sub_reason_list_div .child_mandatory').each(function(){
			div_id = $(this).attr('id');
			selected = $(this).val();
			if ($('#sub_reasons_div_'+div_id).css('display') == 'block') {
				if (selected){
					if (selected[0] != ''){
				 		 sub_reason_valid = 'valid'
					}else{
						$( "<div style='color: red;' class='sub_error'>This field is required.</div>" ).insertAfter(this);
						sub_reason_valid = '';
						return false;
					}
				}else{
				  	$( "<div style='color: red;' class='sub_error'>This field is required.</div>" ).insertAfter(this);
				  	sub_reason_valid = '';
				  	return false;
				}
			}	
		});
	}	
	if (sub_reason_valid == 'valid'){
		if ($("#info_modal_form").valid() == true){
			$('#myPleaseWait').modal('show');
			return true;
		}
	}else{
		return false;
	}

}
// Dummy Fucntion . Not works now
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
// This function checks password length on login
function check_password_length(){
	if ($('#user_password').val().length > 0 && $('#user_password').val().length < 8){
		$( "<div class='password_error_length'>Minimum 8 character password required!</div>" ).insertBefore( "#user_password" );
		return false;
	}else{
		return true;
	}
}
// Following lines activates Jquery DataTable plugin for Admin users List
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

//This Function prompts Confirm action on user delete
function confirm_action(e){
	var confrm = confirm('Are you sure?');
    if (confrm == true) {
    	return true;
    } else {
    	e.preventDefault();
    	return false;
    }
}
//This functions toggles admin status when ever admin scheckbox is checked in users list
function toggleAdmin(chkbox, usr_id){
	if($(chkbox).is(':checked')){
		window.top.location = '/admin/users/'+usr_id+'/set-admin'
	}else{
		window.top.location = '/admin/users/'+usr_id+'/unset-admin'
	}
	console.log(chkbox);
}
// This Function turns OOPs mode on 
function turn_off_oops_mode(){
	$('.actual_confirmation a').each(function() {
        href_id = $(this).attr('id');
        href_value = $(this).attr('href');
    });
}

function download_handoff_report_csv(){
	$("#ho_wildcard_bu").val($("#ho_wildcard_bu_web").val());
	$("#ho_exact_bu").val($("#ho_exact_bu_web").val());
	$("#ho_wildcard_l1").val($("#ho_wildcard_l1_web").val());
	$("#ho_wildcard_l2").val($("#ho_wildcard_l2_web").val());
	$("#ho_exact_l2").val($("#ho_exact_l2_web").val());
	$("#ho_wildcard_l3").val($("#ho_wildcard_l3_web").val());
	$("#ho_exact_l3").val($("#ho_exact_l3_web").val());

	if ($("#report_include_completed").is(':checked')) {
		$("#ho_report_include_completed").val("report_include_completed");
	}else{
		$("#ho_report_include_completed").val('');
	}

	if ($("#report_include_canceled").is(':checked')) {
		$("#ho_report_include_canceled").val("report_include_canceled");
	}else{
		$("#ho_report_include_canceled").val('');
	}

	if ($("#report_include_onhold").is(':checked')) {
		$("#ho_report_include_onhold").val("report_include_onhold");
	}else{
		$("#ho_report_include_onhold").val('');
	}

	return true;
}
function show_waiting_bar_daily_activity()
{
		if ($('#search_form').valid() == true){
		$('#myPleaseWait').modal('show');
	}

}
function show_waiting_bar_wip(){
	if ($('#wip_form').valid() == true){
		$('#myPleaseWait').modal('show');
	}
}
function show_all_data_form_db(){
	if ($("#include_completed").is(':checked')) {
		$("#show_all_include_completed").val("show_all_include_completed");
	}else{
		$("#show_all_include_completed").val('');
	}

	if ($("#include_canceled").is(':checked')) {
		$("#show_all_include_canceled").val("show_all_include_canceled");
	}else{
		$("#show_all_include_canceled").val('');
	}
	
	$('#myPleaseWait').modal('show');
	return true;
}

function validate_reject_reasons(){

	sub_reason_valid = 'valid';
	$('.sub_error').empty();
	$('#sub_reason_list_div .child_mandatory').each(function(){
		div_id = $(this).attr('id');
		selected = $(this).val();
		if ($('#sub_reasons_div_'+div_id).css('display') == 'block') {
			if (selected){
				if (selected[0] != ''){
			 		 sub_reason_valid = 'valid'
				}else{
					$( "<div style='color: red;' class='sub_error'>This field is required.</div>" ).insertAfter(this);
					sub_reason_valid = '';
					return false;
				}
			}else{
			  	$( "<div style='color: red;' class='sub_error'>This field is required.</div>" ).insertAfter(this);
			  	sub_reason_valid = '';
			  	return false;
			}
		}	
	});
	if (sub_reason_valid == 'valid'){
		return true;
	}else{
		return false;
	}	

}

function get_sub_reasons(reason, all_parents){
  var all_main_reasonsids = $('#main_reasons_ids').val();
  var reasons = reason;
  if (reasons == '')
  {
  	 reasons = all_parents;
  }else
  {
  	reasons = $(reason).val();
  }

  all_main_reasons_ids = all_main_reasonsids.split(',');

  jQuery.each( all_main_reasons_ids, function( i, mval ) {
    is_selected = jQuery.inArray( $.trim(mval), reasons );

    if (is_selected == -1){
      $('#sub_reasons_div_'+mval).hide();
      $('#sub_reasons_div_'+mval+'_id select option').removeAttr("selected");
    }
  });

  jQuery.each( reasons, function( i, val ) {
    console.log(val);
    $('#sub_reasons_div_'+val).show();
  });

}

