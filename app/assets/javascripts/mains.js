
console.log('main js working........');

function messageform()
{
     var className = $('.project-formset').attr('class');
      if (className=='project-data project-formset collapsed'){
      	$('#labeling_body').removeClass('labeling_body_detail');
      	 $('#labeling_container').removeClass('labeling_container_detail');

      	 $('#labeling_body').addClass('labeling_body_detail_search');
      	 $('#labeling_container').addClass('labeling_container_detail_search');

		 $('#projectform').removeClass('collapsed');
		 $('#detail_data').removeClass('tspend');

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
		 $('#detail_data').removeClass('tspend');
		 $('#project_ia').removeClass('project_serach_noDetail');
	  }else{	
	  	 $('#labeling_body').removeClass('labeling_body_detail');	
	  	 $('#labeling_container').removeClass('labeling_container_detail');
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
		 }

	  }
	  
	 
}
