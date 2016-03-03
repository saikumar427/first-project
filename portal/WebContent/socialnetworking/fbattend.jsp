<%@ page import="com.eventbee.util.CoreConnector,java.util.HashMap,org.json.*,com.eventbee.general.DbUtil,com.eventbee.general.StatusObj,com.eventbee.general.DBManager,com.eventbee.general.GenUtil"%>
<%@ page import="java.util.ArrayList"%> 

<%!
public String getResponseData(String fbeid){
		String st="";
		try{
 String query="SELECT uid, name, sex FROM user WHERE uid IN (SELECT uid FROM event_member WHERE eid in("+fbeid+") and rsvp_status='attending') order by name";
		
		
		
		
			CoreConnector cc1=new CoreConnector("https://graph.facebook.com/"+fbeid+"/attending");
			//CoreConnector cc1=new CoreConnector("https://api.facebook.com/method/fql.query");
			HashMap parammap=new HashMap();
			parammap.put("access_token","48654146645|UTrkZdHI8EPmvWeWKw-IaKP7cfk");
			parammap.put("query",query);
			parammap.put("format","json");
			cc1.setArguments(parammap);
			cc1.setTimeout(30000);
			st=cc1.MGet();
			//System.out.println(st);
		}
		catch(Exception e){
			System.out.println("exception occurred is:"+e.getMessage());
		}

		return st;
	}
%>
<%
//208307859183540    -----ticketfly
//114620945290425 -----our 
//144841005571696 ----one million
//206044992753002 f2support
String eventid=request.getParameter("eventid");
if(eventid==null || "".equals(eventid) || "null".equals(eventid)){
	out.println("{data:'error'}");
	return;
}else{
	try{
	Integer.parseInt(eventid);
	}
	catch(Exception e){
		out.println("{'data':'error'}");
		return;
	}
}
String fbeid=request.getParameter("fbeid");
JSONObject jobj=new JSONObject();
if("null".equals(fbeid) || "".equals(fbeid)){
DBManager db=new DBManager();
StatusObj sb=db.executeSelectQuery("select name,value from config where name in ('event.FBRSVPList.eventid','event.FBRSVPList.gendercount.show') and config_id=(select config_id from eventinfo where eventid=CAST(? AS INTEGER)) ",new String[]{eventid});
if(sb.getStatus()){
	for(int i=0;i<sb.getCount();i++){
		jobj.put(db.getValue(i,"name",""),db.getValue(i,"value",""));
	}
}
try{
fbeid=(String)jobj.get("event.FBRSVPList.eventid");
}catch(Exception e){}
}
else{
jobj.put("event.FBRSVPList.gendercount.show",request.getParameter("showgenderlink"));
}
String s=getResponseData(fbeid);
jobj.put("data",s);
jobj.put("fbeid",fbeid);
out.println(jobj.toString());
%>



