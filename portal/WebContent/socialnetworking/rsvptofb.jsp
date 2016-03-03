<%@ page import="com.eventbee.util.CoreConnector,java.util.HashMap,org.json.*,com.eventbee.general.GenUtil"%>

<%!
public String getResponseData(String fbeid,String access_token,String responsetype){
		String st="";
		try{
			CoreConnector cc1=new CoreConnector("https://graph.facebook.com/"+fbeid+"/"+responsetype+"");
			HashMap parammap=new HashMap();
			parammap.put("access_token",access_token);
			parammap.put("method","POST");
			parammap.put("format","json");
			cc1.setArguments(parammap);
			cc1.setTimeout(30000);
			st=cc1.MGet();
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
String fbeid=request.getParameter("fbeid");
String access_token=request.getParameter("access_token");
String responsetype=request.getParameter("responsetype");
if(responsetype==null || "".equals(responsetype))
	responsetype="attending";
JSONObject jobj=new JSONObject();
String[] fbeidarray=GenUtil.strToArrayStr(fbeid,",");
String firstfbeid=fbeidarray[0];
String s=getResponseData(firstfbeid,access_token,responsetype);
	   
jobj.put("data",s);
jobj.put("fbeid",fbeid);
System.out.println(jobj);
out.println(jobj);
%>



