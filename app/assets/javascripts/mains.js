
console.log('main js working........');

function addProjectSubmit() {
	$("form#add_project_form").submit();
}
function addEcrSubmit() {
	$("form#add_ecr_form").submit();
}
function addIaSubmit() {
	$("form#add_ia_form").submit();
}

$(document).ready(function() {
  return $("#new_article").on("ajax:success", function(e, data, status, xhr) {
  	console.log("pkpk");
  	//$('add_project_modal').hide();
    return $("#new_article").append(xhr.responseText);
  }).on("ajax:error", function(e, xhr, status, error) {
    return $("#new_article").append("<p>ERROR</p>");
  });
});


function set_current_timestamp(){
	$('#datetimepicker_info').val(moment().format('MM/DD/YYYY hh:mm A'));
}


function messageform()
{
     var className = $('.project-formset').attr('class');
      if (className=='project-data project-formset collapsed'){
      	$('#labeling_body').removeClass('labeling_body_detail');
      	 $('#labeling_container').removeClass('labeling_container_detail');

      	 $('#labeling_body').addClass('labeling_body_detail_search');
      	 $('#labeling_container').addClass('labeling_container_detail_search');

		 $('#projectform').removeClass('collapsed');
		 $('#detail_data').removeClass('tspend_initial');

		 var classNameIadiv = $('.project_ia').attr('class');
		 if (classNameIadiv=='project-data project_ia collapsed'){
		 	$('#project_ia').addClass('project_serach_noDetail');
		 }

	  }else{
	  	 $('#labeling_body').removeClass('labeling_body_detail_search');
      	 $('#labeling_container').removeClass('labeling_container_detail_search');
      	 $('#project_ia').removeClass('project_serach_noDetail');

      	 $('#labeling_body').addClass('labeling_body_detail_search');
      	 $('#labeling_container').addClass('labeling_container_detail_search');

		 $('#projectform').addClass('collapsed');
		 $('#detail_data').addClass('tspend');

		 var className = $('.project-formset').attr('class');
     	 var className_datil = $('.project_ia').attr('class');
	 	 if ( (className_datil == "project-data project_ia collapsed" || className_datil == 'project-data project_ia collapsed project_serach_noDetail') && className == 'project-data project-formset collapsed'){
	        $('#labeling_body').removeClass('labeling_body_detail');	
		  	 $('#labeling_container').removeClass('labeling_container_detail');
		  	 $('#labeling_body').removeClass('labeling_body_detail_search');
	      	 $('#labeling_container').removeClass('labeling_container_detail_search');
	      	 $('#project_ia').removeClass('project_serach_noDetail');
	      	 $('#detail_data').addClass('tspend_initial');
		 }	  
	  }

	  
	 
}

function messagebox()
{
	console.log('sssssssss');
     var className = $('.project_ia').attr('class');

      if (className == "project-data project_ia collapsed" || className == 'project-data project_ia collapsed project_serach_noDetail'){
      	 $('#labeling_body').addClass('labeling_body_detail');
      	 $('#labeling_container').addClass('labeling_container_detail');
		 $('#project_ia').removeClass('collapsed');
		 $('.collapse_table_data').removeClass('collapse_table');
		 $('.collapse_table_data').removeClass('collapse_table');
		 $('#detail_data').removeClass('tspend');
		 $('#project_ia').removeClass('project_serach_noDetail');
		 $('#detail_data').removeClass('tspend_initial');
	  }else{	
	  	 $('#labeling_body').removeClass('labeling_body_detail');	
	  	 $('#labeling_container').removeClass('labeling_container_detail');
	  	 $('.collapse_table_data').addClass('collapse_table');
		 $('.collapse_table_data').addClass('collapse_table');
		 $('#project_ia').addClass('collapsed');
		 $('#detail_data').addClass('tspend');

		 var classNameSearchdiv = $('.project-formset').attr('class');
		 if (classNameSearchdiv=='project-data project-formset'){
		 	$('#project_ia').addClass('project_serach_noDetail');
		 }

	 	 var className = $('.project_ia').attr('class');
	     var classNameSearch = $('.project-formset').attr('class');

		 if ( (className == "project-data project_ia collapsed"  || className == 'project-data project_ia collapsed project_serach_noDetail' )&& classNameSearch == 'project-data project-formset collapsed'){
		  	 $('#labeling_body').removeClass('labeling_body_detail');	
		  	 $('#labeling_container').removeClass('labeling_container_detail');
		  	 $('#labeling_body').removeClass('labeling_body_detail_search');
		  	 $('#labeling_container').removeClass('labeling_container_detail_search');
		  	 $('#project_ia').removeClass('project_serach_noDetail');
		  	 $('#detail_data').addClass('tspend_initial');
		 }

	  }
	  
	 
}
