<%@ page import="java.util.*,com.eventbee.general.*,java.sql.*,java.text.*, com.eventbee.authentication.*,java.io.*,com.eventbee.util.*,org.w3c.dom.*"%>
<%@ page import="com.eventbee.general.formatting.*"%>
<%!
	Vector getPaypalDetails(String query,String eventid){	
		Vector dbvect=new Vector();
		DBManager dbmanager=new DBManager();
		HashMap dbhmap = null;
		StatusObj statobj=dbmanager.executeSelectQuery(query,new String [] {eventid});
  			if(statobj.getStatus()){   
        		for(int k=0;k<statobj.getCount();k++){
		 			dbhmap=new HashMap();
		 			dbhmap.put("date",dbmanager.getValue(k,"time","")); 
					dbhmap.put("transid",dbmanager.getValue(k,"transid",""));
					dbhmap.put("xmldata",dbmanager.getValue(k,"xmldata",""));
					dbhmap.put("orderno",dbmanager.getValue(k,"orderno",""));
		 			dbvect.add(dbhmap);
				}
			}
   		return dbvect;
	}
	
	
	Vector getGoogleDetails(String query,String eventid){	
			Vector dbvect=new Vector();
			DBManager dbmanager=new DBManager();
			HashMap dbhmap = null;
			StatusObj statobj=dbmanager.executeSelectQuery(query,new String [] {eventid});
	  			if(statobj.getStatus()){   
	        		for(int k=0;k<statobj.getCount();k++){
			 			dbhmap=new HashMap();
			 			dbhmap.put("date",dbmanager.getValue(k,"time","")); 
						dbhmap.put("transid",dbmanager.getValue(k,"transid",""));
						dbhmap.put("xmldata",dbmanager.getValue(k,"xmldata",""));
						dbhmap.put("orderno",dbmanager.getValue(k,"orderno",""));
						dbhmap.put("google_charged_xml",dbmanager.getValue(k,"google_charged_xml","null"));
			 			dbvect.add(dbhmap);
					}
				}
	   		return dbvect;
	}
	
	
	
	
	
	
	
%>
<%!
	
	String fname,lname,email,gt;
	
	public String getNodeValue(Element el,String ename,String dfval){
		String nv=dfval;
		NodeList nl =el.getElementsByTagName(ename);
		if(nl != null && nl.getLength() > 0) {
		nv=nl.item(0).getChildNodes().item(0).getNodeValue();
		}		
		return nv;
	}
	public void initEventRegXmlData(String xmldata){
	try{
		StringBufferInputStream sbips= new StringBufferInputStream(xmldata);
		Document doc=ProcessXMLData.getDocument(sbips);
		NodeList regNodes = doc.getElementsByTagName("event-registration");
		if(regNodes != null && regNodes.getLength() > 0) {
			Element el = (Element)regNodes.item(0);
			gt=getNodeValue(el,"grand-total","0.00");
		}			
		
		NodeList listOfNodes = doc.getElementsByTagName("event-attendee");
		
		if(listOfNodes != null && listOfNodes.getLength() > 0) {
			Element el = (Element)regNodes.item(0);
			
			fname=getNodeValue(el,"f-name","");
			lname=getNodeValue(el,"l-name","");
			email=getNodeValue(el,"email","");
		}
		}
		catch(Exception e)
				
			{  
			System.out.println("Exception occured in processing Xml"+e.getMessage()); 
			}
		
		
		
		
	}
%>

<%!
	String tid=null,date=null,xmldata=null,ordno=null;String google_charged_xml=null;
	String base=null;
	String cbins=null;
	String cbdel=null;
	public String vendorDetails(Vector vect_vendor,String vendor,String groupid,String URLBase){	
	if("ningapp/ticketing".equals(URLBase)){	
	URLBase="ningapp";
	}
		String tableinfo="";
		String[] vendorvalues = null;
		String[] displayStyle=new String[]{"center","center","center","left","right","left","left"};
		if(vect_vendor!=null&&vect_vendor.size()>0){
			for(int i=0;i<vect_vendor.size();i++){
				if(i%2==0){
					base="evenbase";
				}
				else{
					base="oddbase";
				}
				HashMap hm_vendor=(HashMap)vect_vendor.elementAt(i);
				date= (hm_vendor.get("date")).toString();
				tid= (hm_vendor.get("transid")).toString();
				xmldata=(hm_vendor.get("xmldata")).toString();
				ordno=(hm_vendor.get("orderno")).toString();
				google_charged_xml=(String)hm_vendor.get("google_charged_xml");
				if(xmldata!=null){
					initEventRegXmlData(xmldata);
					GenUtil.AllXMLEncode(xmldata);
					String status=null;
					int k=0;
				
					if("Paypal".equals(vendor)){
					
					
					if(("".equals(ordno)||!"VERIFIED".equals(ordno))&&!"1".equals(ordno)){
						status="Not Confirmed";
						k=1;
						
					}
					else if(ordno.equals("1")){
						status="Manually Confirmed";
					}
					
					else
					{
					status=vendor+" Confirmed";
					}
					
					
					}
					
					else
					{
									
					if("".equals(ordno)||google_charged_xml==null||"null".equals(google_charged_xml)){
					status="Not Confirmed";
					k=1;
					}
					else if(!"".equals(ordno)&&"Manual".equals(google_charged_xml)){
					status="Manually Confirmed";
					}

					else
					{
					status=vendor+" Confirmed";
					}					
					
					}
					
					
					
					tableinfo=tableinfo+"<tr>";
					
					if(k!=1){
						cbdel="<input type='checkbox' id='gp' name='"+vendor+"del' value='"+tid+"'>";
						vendorvalues=new String[]{cbdel,status,date,"<a href='/portal/"+URLBase+"/transaction.jsp?key="+tid+"&GROUPID="+groupid+"&groupid="+groupid+"&cardtype="+vendor+"'>"+tid+"</a>",CurrencyFormat.getCurrencyFormat("$",gt+"",true),fname+" "+lname,email};
						
						displayStyle[1]="left";
					}
					else{
						cbins="<input type='checkbox' id='gp' name='"+vendor+"nins' value='"+tid+"'>";
						cbdel="<input type='checkbox' id='gp' name='"+vendor+"ndel' value='"+tid+"'>";
						vendorvalues=new String[]{cbdel,cbins,date,tid,CurrencyFormat.getCurrencyFormat("$",gt+"",true),fname+" "+lname,email};
						displayStyle[1]="center";
					}
					
					for(int j=0;j<vendorvalues.length;j++){
						String telement="<td class="+base+" align='"+displayStyle[j]+"'>"+vendorvalues[j]+"</td>";
						tableinfo=tableinfo+telement;
					}
					tableinfo=tableinfo+"</tr>";
				}
			}
		}
		return tableinfo;
	}
%>

<%
String platform = request.getParameter("platform");
String URLBase="mytasks";
    if("ning".equals(platform)){
	URLBase="ningapp/ticketing";	
    }

String groupid=request.getParameter("GROUPID");
String groupname=null;
Vector vect_trans=null;
String vendor=null;
String vendor_type=request.getParameter("type");
if(vendor_type==null) vendor_type="google";
String query="";
String status=request.getParameter("status");
if(status==null) status="v";
String query_google[]={"select to_char(ebee_to_google_time,'Mon dd, yyyy') as time,ebee_tran_id as transid,ebee_to_google_xml as xmldata,google_order_no as orderno,google_charged_xml from google_payment_data where refid = ? and google_charged_xml is null group by refid,ebee_tran_id,ebee_to_google_xml,ebee_to_google_time,google_order_no,google_charged_xml ORDER BY time DESC","select to_char(ebee_to_google_time,'Mon dd, yyyy') as time,ebee_tran_id as transid,ebee_to_google_xml as xmldata,google_order_no as orderno,google_charged_xml from google_payment_data a where refid = ? and google_charged_xml is not null group by refid,ebee_tran_id,ebee_to_google_xml,ebee_to_google_time,google_order_no,google_charged_xml ORDER BY time DESC"};
String query_paypal[]={"select to_char(time,'Mon dd, yyyy') as time,ebee_tran_id as transid,ebee_xml_data as xmldata,paypal_order as orderno from paypal_payment_data where refid = ? and  (paypal_order is null OR paypal_order not in('VERIFIED','1')) group by refid,ebee_tran_id,ebee_xml_data ,time,paypal_order ORDER BY time DESC","select to_char(time,'Mon dd, yyyy') as time,ebee_tran_id as transid,ebee_xml_data as xmldata,paypal_order as orderno from paypal_payment_data a where refid = ? and (paypal_order is not null AND paypal_order not in('INVALID'))  group by refid,ebee_tran_id,ebee_xml_data ,time,paypal_order ORDER BY time DESC"};
int queryIndex=0;
if("v".equals(status)){
queryIndex=1;
}
if("paypal".equals(vendor_type)){
vendor="Paypal";
query=query_paypal[queryIndex];
}else{
vendor="Google";
query=query_google[queryIndex];
}
%>
<html>
<head>
<script language="javascript">
function validation(thisform,bt){
	myOption = -1;
	for (i=thisform.gp.length-1; i > -1; i--) {
		if (thisform.gp[i].checked) {
			myOption = i; i = -1;
		}
	}
		if (myOption == -1) {
			alert("Select a transaction");
			return false;
		}

		else{
			document.gptrans.button.value=bt;
			document.gptrans.action="/googlepaypaltransactions/vendordbupdate.jsp";
			document.gptrans.submit();
		}
}

function gettransactiondetails(){
	document.transactiondetailsform.submit(); 
} 
</script>
  
</head>
<body>

<form name="transactiondetailsform" action="/<%=URLBase%>/transactionmanagement.jsp">
<table align="center">
<tr><td>
<%if("v".equals(status)){%>
<input type="radio" name="status" value="v" checked>Confirmed
<input type="radio" name="status" value="nv" onclick="gettransactiondetails();">Not Confirmed
<%}if("nv".equals(request.getParameter("status"))){%>
<input type="radio" name="status" value="v" onclick="gettransactiondetails();">Confirmed
<input type="radio" name="status" value="nv" checked>Not Confirmed 
<%}%>
<input type="hidden" name="type" value="<%=request.getParameter("type")%>" >
<input type="hidden" name="GROUPID" value="<%=request.getParameter("GROUPID")%>" >
<input type="hidden" name="platform" value="<%=platform%>" >

<!--<input type="button" value="Submit" onclick="gettransactiondetails();">-->
</td></tr></table>
</form>
<form name="gptrans" method="post">
<table class='portaltable' cellpadding="3" cellspacing="0" align="center">
<input type="hidden" name="status" value="<%=status%>" >
<input type="hidden" name="type" value="<%=vendor_type%>" >
<input type="hidden" name="platform" value="<%=platform%>" >
			
<%

        if("Google".equals(vendor))
	vect_trans=getGoogleDetails(query,groupid);
	else 
	vect_trans=getPaypalDetails(query,groupid);				
	if(vect_trans!=null&&vect_trans.size()>0){
%>
	<th class='colheader'>
	<input type="button" name="delete" value="Delete" onclick="validation(gptrans,'delete')"></th>
	<%if("v".equals(request.getParameter("status"))){%>	
	<th class='colheader'>Status</th>
	<%}else{%>
	<th class='colheader'><input type="button" name="insert" value="Confirm" onclick="validation(gptrans,'insert')"></th>
	<%}%>
	<th class='colheader'>Transaction Date</th>
	<th class='colheader'>Transaction ID</th>
	<th class='colheader'>Amount</th>
	<th class='colheader'>Name</th>
	<th class='colheader'>Email</th>
<%
		String vendordata=vendorDetails(vect_trans,vendor,groupid,URLBase);
		out.println(vendordata);
	}else{
	out.println("<tr><td class='evenbase' colspan='7'>No Transactions</td></tr>");
	}
	out.println("</table>");	
	
%>
<input type="hidden" name="button">
<input type="hidden" name="groupid" value="<%= groupid%>">
</form>
</body>
</html>
<div id="transactiondetails" align="center" /></div>