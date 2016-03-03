var sel_seatcodes=new Array();
var sel_ticket=new Object();
var ticket_count=new Object();
var ids="";
var ticketnameids=new Object();
var seating_ticketids=new Array();
var seatposition="";
var section_sel_seats=new Object();
var seatinfo=new Object();
var button="<center><input type='button' value='Select Ticket' id='accept' onclick='closeit(\"Y\")'><input type='button' value='Cancel' id='cancel' onclick='closeit(\"N\")'></center>";
var sel_select=new Object();	
var seatcode_ticid=new Object();
var sel=false;
var count=0;
var reg_timeout='';
var layoutcount=0;

function generateSeating(data){

	var idarr=[];
	var inc=0;
	json=data;
	var sectionid=document.getElementById('section').value;
	var header="headers_"+sectionid;
	var headerobj=json[header];
	var row_header=""+headerobj.rowheader;
	var col_header=""+headerobj.columnheader;
	var rowheader=row_header.split(",");
	var colheader=col_header.split(",");
	var finalseats=json.completeseats;
	ticketnameids=finalseats["s_1_1"].ticketnameids;
	
	var cell=document.getElementById("seatcell");
	
	while(cell.hasChildNodes()){
		cell.removeChild(cell.lastChild);
	}
	var table=document.createElement("table");
	table.setAttribute('border','0');
	table.setAttribute('align','center');
	table.setAttribute('id','seatstab');
	
	var tbody=document.createElement("tbody");
	
	for(var i=0;i<=json.noofrows;i++){
	var row=document.createElement("tr");
	row.setAttribute("id","row_tr_"+i)
	for(var j=0;j<=json.noofcols;j++){
	var col=document.createElement("td");
	sel_select[sectionid+"_"+i+"_"+j]=false;
	if(i==0||j==0){
	
		col.setAttribute('align','center');
		col.setAttribute('id','header_'+sectionid+"_"+i+"_"+j);
		
		var p=document.createElement("div");
		if(i==0&&j>0&&colheader[j-1]!=undefined&&colheader[j-1]!=""){
		p.innerHTML=colheader[j-1];
		col.className="layoutheader";
		
		}
		if(i>0&&j==0&&(rowheader[i-1]!=undefined&&rowheader[i-1]!="")){
		p.innerHTML=rowheader[i-1];
		col.className="layoutheader";
		}
		col.appendChild(p);
	}else{
		var ttHtml="";
		var sid="s_"+i+"_"+j;
		
		var type=finalseats[sid].type;
		var ticketname=finalseats[sid].ticketname;
		
		var ticketid=finalseats[sid].ticketids;
		
		if(ticketid==undefined)ticketid=[];
		else
			ticketid=getavailableticketid(ticketid);
			
		
		var scode=finalseats[sid].seatcode;
		if(scode=="EMPTY") scode="";
		var imgsrc="";
		ttHtml=ttHtml+"Seat Number: "+scode;
		if(type){
			imgsrc="/main/images/seatingimages/"+type+".png";
			col.className=type;
			
			if(ticketid==undefined||ticketid.length==0){
				
				if(type.indexOf("SO")>-1){
				
						ttHtml=ttHtml+" <br><b><font color='red'>Sold Out</font></b>";
						//var curtype=type.split("_");
						//imgsrc="/main/images/seatingimages/"+curtype[0]+"_sold.png";
						imgsrc="/main/images/seatingimages/lightgray_sold.png";
					}
				else{
					col.className='unassign';
					imgsrc="/main/images/seatingimages/lightgray_blank.png";
					ttHtml=ttHtml+"<br><b><font color='red'>Not Available</font></b>";
					}
				}
			else{
				if(type.indexOf("SO")>-1){
						ttHtml=ttHtml+" <br><b><font color='red'>Sold Out</font></b>";
						//var curtype=type.split("_");
						//imgsrc="/main/images/seatingimages/"+curtype[0]+"_sold.png";
						imgsrc="/main/images/seatingimages/lightgray_sold.png";
					}
				else if(type.indexOf("Hold")>-1){
					ttHtml=ttHtml+"<br><b><font color='black'>This seat is currently on hold</font></b>";
					//var curtype=type.split("_");
					//imgsrc="/main/images/seatingimages/"+curtype[0]+"_exclaimation.png";
					imgsrc="/main/images/seatingimages/lightgray_exclaimation.png";
				}
				else if(type.indexOf("NA")>-1 ){
					ttHtml=ttHtml+"<br><b><font color='red'>Not Available</font></b>";
				}
				else if(type=="noseat"){
						//ttHtml="<b>No Seat</b>";
						ttHtml='';
						seatposition="";
						}
			}
		}
		else{
		col.className='unassign';
		imgsrc="/main/images/seatingimages/lightgray_blank.png";
		ttHtml=ttHtml+"<br><b><font color='red'>Not Available</font></b>";
		}
		
	
		ttHtml=ttHtml+seatposition;
		if(type!="noseat"){
		var img=document.createElement("img");
		img.setAttribute("src",imgsrc);
		img.setAttribute("height","17px");
		img.setAttribute("width","17px");
		
		var sc_index_tic=finalseats[sid].seat_ind;
		
			var a=new Array();
		if(seatcode_ticid[sc_index_tic]!=undefined){
			seatcode_ticid[sc_index_tic]=a;
		}if(ticketid!=undefined)
			a.push(ticketid);	
		seatcode_ticid[sc_index_tic]=a;
			
		
		col.appendChild(img);
		
		col.setAttribute('align','center');
		
		if(!ticketname || ticketname==''){
			}
		else{
		if(ticketid!=undefined && ticketid.length>0 && type.indexOf("SO")==-1 && type.indexOf("Hold")==-1){
			ttHtml=ttHtml+'<br><br><u><b>Available for Tickets:</b></u>';
			ttHtml=ttHtml+"<ul>";
			for(k=0;k<ticketid.length;k++){
				var tktID=ticketid[k];
				var groupname='';
				if($('ticketGroup_'+tktID)){
				var groupid=$('ticketGroup_'+tktID).value;
				
			if(ticket_groupnames[groupid]!=undefined){
				groupname='&nbsp;('+ticket_groupnames[groupid]+')';
			}
				ttHtml=ttHtml+"<li>"+ticketnameids[tktID]+groupname+"</li>";
				}else{
					ttHtml=ttHtml+"<li>"+ticketnameids[tktID]+"</li>";
				}
			}
		}
		ttHtml=ttHtml+"</ul>";
		
		}
		
			//ttHtml=ttHtml+"<br>Row: <b>"+i+"</b>"+" Column: <b>"+j+"</b>";
		
			idarr[inc]=col;
			inc++;
		}	
		col.setAttribute('id',finalseats[sid].seat_ind);
		
		seatinfo[finalseats[sid].seat_ind]=ttHtml;
			
		
	}
	row.appendChild(col);
	}
	tbody.appendChild(row);
	}
	table.appendChild(tbody);
	cell.appendChild(table);
	/*
	for(k=1;k<=json.noofrows;k++){
		if(k%2==0){
			var row="#row_td_"+k;
			alert(row);
			jQuery(row).animate({"left": "+=8px"}, 1000, function() {
			alert("s"+row);
	  		//var div=$('ticket_timer');
		   // div.className='ticket_timer';
	    });
			
			// jQuery(row).animate({"left": "+=8px"}, "fast");
		}
	}
	*/
	var div=document.createElement("div");
	div.setAttribute('id','divpopup');
	div.className='ticketwidget';
	div.setAttribute('style','display:none;');
	cell.appendChild(div);
	settooltip(idarr);
if($('orderbutton'))$('orderbutton').disabled=false;

jQuery("#seatstab img").click(function(){
ids=jQuery(this).parent('td').attr('id');
if(sel_select[ids]==undefined){
	var a=new Array();
		a.push(false);
		sel_select[ids]=a;
		
}
	if(sel_select[ids]==true){
		sel_select[ids]=false;
		jQuery(this).css("border","0px none");
		jQuery(this).parent("td").attr("style","");
		var allticids=seatcode_ticid[ids];
		//var allticids=jQuery(this).attr("ticketid");
		ticid=getTicketIdforSelectedSeat(ids,allticids);
		remove_seats(ids,ticid);
		restoreoldtooltip(ids);
	}
	else{
		sel_select[ids]=true;
		var chkclass=jQuery(this).parent("td").attr('class');
		if(chkclass!=""&&chkclass!="noseat"&&chkclass!="unassign"&&chkclass!="white_NA"&&chkclass.indexOf('SO')==-1&&chkclass.indexOf('Hold')==-1){
			ids=jQuery(this).parent('td').attr('id');
			var sel_ticid=seatcode_ticid[ids];
			//var sel_ticid=jQuery(this).attr('ticketid');
			sel_ticid=""+sel_ticid;
			var selticketid=new Array();
			selticketid=sel_ticid.split(",");
			if(selticketid.length==1){
				jQuery(this).css("border","1px solid red");
				
				var cur_title=seatcode_ticid[ids];
				//var cur_title=jQuery(this).attr('ticketid');
				var cur_id=jQuery(this).attr('id');
				sel_seatcodes.push(cur_id);
				
				fillticketqty(cur_title);
			}
			else if(selticketid.length > 1){
				ids=jQuery(this).parent('td').attr('id');
				var radio="<p style='text-align:left; margin-top:-15px;'>This seat is assigned to multiple Ticket Types, select one</p><a href='javascript:closeit(\"N\");'><img src='/home/images/images/close.png' class='imgclose'></a>";
				radio=radio+"<table>"
				for(i=0;i<selticketid.length;i++){
					var tktID=selticketid[i];
					var groupname='';
					var groupid=$('ticketGroup_'+tktID).value;
					if(ticket_groupnames[groupid]!=undefined){
						groupname='&nbsp;('+ticket_groupnames[groupid]+')';
					}	
					radio=radio+"<tr><td valign='top' align='left'><input type='radio' name='selticketid' id='selticketid' value='"+selticketid[i]+"'></td><td valign='top' align='left'> "+ticketnameids[tktID]+groupname+"</td></tr>";
				}
				radio=radio+"</table>";
				changeBg(radio+button);
			}
			else{
				alert("not available or no seats assigned to this seat");
			}
		}
		}
});
}

function settooltip(idarr){
seatsTooltip = new YAHOO.widget.Tooltip("seatsTooltip", { 
   		 context: idarr,
		 disabled: false,
		 showdelay: 0,
		 hidedelay:0
 	});
 	seatsTooltip.contextTriggerEvent.subscribe( 
	    function(type, args) { 
	        var context = args[0]; 
			
	        this.cfg.setProperty("text",  seatinfo[context.id]); 
			
	    } 
	); 
}

function addticketidinall(ticketid){
if(seating_ticketids.length>1){

}
else{
seating_ticketids[0]=ticketid;
}
}

function changeBg(radio){
	if(document.getElementById("backgroundPopup")){
		document.getElementById("backgroundPopup").style.display='block';
	}
	//jQuery('#divpopup').bgiframe();
	document.getElementById('divpopup').innerHTML=radio;
	document.getElementById('divpopup').style.display="block";
	document.getElementById('divpopup').style.top='50%';
	document.getElementById('divpopup').style.left='30%';
	scrollTo(0,150);
	//jQuery( "#divpopup" ).draggable();
	
}
function closeit(type){
	if(type=='Y' && document.getElementById('accept').value=="Select Ticket"){
		var selticktemp=document.getElementsByName('selticketid');
		for(var i = 0; i < selticktemp.length; i++){
			if(selticktemp[i].checked){
				//jQuery("#"+ids).attr("style","border:1px solid black;");
				jQuery("#"+ids+" img").attr("style","border:1px solid red;");
				sel_select[ids]=true;
				sel_seatcodes.push(selticktemp[i].value);
				fillticketqty(selticktemp[i].value);
				break;
			}
			else{
				sel_select[ids]=false;
			}
		}

	}
	else{
		sel_select[ids]=false;
	}
	$("divpopup").innerHTML='';
	$("divpopup").hide();
	if(document.getElementById("backgroundPopup")){
			document.getElementById("backgroundPopup").style.display='none';
	}
}


function fillticketqty(id){
	
	var cur_id="qty_"+id;
	var show_id="show_"+id;
	var count=0;
	var tic_dropdown=document.getElementById(cur_id).value;
	var min_qty=min_ticketid[id];
	var max_qty=max_ticketid[id];
	count=ticket_count[cur_id];

	if(count==undefined){
		count=0;
	}
	count++;
	ticket_count[cur_id]=count;
	if(count>=min_qty && count<=max_qty){
		tic_dropdown=Number(tic_dropdown)+1;
		
		document.getElementById(cur_id).value=tic_dropdown;
		document.getElementById(show_id).innerHTML=tic_dropdown;
		//tic_dropdown.selectedIndex=tic_dropdown.selectedIndex+1;
		
		add_seats(ids,id);
	}
	else{
		if(count<min_qty){
			tic_dropdown=Number(tic_dropdown)+1;
			document.getElementById(cur_id).value=tic_dropdown;
			alert("for \""+ticketnameids[id]+"\" ticket, you need to select minimum of "+min_qty+" seats");
			add_seats(ids,id);
		}
		else if(count>max_qty){
			alert("maximum quantity reached for \""+ticketnameids[id]+"\" ticket type");
			remove_extra(ids,id);
		}
		
	}

}

function add_seats(seatid,ticketid){
/*start-ticket level seats selection */
	if(sel_ticket[ticketid]==undefined){
		var a=new Array();
		a.push(seatid);
		sel_ticket[ticketid]=a;
		
	}
	else{
		var a=sel_ticket[ticketid];
		a.push(seatid);
		sel_ticket[ticketid]=a;
	}
	/*End-ticket level seats selection*/
	/*Start Section level selected seats*/
	if(section_sel_seats[sectionid]==undefined){
		var a=new Array();
		a.push(seatid);
		section_sel_seats[sectionid]=a;
	}
	else{
		var a=section_sel_seats[sectionid];
		a.push(seatid);
		section_sel_seats[sectionid]=a;
	}
	/*End-section level selected seats*/
	addselectiontotooltip(seatid,ticketid);
}

function remove_extra(seatid,ticketid){
	var drop_down_id="qty_"+ticketid;
	var	removecount=ticket_count[drop_down_id];

	if(removecount!=undefined){
		removecount--;
		ticket_count[drop_down_id]=removecount;	
	}
	jQuery("#"+seatid+" img").css("border","0px none");
	jQuery("#"+seatid).css("border","0px none");
	sel_select[seatid]=false;
}

function remove_seats(seatid,ticketid){
	var drop_down_id="qty_"+ticketid;
	var drop_down_id1="show_"+ticketid;
	var	removecount=ticket_count[drop_down_id];
	if(removecount!=undefined){
		removecount--;
		ticket_count[drop_down_id]=removecount;	
		
		
	}
	
	var drop_down=document.getElementById(drop_down_id).value;
	var seat_temp=section_sel_seats[sectionid];
	if(seat_temp!=undefined){
		for(l=0;l<seat_temp.length;l++){
			if(seat_temp[l] == seatid){
				seat_temp.splice(l,1);
				section_sel_seats[sectionid]=seat_temp;
			}
		}
	}
	var temp=sel_ticket[ticketid];
		if(temp!=undefined){
			
			for( var k = 0; k < temp.length; k++ )
				{
					if( temp[ k ] == seatid )
					{
						temp.splice(k,1); 
						sel_ticket[ticketid]=temp;
						if(drop_down!=0){
							drop_down=Number(drop_down)-1;
							document.getElementById(drop_down_id).value=drop_down;
							document.getElementById(drop_down_id1).innerHTML=drop_down;
							if(drop_down!=0 && drop_down<min_ticketid[ticketid]){
								document.getElementById(drop_down_id1).innerHTML=0;
								alert("you need to select mininmum of "+min_ticketid[ticketid]+" for \""+ticketnameids[ticketid]+"\" ticket type");
							}
							
							}
						break;
					}
				}
		}
}


function getTicketIdforSelectedSeat(sid,allticketid){
	var selticid="";
	allticketid=""+allticketid;
	var ticid=allticketid.split(",");
	for(i=0;i<ticid.length;i++){
		var id=ticid[i];
		var temp=sel_ticket[id];
		if(temp!=undefined){
			for( var k = 0; k < temp.length; k++ )
				{
					if( temp[ k ] == sid )
					{
						selticid = id;
						break;
					}
				}
		}

	}
	return selticid;
}


function generate_Sectiondropdown(allsectionid,allsectionname){
var select="<select name='section' id='section' onchange='getsection()' >"
for(i=0;i<allsectionid.length;i++){
select=select+"<option value="+allsectionid[i]+">"+allsectionname[i]+"</option>";
}
select=select+"</select>";
return select;
}


function getsection(){
var sec_id=document.getElementById("section").value;
sectionid=document.getElementById("section").value;
generateSeating(seatingsectionresponsedata.allsections[sec_id]);
getsectionlevelselectedseats();
}


function getsectionlevelselectedseats(){
	var temp=new Array();
	temp=section_sel_seats[sectionid];
	if(temp!=undefined){
		for(i=0;i<temp.length;i++){
			//jQuery("#"+temp[i]+" img").attr("style","border:1px solid black;");
			jQuery("#"+temp[i]+" img").attr("style","border:1px solid red;");
			sel_select[temp[i]]=true;
			
			
		}
	}
	
}




function getseatingtimer(){
	
	var divpopup=document.createElement("div");
	divpopup.setAttribute('id','ticketpoup_div');
	divpopup.className='ticketpoup_div';
	var cell=$('container');
	var div=document.createElement("div");
	div.setAttribute('id','ticket_timer');
	div.className='ticket_timer';
	//div.className='initial_timer';
	div.setAttribute('style','display:block;');
	cell.appendChild(div);
	cell.appendChild(divpopup);
	$('ticket_timer').innerHTML='Time left to buy<br>';
	//window.scrollTo("0","25");
	var divcell=$('ticket_timer');
	var span=document.createElement("div");
	span.setAttribute('id','time_left_tobuy');
	span.setAttribute('class','spannormal');
	divcell.appendChild(span);
	mins_left = 14;
	//mins_left=0;
    s_left = 60;
	//s_left = 10;
	mins_remain=14;
	secs_remain=60;
	/*
	jQuery('#ticket_timer').animate({
	 jQuery("#ticket_timer").animate({"left": "+=50px"}, "slow");
	 
	 });

	jQuery('#ticket_timer').animate({"left": "+=600px"}, 2000, function() {
		jQuery('#ticket_timer').animate({"top": "+=450px"}, 2000, function() {
	  		//var div=$('ticket_timer');
		   // div.className='ticket_timer';
	    });
	});
	*/
	fifteenMinutes();
}

function fifteenMinutes(){

   s_left--;
if(s_left<0) {
   s_left="59";
   mins_left--;
}

if(mins_left==-1) {
	clearTimeout(reg_timeout);
	getconfirmationpopup();
}
else{
if(mins_left<10) {
   mins_remain='0'+mins_left;
}
else {
   mins_remain=mins_left;
}
if(s_left<10) {
   secs_remain='0'+s_left;
}
else {
   secs_remain=s_left;
}

   document.getElementById('time_left_tobuy').innerHTML='<center>'+mins_remain+':'+secs_remain+'</center>';
	
	
  reg_timeout=setTimeout('fifteenMinutes()',1000);
}
   }
   
 function getconfirmationpopup(){
	var divpopupcontent="Sorry, timed out!<br><input type='button' value='Try Again' onclick='seatingtryagain()'><a href=# onclick=seatingcancel()><img src='/home/images/close.png' class='divimage'></a>";
	
	//jQuery("").attr("tabindex", "-1");;;
	if($('registration')){
		jQuery("#registration input").attr("tabindex", "-1");
		jQuery("#registration a").attr("tabindex", "-1");
		jQuery("#registration select").attr("tabindex", "-1");
	}
	if($('profile')){
		jQuery("#profile input").attr("tabindex", "-1");
		jQuery("#profile a").attr("tabindex", "-1");
	}
	if($('paymentsection')){
		jQuery("#paymentsection input").attr("tabindex", "-1");
		jQuery("#paymentsection a").attr("tabindex", "-1");
	}
	if(document.getElementById("backgroundPopup")){
		document.getElementById("backgroundPopup").style.display='block';
	}
	
	//jQuery('#ticketpoup_div').bgiframe();
	document.getElementById('ticketpoup_div').innerHTML=divpopupcontent;
	document.getElementById('ticketpoup_div').style.display="block";
	document.getElementById('ticketpoup_div').style.top='50%';
	document.getElementById('ticketpoup_div').style.left='26%';
	window.scrollTo("0","150");
}

function seatingtryagain(){
	$('ticketpoup_div').hide();
	document.getElementById('ticketpoup_div').innerHTML='';
	if(document.getElementById("backgroundPopup")){
		document.getElementById("backgroundPopup").style.display='none';
	}
	del_seat_temp();
	getTicketsPage();
} 
   
function seatingcancel(){
	del_seat_temp_cancel();
	//var t=setTimeout('window.location.reload()',2000);
} 


function delete_locked_temp(tid){
	new Ajax.Request('/embedded_reg/seating/delete_temp_locked_tickets.jsp?timestamp='+(new Date()).getTime(), {
	method: 'post',
	parameters:{eid:eventid,tid:tid},
	onComplete:hidetimer
	});
}
function hidetimer(){
if($('paymentsection')){
		$('paymentsection').hide();
		$('paymentsection').innerHTML='';
	}
	if($('ticket_div')){
		$('ticket_div').hide();
	}
	if($('ticket_timer')){
		$('ticket_timer').remove();
		clearTimeout(reg_timeout);
	
	}
}


function del_seat_temp_cancel(){
	
	new Ajax.Request('/embedded_reg/seating/delete_tempseats.jsp?timestamp='+(new Date()).getTime(), {
	method: 'post',
	parameters:{eid:eventid,tid:tranid},
	onComplete:window.location.reload()
	});
}

function hidetimerpopup(){
	if($('ticketpoup_div')){
		var div=$('ticketpoup_div');
		div.className='ticketpoup_div1';
	}
}

function displaydivpopuptimeup(){
	if($('ticketpoup_div')){
		if(mins_left==-1){
			var div=$('ticketpoup_div');
			div.className='ticketpoup_div';
			if(document.getElementById("backgroundPopup")){
				document.getElementById("backgroundPopup").style.display='block';
			}
		}
	}
}


function resetobjectdata(){
var a=[];
sel_seatcodes=[];

for(i=0;i<=allsectionid.length;i++){
	if(section_sel_seats[allsectionid[i]]!=undefined){
		section_sel_seats[allsectionid[i]]=a;
	}
}
for(i=0;i<ticketsArray.length;i++){
	var drop_down_id="qty_"+ticketsArray[i];
	if(sel_ticket[ticketsArray[i]]!=undefined){
		sel_ticket[ticketsArray[i]]=a;
	}
	if(ticket_count[drop_down_id]!=undefined){
		ticket_count[drop_down_id]=a;
	}
}
	
}

function getvenuelayout(url){

if($('layoutpopup')){
	//var div=document.getElementById('layoutpopup');
	//div.setAttribute('width','550px');
	//div.setAttribute('height','400px');
}
else{
var cell=$('seatcell');
	var div=document.createElement("div");
	div.setAttribute('id','layoutpopup');
	div.className='layoutwidget';
	cell.appendChild(div);
	jQuery( "#layoutpopup" ).draggable();
	
}
var layout="<a href='javascript:closepopuplayout();'><img src='/home/images/close.png' class='imgclose'></a><iframe width='100%' height='100%' src='"+url+"' resizeIFrame=true frameborder='0' allowfullscreen></iframe>";
document.getElementById('layoutpopup').innerHTML=layout;
document.getElementById('layoutpopup').style.display='block';
document.getElementById('layoutpopup').style.top='35%';
	document.getElementById('layoutpopup').style.left='15%';
	//if(document.getElementById("backgroundPopup"))
	//	document.getElementById("backgroundPopup").style.display='block';
	window.scrollTo("0","150");
	jQuery( "#layoutpopup" ).resizable();
	


}

function closepopuplayout(){
	//if(document.getElementById("backgroundPopup")){
	//	document.getElementById("backgroundPopup").style.display='none';
	//}
	if($('layoutpopup')){
		$('layoutpopup').style.display='none';
	}
}


function getavailableticketid(ticketid){
for (var i = 0; i<notavailableticketids.length; i++) {
		var arrlen = ticketid.length;
		for (var j = 0; j<arrlen; j++) {
			if (notavailableticketids[i] == ticketid[j]) {
				ticketid = ticketid.slice(0, j).concat(ticketid.slice(j+1, arrlen));
			}
		}
	}
return ticketid;
}



function showmemberseats(){

for(i=0;i<memberseatticketids.length;i++){

	var cur_id=memberseatticketids[i];
	var dropdown_id='qty_'+cur_id;
	var dropdown_id1='show_'+cur_id;
	var td_id="td_ticketid_"+cur_id;
	$(td_id).innerHTML="";
	$(td_id).innerHTML="<center title='Select Seats below'><span id='"+dropdown_id1+"' style='font-size:14px;margin-left:40px' >0</span></center><input value='0' type='hidden' name='"+dropdown_id+"' id='"+dropdown_id+"'>Select seats";
	
}
enablememberseats();
}


function enablememberseats(){
	for (var i = 0; i<memberseatticketids.length; i++) {
		var arrlen = notavailableticketids.length;
		for (var j = 0; j<arrlen; j++) {
			if (memberseatticketids[i] == notavailableticketids[j]) {
				notavailableticketids = notavailableticketids.slice(0, j).concat(notavailableticketids.slice(j+1, arrlen));
			}
		}
	}
	getsection();

}



function addselectiontotooltip(seatid,ticketid){
var tooltip=seatinfo[seatid]+"";
var newtip=tooltip.split("<u>");
tooltip=newtip[0]+"<u><b>Current Selection:</b></u><br><ul><li>"+ticketnameids[ticketid]+"</li></ul><br><u>"+newtip[1];
seatinfo[seatid]=tooltip;

}


function restoreoldtooltip(seatid){
var tooltip=seatinfo[seatid]+"";
var newtip=tooltip.split("<u>");
tooltip=newtip[0]+"<u>"+newtip[2];
seatinfo[seatid]=tooltip;
}


function clearallselections(){
	for(i=0;i<ticketsArray.length;i++){
		var ticketd=ticketsArray[i];
		if(document.getElementById("qty_"+ticketd)){
			document.getElementById("qty_"+ticketd).value=0;
			if(document.getElementById("show_"+ticketd))
				document.getElementById("show_"+ticketd).innerHTML=0;
		}
	}
    if($('seatingsection')){
		getseatingsection();
	}
}


function getTicketsAvailabilityMsg(){
	var data=tktsData.availibilitymsg;
	for(i=0;i<ticketsArray.length;i++){
		var tktid=ticketsArray[i];
		if(data[tktid]!=undefined){
			var str=data[tktid];
			var capacity=data["capacity_"+tktid];
			var soldqty=data["soldqty_"+tktid];
			var holdqty=data["hold_"+tktid];
			var remainingqty=Number(data["remaining_"+tktid])-Number(holdqty);
			if(remainingqty<0)remainingqty=0;
			str = str.replace(/\$capacity/g,capacity);
			str=str.replace(/\$soldOutQty/g,soldqty);
			str=str.replace(/\$remainingQty/g,remainingqty);
			str=str.replace(/\$onHoldQty/g,holdqty);
			str="<pre  style='font-family: verdana; font-size:10px; line-height:100%; padding:0px; margin:0px; white-space: pre-wrap; white-space: -moz-pre-wrap !important; white-space: -pre-wrap; white-space: -o-pre-wrap; word-wrap: break-word;color:#666666;'>"+str+"</pre>";
			//str="<span class='small' >"+str+"</span>";
			if($(tktid)){
				var availmsg="availmsg_"+tktid;
				var cellid="divmsg_"+tktid;
				var cell=$(cellid);
				var div=document.createElement("div");	
				div.setAttribute("id",availmsg);
				div.setAttribute("class","small");
				div.setAttribute("width","55%");
				cell.appendChild(div);
				
				if($(availmsg))
					$(availmsg).innerHTML=str;
			}
		}	
	}

}

function emailcheck(str) {
		var at="@"
		var dot="."
		var lat=str.indexOf(at)
		var lstr=str.length
		var ldot=str.indexOf(dot)
		if (str.indexOf(at)==-1){
		   return false
		}

		if (str.indexOf(at)==-1 || str.indexOf(at)==0 || str.indexOf(at)==lstr){
		   return false
		}

		if (str.indexOf(dot)==-1 || str.indexOf(dot)==0 || str.indexOf(dot)==lstr){
		    return false
		}

		 if (str.indexOf(at,(lat+1))!=-1){
		    return false
		 }

		 if (str.substring(lat-1,lat)==dot || str.substring(lat+1,lat+2)==dot){
		    return false
		 }

		 if (str.indexOf(dot,(lat+2))==-1){
		    return false
		 }
		
		 if (str.indexOf(" ")!=-1){
		    return false
		 }

 		 return true					
	}

function Validate_email(emailID){
	if ((emailID==null)||(emailID=="")){
		return false
	}
	if (emailcheck(emailID)==false){
		return false
	}
	return true
 }

function getemailmessage(type){
	if(type){
		if($('email_err_msg')){
			$('email_err_msg').innerHTML='';
			$('email_err_msg').style.display='none';
		}
	}
	else{
		if($('email_err_msg')){
		}
		else{
			var cell=$('buyer_email_1');
			var div=document.createElement('div');
			div.setAttribute('id','email_err_msg');
			div.setAttribute("style","color: red;");
			cell.appendChild(div);
		}
		$('email_err_msg').innerHTML='Invalid Email';
		$('email_err_msg').style.display='block';
	}
}

function setTicketGroupDescription(eleid){
	   var ele=document.getElementById(eleid);
	   document.getElementById("desc_"+eleid).style.display="none";
	   ele.innerHTML = ele.innerHTML + ' <img style="cursor:pointer;" id="imgShowHidegrp_'+eleid+'" src="/home/images/expand.gif" onClick=showTcktGrpDescr('+eleid+');>';
}
function showTcktGrpDescr(eleid){
	   var a=document.getElementById("desc_"+eleid).style.display;
	   if(a=="none"){
			   document.getElementById("imgShowHidegrp_"+eleid).src="/home/images/collapse.gif";
			   document.getElementById("desc_"+eleid).style.display="block";
	   }else{
			   document.getElementById("imgShowHidegrp_"+eleid).src="/home/images/expand.gif";
			   document.getElementById("desc_"+eleid).style.display="none";
	   }
	   
}