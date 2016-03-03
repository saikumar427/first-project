<%@page import="com.eventbee.authentication.*,java.util.*,com.eventbee.general.*" %>
<%@ page import="com.eventbee.customconfig.MemberFeatures" %>

<%

String rollercontext=(application.getInitParameter("rollercontext")!=null)?application.getInitParameter("rollercontext"):"/roller";




//String UNITID=(request.getParameter("UNITID")==null)?"13579":request.getParameter("UNITID");

String tabtype=request.getParameter("type");
String stabtype=request.getParameter("ltype");
String act=request.getParameter("act");





String [] lifestyle={"Snapshot","Blog"};
int len=lifestyle.length;
      int width=(100/len)-1;

if(tabtype==null||"null".equals(tabtype))
tabtype=lifestyle[0];




//if(stabtype==null)stabtype="theme";
if(stabtype==null)stabtype="view";
if(stabtype !=null)request.setAttribute("ltype",stabtype);
if(tabtype !=null)request.setAttribute("type",tabtype);
if(act !=null) request.setAttribute("act",act);


request.setAttribute("menuhelper","type="+tabtype);

	String unitid_auth="",authid_auth=null;
	Authenticate authData_auth=(Authenticate)com.eventbee.general.AuthUtil.getAuthData(pageContext);
	
	String serveraddress1 =(String)session.getAttribute("HTTP_SERVER_ADDRESS");
	if (authData_auth!=null){
		unitid_auth=authData_auth.getUnitID();
		authid_auth=authData_auth.getUserID();
	request.setAttribute("userid",authid_auth);
	
	
	
	
	
	
%>

<%

if("Blog".equals(tabtype) ){
//response.sendRedirect("/eroller/rollerlogin.jsp?act=eweblogQuery");
response.sendRedirect("/eroller/rollerlogin.jsp?act=eweblogCreate");
}else if("Photos".equals(tabtype)){
response.sendRedirect("/portal/photogallery/photosmanage.jsp?type=Photos");
}else{
	MemberFeatures featuresofunitreq1=new MemberFeatures(unitid_auth);
	request.setAttribute("memberfeatures",featuresofunitreq1);
	String scrname=null;
	HashMap hm1=(new AuthDB()).getUserPreferenceInfo(authid_auth,"pref:myurl");
		if (hm1!=null)
		scrname=(String)hm1.get("pref_value");
	
	if(scrname!=null)request.setAttribute("lifestyleurl","<a style='text-decoration:none' href='"+ShortUrlPattern.get(scrname)+"' >"+serveraddress1+"/member/"+scrname+"</a>"  );
	
	if(scrname!=null)request.setAttribute("lifestylescrname",scrname);
	request.setAttribute("subtabtype","mynetwork");
	// request.setAttribute("linktohighlight","Theme");
	String linktohighlight=request.getParameter("ltype");
	request.setAttribute("linktohighlight",linktohighlight);
	

%>



<table cellpadding='0' cellspacing='0' class='portalback' border='0' width='100%' >
<%--
<tr><td colspan='2'>
<jsp:include page='/lifestyle/lifestylesubmenu.jsp' />
</td></tr>
--%>
<%--<tr><td colspan='5'><jsp:include page='/lifestyle/lifemenu.jsp' /></td></tr>--%>
<tr height='5'><td colspan='5'></td></tr>
	<tr><td width='100%' colspan='5'>
	<%
	if("theme".equals(stabtype) ){
	%>
	
	<jsp:include page='/lifestyle/getlifestyle.jsp' />
	<%
	}
	%>
	
	<%
	if("template".equals(stabtype) ){
	%>
	
	<jsp:include page='/lifestyle/getTemplate.jsp' />
	<%
	}
	%>
	
	<%
	if("view".equals(stabtype) ){
	%>
	
	<jsp:include page="/lifestyle/mylifestylehome.jsp" />
	<%--<jsp:include page="../editprofiles/userprofile.jsp" >
	<jsp:param name='userid' value='<%=authid_auth%>' />
	<jsp:param name='Dummy_ph' value='' /></jsp:include>
	--%>
	<%
	}
	%>
	
	
	
	</td></tr>


</table>


<%
}
%>


<%
}else{
HashMap hm=new HashMap();
hm.put("redirecturl","/portal/mytasks/Network.jsp?type="+tabtype);
session.setAttribute("BACK_PAGE","mylifestyle");
session.setAttribute("REDIRECT_HASH",hm);

%>
<jsp:include page="/auth/authenticate.jsp" />
<%
}
%>
