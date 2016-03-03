

var date = new Date();

var evtid="";
var oneupval=1;
var url1="";
var upurl="";
function testtrim(str)
{
var temp='';
temp=new String(str);
temp=temp.replace(/[^a-zA-Z 0-9]+/g,'');

return temp;



}

function changeStatus(evtid) {
var status=document.getElementById("statusval").innerHTML;
	advAJAX.get( {
		url   : '/networkadvertising/networkadvstatus.jsp?GROUPID='+evtid+'&status='+status,
	    onSuccess : function(obj) {
	    var val=obj.responseText;
	    val=testtrim(val);
	      document.getElementById("status").value=val; 
	   if(val.indexOf("Stop")>-1)
	   document.getElementById("statusval").innerHTML="Active"; 
	   else
	    document.getElementById("statusval").innerHTML="Stopped"; 
	  
	   
	   },
	    	onError : function(obj) { 
		//alert("Error: " + obj.status); 
		}
	});
}


function getAdvcostsblock(evtid,url){
advAJAX.get( {
		url   : url+'?GROUPID='+evtid+'&status='+status,
	    onSuccess : function(obj) {
	    var val=obj.responseText;
	    if(document.getElementById("networkadvertisementblock"))
	      document.getElementById("networkadvertisementblock").innerHTML=val; 
	       },
	      	    	onError : function(obj) { 
	      		//alert("Error: " + obj.status); 
		}
	  
	  });



}



function editcost(price,id,url,eventid,updateurl){
evtid=eventid;
upurl=updateurl;

evtid=document.getElementById('GROUPID').value;
	url1=url;
	
	var currentAmount=price;
	oneupval+=oneupval;
	type=id;
	document.getElementById(id+'link').innerHTML='<span style="cursor: pointer; text-decoration: underline" onclick=makeRequest(url1+"?GROUPID="+evtid+"&pt="+date.getTime()+oneupval,"networkadvertisementblock")>Cancel</span>';
	if(type=='cpm'){
	document.getElementById(id+'amount').innerHTML=""
	+"$<input type='text' name='editcpm'  id='editcpm' size='5' value='"+price+"' />"
	+" &nbsp;<input type='button' name='go'  value='Update' onclick='updateCost()'>";
	}
	else{
	document.getElementById(id+'amount').innerHTML=""
	+"$<input type='text' name='editcpc'  id='editcpc' size='5' value='"+price+"'  />"
	+" &nbsp;<input type='button' name='go'  value='Update' onclick='updateCost()'>";
	}
	
}






function updateCost(){
currentval='0';
if(type=='cpm')
var myprice=document.getElementById('editcpm').value;
else
var myprice=document.getElementById('editcpc').value;

 advAJAX.get( {
	 	    		url :upurl +'?GROUPID='+evtid+'&price='+myprice+'&type='+type,
	    		onSuccess : function(obj) {
	    		var data=obj.responseText;
	    		var cpcval=type.toUpperCase();
if(data.indexOf("Success")>-1){
finalupdate(url1+"?update=yes&GROUPID="+evtid);
}
else if(data.indexOf("failure")>-1){
   
  document.getElementById('adverror').innerHTML= cpcval+' for network Advertsing should be a positive value.';
}
else if(data.indexOf("empty")>-1){
document.getElementById('adverror').innerHTML= cpcval+'  for network Advertsing should not be empty.';
}
else if(data.indexOf("Invalid")>-1)

	  document.getElementById('adverror').innerHTML='Enter a valid '+cpcval+' price .';

else if(data.indexOf("CLK")>-1)

	  document.getElementById('adverror').innerHTML='Minimum CPC amount should be $0.50 .';

else if(data.indexOf("IMP")>-1)

	  document.getElementById('adverror').innerHTML='Minimum CPM amount should be $10 .';



	               },
	              onError : function(obj) { alert("Error: " + obj.status);}
	});
   
            
}


function finalupdate(url){
 advAJAX.get( {
	 	    		url : url,
	    		onSuccess : function(obj) {
	    		var data=obj.responseText;
	    		document.getElementById('networkadvertisementblock').innerHTML=data;
			       	    	
					
	               },
	              onError : function(obj) { alert("Error: " + obj.status);}
	});
   
            
}


