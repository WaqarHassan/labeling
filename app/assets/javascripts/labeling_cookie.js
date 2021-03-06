if (window.jQuery) {  
	$(document).ready(function() {
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
			var detail_data = container_width() - 250 - 342 - 523 ;
			console.log('detail_data width = '+detail_data);
			$('#detail_data').width(detail_data);
		}
	});
} 
//It returns width of Panel's container on index page
function container_width(){
	return  $('#labeling_container').width() - 22 ;
}
//This function adjusts Panel's container width whenever search panel is collapsed or expanded.
function overview_serach_box()
{
	 var labelsClassName = $('.project_ia').attr('class');	
     var className = $('#projectform').attr('class');

      if (className=='project-data' && labelsClassName == 'project-data project_ia collapsed project_serach_noDetail'){
      	 $('#projectform').addClass('collapsed');
		var detail_data = container_width() - 342 ;
		$('#detail_data').width(detail_data);

      }
      else if (className=='project-data'){
		 $('#projectform').addClass('collapsed');
		var detail_data = container_width() - 342 - 523;
		$('#detail_data').width(detail_data);

	  }else if (className=='project-data collapsed' && labelsClassName == 'project-data project_ia collapsed project_serach_noDetail'){
	  	$('#projectform').removeClass('collapsed');
		$('#project_ia').addClass('project_serach_noDetail');
		var detail_data = container_width() - 342 -250  ;
		$('#detail_data').width(detail_data);

	  }else{
	  	 $('#projectform').removeClass('collapsed'); 
		var detail_data = container_width() - 250 - 342 - 523 ;
		$('#detail_data').width(detail_data);
	  }
		project_ia_classes = $('#project_ia').attr('class');	 
		projectform_classes = $('#projectform').attr('class');

		Cookies.set('project_ia', project_ia_classes, { expires: 7 });
		Cookies.set('projectform', projectform_classes, { expires: 7 });
}
//This function adjusts panel's container width whenever any panel in expaneded or collapsed 
function adjust(){

	if($('#projectform').hasClass('collapsed'))
	{
		if($('#project_ia').hasClass('collapsed'))
		{
			var detail_data = container_width() - 342 ;
			$('#detail_data').width(detail_data);	
		}
		else{
			var detail_data = container_width() - 342 - 523 ;
			$('#detail_data').width(detail_data);

		}

	}
	else
	{
		if($('#project_ia').hasClass('collapsed'))
		{
			var detail_data = container_width() -250 - 342 ;
			$('#detail_data').width(detail_data);	
		}
		else{
			var detail_data = container_width() - 342 - 523 - 250 ;
			$('#detail_data').width(detail_data);
		}

	}

}
//This function adjusts Panel's container width when ever objects Panel is expanded or collapsed
function label_attributes_box()
{
	 var searchclassName = $('#projectform').attr('class');	
     var className = $('.project_ia').attr('class');

      if (searchclassName == "project-data collapsed" && className == "project-data project_ia"){
		 $('#project_ia').addClass('collapsed');
		 $('.collapse_table_data').addClass('collapse_table');
		 $('.collapse_table_data').addClass('collapse_table');
		 $('#project_ia').addClass('project_serach_noDetail');
		var detail_data = container_width() - 342 ;
		$('#detail_data').width(detail_data);

      }
      else if (className == "project-data project_ia"){
		 $('#project_ia').addClass('collapsed');
		 $('.collapse_table_data').addClass('collapse_table');
		 $('.collapse_table_data').addClass('collapse_table');
		 $('#project_ia').addClass('project_serach_noDetail');
		 var detail_data = container_width() - 342 - 250  ;
		$('#detail_data').width(detail_data);

	  }else if( searchclassName == "project-data collapsed" && 
	  		className == "project-data project_ia collapsed project_serach_noDetail") {
	  		$('#project_ia').removeClass('collapsed');
 	  		$('#project_ia').removeClass('project_serach_noDetail');
	  		var detail_data = container_width() - 342 - 523;
			$('#detail_data').width(detail_data);

	  }else{	
	  	 $('#project_ia').removeClass('collapsed');
		 $('.collapse_table_data').removeClass('collapse_table');
		 $('.collapse_table_data').removeClass('collapse_table');
		 $('#project_ia').removeClass('project_serach_noDetail');
		var detail_data = container_width() - 342 - 523 - 250;
		$('#detail_data').width(detail_data);

	  }
	project_ia_classes = $('#project_ia').attr('class');	 
	projectform_classes = $('#projectform').attr('class');

	Cookies.set('project_ia', project_ia_classes, { expires: 7 });
	Cookies.set('projectform', projectform_classes, { expires: 7 });	 
}
