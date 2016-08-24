$(document).ready(function() {
	console.log('modal  form');
	$('.datetimepicker').datetimepicker({maxDate : moment.now()});
	$('.datepicker_only').datepicker({format: 'mm/dd/yyyy' , autoclose: true });
	//$('.datepicker_only').datetimepicker({format: 'MM/DD/YYYY' , autoclose: true });

	$('.modal-dialog').draggable({
    	handle: ".modal-header"
	});

	$('#project_name').focus();
	$('#ia_list_name').focus();
	$('#ecr_name').focus();

	$("#ia_modal_form").validate();
	$("#add_l1_form").validate();
	$("#add_edit_ecr_form").validate();
	$("#errors__container").hide();

});


function set_l2_status(status){
	$('#l2_status').val(status);
}

function remove_l2_status(){
	$('#l2_status').remove();
}