$(document).ready(function() {
	console.log('modal  form');
	$('.datetimepicker').datetimepicker({maxDate : moment.now()});
  $('.datetimepicker_all').datetimepicker({autoclose: true});
	$('.datepicker_only').datepicker({format: 'mm/dd/yyyy' , autoclose: true });

	$('.modal-dialog').draggable({
    	handle: ".modal-header"
	});
  var v = $('#comp_type').val();
  if (  v != 'Multi-Lingual IFUs' ) 
  {
    $('#lang').hide(); 
 }
 
 if ($('#reason_codes_selected_values').val() != null)
 {
   var parents = $('#reason_codes_selected_values').val();
   get_sub_reasons('', parents.split(','));
   console.log(parents.split(','));
    $('#reason_codes_selected_values').val(null);
 }


  //Following three lines focus on the fields with given id (for Lx Pop'ups)    
	$('#project_name').focus();
	$('#ia_list_name').focus();
	$('#ecr_name').focus();
//Following Lines are used to validates forms with given Id's
	$('#add_l2_modal #ia_modal_form').validate();
	$('#l2_update_popup #ia_modal_form').validate();
	$("#add_l1_modal #add_l1_form").validate();
	$("#add_l3_modal #add_edit_ecr_form").validate();
	$("#l3_update_popup #add_edit_ecr_form").validate();
	$("#info_modal_popup #info_modal_form").validate();
	$("#confirm_modal_popup #task_confirmation").validate();
	$("#add_l2_modal #task_confirmation").validate();
	$("#reject_reason_modal #save_reject_reason").validate();
	$("#rework_modal_popup #rework_modal_from").validate();
  $('#oops_mode_reason_code_info #add_oops_mode_reason_code_form').validate();
	//Following line hides errors container when user click on "x" on the container
	$("#errors_container").hide();
//Following lines hides #Language component whenever Component type is 'cgl' on L3s pop up
	if($("#comp_type").length){
		if ($('#comp_type').val().toLowerCase() == 'cgl'){
			$('#lang input').removeAttr("value");
			$('#lang').hide();
		}
	}
}); 

// FOllowing Lines of code displays error message in error container if given L1 name is not unique
$("#add_l1_modal #add_l1_form").on('ajax:success', function(e, data, status, xhr){
  successHTML = '<div class="alert alert-dismissable alert-info">';
  successHTML += '<button class="close" data-dismiss="alert" aria-hidden="">×</button>';
  successHTML += 'Validation Error: Name must be unique!';
  successHTML += '</div>';
  if (data.unique_error == 'unique_error'){
    $("#add_l1_modal #add_l1_form .errors__container").html(successHTML);
    $("#add_l1_modal #add_l1_form .errors__container").show();
  }
}).on('ajax:error',function(e, xhr, status, error){
  console.log('error on save!');
});

// FOllowing Lines of code displays error message in error container if given L2 name is not unique

$("#add_l2_modal #ia_modal_form").on('ajax:success', function(e, data, status, xhr){
  successHTML = '<div class="alert alert-dismissable alert-info">';
  successHTML += '<button class="close" data-dismiss="alert" aria-hidden="">×</button>';
  successHTML += 'Validation Error: Name must be unique!';
  successHTML += '</div>';
  if (data.unique_error == 'unique_error'){
  	$('#myPleaseWait').modal('hide');
    $("#add_l2_modal #ia_modal_form .errors__container").html(successHTML);
    $("#add_l2_modal #ia_modal_form .errors__container").show();
  }
}).on('ajax:error',function(e, xhr, status, error){
  console.log('error on save!');
});
// FOllowing Lines of code displays error message in error container if given L2 name is not unique
$("#l2_update_popup #ia_modal_form").on('ajax:success', function(e, data, status, xhr){
  successHTML = '<div class="alert alert-dismissable alert-info">';
  successHTML += '<button class="close" data-dismiss="alert" aria-hidden="">×</button>';
  successHTML += 'Validation Error: Name must be unique!';
  successHTML += '</div>';
  if (data.unique_error == 'unique_error'){
  	$('#myPleaseWait').modal('hide');
    $("#l2_update_popup #ia_modal_form .errors__container").html(successHTML);
    $("#l2_update_popup #ia_modal_form .errors__container").show();
  }
}).on('ajax:error',function(e, xhr, status, error){
  console.log('error on save!');
});
// FOllowing Lines of code displays error message in error container if given L3 name is not unique

$("#add_l3_modal #add_edit_ecr_form").on('ajax:success', function(e, data, status, xhr){
  successHTML = '<div class="alert alert-dismissable alert-info">';
  successHTML += '<button class="close" data-dismiss="alert" aria-hidden="">×</button>';
  successHTML += 'Validation Error: Name must be unique!';
  successHTML += '</div>';
  if (data.unique_error == 'unique_error'){
  	$('#myPleaseWait').modal('hide');
    $("#add_l3_modal #add_edit_ecr_form .errors__container").html(successHTML);
    $("#add_l3_modal #add_edit_ecr_form .errors__container").show();
  }
}).on('ajax:error',function(e, xhr, status, error){
  console.log('error on save!');
});
// FOllowing Lines of code displays error message in error container if given L3 name is not unique

$("#l3_update_popup #add_edit_ecr_form").on('ajax:success', function(e, data, status, xhr){
  successHTML = '<div class="alert alert-dismissable alert-info">';
  successHTML += '<button class="close" data-dismiss="alert" aria-hidden="">×</button>';
  successHTML += 'Validation Error: Name must be unique!';
  successHTML += '</div>';
  if (data.unique_error == 'unique_error'){
  	$('#myPleaseWait').modal('hide');
    $("#l3_update_popup #add_edit_ecr_form .errors__container").html(successHTML);
    $("#l3_update_popup #add_edit_ecr_form .errors__container").show();
  }
}).on('ajax:error',function(e, xhr, status, error){
  console.log('error on save!');
});


$("#change_rework_station #change_rework_station_form").on('ajax:success', function(e, data, status, xhr){
  console.log("AJAZ:SUCCESS!!!!!");
  successHTML = '<div class="alert alert-dismissable alert-info">';
  successHTML += '<button class="close" data-dismiss="alert" aria-hidden="">×</button>';
  successHTML += 'No Record Found for ';
  successHTML += data.ecr
  successHTML += '</div>';
  if (data.not_found_error == 'not_found'){
    console.log("APPENDINGGG......");
    $("#change_rework_station #change_rework_station_form .errors_container").html(successHTML);
    $("#change_rework_station #change_rework_station_form .errors_container").show();
  }
}).on('ajax:error',function(e, xhr, status, error){
  console.log('error on save change reowrk station!');
});
$("#oops_mode_reason_code_ecr_search #oops_mode_reason_code_form").on('ajax:success', function(e, data, status, xhr){
  successHTML = '<div class="alert alert-dismissable alert-info">';
  successHTML += '<button class="close" data-dismiss="alert" aria-hidden="">×</button>';
  successHTML += 'No Record Found for ';
  successHTML += data.ecr
  successHTML += '</div>';
  if (data.not_found_error == 'not_found'){
    //$('#myPleaseWait').modal('hide');
    $("#oops_mode_reason_code_ecr_search #oops_mode_reason_code_form .errors_container").html(successHTML);
    $("#oops_mode_reason_code_ecr_search #oops_mode_reason_code_form .errors_container").show();
  }
}).on('ajax:error',function(e, xhr, status, error){
  console.log('error on save change reowrk station!');
});

// This function sets l2 status to the hidden field whenever Accept or Reject is clicked
function set_l2_status(status){
	$('#l2_status').val(status);
	if ($('#add_l2_modal #ia_modal_form').valid() == true){
		$('#myPleaseWait').modal('show');
	}
}
function remove_confirmation_progress_bar() {
    $('#myPleaseWait').modal('show');
}

// This function removes l2 status to the hidden field whenever Accept or Reject is clicked
function remove_l2_status(){
	$('#l2_status').remove();
	if ($('#l2_update_popup #ia_modal_form').valid() == true){
		$('#myPleaseWait').modal('show');
	}
}
//This Function validates and shows progress bar pop-up upon Add L3 form submit
function show_waiting_bar_l3(){
	if ($("#add_l3_modal #add_edit_ecr_form").valid() == true){
		$('#myPleaseWait').modal('show');
	}
}
//This Function validates and shows progress bar pop-up upon Upon L3 form submit
function show_waiting_bar_l3_update(){
	if ($("#l3_update_popup #add_edit_ecr_form").valid() == true){
		$('#myPleaseWait').modal('show');
	}
}
//This Function validates and showa progress bar upon pop-up on Task Confirmation form submit
function show_waiting_bar_confirmation(){
  if ($("#task_confirmation").valid() == true){
    $('#myPleaseWait').modal('show');
  }
}
 // This function pops up progress whenever called
function show_waiting_bar(){
  $('#save_note_only').val("");
  $('#myPleaseWait').modal('show');
  return true;
}
//This Function set value of hidden field with id = save_note_only 
//on additional info pop-up when save note only button is clicked
function onlySaveNote(e){
  $('#save_note_only').val("savenoteonly");
  $('#additional_info_status').removeAttr('required');
  additional_info_status = $('#additional_info_status').val();
  if (additional_info_status != ""){
    var confrm = confirm('Status settings will be lost');
      if (confrm == true) {
        return true;
      } else {
        e.preventDefault();
        return false;
      }
  }else{
    return true;
  }
}




