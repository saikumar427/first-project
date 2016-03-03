var _win;
function setAction(){
		if(_win)
		_win.close();
		document.form.target="_self"
		document.form.action="newclassified.jsp";
   }
 function preview(){
		document.form.target="foobar"
		document.form.action="/classifieds/classifieddisplay.jsp";
		document.form.args="width=800,height=450,menubar=no,status=no,scrollbars=yes,toolbar=no,directories=no,location=no";
   }
   function checkForm(form){
    if((document.form.classifiedtype.value==' ')||(document.form.classifiedtype.value=='')){
  	//alert("Type is empty");
  	alert(typeempty);
  	return false;
  }else
	 if(document.form.title.value==''){
  	//alert("Title is empty");
  	alert(titleempty);
  	return false;
  }else if(document.form.location.value==''){
  	//alert("City is empty");
  	alert(cityempty);
  	return false;
	}else if(document.form.country.value==''){
  	alert("Choose a country name");
  	return false;
	//}else if(trim(document.form.classified.value)==''){
  	//alert("Description is empty");
  	//return false;
  	}else{
		if(form.action=='newclassified.jsp')
			return true;
	      _win = window.open('',form.target,form.args);
	      _win.moveTo(175,50);
	       if(typeof(focus)=="function" || typeof(focus)=="object")
		_win.focus();
		return true;
	}

  }
