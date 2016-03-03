<%@ page import="java.util.*,com.eventbee.general.*" %>
<%@ page import="com.eventbee.context.ContextConstants,com.eventbee.authentication.*,com.eventbee.general.formatting.*" %>
<%@ page import="com.eventbee.mythemes.*" %>
<%!

%>

<%
String CLASS_NAME="blogtheme.jsp";
String username=request.getParameter("uname");
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG, "CLASS_NAME", "null", "username  value is-------"+username,null);
if(request.getParameter("frompagebuilder") !=null)
out.println(PageUtil.startContent("My Blog Page Theme",request.getParameter("border"),request.getParameter("width"),true) );
String ThemeQuery="select editortheme from website where userid=(select id from rolleruser where username=?)";
String networktheme=mythemesDb.themeName(ThemeQuery,username);
if(networktheme==null)
networktheme="bluesky";
System.out.println("networkthemeeeeeeeeeeeeeee"+networktheme);
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG, "CLASS_NAME", "null", "networktheme value is-------"+networktheme,null);

%>
<table cellpadding="0" cellspacing="0"  width="100%">
<tr class="evenbase">
	<td class="evenbase"><a href="/blogs/eroller/content.jsp?act=eeditTheme&amp;rmik=tabbedmenu.website.themes&amp;username=<%=username%>"><%=networktheme%></a>
	</td>
</tr>
</table>

<%
//http://192.168.0.50:8080/blog/editor/themeEditor.do?method=edit&rmik=tabbedmenu.website.themes&username=udayala
if(request.getParameter("frompagebuilder") !=null)
		out.println(PageUtil.endContent());
%>


