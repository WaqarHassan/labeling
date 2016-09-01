jQuery(document).ready(function() {

	if (Cookies.get('project_ia') && Cookies.get('projectform') && Cookies.get('detail_data')){
		console.log('cooke present....');
		project_ia_classes = Cookies.get('project_ia'); 	 
		projectform_classes = Cookies.get('projectform'); 
		detail_data_classes = Cookies.get('detail_data');
		
		$('#project_ia').removeClass();
		$('#projectform').removeClass();
		$('#detail_data').removeClass();
		$('#project_ia').addClass(project_ia_classes);
		$('#projectform').addClass(projectform_classes);
		$('#detail_data').addClass(detail_data_classes);
	}

});