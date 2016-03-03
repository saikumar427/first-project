function AJAXRequest( method, url, data, process, async, dosend) {
   var _ms_XMLHttpRequest_ActiveX;
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

function makeMsgRequest(url, id, message, showMsg){
	if(showMsg){
		document.getElementById(id).style.color='red';
		document.getElementById(id).innerHTML=message;
		(document.getElementById(id)).style.display='block';
		}	
	return AJAXRequest("GET",  url, null,
	function( AJAX ) {
		if (AJAX.readyState == 4) {
		       if (AJAX.status == 200) {
				   var data=AJAX.responseText;
				   data=trim(data);
				   if(data.length>0)
					{
					document.getElementById(id).innerHTML=data;
					(document.getElementById(id)).style.display='block';

					}
					else
					(document.getElementById(id)).style.display='none';
					
			    } else  if (AJAX.status ==404) {
			      document.getElementById(id).style.display='none';
			      
		       } else {
			       alert("There was a problem retrieving the XML data:\n" + AJAX.statusText);
		       }
		}
	},
	true);
}


function makeRequest(url,id){
    return makeMsgRequest(url, id, "", false);	
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

	
