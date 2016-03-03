<%@ page import="java.util.*,java.sql.*,com.eventbee.general.*,com.eventbee.event.EventDB,com.eventbee.event.*" %>
<%@ page import="com.eventbee.pagenating.*" %>
<%@ page import="com.eventbee.streamer.*"%>

<jsp:include page='/stylesheets/CoreRequestMap.jsp' />

<%!

HashMap getnetadvevents(Vector v1){
HashMap hm=null;
HashMap hm1=new HashMap();
for(int j=0;j<v1.size();j++){
hm=(HashMap)v1.elementAt(j);
hm1.put("eventid"+j,(String)hm.get("eventid"));
}
			
			
			
return hm1;			
			
}


%>




<%
 Vector advvec=new Vector();
 HashMap advmap=null;

HashMap param=new HashMap();
String link="/portal/eventdetails/eventdetails.jsp?UNITID=13579&GROUPID=";
String reqdate=null;
String ctgreq=(request.getParameter("ctg")==null)?"All":request.getParameter("ctg");
String keyword=request.getParameter("keyword");
if(keyword==null || "".equals(keyword.trim()) || "null".equals(keyword)) keyword="";
String [] keywords=null;
StringTokenizer st=new StringTokenizer(keyword,",");
keywords=new String[st.countTokens()];
int x=0;
while(st.hasMoreTokens()){
keywords[x++]=st.nextToken();
}
String type=request.getParameter("type");


String dismsg="";
if("event".equals(request.getParameter("evttype"))) dismsg="Events";
else dismsg="Classes";
String tag=request.getParameter("tag");

if(evttype==null) evttype="All";
String country=null;
String location=request.getParameter("location");
String loc2=location;
if(loc2==null)loc2="";
String [] states=null;
List stlist=new ArrayList();
if(location!=null){
states=LocationSearch.getStates(location);
}
if(states!=null)location=null;
String mm=request.getParameter("mm");
String dd=request.getParameter("dd");
String yy=request.getParameter("yy");
if (mm!=null && (!("".equals(mm))) && (!("null".equals(mm))) ){
	//if(yy!=null && ! "".equals(yy.trim()) && (!("null".equals(yy))))
		if(dd!=null && ! "".equals(dd.trim()) && (!("null".equals(dd))))
			reqdate="2007-"+mm +"-"+dd;
}else{

	java.text.SimpleDateFormat SDF=new java.text.SimpleDateFormat("yyyy-MM-dd");
	reqdate=SDF.format(Calendar.getInstance().getTime());
}
if("All".equals(evttype)) evttype=null;
if("".equals(reqdate) || (reqdate==null)) reqdate=null;
param.put("category",ctgreq);
param.put("keyword",keyword);
param.put("type",type);
param.put("location",location);
param.put("states",states);
param.put("keywords",keywords);
param.put("country",country);
param.put("startdate",reqdate);
param.put("unitid","13579");
if(tag!=null)
param.put("tags",tag);
param.put("evttype",evttype);
Vector sdorder=new Vector();
HashMap events=null;
boolean displaycommunityevents=true;
String searchtype="adv";
if(searchtype==null || "".equals(searchtype.trim()) || "null".equals(searchtype)) searchtype="";
sdorder=new Vector();




EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"eventscommunity.jsp","null","HashMap param value is :"+param,null);
events=EventInfoDb.getNewEventMap(param,sdorder);

                      
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"eventscommunity.jsp","null","events  value is :"+events,null);

// -1 means get all events
//events=getNewEventMap(param,sdorder); // -1 means get all events
%>



<table border="0" width="100%" align="center"  class="innerbeelet" cellspacing="0" cellpadding="0" >
<input type="hidden" name="ctgreq" value='<%=ctgreq%>'>
<%
String  serveraddress="http://"+EbeeConstantsF.get("serveraddress","");

List l=new Vector();
pageNating pageNav=new pageNating();
int pageIndex=1;
try{
	pageIndex=Integer.parseInt(request.getParameter(".pageIndex"));
}catch(Exception e){ pageIndex=1;}

String base="oddbase";
HashMap event;
Vector v1=new Vector();
Vector v=new Vector();
Vector dummy=new Vector();
 int j=0;

if(events!=null&&events.size()>0){

	for (int i=0;i<sdorder.size();i++){
		String startdate=(String)sdorder.elementAt(i);
		Vector EventVector=(Vector)events.get(startdate);
		for(int k=0;k<EventVector.size();k++){
			dummy.add(EventVector.get(k));
			 
		}
	}
	
	
	
	
	
	
	
	
	
	
	contenturl="/portal/eventdetails/eventlistings.jsp?x=y";
		if(location!=null&&!"".equals(location)&&!"null".equals(location))
		contenturl=contenturl+"&location="+location;
		if(keyword!=null&&!"".equals(keyword)&&!"null".equals(keyword))
		contenturl=contenturl+"&keyword="+keyword;
		if(ctgreq!=null&&!"".equals(ctgreq)&&!"null".equals(ctgreq))
		contenturl=contenturl+"&ctg="+ctgreq;
		
		

try{
	l=pageNav.getPagenatingElements(0,pageIndex,15,dummy);

/*String link1=com.eventbee.general.PageUtil.appendLinkWithGroup("/portal/eventdetails/events.jsp?evttype="+evttype
	         +"&location="+loc2+"&ctg="+ctgreq+"&keyword="+keyword+"&mm="+reqmm+"&dd="+regdd+"&yy="+regyy
		 +"&searchtype="+searchtype,(HashMap) request.getAttribute("REQMAP"));*/
	pageNav.setLink(contenturl);
}catch(Exception e){System.out.println(e);}
%>
<%--
<tr class='tab2' >
	<td colspan='3'>
		<table border='0' cellpadding='2' cellspacing='0' width='100%'>
				<tr>
					<td width='2%'/>
					<td width='30%' align='left'><%=pageNav.showRecordPosition()%></td>
					<td align='right'> <%=pageNav.pageNavigatorWithPageIndexs()%></td>
				</tr>
		</table>
	</td>
</tr>
--%>
<%
for (int i=0;i<sdorder.size();i++){

	boolean printed=false;
	if(j>= pageNav.getEndIndex())
		break;
	String startdate=(String)sdorder.elementAt(i);
	if(j>= pageNav.getStartIndex()){
		base="colheader";
%>

<tr width="100%" class="<%=base%>">
	<td width="2%"></td>
	<td width="98%" align="left" colspan="2"><b><%=startdate%><b></td>
</tr>
<% printed=true; %>
<%}%>
<%

		Vector sdevents=(Vector)events.get(startdate);
		for(int k=0;k<sdevents.size() ;k++){
		if (j>= pageNav.getStartIndex() && j< pageNav.getEndIndex()){
			if(k%2==0){
				base="evenbase";
			}else{
				base="oddbase";
			}
			HashMap hmap=(HashMap)sdevents.elementAt(k);
			advmap=new HashMap();
							advmap.put("eventid",(String)hmap.get("eventid"));
	advvec.add(advmap);
%>
	<% if(!printed){ %>
		<tr width="100%" class="colheader">
			<td width="2%"></td>
			<td width="98%" align="left" colspan="2"><b><%=startdate%><b></td>
		</tr>

	<%printed=true;
	}%>
<tr width="100%" class="<%=base%>">
	<td colspan="3" height="5"></td>
</tr>
<tr width="100%" class="<%=base%>">
	<td width="2%"></td>
	<td width="98%" align="left">

		 <%=hmap.get("eventtime")%> <%=hmap.get("location")%>
		 <br/>
		<%
		String fontcolor="blue";

			if("3".equals(hmap.get("evtlevel"))){
			fontcolor="green";
			}
			else if("2".equals(hmap.get("evtlevel"))){
			fontcolor="purple";
			}
link=serveraddress+"/event?eid=";
		if(!"0".equals(hmap.get("tcount"))){%>
			<a HREF="<%=link%><%=hmap.get("eventid")%>"><img src="/home/images/ticket.gif" width='13' height="11" border='0' alt="Registration Available"/></a>
		<%}
		if(hmap.get("photourl")!=null&&!"".equals(hmap.get("photourl"))){%>
			<a HREF="<%=link%><%=hmap.get("eventid")%>"><img src="/home/images/camera.gif" width='13' height="11" border='0' alt="Photo Available"/></a>
		<%}%>
			<a HREF="<%=link%><%=hmap.get("eventid")%>"><font color="<%=fontcolor%>">
			 <%
//if("EVENT_PREMIUM_LISTING".equals(hmap.get("premiumlevel"))||"EVENT_FEATURED_LISTING".equals(hmap.get("premiumlevel"))){
if(!"no".equals(hmap.get("premiumlevel"))&&hmap.get("premiumlevel")!=null&&!"".equals(hmap.get("premiumlevel"))){
%>
			 <b><%=hmap.get("name")%></b>
			 <%}else{%>
			 <%=hmap.get("name")%>
			 <%}%>
			 </font></a>
		<%
			if(hmap.get("user_name")!=null)
			{
		%>  - by <a HREF="/portal/editprofiles/networkuserprofile.jsp?userid=<%=hmap.get("userid")%>&entryunitid=13579"><%=hmap.get("user_name")%></a>
<%}%>
	</td>
	

</tr>
<tr width="100%" class="<%=base%>">
	<td colspan="3" height="5"></td>
</tr>


<%
		}j++;}

	}
%>


<tr class='colheader'>
	<td colspan='3'>
		<table border='0' cellpadding='2' cellspacing='0' width='100%'>
				<tr>
					<td width='2%'/>
					<td width='30%' align='left'><%=pageNav.showRecordPosition()%></td>
					<td align='right'> <%=pageNav.getPageNavigatorWithPageIndexs("contenttab")%></td>
				</tr>                             
		</table>                                  
	</td>
</tr>

<%}else{%>

<tr width="100%">
	<td colspan="3" align="left" class='evenbase' >No <%=dismsg%> listed</td>
</tr>
<%}

HashMap advobj=getnetadvevents(advvec);
	
	
	
	
	
	
	
	String partnerid=EbeeConstantsF.get("networkadv.partner","3809");
	boolean isnewsession=(session.getAttribute("netadv_session")==null);
	if(isnewsession)
	{
	session.setAttribute("netadv_session","yes");
	if(advobj!=null){
	PartnerTracking pt=new PartnerTracking(advobj);
	pt.setInsertionType("homepageimpressions");
	pt.setPartnerId(partnerid);
	pt.start();
	
	}
	
}	





%>
</table>


