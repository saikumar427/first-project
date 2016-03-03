function selectAll(){
	
	document.form.delmsgid.checked=document.form.topics.checked;
	for(i=0;i<document.form.delmsgid.length;i++){
		
		document.form.delmsgid[i].checked=document.form.topics.checked;
	}
}
function changeMsgid(str){
	document.form.msgid.value=str;
	
}
function messageForum(f){
	
	var preview=document.form.ispreview.value;
	
	if(preview=='Yes'){
		
		document.form.target="preview"
		document.form.action='previewmsginfo';
		document.form.args="width=800,height=600,menubar=no,status=no,scrollbars=yes,toolbar=no,directories=no,location=no";
		_win = window.open(document.form.action,document.form.target,document.form.args);
		_win.moveTo(175,50);
		if(typeof(focus)=="function" || typeof(focus)=="object")
			_win.focus();
		return false;
		
	}else
		return true;
}
	