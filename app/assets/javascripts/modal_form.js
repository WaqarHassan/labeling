$(document).ready(function() {
	console.log('modal  form');
	$('.datetimepicker').datetimepicker();

	$('.modal-dialog').draggable({
    	handle: ".modal-header"
	});

	$('#project_name').focus();
	$('#ia_list_name').focus();
	$('#ecr_name').focus();

	$("#ia_modal_form").validate();
	$("#add_project_form").validate();
	$("#add_edit_ecr_form").validate();
});


$('#myModal').on('shown.bs.modal', function () {
    setTimeout(function(){
        $('#inputId').focus();
    }, 100);
});

function set_l2_status(status){
	$('#l2_status').val(status);
}	