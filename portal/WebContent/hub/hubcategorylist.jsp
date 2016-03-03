<%@ page import="com.eventbee.general.formatting.EventbeeStrings,com.eventbee.event.*" %>
<%@ page import="com.eventbee.general.formatting.*" %>
<%@ page import="com.eventbee.general.*"%>
<%@ page import="java.util.*"%>
<%!
public static HashMap getHubsLocations(String unitid)
{
String HUBS_LOCATION_QUERY="select countryname,countrycode,statename,statecode,disposition from country_states where statecode||'~'||countrycode in " 
	+" (select distinct state||'~'||country from clubinfo where unitid=? ) "
	+" union "
	+" select countryname,countrycode,'' as statename,'' as statecode,disposition from country_states where countrycode in " 
	+" (select country from clubinfo where unitid=? ) and (statecode is null or trim(statecode)='') order by disposition ";

HashMap hm=EventInfoDb.getLocations(HUBS_LOCATION_QUERY,new String[]{"13579","13579"});
return hm;
}
%>
<%


String country=(String)request.getAttribute("USER_COUNTRY");
if(country==null||"".equals(country))
	country=request.getParameter("country");

String location="";
if((String)request.getAttribute("USER_LOCATION")!=null&& !"null".equals((String)request.getAttribute("USER_LOCATION")))
{
	location=(String)request.getAttribute("USER_LOCATION");
}

if(location==null||"".equals(location))
	location=request.getParameter("location");
String contenturl="";

String keyword=request.getParameter("keyword");
String type=request.getParameter("type");
		
String eunitid=request.getParameter("UNITID");
if(eunitid==null || "null".equals(eunitid) || "".equals(eunitid.trim())) eunitid="13579";

HashMap locationsMap=getHubsLocations("13579");
String[] hubLocations=(String [])locationsMap.get("Locations");
String[] hubLocationVals=(String [])locationsMap.get("LocationVals");
String club_title="Community";
List categoryCode=DbUtil.getValues("select code from categories where purpose=? order by displayname",new String[]{club_title});
List categoryName=DbUtil.getValues("select displayname from categories where purpose=? order by displayname",new String[]{club_title});




if(categoryCode==null) {categoryCode=new ArrayList();categoryName=new ArrayList();} 
categoryCode.add("Other");
categoryCode.add(0,"All");
categoryName.add("Other");
categoryName.add(0,"All"); 

String reqtype=request.getParameter("type");

String reqkeyword=request.getParameter("keyword");
if(reqkeyword==null) reqkeyword="";
%>

<script language="javascript" src="<%=EbeeConstantsF.get("js.webpath","http://www.eventbee.com/home/js")%>/popup.js">
        function dummy(){}
</script>

<table width="100%" border="0" cellpadding="0" cellspacing="0" align="center" >
    <tr>
    <td valign="top" rowspan="2" >
      <form name="fnew" id="fnew" method="POST" action="/portal/hub/clubslisting.jsp" onSubmit='hitsubmit(); return false;'>
      <table width="100%" border="0" cellpadding="0" cellspacing="0">
        
        <tr>
          <td height="58" valign="top" >
            <table width="100%" border="0" cellpadding="0" cellspacing="0"  class1="beelet" height="0">
	      <tr>
                <td width="800">
                  <table  cellpadding='5' width='100%' height='0' cellspacing='0'  class='beelet-header' >
		  <tr ><td colspan='2' >
		    <table border='0' cellpadding='0' cellspacing='0' width='100%' >
                    <tr >
                      <td valign='center' >
		      <%
		      String loc=request.getParameter("location");
		      if(loc==null) loc="All";
		       String loc1=loc;
		     	loc=java.net.URLEncoder.encode(loc);
		      %>
		     
			  Keyword</td>
		      <td width='1%'></td>
		      <td ><input type="text" name="keyword" value="<%=reqkeyword%>" size="12"/></td>
		      <td width='1%'></td>
		      <td valign='center'>Type</td>
		      <td width='1%'></td>
		      <td ><%=WriteSelectHTML.getSelectHtml((String[])categoryCode.toArray(new String[0]),(String[])categoryName.toArray(new String[0]),"type",reqtype,null,null)%></td>
		      <td width='1%'></td>
                    </tr>
			
		    <tr><td colspan='8' height='5'></td></tr>
			
		    </table>
		    </td>
		    <td colspan='2' >
		    	<%= com.eventbee.general.PageUtil.writeHiddenCore( (HashMap)request.getAttribute("REQMAP") )%>
		   	<input type="hidden" name="location" value="<%=location%>">
			<input type="hidden" name="country" value="<%=country%>">
			<input value="Search" name="go" type="submit" />
		    </td>
		    </tr>
                  </table>
                </td>
              </tr>
              <tr>
                <td height="30" valign="top">
               
		 <!-- ########################### BEGIN clubs ################################-->
	                  <%@include file="hubcategories.jsp"%>
		<!-- ########################### END clubs ################################-->	  

                </td>
              </tr>
            </table>
          </td>

        </tr>
        
      </table></form>
    </td>
  </tr>
</table>
