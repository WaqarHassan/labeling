$(document).ready(function() {
	console.log('modal  form');
	$('.datetimepicker').datetimepicker();

	$('.modal-dialog').draggable({
    	handle: ".modal-header"
	});

	$("#ia_modal_form").validate();
	$("#add_project_form").validate();
	$("#add_edit_ecr_form").validate();
});	