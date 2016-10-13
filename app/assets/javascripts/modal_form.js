$(document).ready(function() {
	console.log('modal  form');
	$('.datetimepicker').datetimepicker({maxDate : moment.now()});
	$('.datepicker_only').datepicker({format: 'mm/dd/yyyy' , autoclose: true });

	$('.modal-dialog').draggable({
    	handle: ".modal-header"
	});

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
// This function sets l2 status to the hidden field whenever Accept or Reject is clicked
function set_l2_status(status){
	$('#l2_status').val(status);
	if ($('#add_l2_modal #ia_modal_form').valid() == true){
		$('#myPleaseWait').modal('show');
	}
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
  if ($("#confirm_modal_popup #task_confirmation").valid() == true){
    $('#myPleaseWait').modal('show');
  }
}
 // This function pops up progress whenever called
function show_waiting_bar(){
	$('#myPleaseWait').modal('show');
}
//This Function set value of hidden field with id = save_note_only 
//on additional info pop-up when save note only button is clicked
function onlySaveNote(){
	$('#save_note_only').val("savenoteonly");
}