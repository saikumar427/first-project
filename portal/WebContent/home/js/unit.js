function checkName() {  	
  if(document.form.unitname.value==''){
	alert("Community name should not be empty");
	return false;	
  }else if((document.form.loginname.value==' ')||(document.form.loginname.value=='')){
	alert("Login should not be empty");	
	return false;
  }else if((document.form.loginname.value.length) <4){  	
	alert("Login should have minimum 4 characters");
	return false;			  	
  }else if((document.form.password.value==' ')||(document.form.password.value=='')){
	alert("Password should not be empty");
	return false;		
  }else if((document.form.password.value.length) <4){  	
	alert("Password should have minimum 4 characters");
	return false;			  		
  }else if(!(document.form.repassword.value==document.form.password.value)){
	alert("Password entries did not match");
	return false;		
  }else if((document.form.firstname.value==' ')||(document.form.firstname.value=='')){
	alert("First name should not be empty");
	return false;	
  }else if((document.form.firstname.value.length) <4){  	
	alert("First name should have minimum 4 characters");
	return false;	
  }else{
	return true;

  }

}
