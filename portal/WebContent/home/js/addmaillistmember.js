function testtrim(str)
{
var temp='';
temp=new String(str);
temp=temp.replace(/[^a-zA-Z 0-9]+/g,'');

//alert("in the testtrim------->"+temp);
return temp;
}


function demo123() {
	advAJAX.submit(document.getElementById("updatememberlist"), {
	    onSuccess : function(obj) {
	       showmemberlist(); 
	    },
	    onError : function(obj) { alert("Error: " + obj.status); }    
	});
	
}

function showmemberlist() {

document.getElementById("manual").style.display='none';
document.getElementById("manualEntry").innerHTML='';

advAJAX.get( {
	url : "/portal/listmgmt/showaddmemberlist.jsp",
	onSuccess : function(obj) {document.getElementById('memberlist').innerHTML=obj.responseText;},
	onError : function(obj) { alert("Error: " + obj.status); }
});


	

}



function addmembers(id,memid) {

advAJAX.submit(document.getElementById(id),{
    onSuccess : function(obj) {
	var data=obj.responseText;
	var url='';	
	data=testtrim(data);
	if(data=='yes'){
		url='/portal/listmgmt/addMemberManual.jsp?error=yes';
		manualdetails(memid,url);
	}else{
		document.getElementById('manual').innerHTML=''
		showmemberlist();
	}
	},
    onError : function(obj) { alert("Error: " + obj.status); }    

});
}

function manualdetails(memberid,url) {
	
advAJAX.get( {
		url : url+"&memid="+memberid,
		onSuccess : function(obj) {document.getElementById('manual').innerHTML=obj.responseText;},
		onError : function(obj) { alert("Error: " + obj.status); }
	});
}

function addManual(memberid) {

	document.getElementById("manual").innerHTML='';
	document.getElementById('addonemore').style.display='none';
	advAJAX.get( {
		url : "/portal/listmgmt/addMemberManual.jsp?memid="+memberid,
		onSuccess : function(obj) {
			document.getElementById('manualEntry').innerHTML=obj.responseText;
			document.getElementById('addbutton').innerHTML='';
			document.getElementById('addbutton').innerHTML="<input type='button' name='submit' value='Add' onClick='addmembers1(\"addmoremembers\","+memberid+");  return false;' />"
			},
		onError : function(obj) { alert("Error: " + obj.status); }
	});
}

function addmembers1(id,memberid) {

advAJAX.submit(document.getElementById(id),{
    onSuccess : function(obj) {
	var data=obj.responseText;
	var url='';	
	data=testtrim(data);
	if(data=='yes'){
		url='/portal/listmgmt/addMemberManual.jsp?error=yes';
		manualdetails1(url,memberid);
	}else{
		showmemberlist();
	}
		},
    onError : function(obj) { alert("Error: " + obj.status); }    

});
}

function manualdetails1(url,memberid) {
	
advAJAX.get( {
		
		url : url+"&memid="+memberid,
		onSuccess : function(obj) {document.getElementById('manualEntry').innerHTML=obj.responseText;
		
		},
		onError : function(obj) { alert("Error: " + obj.status); }
	});
}

function changehiddens(){
document.getElementById('inputhiddens').innerHTML+="<input type='hidden' name='operation' value='delete' />"
}

function showmemberlist1(memberid,mempos) {
document.getElementById("manual").style.display='none';
document.getElementById("manualEntry").innerHTML='';
advAJAX.get( {
	url : "/portal/listmgmt/showaddmemberlist.jsp",
	onSuccess : function(obj) {
	
		document.getElementById('memberlist').innerHTML=obj.responseText;
		
		showmemberdata(memberid,mempos);
		changehiddens();
		
		},
	onError : function(obj) { alert("Error: " + obj.status); }
});
}

function  showmemberdata(memberid,mempos){

advAJAX.get( {
		url : "/portal/listmgmt/addMemberManual.jsp?memid="+mempos,
		onSuccess : function(obj) {
			document.getElementById('memberdata_'+mempos).innerHTML=obj.responseText;
			document.getElementById('inputhiddens').innerHTML="<input type='hidden' name='LIST_EDIT_ID' value='"+mempos+"' />"
			document.getElementById('inputhiddens').innerHTML+="<input type='hidden' name='operation' value='edit' />"
			document.getElementById('inputhiddens').innerHTML+="<input type='hidden' name='memberid' value='"+memberid+"' />"
			document.getElementById('addbutton').innerHTML="<input type='button' name='submit' value='Update' onClick='addmembers(\"updatememberlist\","+memberid+");  return false;' />"
			document.getElementById('addonemore').style.display='none';
		},
		onError : function(obj) { alert("Error: " + obj.status); }
	});
}


function uploadcontent(){

document.getElementById('upload').innerHTML+="<input type='hidden' name='operation' value='uploadfile'/>";

advAJAX.submit(document.getElementById("upload"), {
        onSuccess : function(obj) { },
	    onError : function(obj) { alert("Error: " + obj.status); }    
	});
}

function mapmemberdata(){ 

document.getElementById('uploaddata').innerHTML='';
advAJAX.get( {
		url : "/portal/listmgmt/mapmemlist.jsp",
		onSuccess : function(obj) {
		
		document.getElementById('mapdata').innerHTML=obj.responseText;
		},
		onError : function(obj) { alert("Error: " + obj.status); }
	});
}

function mapcontent(){


document.getElementById("hiddens").innerHTML='<input type="hidden" name="purpose" value="add">';

advAJAX.submit(document.getElementById('mapmemberdata'), {
    onSuccess : function(obj) {
	
	var data=obj.responseText;
	data=testtrim(data);
	
	if(data=='yes'){
		url='/portal/listmgmt/mapmemlist.jsp?error=yes';
		mapmemberdata1(url);
	}
	else{
	document.getElementById('disperror').innerHTML='';
	document.getElementById('mapdata').innerHTML='';
	document.getElementById('validdata').innerHTML=obj.responseText;	
	}
		
	},
    onError : function(obj) { alert("Error: " + obj.status); }
});
}

function mapmemberdata1(url){ 

document.getElementById('uploaddata').innerHTML='';
advAJAX.get( {
		url : url,
		onSuccess : function(obj) {
		document.getElementById('mapdata').innerHTML=obj.responseText;
		
		},
		onError : function(obj) { alert("Error: " + obj.status); }
	});
}
function insertIntoList(){

advAJAX.submit(document.getElementById("validatedata"), {
	    onSuccess : function(obj) { 
		addList();
		},
	    onError : function(obj) { alert("Error: " + obj.status); }    
	});

}




function addList() {

var url='/portal/mytasks/listmgmtdone.jsp?ntype=Upload';

   window.location.href=url;
}