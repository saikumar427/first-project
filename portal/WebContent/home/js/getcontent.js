var _ms_XMLHttpRequest_ActiveX;
function getPage(qstring){
 if(PAGE_LINK)
 window.location.href=PAGE_LINK+qstring+"&t=y";
 else
 window.location.href='/portal/home.jsp?'+qstring+"&t=y";
}
function trim(s1)
 	{
		s1=ltrim(s1);
		s1=rtrim(s1);
		return s1;
 	}
function ltrim(s1)
 {
	for(i=0;i<s1.length;i++){
		if(s1.charAt(i)==' ' || s1.charAt(i)=='\t' || s1.charAt(i)=='\n'){

		}
		else{
			s1=s1.substr(i)
			break;
		}
		if(i==s1.length-1)
		s1="";
	}

	return s1;
 }
function rtrim(s1)
 {
	for(i=s1.length-1;i>=0;i--){
		if(s1.charAt(i)==' ' || s1.charAt(i)=='\t' || s1.charAt(i)=='\n'){
		}
		else{
			s1=s1.substring(0,i+1);
			break;
		}
		if(i==0)
		s1="";
	}
	return s1;
 }

function collapse(id){
	elm=document.getElementById(id);
	if (elm){
		if(elm.style.display=='none'){
			elm.style.display='block';
			document.getElementById(id+'_img').src="";
			document.getElementById(id+'_img').src="/home/images/downarrow.gif";
		}else{
			elm.style.display='none';
			document.getElementById(id+'_img').src="";
			document.getElementById(id+'_img').src="/home/images/uparrow.gif";
		}
	}
}
function getPopUpHere(abc){
	var curelement=document.getElementById("locationchange")
	var popupdiv=document.getElementById("locbox");	
	if(popupdiv){
	popupdiv.style.left=alignLeft(curelement)+"px";
	popupdiv.style.top=alignTop(curelement)+curelement.offsetHeight-1+"px";
	popupdiv.style.display=(popupdiv.style.display=='none'||popupdiv.style.display=='')?'block':'none';
	}
}

function hidePopUp(){
	var popupdiv=document.getElementById("locbox");	
	popupdiv.style.display="none";
	return true;
	
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

function buildTree(country,location){
		var countries=new Array("India","USA");
		var India=new Array("Ahmedabad","Bangalore","Chennai","Delhi","Hyderabad","Kolkata","Mumbai","Other");
		var India_new=new Array("Ahmedabad","Bangalore","Chennai","Delhi","Kolkata","Mumbai","Other");
		var USA=new Array("Austin","Bay Area","Boston","Chicago","Dallas","Houston","Los Angeles","New York","New Jersey","Pittsburgh","San Diego","Seattle","Other");
		var USA_new=new Array("Austin","Boston","Chicago","Dallas","Houston","Los Angeles","New York","New Jersey","Pittsburgh","San Diego","Seattle","Other");
		var India_lower=new Array("ahmedabad","bangalore","chennai","delhi","hyderabad","kolkata","mumbai","other");
		var India_new_lower=new Array("ahmedabad","bangalore","chennai","delhi","kolkata","mumbai","other");
		var USA_lower=new Array("austin","bayarea","boston","chicago","dallas","houston","losangeles","newyork","newjersey","pittsburgh","sandiego","seattle","other");
		var USA_new_lower=new Array("austin","boston","chicago","dallas","houston","losangeles","newyork","newjersey","pittsburgh","sandiego","seattle","other");
		
		var locations=new Array(India,USA);
		var locations_new=new Array(India_new,USA_new);
		var locations_lower=new Array(India_lower,USA_lower);
		var locations_new_lower=new Array(India_new_lower,USA_new_lower);
		var htmlcontent="<div class='locclose'> <a href='#' onclick= javascript:hidePopUp() >&times;</a></div>";
		htmlcontent+="<div id='loclist' >";
		for(var i=0;i<countries.length;i++){
			var classname="loccountry";
			var showexpand=false;
			if(country==countries[i]) {
				//classname="locselected";
				showexpand=true;
			}
			
			htmlcontent+="<div class='"+classname+"' ><a href='#' onClick=javaScript:getPage('cid="+countries[i]+"'); >"+countries[i]+"</a></div>";
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
					htmlcontent+="<div class='"+classname1+"' >"+state+"&nbsp;<a href='#' onClick= javaScript:getPage('lid="+locations1_lower[j]+"&cid="+countries[i]+"','lid'); >"+locations1[j]+"</a></div>";
				}
			}
			htmlcontent+="</div>";
		elm=document.getElementById('locbox');
		elm.innerHTML=htmlcontent;
		elm.style.display=='none'
	}
	
function init(url,id,parentid){
	 return AJAXRequest("GET",  url, null,
		       function( AJAX ) {
			       if (AJAX.readyState == 4) {
				       if (AJAX.status == 200) {
						   var data=AJAX.responseText;
						   data=trim(data);
							if(data.length>0)
							{
							document.getElementById(id).innerHTML=data;
							(document.getElementById(parentid)).style.display='block';
							}
							else
							(document.getElementById(parentid)).style.display='none';
					    } else  if (AJAX.status ==404) {
					      document.getElementById(parentid).style.display='none';
				       } else {
					       alert("There was a problem retrieving the XML data:\n" + AJAX.statusText);
				       }
			       }
		       },
                       true);
}

function AJAXRequest( method, url, data, process, async, dosend) {
   var AJAX = null;

    // check the dom to see if this is IE or not
    if (window.XMLHttpRequest) {
	// Not IE
        AJAX = new XMLHttpRequest();
    } else if (window.ActiveXObject) {
	// Hello IE!
        // Instantiate the latest MS ActiveX Objects
        if (_ms_XMLHttpRequest_ActiveX) {
            AJAX = new ActiveXObject(_ms_XMLHttpRequest_ActiveX);
        } else {
	    // loops through the various versions of XMLHTTP to ensure we're using the latest
	    var versions = ["Msxml2.XMLHTTP.7.0", "Msxml2.XMLHTTP.6.0", "Msxml2.XMLHTTP.5.0", "Msxml2.XMLHTTP.4.0", "MSXML2.XMLHTTP.3.0", "MSXML2.XMLHTTP",
                        "Microsoft.XMLHTTP"];

            for (var i = 0; i < versions.length ; i++) {
                try {
		    // try to create the object
		    // if it doesn't work, we'll try again
		    // if it does work, we'll save a reference to the proper one to speed up future instantiations
                    AJAX = new ActiveXObject(versions[i]);

                    if (AJAX) {
                        _ms_XMLHttpRequest_ActiveX = versions[i];
                        break;
                    }
                }
                catch (objException) {
                // trap; try next one
                } ;
            }

            ;
        }
    }

    // if no callback process is specified, then assing a default which executes the code returned by the server
    if (typeof process == 'undefined' || process == null) {
        process = executeReturn;
    }

     // create an anonymous function to log state changes
    AJAX.onreadystatechange = function( ) {

        process(AJAX);
    }

    // if no method specified, then default to POST
    if (!method) {
        method = "POST";
    }

    method = method.toUpperCase();

    if (typeof async == 'undefined' || async == null) {
        async = true;
    }




    AJAX.open(method, url, async);

    if (method == "POST") {
        AJAX.setRequestHeader("Connection", "close");
        AJAX.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
        AJAX.setRequestHeader("Method", "POST " + url + "HTTP/1.1");
    }

    // if dosend is true or undefined, send the request
    // only fails is dosend is false
    // you'd do this to set special request headers
    if ( dosend || typeof dosend == 'undefined' ) {
	    if ( !data ) data="";
	    AJAX.send(data);
    }
    return AJAX;
}
	
function executeReturn( AJAX ) {
    if (AJAX.readyState == 4) {
        if (AJAX.status == 200) {

	    if ( AJAX.responseText ) {
		    eval(AJAX.responseText);
	    }
	}
    }
}
	
	
	
/*
function init(url,id,parentid){
	var bindArgs = {
		url: url,
		load: function(type, data, evt){
			dj_debug(data);
			data=dojo.string.trim(data);
			if(data.length>0)
			document.getElementById(id).innerHTML=data;
			else
			(document.getElementById(parentid)).style.display='none';
				
		},
		error: function(type,evt){
			document.getElementById(parentid).style.display='none';
		}
	};
	var canBind = dojo.io.bind(bindArgs);
}
*/
/*
function buildTree(country,location){
			var countries=new Array("India","USA");
		var India=new Array("Banglore","Chennai","Delhi","Hyderabad","Mumbai","Trivendram");
		var USA=new Array("Boston","Bay Area","California","NewYork");
		var locations=new Array(India,USA);
		var tree = dojo.widget.createWidget("Tree", {toggle: "fade", showGrid: "false", 
		expandIconSrcPlus: "/home/images/pulldownarrow.gif",
		expandIconSrcMinus: "/home/images/star.gif", iconWidth: null, iconHeight: null, width:"150px" });
		dojo.style.getTotalOffset(tree,"top",false);
		document.body.appendChild(tree.domNode);
		
			for(var i=0;i<countries.length;i++){
			var classname="rootNodeStyle";
			var showexpand=false;
			if(country==countries[i]) {
				classname="selectedRootNodeStyle";
				showexpand=true;
			}
				var node1 = dojo.widget.createWidget("TreeNode", {isExpanded: showexpand, title: countries[i], onTitleClick: function(){window.location.href="/portal/home.jsp?cid="+this.title;}, className: classname});
				tree.addChild(node1);
				var locations1=locations[i];
				for(var j=0;j<locations1.length;j++){
				var classname1="nodeStyle";
					if(location==locations1[j]) 
						classname1="selectedNodeStyle";
					node1.addChild(dojo.widget.createWidget("TreeNode", {title: locations1[j], childIconSrc: "/home/images/pulldownarrow.gif", onTitleClick: function(){window.location.href="/portal/home.jsp?lid="+this.title;}, className: classname1 }));
				}
				
			}
			
		elm=document.getElementById('locationtree');
		elm.appendChild(tree.domNode);
		elm.style.display=='none'
	}
*/

