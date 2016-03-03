<%@ page import="java.util.*,java.sql.*,java.net.*" %>
<%@ page import="com.eventbee.event.EventsContent" %>
<%@ page import="com.eventbee.general.*" %>
<%@ page import="org.eventbee.sitemap.util.Presentation" %>

<%

 String  serveraddress="http://"+EbeeConstantsF.get("serveraddress","");
HashMap evtinfo=(HashMap)request.getAttribute("EVENT_INFORMATION");
HashMap confighm=(HashMap)request.getAttribute("EVENT_CONFIG_INFORMATION");
String GOOGLEMAP="";
String mapstring="";
String venue="";
String [] address_arr=null;
List addressList=new ArrayList();
String groupid=Presentation.GetRequestParam(request,  new String []{"eid","eventid", "id","GROUPID","groupid","gid"});

if(evtinfo!=null&&confighm!=null){

String gmstring="";
String mstr="";	
String city=(String)evtinfo.get("city");
String state=(String)evtinfo.get("state");
String country=(String)evtinfo.get("country");
String gmappref=DbUtil.getVal("select value from config a,eventinfo b where b.eventid=? and a.name='eventpage.map.show' and a.config_id=b.config_id",new String [] {groupid});
venue=DbUtil.getVal("select venue from eventinfo where eventid=? ",new String [] {groupid});
if("Yes".equals(gmappref)){
String lon=GenUtil.getHMvalue(confighm,"longitude",null);
String lat=GenUtil.getHMvalue(confighm,"latitude",null);

if((lon!=null&&(!"".equals(lon.trim())))&&(lat!=null&&(!"".equals(lat.trim())))){
 GOOGLEMAP="<iframe src='"+serveraddress+"/portal/customevents/googlemap_js.jsp?lon="+lon+"&lat="+lat+"'  frameborder='0' height='260' width='260' marginheight='0' marginwidth='0' name='googlemap' scrolling='no'    ></iframe>";
	
	  


}  
} 

String address2=GenUtil.getHMvalue(evtinfo,"address2",null);
String address1=GenUtil.getHMvalue(evtinfo,"address1",null);
String address=GenUtil.getCSVData(new String[]{city,state,country});

if(venue!=null&&(venue.trim()).length()>0)
addressList.add(venue);
if(address1!=null&&(address1.trim()).length()>0)
addressList.add(address1);
if(address2!=null&&(address2.trim()).length()>0)
addressList.add(address2);
if(address!=null&&(address.trim()).length()>0)
addressList.add(address);


if(!GOOGLEMAP.equals("")){

if(address2.equals("")){
mstr=address1+"+"+city+"+"+state+"+"+country;
}
else{
mstr=address1+"+"+address2+"+"+city+"+"+state+"+"+country;
}

mstr=URLEncoder.encode(mstr);
gmstring="http://maps.google.com/maps?q="+mstr;

mapstring="<a href="+gmstring+"> Map and driving directions</a>";
session.setAttribute("mapstring",mapstring);

request.setAttribute("GOOGLEMAP",GOOGLEMAP);//googlemap
request.setAttribute("mapstring",mapstring);//whole googlemap 
}

}
address_arr=(String [])addressList.toArray(new String [0]);

request.setAttribute("FULLADDRESS",address_arr);

%>
