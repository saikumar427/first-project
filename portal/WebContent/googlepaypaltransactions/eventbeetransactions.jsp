<%@ page import="java.util.*,com.eventbee.general.*,java.sql.*,java.text.*, com.eventbee.authentication.*,java.io.*,com.eventbee.util.*,org.w3c.dom.*"%>
<%@ page import="com.eventbee.general.formatting.*"%>
<%!
String process_vendor=EbeeConstantsF.get("cardvendor","SKIPJACK");      

	Vector getDetails(String query,String eventid){	
		Vector dbvect=new Vector();
		DBManager dbmanager=new DBManager();
		HashMap dbhmap = null;
		StatusObj statobj=dbmanager.executeSelectQuery(query,new String [] {eventid,process_vendor});
  			if(statobj.getStatus()){   
        		for(int k=0;k<statobj.getCount();k++){
		 			dbhmap=new HashMap();
		 			dbhmap.put("date",dbmanager.getValue(k,"trandate","")); 
					dbhmap.put("transid",dbmanager.getValue(k,"transactionid",""));
					dbhmap.put("name",dbmanager.getValue(k,"name",""));
					dbhmap.put("email",dbmanager.getValue(k,"email",""));
					dbhmap.put("totalamount",dbmanager.getValue(k,"totalamount",""));
		 			dbvect.add(dbhmap);
				}
			}
   		return dbvect;
	}
%>
<%!
	
	String name,email,gt;
	
	
	
%>

<%!
	String tid=null,date=null,xmldata=null,ordno=null;
	String base=null;
	String cbins=null;
	String cbdel=null;
	public String vendorDetails(Vector vect_vendor,String vendor,String groupid,String URLBase){
		String tableinfo="";
		
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
				name=(hm_vendor.get("name")).toString();
				email=(hm_vendor.get("email")).toString();
				gt=(hm_vendor.get("totalamount")).toString();
					tableinfo=tableinfo+"<tr>";
					
					String vendorvalues[]={date,"<a href='/portal/"+URLBase+"/transaction.jsp?key="+tid+"&GROUPID="+groupid+"&groupid="+groupid+"&cardtype="+vendor+"'>"+tid+"</a>",CurrencyFormat.getCurrencyFormat("$",gt+"",true),name,email};
					for(int j=0;j<vendorvalues.length;j++){
						String telement="<td class="+base+">"+vendorvalues[j]+"</td>";
						tableinfo=tableinfo+telement;
					}
					tableinfo=tableinfo+"</tr>";
				
			}
		}
		return tableinfo;
	}
%>

<%
String groupid=null;
String groupname=null;
groupid=request.getParameter("GROUPID");
String platform = request.getParameter("platform");
String URLBase="mytasks";
    if("ning".equals(platform)){
	URLBase="ningapp";	
    }

Vector vect_trans=null;
String[] vendor=null;
vendor=new String[]{"Eventbee"};
int beginIndex=0;
int endIndex=2;
String query= "select distinct a.transactionid,firstname || ' ' || lastname as name, "
	    +" to_char(trandate,'mm/dd/yyyy') as trandate,totalamount,email " 
	    +" from transaction a, eventattendee b,cardtransaction c "
	    +" where refid=? and purpose='EVENT_REGISTRATION' and a.transactionid=b.transactionid "
	    +" and priattendee='Y' and c.internal_ref=a.transactionid and process_vendor = ? "
	    +" and  proces_status not in('CANCELLED','Refunded') order by trandate desc";

%>
<html>
<body>
<table class='portaltable' cellpadding="3" cellspacing="0" align="center">			
<%
	vect_trans=getDetails(query,groupid);				
		if(vect_trans!=null&&vect_trans.size()>0){
%>	
<th class='colheader'>Transaction Date</th>
<th class='colheader'>Transaction ID</th>
<th class='colheader'>Amount</th>
<th class='colheader'>Name</th>
<th class='colheader'>E-Mail</th>
<%
	String vendordata=vendorDetails(vect_trans,"Eventbee",groupid,URLBase);
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