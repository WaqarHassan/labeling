
console.log('main js working........');


function resetSearchResult(){
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

function label_attributes_box()
{
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
