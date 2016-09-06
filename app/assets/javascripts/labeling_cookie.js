if (window.jQuery) {  
	$(document).ready(function() {

		if (Cookies.get('project_ia') && Cookies.get('projectform') ){
			console.log('cooke present....');
			project_ia_classes = Cookies.get('project_ia'); 	 
			projectform_classes = Cookies.get('projectform'); 
			
			$('#project_ia').removeClass();
			$('#projectform').removeClass();
			$('#project_ia').addClass(project_ia_classes);
			$('#projectform').addClass(projectform_classes);


			label_attributes_box();
			overview_serach_box();
		}

	});
}