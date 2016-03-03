<%@ page import= "java.util.Map, java.util.Map.Entry, java.util.Iterator, com.eventbee.general.EbeeConstantsF"%>
<html>
<head>
<title>Missed Properties</title>
<center><h2>Missed Properties</h2></center><hr>
</head>
<body>
<table border="1" align="center" cellpadding="2" cellspacing="2">
<tr>
<th>Property Name</th>
<th>Count</th>
</tr>
<%
	try{
		Map missedprop = EbeeConstantsF.getAllMisssedProperties();
		if(missedprop.size()!=0){	
			Iterator it = missedprop.entrySet().iterator();
			    while (it.hasNext()) {
				Map.Entry pairs = (Map.Entry)it.next();
				out.println("<tr><td>"+pairs.getKey() + "</td><td>" + pairs.getValue()+"</td></tr>");
			    }
		}
	}
	catch(Exception e){
		System.err.println("Exception: " + e.getMessage());
	}
%>
</table>
</body>
</html>
