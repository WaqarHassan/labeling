$(document).ready(function() {
	console.log('modal  form');
	$('.datetimepicker').datetimepicker({maxDate : moment.now()});
	$('.datepicker_only').datepicker({format: 'mm/dd/yyyy' , autoclose: true });

	$('.modal-dialog').draggable({
    	handle: ".modal-header"
	});

	$('#project_name').focus();
	$('#ia_list_name').focus();
	$('#ecr_name').focus();

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
	
	$("#errors_container").hide();

	if($("#comp_type").length){
		if ($('#comp_type').val().toLowerCase() == 'cgl'){
			$('#lang input').removeAttr("value");
			$('#lang').hide();
		}
	}
}); 


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

$("#add_l2_modal #ia_modal_form").on('ajax:success', function(e, data, status, xhr){
  successHTML = '<div class="alert alert-dismissable alert-info">';
  successHTML += '<button class="close" data-dismiss="alert" aria-hidden="">×</button>';
  successHTML += 'Validation Error: Name must be unique!';
  successHTML += '</div>';
  if (data.unique_error == 'unique_error'){
    $("#add_l2_modal #ia_modal_form .errors__container").html(successHTML);
    $("#add_l2_modal #ia_modal_form .errors__container").show();
  }
}).on('ajax:error',function(e, xhr, status, error){
  console.log('error on save!');
});

$("#add_l3_modal #add_edit_ecr_form").on('ajax:success', function(e, data, status, xhr){
  successHTML = '<div class="alert alert-dismissable alert-info">';
  successHTML += '<button class="close" data-dismiss="alert" aria-hidden="">×</button>';
  successHTML += 'Validation Error: Name must be unique!';
  successHTML += '</div>';
  if (data.unique_error == 'unique_error'){
    $("#add_l3_modal #add_edit_ecr_form .errors__container").html(successHTML);
    $("#add_l3_modal #add_edit_ecr_form .errors__container").show();
  }
}).on('ajax:error',function(e, xhr, status, error){
  console.log('error on save!');
});

function set_l2_status(status){
	$('#l2_status').val(status);
}

function remove_l2_status(){
	$('#l2_status').remove();
}

function onlySaveNote(){
	$('#save_note_only').val("savenoteonly");
}