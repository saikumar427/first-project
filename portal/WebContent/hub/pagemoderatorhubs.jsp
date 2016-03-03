<%@ page import="com.eventbee.hub.hubDB" %>
<%@ page import="java.util.*" %>
<%@ page import="com.eventbee.pagenating.*" %>
<%
	request.setAttribute("tabtype","community");
	String id1=request.getParameter("userid");
	String uname=null;
	if(id1==null) id1="";
	id1=id1.trim();
	if(!("000000".equals(id1)|| "".equals(id1)|| "0".equals(id1))){
	  uname=DbUtil.getVal("select getMemberName(?)",new String[]{id1});
	  if(uname==null) uname=""; 
	  //uname+="'s Page";
	  request.setAttribute("tasktitle",uname);
	  request.setAttribute("tasksubtitle","Moderated "+EventbeeStrings.getDisplayName(EbeeConstantsF.get("club.label","Bee Hive"),"Beehive")+"s");
	}else{
	   request.setAttribute("tasktitle","Member");
	   request.setAttribute("tasksubtitle","Not Found");
	}
	String appname=("/manager".equalsIgnoreCase(request.getContextPath()))?"/manager":"/portal";
	boolean pageNatingException=false;
	int pageIndex=1;
	try{
		pageIndex=Integer.parseInt(request.getParameter(".pageIndex"));
	}catch(NumberFormatException e){pageIndex=1;}
%>
<%
	request.setAttribute("tabtype","community");
	request.setAttribute("NavlinkNames",new String[]{uname+"'s Page"});
	String url=com.eventbee.general.PageUtil.appendLinkWithGroup("/portal/editprofiles/networkuserprofile.jsp?userid="+id1,(HashMap)request.getAttribute("REQMAP"));
	request.setAttribute("NavlinkURLs",new String[]{url});
%>

	<% if(!("000000".equals(id1)|| "".equals(id1)|| "0".equals(id1))){ 
      		String Query="select cm.clubid from club_member cm,clubinfo c where userid=? and ismgr='true' "
				+" and cm.status in ('ACTIVE','PENDING') and cm.clubid=c.clubid and c.status in ('ACTIVE')";
		Vector myListedHubs1=hubDB.getHubs(Query,new String[]{id1});
		List myListedHubs=null;
		pageNatingException pageException=null;
		pageNating pageNav=new pageNating();
		try{
			pageNav.setLink(PageUtil.appendLinkWithGroup("/portal/guesttasks/pagemoderatorhubs.jsp?userid="+id1,(HashMap)request.getAttribute("REQMAP")));
			myListedHubs=pageNav.getPagenatingElements(0,pageIndex,20,myListedHubs1);
		}catch(pageNatingException pageexcep){pageNatingException=true;pageException=pageexcep;}
	%>
		<table border='0' cellpadding='0' cellspacing='0' width='100%' class='block'>
		<tr><td height='10'></td></tr>
		<%if(pageNatingException){%>
			<tr><td><%=pageException%></td></tr>
		<%}else{%>
		
		<tr><td valign='center'>
			<table border='0' cellpadding='2' cellspacing='0' width='100%' valign='center'>
				<tr>
					<td width='2%'/>
					<td width='30%' align='left'><%=pageNav.showRecordPosition()%></td>
					<td align='right'> <%=pageNav.pageNavigatorWithPageIndexs()%></td>
				</tr>
			</table>
		</td></tr>
		<tr><td height='10'></td></tr>
		<%for(int i=0;myListedHubs!=null && i<myListedHubs.size();i++){
			String base="evenbase";
			if(i%2==0) base="oddbase";
			HashMap hubMap=(HashMap)myListedHubs.get(i);
			String refer=appname+"/hub/clubview.jsp?GROUPID="+GenUtil.getHMvalue(hubMap,"clubid");
		%>
			<tr class='<%=base%>' height='20'><td  valign='center' align='left'><a href="<%=GenUtil.getEncodedXML(refer)%>" ><%=GenUtil.getHMvalue(hubMap,"clubname","",true)%></a></td></td>
		<%}%>
		<tr><td height='10'></td></tr>
		<tr><td valign='center'>
			<table border='0' cellpadding='2' cellspacing='0' width='100%' valign='center'>
				<tr>
					<td width='2%'/>
					<td width='30%' align='left'><%=pageNav.showRecordPosition()%></td>
					<td align='right'> <%=pageNav.pageNavigatorWithPageIndexs()%></td>
				</tr>
			</table>
		</td></tr>
		<%}%>
		<tr><td height='10'></td></tr>
		</table>
	<%}else{%>	
	<table border='0' cellpadding='0' cellspacing='0' width='100%'>
		<tr><td height='10'></td></tr>
		<tr><td align='center'>No Member Found</td></tr>
		<tr><td height='10'></td></tr>
	</table>
	<%}%>	

