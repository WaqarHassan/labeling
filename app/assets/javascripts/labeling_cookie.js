if (window.jQuery) {  
	$(document).ready(function() {
		console.log('inside labeling_Cookie.js')
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
	});
}
function container_width(){
	return  $('#labeling_container').width() - 22 ;
}
function overview_serach_box()
{
	console.log('inside overview_serach_box');
	 var labelsClassName = $('.project_ia').attr('class');	
     var className = $('#projectform').attr('class');

      if (className=='project-data' && labelsClassName == 'project-data project_ia collapsed project_serach_noDetail'){
      	 $('#projectform').addClass('collapsed');
		var detail_data = container_width() - 300 ;
		$('#detail_data').width(detail_data);

      }
      else if (className=='project-data'){
		 $('#projectform').addClass('collapsed');
		var detail_data = container_width() - 300 - 600;
		$('#detail_data').width(detail_data);

	  }else if (className=='project-data collapsed' && labelsClassName == 'project-data project_ia collapsed project_serach_noDetail'){
	  	$('#projectform').removeClass('collapsed');
		$('#project_ia').addClass('project_serach_noDetail');
		var detail_data = container_width() - 300 -250  ;
		$('#detail_data').width(detail_data);

	  }else{
	  	 $('#projectform').removeClass('collapsed'); 
		var detail_data = container_width() - 250 - 300 - 600 ;
		$('#detail_data').width(detail_data);
	  }
	  console.log('=>gonna set Cookies');
		project_ia_classes = $('#project_ia').attr('class');	 
		projectform_classes = $('#projectform').attr('class');

		Cookies.set('project_ia', project_ia_classes, { expires: 7 });
		Cookies.set('projectform', projectform_classes, { expires: 7 });
		console.log('===>Cookies are set');	  
}
function adjust(){

	console.log('Inside Adjust');
	if($('#projectform').hasClass('collapsed'))
	{
		if($('#project_ia').hasClass('collapsed'))
		{
			var detail_data = container_width() - 300 ;
			$('#detail_data').width(detail_data);	
		}
		else{
			var detail_data = container_width() - 300 - 600 ;
			$('#detail_data').width(detail_data);

		}

	}
	else
	{
		if($('#project_ia').hasClass('collapsed'))
		{
			var detail_data = container_width() -250 - 300 ;
			$('#detail_data').width(detail_data);	
		}
		else{
			var detail_data = container_width() - 300 - 600 - 250 ;
			$('#detail_data').width(detail_data);
		}

	}

}
function label_attributes_box()
{
	console.log('inside label_attributes_box');
	 var searchclassName = $('#projectform').attr('class');	
     var className = $('.project_ia').attr('class');

      if (searchclassName == "project-data collapsed" && className == "project-data project_ia"){
		 $('#project_ia').addClass('collapsed');
		 $('.collapse_table_data').addClass('collapse_table');
		 $('.collapse_table_data').addClass('collapse_table');
		 $('#project_ia').addClass('project_serach_noDetail');
		var detail_data = container_width() - 300 ;
		$('#detail_data').width(detail_data);

      }
      else if (className == "project-data project_ia"){
		 $('#project_ia').addClass('collapsed');
		 $('.collapse_table_data').addClass('collapse_table');
		 $('.collapse_table_data').addClass('collapse_table');
		 $('#project_ia').addClass('project_serach_noDetail');
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
		var detail_data = container_width() - 300 - 600 - 250;
		$('#detail_data').width(detail_data);

	  }
	  console.log('=>gonna set Cookies');
	project_ia_classes = $('#project_ia').attr('class');	 
	projectform_classes = $('#projectform').attr('class');

	Cookies.set('project_ia', project_ia_classes, { expires: 7 });
	Cookies.set('projectform', projectform_classes, { expires: 7 });
	console.log('======>cookies are set');  	 
}
