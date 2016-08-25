
console.log('main js working........');

function updateprojectstatusSubmit(){
	$("form#update_project_status_form").submit();
	$('#modal').modal('toggle');
}

function resetSearchResult(){
	$.ajax({
	  type:"GET",
	  url:"/overview/destroy_seaaion",
	  dataType:"json",
	});

	$('.form-control').removeAttr( "value" )
	dataHtml = '<ul class="ia-list" search_result_div>';
	dataHtml += '<span style="color:green">Search result we be display here: </span>';
	dataHtml += '</ul>';
	$('#search_result_div').html(dataHtml);
}

$(document).ready(function() {

	$('.modal-dialog').draggable({
	    handle: ".modal-header"
	});

});

function set_current_timestamp(){
	$('#datetimepicker_info').val(moment().format('MM/DD/YYYY hh:mm A'));
}

function overview_serach_box()
{
	 var labelsClassName = $('.project_ia').attr('class');	
     var className = $('#projectform').attr('class');

      if (className=='project-data' && labelsClassName == 'project-data project_ia collapsed project_serach_noDetail'){
      	 $('#projectform').addClass('collapsed');
		 $('#detail_data').addClass('search_labels_hidden');
		 $('#detail_data').addClass('search_and_labels_both_hidden');
      }
      else if (className=='project-data'){
		 $('#projectform').addClass('collapsed');
		 $('#detail_data').addClass('search_labels_hidden');
	  }else if (className=='project-data collapsed' && labelsClassName == 'project-data project_ia collapsed project_serach_noDetail'){
	  	$('#projectform').removeClass('collapsed');
		$('#detail_data').removeClass('search_labels_hidden');
		$('#detail_data').removeClass('search_and_labels_both_hidden');
		$('#project_ia').addClass('project_serach_noDetail');
		$('#detail_data').addClass('labels_hidden');

	  }else{
	  	 $('#projectform').removeClass('collapsed'); 
	  	 $('#detail_data').removeClass('search_labels_hidden'); 
	  	 $('#detail_data').removeClass('search_and_labels_both_hidden');
	  }
}

function label_attributes_box()
{
	 var searchclassName = $('#projectform').attr('class');	
     var className = $('.project_ia').attr('class');

      if (searchclassName == "project-data collapsed" && className == "project-data project_ia"){
		 $('#project_ia').addClass('collapsed');
		 $('.collapse_table_data').addClass('collapse_table');
		 $('.collapse_table_data').addClass('collapse_table');
		 $('#project_ia').addClass('project_serach_noDetail');
      	$('#detail_data').addClass('search_and_labels_both_hidden');
      }
      else if (className == "project-data project_ia"){
		 $('#project_ia').addClass('collapsed');
		 $('.collapse_table_data').addClass('collapse_table');
		 $('.collapse_table_data').addClass('collapse_table');
		 $('#project_ia').addClass('project_serach_noDetail');
		 $('#detail_data').addClass('labels_hidden');
	  }else{	
	  	 $('#project_ia').removeClass('collapsed');
		 $('.collapse_table_data').removeClass('collapse_table');
		 $('.collapse_table_data').removeClass('collapse_table');
		 $('#project_ia').removeClass('project_serach_noDetail');
		 $('#detail_data').removeClass('labels_hidden');

		 $('#detail_data').removeClass('search_and_labels_both_hidden');
	  }
	  	 
}

