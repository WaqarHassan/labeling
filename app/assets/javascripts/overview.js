
console.log('main js working........');

function updateprojectstatusSubmit(){
	$("form#update_project_status_form").submit();
	$('#modal').modal('toggle');
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
	console.log('inside overview.js');
	if (Cookies.get('project_ia') && Cookies.get('projectform') ){
			console.log('Cookie present and gonna get them');
			project_ia_classes = Cookies.get('project_ia'); 	 
			projectform_classes = Cookies.get('projectform'); 
			
			$('#project_ia').removeClass();
			$('#projectform').removeClass();
			$('#project_ia').addClass(project_ia_classes);
			$('#projectform').addClass(projectform_classes);
			adjust();
			

		}
		else
		{
			console.log('Cookie not present');
			var detail_data = container_width() - 250 - 300 - 600 ;
			console.log('detail_data width = '+detail_data);
			$('#detail_data').width(detail_data);
		}
	$('.modal-dialog').draggable({
	    handle: ".modal-header"
	});

});

function set_current_timestamp(){
	$('#datetimepicker_info').val(moment().format('MM/DD/YYYY hh:mm A'));
}

