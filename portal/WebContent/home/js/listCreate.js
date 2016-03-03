var fileupload=false;
var mapdata=false;
var validatedata=false;



function testtrim(str)
{
var temp='';
temp=new String(str);
temp=temp.replace(/[^a-zA-Z 0-9]+/g,'');

//alert("in the testtrim------->"+temp);
return temp;
}



function uploadcontent(){

document.getElementById('addmemberlist').innerHTML+="<input type='hidden' name='operation' value='uploadfile'/>";
advAJAX.submit(document.getElementById("addmemberlist"), {
        onSuccess : function(obj) { },
	    onError : function(obj) { alert("Error: " + obj.status); }    
	});
}

function fileUpload(attribname) {
//alert("hiiiiii");

		advAJAX.get( {
		url : "/portal/listmgmt/uploadcontent.jsp",
		onSuccess : function(obj) {
		document.getElementById('manual').innerHTML='';
		document.getElementById('listsMerge').innerHTML='';
		document.getElementById('manualEntry').innerHTML='';		
		document.getElementById('uploaddata').innerHTML=obj.responseText;
		},
		onError : function(obj) { alert("Error: " + obj.status); }
	});

}

function uploadfile()
{
	
	advAJAX.submit(document.getElementById('upload'),{
    onSuccess : function(obj) {
    	var data=obj.responseText;
	
	data=testtrim(data);
	if(data=='yes'){
		
		url='/portal/listmgmt/uploadcontent.jsp?error=yes';
		uploadfiledata(url,"Upload");
	}else{
	
	mapmemberdata();
	}
	},
    onError : function(obj) { alert("Error: " + obj.status);}    

});
}

function uploadfiledata(url,attribname) {
document.getElementById('mapdata').innerHTML='';

		advAJAX.get( {
		url : url,
		onSuccess : function(obj) {
		document.getElementById('manual').innerHTML='';
		document.getElementById('manualEntry').innerHTML='';		
		document.getElementById('uploaddata').innerHTML=obj.responseText;
		},
		onError : function(obj) { alert("Error: " + obj.status);}
	});
}

function mapmemberdata(){

document.upload.fileup.value=true;
document.getElementById('uploaddata').innerHTML='';
advAJAX.get( {
		url : "/portal/listmgmt/mapmemberdata.jsp",
		onSuccess : function(obj) {
		document.getElementById('mapdata').innerHTML=obj.responseText;
		
		},
		onError : function(obj) { alert("Error: " + obj.status); }
	});
}

function mapcontent(){



advAJAX.submit(document.getElementById('mapmemberdata'), {
    onSuccess : function(obj) {
	
	var data=obj.responseText;
	data=testtrim(data);
	
	if(data=='yes'){
		url='/portal/listmgmt/mapmemberdata.jsp?error=yes';
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

function insertvalid(){

document.getElementById('validdata').innerHTML='';
document.getElementById('insertdata').innerHTML='Members are inserted into MailList.Select Create to create The MailList.';
advAJAX.submit(document.getElementById("mappingcontent"), {
	    onSuccess : function(obj) { 
		
		
		},
	    onError : function(obj) { alert("Error: " + obj.status); }    
	});
	
 //document.forms["addmemberlist"].elements["rad"][1].disabled = true;
//document.forms["addmemberlist"].elements["rad"][2].disabled = true;
 
}


function demo14() {
advAJAX.submit(document.getElementById('addmanualmember'), {
    onSuccess : function(obj) {showmemberlist();},
    onError : function(obj) { alert("Error: " + obj.status); }

});
document.getElementById("manualEntry").style.display='none';
}
function demo12() {
	advAJAX.submit(document.getElementById("editmember"), {
	
	    onSuccess : function(obj) {showmemberlist(); },
	    onError : function(obj) { alert("Error: " + obj.status); }    
	});
}

function demo123() {
	advAJAX.submit(document.getElementById("updatememberlist"), {
	    onSuccess : function(obj) {
	       showmemberlist(); 
	    },
	    onError : function(obj) { alert("Error: " + obj.status); }    
	});
	
}

function getmemberdata(){
	advAJAX.get( {
		url : "/portal/listmgmt/showmemberlist.jsp",
		onSuccess : function(obj) {
				document.getElementById('memberlist').innerHTML=obj.responseText;
				
		},
		onError : function(obj) { alert("Error: " + obj.status); }
	});
}


function  showmemberdet(){
	document.getElementById("manual").innerHTML='';
	var memid=document.form.memberid.value;
	advAJAX.get( {
		url : "/portal/listmgmt/addMemberManual.jsp?memid="+memid,
		onSuccess : function(obj) {document.getElementById('manual').innerHTML=obj.responseText;},
		onError : function(obj) { alert("Error: " + obj.status); }
	});
}


function addManualDetails(memberid) {


		advAJAX.get( {
		url : "/portal/listmgmt/addMemberManual.jsp?memid="+memberid+"&isNew=yes",
		onSuccess : function(obj) {
		document.getElementById('uploaddata').innerHTML='';
		document.getElementById('listsMerge').innerHTML='';
		document.getElementById('mapdata').innerHTML='';
		document.getElementById('validdata').innerHTML='';
		
		document.getElementById('manual').innerHTML=obj.responseText;
		
		},
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



function editmember(){
document.getElementById("memberdata").innerHTML+='<input type="hidden" name="submitpurpose" value="edit">';
}

function changehiddens(){
document.getElementById('inputhiddens').innerHTML+="<input type='hidden' name='operation' value='delete' />"
}   

function  showmemberdata(member){
//alert('in show members-->'+member);

advAJAX.get( {
		url : "/portal/listmgmt/addMemberManual.jsp?memid="+member,
		onSuccess : function(obj) {
			document.getElementById('memberdata_'+member).innerHTML=obj.responseText;
			document.getElementById('inputhiddens').innerHTML="<input type='hidden' name='LIST_EDIT_ID' value='"+member+"' />"
			document.getElementById('inputhiddens').innerHTML+="<input type='hidden' name='operation' value='edit' />"
			
			document.getElementById('addbutton').innerHTML="<input type='button' name='submit' value='Update' onClick='addmembers(\"updatememberlist\","+member+");  return false;' />"
			document.getElementById('addonemore').style.display='none';
			
		},
		onError : function(obj) { alert("Error: " + obj.status); }
	});
}
function addmembers(id,memid) {
//alert('In add members----->'+memid);
advAJAX.submit(document.getElementById(id),{
    onSuccess : function(obj) {
	var data=obj.responseText;
	var url='';	
	data=testtrim(data);
	
	if(data=='yes'){
		url='/portal/listmgmt/addMemberManual.jsp?error=yes';
		manualdetails(memid,url);
	}else if(data=='editerror'){
		url='/portal/listmgmt/addMemberManual.jsp?error=yes';
		updatemanual(memid,url);
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


function updatemanual(memberid,url) {
	
advAJAX.get( {
		url : url+"&memid="+memberid,
		onSuccess : function(obj) {
		document.getElementById('memberdata_'+memberid).innerHTML=obj.responseText;
			document.getElementById('addbutton').innerHTML="<input type='button' name='submit' value='Update' onClick='addmembers(\"updatememberlist\","+memberid+");  return false;' />"
		
		
		},
		onError : function(obj) { alert("Error: " + obj.status); }
	});
	//alert(document.getElementById('manual').innerHTML);
	//alert(document.getElementById('memberlist').innerHTML);
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




function showmemberlist1(memid) {
document.getElementById("manual").style.display='none';
document.getElementById("manualEntry").innerHTML='';
advAJAX.get( {
	url : "/portal/listmgmt/showmemberlist.jsp",
	onSuccess : function(obj) {
	
		document.getElementById('memberlist').innerHTML=obj.responseText;
		
		showmemberdata(memid);
		changehiddens();
		
		},
	onError : function(obj) { alert("Error: " + obj.status); }
});
}


function showmemberlist() {

document.getElementById("manual").style.display='none';
document.getElementById("manualEntry").innerHTML='';
advAJAX.get( {
	url : "/portal/listmgmt/showmemberlist.jsp",
	onSuccess : function(obj) {document.getElementById('memberlist').innerHTML=obj.responseText;},
	onError : function(obj) { alert("Error: " + obj.status); }
});
document.forms["addmemberlist"].elements["rad"][0].disabled = true;
document.forms["addmemberlist"].elements["rad"][2].disabled = true;



}

function addListOnSubmit(){

advAJAX.submit(document.getElementById("addmemberlist"),{
    onSuccess : function(obj) {
	var data=obj.responseText;
	var url='';	
	data=testtrim(data);
			if(data=='yes'){
			url='/portal/lists/ListCreateScreen1.jsp?error=yes';
			}else{
				addlist();
			}
	},
    onError : function(obj) { alert("Error: " + obj.status); }
});
}

function addList() {
advAJAX.submit(document.getElementById("addmemberlist"), {
    onSuccess : function(obj) {
	var data=obj.responseText;
	
	data=testtrim(data);
			if(data=='yes'){
				url='/portal/mytasks/ListCreateScreen.jsp?error=yes';
			}else{
				url='/portal/mytasks/marketing.jsp?operation=Create';
			}
   window.location.href=url;
    },
    onError : function(obj) { alert("Error: " + obj.status); }    
});
}
         

function listMerge(url){ 


	 advAJAX.get( {
		url : url,
		onSuccess : function(obj) {
				document.getElementById('uploaddata').innerHTML='';
				document.getElementById('manual').innerHTML='';
				document.getElementById('mapdata').innerHTML='';
				document.getElementById('validdata').innerHTML='';
				document.getElementById('listsMerge').innerHTML=obj.responseText;
		},
		onError : function(obj) { alert("Error: " + obj.status); }
	});
}




function processdata(){
document.forms['addmemberlist'].action="/portal/listmgmt/storeformdata.jsp";


advAJAX.submit(document.getElementById('addmemberlist'),{
    onSuccess : function(obj) {
 
    finalSubmit();

		},
    onError : function(obj) { finalSubmit(); }    

});

}

function finalSubmit(){
	document.forms['upload'].submit();
	
}




function validate(){

advAJAX.submit(document.getElementById("validateLists"),{
    onSuccess : function(obj) {
	var data=obj.responseText;
	
	var url='';	
	data=testtrim(data);
	//alert('alerttrim-->'+data);
		if(data=='error'){
				
				listMerge('/portal/listmgmt/mailListMerge.jsp?error=yes');
				}else if(data=='nolists'){
		  listMerge('/portal/listmgmt/mailListMerge.jsp?nolists=yes');	
		
		}else{
			document.getElementById('listsMerge').style.display='none';
			document.getElementById('mergeResult').innerHTML=data;
		}
	},
    onError : function(obj) { alert("Error: " + obj.status);}
});

document.forms["addmemberlist"].elements["rad"][0].disabled = true;
document.forms["addmemberlist"].elements["rad"][1].disabled = true;
}

