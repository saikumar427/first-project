function puttitle1(name)
{
document.form.changetitle.value=name;
}
function puttitle(name)
{
//var ct=document.form.changetitle.value;
//if(ct=='')
document.form.title.value=name;
}
function checklogForm(form){
var i=0;
	if(document.form.uploadurl.length==null){
		if(document.form.uploadurl.checked==true) i=1;
	}else{
		for(var j=0;j<document.form.uploadurl.length;j++){
			if(document.form.uploadurl[j].checked==true){
				i=1;
				break;
			}
		}
	}
	if(i==0){
		alert(" Please select your Photo");
		return false;
	}else
	if(trim(document.form.type.value)==''){
  	alert("Type is empty");
  	return false;
  }else if(trim(document.form.title.value)==''){
  	alert("Title is empty");
  	return false;
	}
  }
