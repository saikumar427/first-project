<%@page import="java.net.UnknownHostException"%>
<%@page import="java.net.InetAddress"%>
<%@page import="com.eventbee.util.CoreConnector"%>
<%@page import="com.eventbee.general.EbeeConstantsF"%>
<%@page import="java.util.HashMap"%>
<%@page import="com.eventbee.general.EbeeCachingManager"%>
<%! private String getServerIp() 
{
	String ipAddress="";
	InetAddress ip;
	  try {
		ip = InetAddress.getLocalHost();
		ipAddress=ip.getHostAddress();
	  } catch (UnknownHostException e) {
		e.printStackTrace();
	  }
	  return ipAddress;	
}

%>
<%
HashMap hm=(HashMap)EbeeCachingManager.get("blockedEvents");
String eid=request.getParameter("eid");
String serveraddr=EbeeConstantsF.get("serveraddress","www.eventbee.com");
if(hm!=null)
{
	out.println(hm.size());	
	out.println("</br>");
	out.println(hm);
	if(eid!=null){
		if(hm.containsKey(eid)){
			hm.remove(eid);
			hm.remove(eid+"_cancelby");
			out.println("event removed");
			EbeeCachingManager.put("blockedEvents",hm);
			HashMap<String,String> inputparams=new HashMap<String,String>();		
			inputparams.put("eid",eid);
			if("www.eventbee.com".equals(serveraddr)){//trying to remove other ip cache
				String s1=EbeeConstantsF.get("s1","www.eventbee.com");
				String s2=EbeeConstantsF.get("s2","www.eventbee.com");
				CoreConnector cc1=null;	 
				if(getServerIp().contains(s1)){
					System.out.println("trying to remove cache on another server i.e s2");
					String otherServerURL="http://"+s2+"/utworks/clearcanceleventcache.jsp?eid="+eid;
					cc1=new CoreConnector(otherServerURL);
					cc1.setArguments(inputparams);
					cc1.setTimeout(10000);
					cc1.MGet(); 
				}
				else{
					System.out.println("trying to remove cache on another server i.e s1");
					String otherServerURL="http://"+s1+"/utworks/clearcanceleventcache.jsp?eid="+eid;
					cc1=new CoreConnector(otherServerURL);
					cc1.setArguments(inputparams);
					cc1.setTimeout(10000);
					cc1.MGet();  
				}
			}
		}else{
			out.println("event not in map");
		}
	}

}else{
	out.println("Map is empty");
}
/*===== below code removes event cache data from cache manager (which refresh data using InstantWatcher)==== */
System.out.println("serveraddress is:"+serveraddr);
String URL="";
if("www.eventbee.com".equals(serveraddr)){
	URL="http://www.eventbee.com/main/utiltools/cleareventpagecache.jsp";
}else if("www.citypartytix.com".equals(serveraddr.trim())){
	String server=EbeeConstantsF.get("s1","www.citypartytix.com");
	URL="http://"+server+"/main/utiltools/cleareventpagecache.jsp";
}
HashMap<String,String> inputparams=new HashMap<String,String>();		
inputparams.put("eid",eid);
CoreConnector cc1=new CoreConnector(URL);
cc1.setArguments(inputparams);
cc1.setTimeout(10000);
cc1.MGet(); 
out.println("success");
%>