<%@ page import="java.io.*, java.util.*,java.sql.*,com.eventbee.nuser.*,com.eventbee.general.*" %>
<%@ page import="com.eventbee.context.ContextConstants,com.eventbee.authentication.*,com.eventbee.general.formatting.*" %>


<%
//if(request.getParameter("frompagebuilder") !=null)
out.println(PageUtil.startContent("Member Promotion",request.getParameter("border"),request.getParameter("width"),true) );
%>



<%
   String manid=null;
Authenticate authData=AuthUtil.getAuthData(pageContext);
if (authData!=null){
      	manid=authData.getUserID();
}
    DbUtil dbutil=new DbUtil();
    
   
    String query="select count(*) as count from user_profile b, user_network_request a where  a.status='A' and b.user_id=? and "
      + "(a.user2=b.user_id or a.user1=b.user_id) and to_date(a.accepted_date::text,'yyyy-mm-dd')>to_date('2005-08-01','yyyy-mm-dd')";
    String count=DbUtil.getVal(query,new String [] {manid});
    int count1=Integer.parseInt(count);
    int count2=100-count1;
   
    
     
%>

   <table width="100%" class="portaltable" >
   <form  method="post" name="form" action="/portal/helplinks/promo.jsp">

   
   <tr>
   <td class='evenbase'>Since August 1st, you have added <b><%=count%></b> friends to your friends network at <%=EbeeConstantsF.get("application.name","")%>.
   You just need <b><%=count2%></b> more friends to win an iPod Shuffle, or Creative Muvo.
   This is a limited time offer, <a href="/portal/nuser/NuserFriends.jsp?type=Friends"> invite your friends </a> to your network now!
   
   </td>
   </tr>
   
   <tr><td class='evenbase' align='center'><a href="/portal/helplinks/promo.jsp">More details &raquo </a></td></tr>
   
   </form>
   </table>

  


<%
//if(request.getParameter("frompagebuilder") !=null)
		out.println(PageUtil.endContent());
%>