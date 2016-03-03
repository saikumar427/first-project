
var _customFieldIdGenerator=0;
var elementid=1;
var arrid;
var valaraay = new Array();
var elementcountaraay = new Array();

function AddOneAttrib(attribname,isrequired,attribtype,attribs) {
	elementcountaraay[elementid]=new Array();
	document.getElementById('addAtribute').style.display='none';
	document.getElementById('dynaattrib_1').style.display='block';
	var frm=document.getElementById('registerform');
	var html1=getDivElement(elementid,attribname,isrequired,attribtype);
	document.getElementById('dynaattrib_'+elementid).innerHTML=html1;
	changeType(attribtype,attribs);	
	
}




function applyColors(){

	var frm=document.getElementById('registerform');
	var base='evenbase';
	var basecount=0;

	var p=0;
	var maxcount=frm.ATTR_MAX_ID.value;
	for(p=1;p<=maxcount;p++){
		if(document.getElementById('customDiv_'+p).innerHTML!=''){

			if(basecount%2==0)
				base='evenbase';
			else
				base='oddbase';
			basecount++;
			document.getElementById('customDiv_'+p).className=base;

		}
		else{

			document.getElementById('customDiv_'+p).className='';

		}
	}


}



function removeThisAttribute(removeid){
	
	var frm=document.getElementById('registerform');
	document.getElementById(removeid).innerHTML='';
	applyColors();
       
	
}    



function removeElement(removeid,changeid){
	
	if(elementcountaraay[changeid]==1){
		document.getElementById("dynaattrib_1").innerHTML='';
		document.getElementById("addAtribute").style.display='block';
		document.getElementById("attriberrors").innerHTML='';
	}
	else{
		elementcountaraay[changeid]--;
		document.getElementById(removeid).innerHTML='';
	}

}







function getInnerElementId(changeid){

	if (valaraay[changeid]==null){

		valaraay[changeid]=0;
		
	}
	valaraay[changeid]++;
	var idd=valaraay[changeid];
	return parseInt(idd);

}



function getElement(changeid,elementtype,elementval){
	
	var req_element;
	
	var rdname;
	
	if(elementtype=="select"||elementtype=="radio"||elementtype=="checkbox"){
		rdname=getInnerElementId(changeid);

		if (elementcountaraay[changeid]==null){

		elementcountaraay[changeid]=0;

		}
		elementcountaraay[changeid]++;
	}

	
	

	if(elementtype=="select"){
		
		req_element='<div id="AJAXCUSTOMFIELD_'+changeid+'_'+elementtype+'_'+rdname+'" ><input type="hidden" name="select_'+changeid+'" value="select">'
		+'<input type="text" name="AJAXCUSTOMFIELD_'+changeid+'_'+elementtype+'_'+rdname+'" value="'+elementval+'">'
		+'[<a href="#" ONCLICK="removeElement(\'AJAXCUSTOMFIELD_\'+\''+changeid+'\'+\'_\'+\''+elementtype+'\'+\'_\'+\''+rdname+'\',\''+changeid+'\');return false">x</a>]</div>'

	}
	
	else if(elementtype=="TEXTBOXSIZE")
	{

		req_element='<div id="AJAXCUSTOMFIELD_'+changeid+'_'+elementtype+'" ><input type="hidden" name="textboxsize_'+changeid+'" value="select">'
		+ 'Enter Textbox size &nbsp;  &nbsp;: <input type="text"  size="5" value="'+elementval[0]+'" name="AJAXCUSTOMFIELD_'+changeid+'_'+elementtype+'"></div>'

	}

	else if(elementtype=="ROWS")
	{
		req_element='<div id="AJAXCUSTOMFIELD_'+changeid+'_'+elementtype+'" >'
		+ 'Rows&nbsp;&nbsp;: <input type="text"  size="5" name="AJAXCUSTOMFIELD_'+changeid+'_ROWS" value="'+elementval[0]+'">&nbsp;'
		+' Columns : <input type="text" size="5" name="AJAXCUSTOMFIELD_'+changeid+'_COLS" value="'+elementval[1]+'"></div>'
	}

	
	else{
			
		req_element='<div id="AJAXCUSTOMFIELD_'+changeid+'_'+elementtype+'_'+rdname+'" ><input type="'+elementtype+'" name="'+elementtype+'_'+changeid+'" >'
		+'<input type="text" name="AJAXCUSTOMFIELD_'+changeid+'_'+elementtype+'_'+rdname+'" value="'+elementval+'">'
		+'[<a href="#" ONCLICK="removeElement(\'AJAXCUSTOMFIELD_\'+\''+changeid+'\'+\'_\'+\''+elementtype+'\'+\'_\'+\''+rdname+'\',\''+changeid+'\');return false">x</a>]</div>'
	}
	return req_element;
}



function addElement(changeid,elementtype){
	document.getElementById("add"+elementtype+"Div_"+changeid).innerHTML+=getElement(changeid,elementtype,'')+'<div id="add'+elementtype+'Div_'+changeid+'"></div>';
}





function changeType(selected_type,optionarr){
	document.getElementById("attriberrors").innerHTML='';
	elementcountaraay[elementid]=new Array();
	var frm=document.getElementById('registerform');
	var count;
	var q;
	if(optionarr!=null&&optionarr.length>0)	
		count=optionarr.length;
	var attribtype=frm["AJAXCUSTOMFIELD_"+elementid+"_TYPE"];
	attribtype.value=selected_type;
	
	if(selected_type=="text"){
		
		attribtype.value="text";

		document.getElementById("typeDiv_"+elementid).innerHTML="Text";
		document.getElementById("AJAXCUSTOMFIELD_"+elementid+"_CHANGEDIVPARENT").innerHTML=''
				+getElement(elementid,"TEXTBOXSIZE",optionarr);

	}

	else if(selected_type=="textarea"){
		attribtype.value="textarea";
		document.getElementById("typeDiv_"+elementid).innerHTML="Multiline Text";
		document.getElementById("AJAXCUSTOMFIELD_"+elementid+"_CHANGEDIVPARENT").innerHTML=getElement(elementid,"ROWS",optionarr);
	
	}

	else if(selected_type=="radio"){
		attribtype.value="radio";

		document.getElementById("typeDiv_"+elementid).innerHTML="Radio Button";
		document.getElementById("AJAXCUSTOMFIELD_"+elementid+"_CHANGEDIVPARENT").innerHTML='';
		
		for(q=0;q<count;q++){
			if(optionarr[q]==null)optionarr[q]='';
		document.getElementById("AJAXCUSTOMFIELD_"+elementid+"_CHANGEDIVPARENT").innerHTML+=getElement(elementid,"radio",optionarr[q])
		}
		
		document.getElementById("AJAXCUSTOMFIELD_"+elementid+"_CHANGEDIVPARENT").innerHTML+='<div id="addradioDiv_'+elementid+'"></div>'
		+'<span style="cursor: pointer; text-decoration: underline" onclick="addElement(\''+elementid+'\',\'radio\')">Add another value</span>';
	}

	else if(selected_type=="dropdown"){
		
		attribtype.value="dropdown";

		document.getElementById("typeDiv_"+elementid).innerHTML="Drop Down";
		document.getElementById("AJAXCUSTOMFIELD_"+elementid+"_CHANGEDIVPARENT").innerHTML='';
		
		for(q=0;q<count;q++){
			if(optionarr[q]==null)optionarr[q]='';
		document.getElementById("AJAXCUSTOMFIELD_"+elementid+"_CHANGEDIVPARENT").innerHTML+=getElement(elementid,"select",optionarr[q])
		}
		
		document.getElementById("AJAXCUSTOMFIELD_"+elementid+"_CHANGEDIVPARENT").innerHTML+='<div id="addselectDiv_'+elementid+'"></div>'
		+'<span style="cursor: pointer; text-decoration: underline" onclick="addElement(\''+elementid+'\',\'select\')">Add another value</span>';
		
	
	}

	else if(selected_type=="checkbox"){
		
		attribtype.value="checkbox";

		document.getElementById("typeDiv_"+elementid).innerHTML="Checkbox";
		document.getElementById("AJAXCUSTOMFIELD_"+elementid+"_CHANGEDIVPARENT").innerHTML='';
		
		for(q=0;q<count;q++){
			if(optionarr[q]==null)optionarr[q]='';
		document.getElementById("AJAXCUSTOMFIELD_"+elementid+"_CHANGEDIVPARENT").innerHTML+=getElement(elementid,"checkbox",optionarr[q])
		}
		
		document.getElementById("AJAXCUSTOMFIELD_"+elementid+"_CHANGEDIVPARENT").innerHTML+='<div id="addcheckboxDiv_'+elementid+'"></div>'
		+'<span style="cursor: pointer; text-decoration: underline" onclick="addElement(\''+elementid+'\',\'checkbox\')">Add another value</span>';
	}
		

}



function getPopUpHere1(pelementid,curelement,event){

	elementid=pelementid;
	var popupdiv=document.getElementById("fortype");	
	popupdiv.style.left=alignLeft(curelement)+"px";
	popupdiv.style.top=alignTop(curelement)+curelement.offsetHeight-1+"px";
	popupdiv.style.display="block";
	return cancelEvent(event);
}


function alignLeft(curelement)
{
	return getAlignment(curelement,"offsetLeft");
}


function alignTop(curelement){

	return getAlignment(curelement,"offsetTop")
}



function getAlignment(curelement,alignposition)
{
	var pos=0;
	while(curelement)
	{
		pos+=curelement[alignposition];
		curelement=curelement.offsetParent;
	}
	return pos;
}


function hidePopUp1(){

	var popupdiv=document.getElementById("fortype");	
	popupdiv.style.display="none";	
	return true;
	
}

function cancelEvent(e){
if(!e)
{
	e = window.event;
}	
	if(e)
	{
		e.cancelBubble=true;
		e.returnValue=false;
	}
	return false;
	
}

 
function emptyTextBox(attribname){
	var frm=document.getElementById('registerform');
//	var attribname=frm["AJAXCUSTOMFIELD_"+elementid];
	//var attribname=frm[elementid];
	
	
	if(attribname.value=='Attribute Name')
	{
		attribname.value=""
	}

}

function swapDivElements(upid, downid){
	var upelement=document.getElementById('AJAXCUSTOMFIELD_'+upid);
	var downelement=document.getElementById('AJAXCUSTOMFIELD_'+downid);
	var elemvalue=upelement.value;
	upelement.value=downelement.value;
	downelement.value=elemvalue;
	
}

function getDivElement(elementid, attribname,isrequired,attribtype){
	var option1='';
	var option2='';
	if(isrequired=="Optional")
		option1='selected="selected"';
	else
		option2='selected="selected"';
        

	var html1='<table cellspacing="0" cellpadding="0" align="center" width="100%" class="taskbox">'
		+'<tr ><td  width="30%" >'
		+'<input type="text" valign="top" id="AJAXCUSTOMFIELD_'+elementid+'" name="AJAXCUSTOMFIELD_'+elementid+'" value="'+attribname+'" onfocus="emptyTextBox(this)">'
		+'</td>'
		+'<td  valign="top"><select id="AJAXCUSTOMFIELD_'+elementid+'_OPTIONREQUIRED" name="AJAXCUSTOMFIELD_'+elementid+'_OPTIONREQUIRED">'
		+'<option value="Optional" '+option1+'>Optional</option>'
		+'<option value="Required" '+option2+'>Required</option></select></td>'

		+'</tr>'
		
		+'<tr><td  valign="top">'
		+'<a  href="#" id="changeTypeAnchor_'+elementid+'" onclick="getPopUpHere1(\''+elementid+'\',this,event);this.blur(); return false;">'
		+'<font size="-1"><span name="typeDiv_'+elementid+'" id="typeDiv_'+elementid+'">Text</span>'
		+'<span id="changeTypeDiv_'+elementid+'">&nbsp;<img src="/home/images/pulldownarrow.gif" alt="" border="0"></span>'
		+'</font></a>'
		+'<input type="hidden" name="AJAXCUSTOMFIELD_'+elementid+'_TYPE" value="'+attribtype+'">'
		+'</td>'

		+'<td  valign="top"><div id="AJAXCUSTOMFIELD_'+elementid+'_CHANGEDIVPARENT">'
		+'</div></td></tr>'
		+'<tr><td><input type="button" name="button" value="Add" onclick="addAttributes()"/><input type="button" name="button" value="Cancel" onclick="chaangeattributes();"/></td></tr>';
		+'</table>';
	return html1;
}



function cancelTheBubble1(curevent){

	curevent=checkTheEvent(curevent);
	curevent.cancelBubble=true;
	if(curevent.stopPropagation)curevent.stopPropagation()
}


function checkTheEvent(curevent)
{

	if(!curevent)curevent=window.event;
	return curevent;

}




function checkform()
{
	var frm=document.getElementById('registerform');
	var i;
	var count=frm.elements.length;
	for (i=0;i<count;i++)
	{
		var ename=frm.elements[i].name;
		if(ename.indexOf('AJAX')>-1)
		{
			var celement=frm.elements[i].value;
			if ((celement=='Attribute Name')||(celement==''))
			{
				alert("Attribute name should not be empty");
				frm.elements[i].focus();
				return false;
			}
		}
	}
}
