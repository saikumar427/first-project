
 
 
 
 
 
 function getPopUpHere(abc){
 
	var curelement=document.getElementById("locationchange")
	var popupdiv=document.getElementById("locbox");	
	if(popupdiv){
	popupdiv.style.left=alignLeft(curelement)+"px";
	popupdiv.style.top=alignTop(curelement)+curelement.offsetHeight-1+"px";
	popupdiv.style.display=(popupdiv.style.display=='none'||popupdiv.style.display=='')?'block':'none';
	}
}


function alignLeft(curelement)
{
	return getAlignment(curelement,"offsetLeft");
}


function alignTop(curelement){

	return getAlignment(curelement,"offsetTop")
}


function hidePopUp(){
	var popupdiv=document.getElementById("locbox");	
	popupdiv.style.display="none";
	return true;
	
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


function buildTree(country,location,evttype){
      
		var countries=new Array("USA");
		
		var USA=new Array("USA","Albuquerque","Anchorage","Atlanta","Austin","Bay Area","Boise","Boston","Brevard County FL","Charlotte",
	"Chicago","Cincinnati","Cleveland","Colorado Springs","Columbus OH","Dallas","Denver","Detroit",
	"Fresno", "Hartford", "Honolulu", "Houston", "Indianapolis", "Jacksonville", "Kansas City", "Las Vegas",
	"Los Angeles", "Miami", "Milwaukee", "Minneapolis", "Nashville","New Jersey", "New Orleans", "New York",
	"Norfolk","Oklahoma City","Orlando", "Philadelphia", "Phoenix", "Pittsburgh", "Portland OR",
	"Providence", "Raleigh", "Richmond VA", "Sacramento", "Salt Lake City", "San Diego", "SF Bay Area",
	"Seattle", "St. Louis", "Tampa Bay Area", "Tucson", "Washington, D.C.","Other"); 
	
	
		var USA_new=new Array("USA","Austin","Boston","Chicago","Dallas","Houston","Los Angeles","New York","New Jersey","Pittsburgh","San Diego","Seattle","Other");
	
		var USA_lower=new Array("USA","albuquerque","anchorage","atlanta","austin","bayarea","boise","boston","brevardcountyfl","charlotte",
	"chicago","cincinnati","cleveland","coloradosprings","columbusoh","dallas","denver","detroit",
	"fresno", "hartford", "honolulu", "houston", "indianapolis", "jacksonville", "kansas", "lasvegas",
	"losangeles", "miami", "milwaukee", "minneapolis", "nashville","newjersey", "neworleans", "newyork",
	"norfolk","oklahoma","orlando", "philadelphia", "phoenix", "pittsburgh", "portlandor",
	"providence", "raleigh", "richmondva", "sacramento", "saltlake", "sandiego", "bayarea",
	"seattle", "stlouis", "tampabayarea", "tucson", "washington","other");
		var USA_new_lower=new Array("USA","austin","boston","chicago","dallas","detroit","houston","losangeles","newyork","newjersey","pittsburgh","sandiego","seattle","other");
		
		var locations=new Array(USA);
		var locations_new=new Array(USA_new);
		var locations_lower=new Array(USA_lower);
		var locations_new_lower=new Array(USA_new_lower);
		//var htmlcontent="<div STYLE='height: 290px; width: 145px; font-size: 12px; overflow:scroll;'>";
		var htmlcontent="<div class='locclose'> <a href='#' onclick= javascript:hidePopUp() >&times;</a></div>";
		htmlcontent+="<div id='loclist' >";
		for(var i=0;i<countries.length;i++){
			var classname="loccountry";
			var showexpand=false;
			
			
			//htmlcontent+="<div class='"+classname+"' ><a href='#' onClick=javaScript:getPage('cid="+countries[i]+"'); >"+countries[i]+"</a></div>";
				var locations1=locations[i];
				var locations2=locations_new[i];
				var locations1_lower=locations_lower[i];
				var locations2_lower=locations_new_lower[i];
				
				for(var j=0;j<locations1.length;j++){
				var classname1="loccity";
				var state="";
				if(location==locations1_lower[j]){
						classname1="locselected";
						state="&diams;";
				}
				for(var k=0;k<locations2.length;k++){
					if(locations1_lower[j]==locations2_lower[k]){
						classname1="loccitynew";
					}
				}
				
				//alert(locations1[j]);
				//var locval=(locations1[j]).replace(/\s+/gi,"");
				var locval=(locations1[j]).replace(" ","&nbsp;");
				//alert(locval);
				locval=locval.replace(" ","&nbsp;");
				//alert(locval);
				htmlcontent+="<div class='"+classname1+"' >"+state+"&nbsp;<a href='#' onClick= javascript:getPage('lid="+locations1_lower[j]+"&cid="+countries[i]+"','"+locval+"','"+evttype+"','"+locations1_lower[j]+"'); >"+locations1[j]+"</a></div>";
				}
			}
			htmlcontent+="</div>";
		elm=document.getElementById('locbox');
		elm.innerHTML=htmlcontent;
		elm.style.display=='none'
	}
	
	
function getPage(qstring,locval,evttype,searchloc){
 //alert(qstring);
 if(searchloc==null)searchloc='USA';
 //alert(searchloc);
 //alert(locval);
 //alert(evttype);
 var disptype='';
 if(evttype=='event')
 {
  disptype="Events in ";
  }
if(evttype=='class')
{
 disptype="Classes in ";
 }
 if(document.evtcat.keyword.value)
 {
 document.evtcat.keyword.value='';
 }
 advAJAX.get( {
	url : '/eventdetails/eventcatdisplay.jsp?'+qstring+'&evttype='+evttype,
	onSuccess : function(obj) {
	//alert('HIIII'+obj.responseText);
	//alert('before'+document.getElementById('eventcategories').innerHTML);
	document.getElementById("locbox").style.display = 'none';
	document.forms[0].action='/portal/eventdetails/eventlistings.jsp?evttype='+evttype+'&searchfrom=main&location='+searchloc;
	document.getElementById('message').innerHTML=obj.responseText;
    document.getElementById('locate').innerHTML=disptype+locval+' '+'<br/> <span id="locationchange" class="locchangelink"><a href="#"  onclick="getPopUpHere(this);">Change Location </a></span>';
    
    
	 },
    
	onError : function(obj) { alert("Error: " + obj.status); }
});
 
 
}

 