
function checkName() {  
  if(document.form.custom_rolename.value==''){
  	alert("Rolename should not be empty");
  	return false;
  }else if((document.form.description.value==' ')||(document.form.description.value=='')){
  	alert("Description should not be empty");
  	return false;
  }else{
  	return true;
  	
  }
  
}  

function checkAll() {  
	var numberOfControls = document.form.length;
	 var element;
	 for(controlIndex = 0; controlIndex < numberOfControls; controlIndex++){
		element = document.form[controlIndex];
		if (element.type == "checkbox"){
			element.checked =document.form.selectall.checked;
		}
	}
	
	return true;
  
}

