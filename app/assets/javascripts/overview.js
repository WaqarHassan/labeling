
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
	//console.log('Inside Overview.js');
	// if (Cookies.get('project_ia') && Cookies.get('projectform') ){
	// 	project_ia_classes = Cookies.get('project_ia'); 	 
	// 	projectform_classes = Cookies.get('projectform'); 
		
	// 	$('#project_ia').removeClass();
	// 	$('#projectform').removeClass();
	// 	$('#project_ia').addClass(project_ia_classes);
	// 	$('#projectform').addClass(projectform_classes);
	// 	console.log('Cookie present');
	// 	label_attributes_box();
	// 	overview_serach_box();
	// }
	// else{
	// 	console.log('Cookie Not present');
	// 	//overview_serach_box();
	// 	//label_attributes_box();
	// 	var detail_data = container_width() - 250 - 300 - 600 ;
	// 	$('#detail_data').width(detail_data);

	// }
	$('.modal-dialog').draggable({
	    handle: ".modal-header"
	});

});
// function container_width(){
// 	return  $('#labeling_container').width() - 22 ;
// }
// function overview_serach_box()
// {
// 	console.log('Inside Overview Search Box');
// 	 var labelsClassName = $('.project_ia').attr('class');	
//      var className = $('#projectform').attr('class');

//       if (className=='project-data' && labelsClassName == 'project-data project_ia collapsed project_serach_noDetail'){
//       	 $('#projectform').addClass('collapsed');
// 		var detail_data = container_width() - 300 ;
// 		$('#detail_data').width(detail_data);

//       }
//       else if (className=='project-data'){
// 		 $('#projectform').addClass('collapsed');
// 		var detail_data = container_width() - 300 - 600;
// 		$('#detail_data').width(detail_data);

// 	  }else if (className=='project-data collapsed' && labelsClassName == 'project-data project_ia collapsed project_serach_noDetail'){
// 	  	$('#projectform').removeClass('collapsed');
// 		$('#project_ia').addClass('project_serach_noDetail');
// 		var detail_data = container_width() - 300 -250  ;
// 		$('#detail_data').width(detail_data);

// 	  }else{
// 	  	 $('#projectform').removeClass('collapsed'); 
// 		var detail_data = container_width() - 250 - 300 - 600 ;
// 		$('#detail_data').width(detail_data);
// 	  }

// 	project_ia_classes = $('#project_ia').attr('class');	 
// 	projectform_classes = $('#projectform').attr('class');

// 	Cookies.set('project_ia', project_ia_classes, { expires: 7 });
// 	Cookies.set('projectform', projectform_classes, { expires: 7 });	  
// }


// function label_attributes_box()
// {
// 	console.log('Inside label_attributes_box');
// 	 var searchclassName = $('#projectform').attr('class');	
//      var className = $('.project_ia').attr('class');

//       if (searchclassName == "project-data collapsed" && className == "project-data project_ia"){
// 		 $('#project_ia').addClass('collapsed');
// 		 $('.collapse_table_data').addClass('collapse_table');
// 		 $('.collapse_table_data').addClass('collapse_table');
// 		 $('#project_ia').addClass('project_serach_noDetail');
// 		var detail_data = container_width() - 300 ;
// 		$('#detail_data').width(detail_data);

//       }
//       else if (className == "project-data project_ia"){
// 		 $('#project_ia').addClass('collapsed');
// 		 $('.collapse_table_data').addClass('collapse_table');
// 		 $('.collapse_table_data').addClass('collapse_table');
// 		 $('#project_ia').addClass('project_serach_noDetail');
// 		 var detail_data = container_width() - 300 - 250  ;
// 		$('#detail_data').width(detail_data);

// 	  }else if( searchclassName == "project-data collapsed" && 
// 	  			className == "project-data project_ia collapsed project_serach_noDetail") {
	  		
// 	  		$('#project_ia').removeClass('collapsed');
// 	  		$('#project_ia').removeClass('project_serach_noDetail');
// 	  		var detail_data = container_width() - 300 - 600;
// 			$('#detail_data').width(detail_data);


// 	  }else{	
// 	  	 $('#project_ia').removeClass('collapsed');
// 		 $('.collapse_table_data').removeClass('collapse_table');
// 		 $('.collapse_table_data').removeClass('collapse_table');
// 		 $('#project_ia').removeClass('project_serach_noDetail');
// 		var detail_data = container_width() - 300 - 600 - 250;
// 		$('#detail_data').width(detail_data);

// 	  }

// 	project_ia_classes = $('#project_ia').attr('class');	 
// 	projectform_classes = $('#projectform').attr('class');

// 	Cookies.set('project_ia', project_ia_classes, { expires: 7 });
// 	Cookies.set('projectform', projectform_classes, { expires: 7 });
	  	 
// }
function set_current_timestamp(){
	$('#datetimepicker_info').val(moment().format('MM/DD/YYYY hh:mm A'));
}

