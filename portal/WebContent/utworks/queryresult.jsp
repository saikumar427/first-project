<%@page import="com.eventbee.general.*"%>
<table border="1" cellpadding="2" cellspacing="2">
<%
	String errorMessage=null;
	String query=request.getParameter("query");
	if(query==null)
	errorMessage="DB query is not set";
	
	DBManager db=new DBManager();			 
	StatusObj sob=db.executeSelectQuery(query,null);
	if(sob.getStatus() ){
	if(sob.getCount()>0){
	String [] columnnames=db.getColumnNames();			
%>
<tr>
<%
	for(int j=0;j<columnnames.length;j++){
%>
<th><%=columnnames[j]%></th>
<%
	}
%>
</tr>	
<%
	for(int i=0;i<sob.getCount();i++){ 
%>
<tr>
<%
		for(int j=0;j<columnnames.length;j++){
			String cname=columnnames[j];
			String cval=db.getValue(i,cname,"");
			if("password".equals(cname))  cval=(new StringEncrypter(StringEncrypter.DES_ENCRYPTION_SCHEME) ).decrypt(cval);
		        
%>
<td><%=cval%></td>
<%
		}//for each column name in a record
%>
</tr>	        
<%     
	}//for each record
	}else{//
		errorMessage="DB query resulted in zero records";
	}
	}else{//
		errorMessage="DB query could not be executed";
	}//
	if(errorMessage!=null){
%>
<tr><td><%=errorMessage%></td></tr>
<%
	}
%>
</table>
