
var temp=true;

function checkform(form){
	var tempflag=false;
	if(temp)
	tempflag=true;
	else
	temp=true;
	return tempflag;
}

function  keypress1(event1,tes){
	//alert("inkeypress");
	
	if( ( document.all && event1.keyCode == 13 ) || event1.which == 13 ){
		temp=false;
		tes.focus();
		
	}else{
		temp=true;
	}



}
function  keypress(event1,tes){
if( ( document.all && event1.keyCode == 13 ) || event1.which == 13 ){
 submitform();
}
}
