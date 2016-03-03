function validate(f) {  
	
	var i=0;
	if(f.choiceid.length==null){
		if(f.choiceid.checked==true) i=1;
	}else{
		for(var j=0;j<f.choiceid.length;j++){
			if(f.choiceid[j].checked==true){
				i=1;
				break;
			}
		}
	}	
	if(i==0){
		alert(" Please select your choice");		
		return false;
	}
	return openWindow(f);	
}
function openWindow(f){
	f.target="POLL"
	f.args="width=800,height=600,menubar=no,status=no,scrollbars=yes,toolbar=no,directories=no,location=no";
      _win = window.open('POLL',f.target,f.args);
      _win.moveTo(175,50);
      
       if(typeof(focus)=="function" || typeof(focus)=="object")
	       _win.focus();
	return true;
}
