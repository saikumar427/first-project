<%@page import="com.eventbee.cachemanage.CacheManager"%>
<%! 
public void clearglobaldata(String groupid,String loader){
	System.out.println("clearglobaldata:::: groupid: "+groupid+" loader: "+loader);
	if("full".equals(loader)){
		System.out.println("groupid: "+groupid+" loader: "+loader);
		CacheManager.clearData(groupid+"_eventmeta");
		CacheManager.clearData(groupid+"_eventinfo");
	}else{
		System.out.println("groupid_loader: "+groupid+"_"+loader);
		CacheManager.clearData(groupid+"_"+loader);
		//out.println(groupid+"_"+loader+" data cleared");
	}
}
%>
<%
String groupid=request.getParameter("groupid");
String loader=request.getParameter("loader");
clearglobaldata(groupid,loader);
%>
