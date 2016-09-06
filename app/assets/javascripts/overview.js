
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

	// 	console.log('sjkadhaj df');
	// var container_width  = $('#labeling_container').width();
	// var project_ia = ( container_width * 37 ) / 97;
	// var detail_data = container_width - 250 - 300 - project_ia;
	// $('#detail_data.approval-data.tspend_initial').width(detail_data); 
	// $('#detail_data.approval-data.tspend_initial.labels_hidden').width(detail_data + project_ia); 
	//$('.approval-data.tspend_initial.labels_hidden').width();

	// console.log('detail_data.labels_hidden = ' + (detail_data + project_ia));
	// console.log('detail_data = ' + detail_data);
	
	$('.modal-dialog').draggable({
	    handle: ".modal-header"
	});

	if (Cookies.get('project_ia') && Cookies.get('projectform') ){
		console.log('cooke present....');
		project_ia_classes = Cookies.get('project_ia'); 	 
		projectform_classes = Cookies.get('projectform'); 
		//detail_data_classes = Cookies.get('detail_data');
		
		$('#project_ia').removeClass();
		$('#projectform').removeClass();
		//$('#detail_data').removeClass();
		$('#project_ia').addClass(project_ia_classes);
		$('#projectform').addClass(projectform_classes);
		//$('#detail_data').addClass(detail_data_classes);

		label_attributes_box();
		overview_serach_box();
	}

	$('.modal-dialog').draggable({
	    handle: ".modal-header"
	});

});

function set_current_timestamp(){
	$('#datetimepicker_info').val(moment().format('MM/DD/YYYY hh:mm A'));
}

function overview_serach_box()
{
	console.log('overview called! =>>>>>>>>>>>>>>>>');
	 var labelsClassName = $('.project_ia').attr('class');	
     var className = $('#projectform').attr('class');

      if (className=='project-data' && labelsClassName == 'project-data project_ia collapsed project_serach_noDetail'){
      	 $('#projectform').addClass('collapsed');
		 //$('#detail_data').addClass('search_labels_hidden');
		 //$('#detail_data').addClass('search_and_labels_both_hidden');

		//var project_ia = ( container_width() * 37 ) / 97;
		var detail_data = container_width() - 300 ;
		$('#detail_data').width(detail_data);

      }
      else if (className=='project-data'){
		 $('#projectform').addClass('collapsed');
		 //$('#detail_data').addClass('search_labels_hidden');

		//var project_ia = (( container_width() * 37 ) / 97) - 2;
		var detail_data = container_width() - 300 - 600;
		$('#detail_data').width(detail_data);

	  }else if (className=='project-data collapsed' && labelsClassName == 'project-data project_ia collapsed project_serach_noDetail'){
	  	$('#projectform').removeClass('collapsed');
		//$('#detail_data').removeClass('search_labels_hidden');
		//$('#detail_data').removeClass('search_and_labels_both_hidden');
		$('#project_ia').addClass('project_serach_noDetail');
		//$('#detail_data').addClass('labels_hidden'); ===>
		var detail_data = container_width() - 300 -250  ;
		$('#detail_data').width(detail_data);

	  }else{
	  	 $('#projectform').removeClass('collapsed'); 
	  	//$('#detail_data').removeClass('search_labels_hidden'); 
	  	 //$('#detail_data').removeClass('search_and_labels_both_hidden');
		//var project_ia = (( container_width() * 37 ) / 97) -2;
		var detail_data = container_width() - 250 - 300 - 600 ;
		$('#detail_data').width(detail_data);
	  }

	project_ia_classes = $('#project_ia').attr('class');	 
	projectform_classes = $('#projectform').attr('class');
	//detail_data_classes = $('#detail_data').attr('class');

	Cookies.set('project_ia', project_ia_classes, { expires: 7 });
	Cookies.set('projectform', projectform_classes, { expires: 7 });
	//Cookies.set('detail_data', detail_data_classes, { expires: 7 });	  
}


function container_width(){
	return  $('#labeling_container').width() - 20 ;
}

function label_attributes_box()
{
	console.log('label_attribute called! =>>>>>>>>>>>>>>>>');
	 var searchclassName = $('#projectform').attr('class');	
     var className = $('.project_ia').attr('class');

      if (searchclassName == "project-data collapsed" && className == "project-data project_ia"){
		 $('#project_ia').addClass('collapsed');
		 $('.collapse_table_data').addClass('collapse_table');
		 $('.collapse_table_data').addClass('collapse_table');
		 $('#project_ia').addClass('project_serach_noDetail');

      	 //$('#detail_data').addClass('search_and_labels_both_hidden');
		var detail_data = container_width() - 300 ;
		$('#detail_data').width(detail_data);

      }
      else if (className == "project-data project_ia"){
		 $('#project_ia').addClass('collapsed');
		 $('.collapse_table_data').addClass('collapse_table');
		 $('.collapse_table_data').addClass('collapse_table');
		 $('#project_ia').addClass('project_serach_noDetail');
		// $('#detail_data').addClass('labels_hidden');
		 var detail_data = container_width() - 300 - 250  ;
		$('#detail_data').width(detail_data);

	  }else if( searchclassName == "project-data collapsed" && 
	  			className == "project-data project_ia collapsed project_serach_noDetail") {
	  		
	  		$('#project_ia').removeClass('collapsed');
	  		$('#project_ia').removeClass('project_serach_noDetail');
	  		var detail_data = container_width() - 300 - 600;
			$('#detail_data').width(detail_data);


	  }else{	
	  	 $('#project_ia').removeClass('collapsed');
		 $('.collapse_table_data').removeClass('collapse_table');
		 $('.collapse_table_data').removeClass('collapse_table');
		 $('#project_ia').removeClass('project_serach_noDetail');
		// $('#detail_data').removeClass('labels_hidden');

		// $('#detail_data').removeClass('search_and_labels_both_hidden');
		var detail_data = container_width() - 300 - 600 - 250;
		$('#detail_data').width(detail_data);

	  }

	project_ia_classes = $('#project_ia').attr('class');	 
	projectform_classes = $('#projectform').attr('class');
	//detail_data_classes = $('#detail_data').attr('class');

	Cookies.set('project_ia', project_ia_classes, { expires: 7 });
	Cookies.set('projectform', projectform_classes, { expires: 7 });
	//Cookies.set('detail_data', detail_data_classes, { expires: 7 });
	  	 
}

