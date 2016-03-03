<%@ page import="java.util.Vector"%>
<%@ page import="com.eventbee.event.EventDB" %>
<%@ page import="com.eventbee.authentication.*" %>
<%@ page import="com.eventbee.general.*"%>
<%!
	void GetCustomButtonsVector(String groupid, Vector customButtonsVector)
	{
	DBManager dbmanager=new DBManager();
	StatusObj statobj=dbmanager.executeSelectQuery("select url from network_ticketselling_images where refid=? ",new String [] {groupid});		 
	if(statobj.getStatus())
	{
		for(int k=0;k<statobj.getCount();k++)
		{
			customButtonsVector.add(dbmanager.getValue(k,"url",""));
		}
	}
	return;
	}
%>
<%	
	
	String width="44";
	String height="2";
	String domain=(String)session.getAttribute("domain");
	if(domain==null)
	 domain=request.getParameter("domain");
	
	String platform=request.getParameter("platform");
	
	Authenticate auth=(Authenticate)com.eventbee.general.AuthUtil.getAuthData(pageContext);
	String uid=(auth!=null)?auth.getUserID():null;
	String oid=DbUtil.getVal("select nid from ebee_ning_link where ebeeid=?",new String[]{uid});

	String eventURL=null,groupid=null;
	Authenticate authData=(Authenticate)com.eventbee.general.AuthUtil.getAuthData(pageContext);
	String serveraddress=EbeeConstantsF.get("serveraddress","www.eventbee.com");
	if(!serveraddress.startsWith("http://")){
		serveraddress="http://"+serveraddress;
	}
	groupid=request.getParameter("groupid");
   	String userid="";
   	String mgrname="";
   	String partnerid=null;
   	Vector customButtonsVector=new Vector();
   	
	if(authData!=null){
	userid = authData.getUserID();
	partnerid = DbUtil.getVal("select partnerid from group_partner where userid=?",new String[]{userid});		
	}
	if("ning".equals(platform)){
	oid=(String)session.getAttribute("oid");
		uid=DbUtil.getVal("select ebeeid from ebee_ning_link where nid=?",new String[]{oid});
		partnerid=DbUtil.getVal("select partnerid from group_partner where userid=?",new String[]{uid});
		
	}
	if(groupid!=null && partnerid!=null){
		eventURL=DbUtil.getVal("select url from event_custom_urls where eventid=?",new String[]{groupid});
		if(eventURL==null){
			mgrname=DbUtil.getVal("select login_name from authentication where user_id=(select mgr_id::varchar from eventinfo where eventid=CAST(? AS INTEGER))",new String[]{groupid});
			if(mgrname!=null){
				eventURL=ShortUrlPattern.get(mgrname)+"/event?eid="+groupid+"&pid="+partnerid;
			}
		}else{
			eventURL=eventURL+"/discount?pid="+partnerid;				
		}
		if("ning".equals(platform)){
			eventURL=""+serveraddress+"/token?oid="+oid+"&eid="+groupid+"&pid="+partnerid+"&d="+domain;
	}
		
		customButtonsVector.add("/home/images/register.jpg");
		customButtonsVector.add("/home/images/buyticket.jpg");
		GetCustomButtonsVector(groupid, customButtonsVector);		
	}
	%>
	<%

	if(groupid==null ||partnerid==null||eventURL==null){
		out.println("<p>Unable to show integartion links. Please make sure you are logged in");
	}else{
	%>

<TABLE align="center"  cellpadding="5" cellspacing="0" width="100%" border='0'>
<tr><td class="colheader" width="100%" cellpadding="0" cellspacing="0" align='left'>
<table cellpadding="0" cellspacing="0" align='left' >
    <tr><td class='subheader' width="100%" align='left' valign='top'  cellpadding="0" cellspacing="0">Event URL</td></tr>
</table></td></tr>
	<tr ><td  class="evenbase"><%=EbeeConstantsF.get("eventmanage.links.publish","Publish following URL on your Website, Emails and Print Media")%></td></tr>
	<tr ><td class="evenbase"><textarea cols="<%=width%>" rows="<%=height%>" onClick="this.select()"><%=eventURL%></textarea>
	</td></tr>	
<tr><td class="colheader" width="100%" cellpadding="0" cellspacing="0" align='left'>
<table cellpadding="0" cellspacing="0" align='left' >
    <tr><td class='subheader' width="100%" align='left' valign='top'  cellpadding="0" cellspacing="0">Button Links</td></tr>
</table></td></tr>
<%
    for(int i=0;i<customButtonsVector.size();i++)
    {
    	String btnImageurl = (String)customButtonsVector.elementAt(i);
%>
<tr><td class="evenbase" height="5">Copy and paste the following code into your blog or website:</td></tr>
<tr><td class="evenbase" ><img src="<%=btnImageurl%>" alt="v"  align="center"></img></td></tr>
<tr><td class="evenbase"><textarea cols="<%=width%>" rows="<%=height%>" onClick='this.select()'>
<a href="<%=eventURL %>"><img src="<%=btnImageurl%>"></img></a>
</textarea></td></tr>
<%    
    	}
%>
</TABLE>
<%} %>
<div align="center" class="evenbase"><input type="button" name="bbb" value="Close" onClick="hide();"></div>

