
console.log('main js working........');

function messageform()
{
     var className = $('.project-formset').attr('class');
	 console.log(className);
      if (className=='project-data project-formset collapsed'){
		 $('#projectform').removeClass('collapsed');
		 $('#ghzanfer').removeClass('tspend');
	  }else{	
		 $('#projectform').addClass('collapsed');
		 $('#ghzanfer').addClass('tspend');	  
	  }
	  
	 
}

function messagebox()
{
	console.log('sssssssss');
     var className = $('.projectcall').attr('class');
	 console.log(className);
      if (className=='project-data projectcall collapsed'){
		 $('#projectbox').removeClass('collapsed');
		 $('#ghzanfer').removeClass('tspend');
	  }else{	
		 $('#projectbox').addClass('collapsed');
		 $('#ghzanfer').addClass('tspend');	  
	  }
	  
	 
}
