<%@ page import="com.eventbee.general.*,java.util.*"%>
<%@ page  import="com.eventbee.util.ProcessXMLData,org.w3c.dom.Document,com.eventbee.util.CoreConnector"%>
<%!
static String serveraddress="http://"+EbeeConstantsF.get("serveraddress","")+"/";
%>
<%
//site=http://bitly.com
String longUrl=request.getParameter("longUrl");
if(longUrl==null)
longUrl="http://www.eventbee.com";
  String data="";
  System.out.println("in shortutl:::"+longUrl);
try{         CoreConnector cc1=null;
             Map resMap=null;
		     HashMap urldet=new HashMap();
			 urldet.put("login","eventbeesupport");
			 //o_32gdgehgh2
			 urldet.put("apiKey","R_842d7dffa8aa721ae9d6cc4eb93b3445");
			 //R_4b1dd578bcd0337cd0277d209038d007
			 urldet.put("longUrl",longUrl);
			 urldet.put("format","json");
			 System.out.println("urldet:::"+urldet);			 
			 cc1=new CoreConnector("http://api.bitly.com/v3/shorten");
			 cc1.setArguments(urldet);
	       	 cc1.setTimeout(50000);
		     data=cc1.MGet();
	        
			 }
			 catch(Exception e)
			 {
			 System.out.println("error"+e.getMessage());
			 }
			System.out.println("resMap::g::"+data); 
out.println(data);
%>