function popupwindow(page,name) {  	
     var win = window.open(page,name,'width=650,height=400,menubar=no,status=no,scrollbars=yes,toolbar=no,directories=no,location=no');
     win.moveTo(120,120);
        if(typeof(focus)=="function" || typeof(focus)=="object")
	       win.focus();
}

function popupwindow(page,name,width,height) {  	
	popupwindowspec(page,name,width,height)
}

function popupwindowspec(page,name,pagewidth,pageheight) { 
	 	
     var win = window.open(page,name,'width='+pagewidth+',  height='+pageheight+', menubar=no,status=no,resizable=yes,scrollbars=yes,toolbar=no,directories=no,location=no');
     	win.moveTo(120,120);
	
	 if(typeof(focus)=="function" || typeof(focus)=="object")
	       win.focus();
}
