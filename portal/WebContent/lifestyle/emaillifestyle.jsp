<%@ page import="com.eventbee.general.formatting.*" %>
<%@ page import="com.eventbee.general.*" %>
<%-- out.println(PageUtil.startContent(null,request.getParameter("border"),request.getParameter("width"),true) );--%>
<%
String homepageurl=EbeeConstantsF.get("lifestyle.homepage.url","lifestyle.desihub.com");
%>
<table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF">



<tr>
          <td  width="800" height="30">
            <table width="100%"  >
	    	<tr><td height="30" >
		<span class='bigfont'><a href='/portal/lifestyle/lifestyle.jsp' >&raquo; Start your Lifestyle</a></span>
		
		<span class='smallfont'>[<a href="/portal/helplinks/StartyourLifestyle.jsp">Friends, Photos, Blogging and more...</a>]</span>
		</td></tr>
		<tr>
			<td height="30" >
			<span class='bigfont'><a href="javascript:popupwindow('/portal/emailprocess/emailprocess.jsp?id=13579&purpose=EMAIL_HOMEPAGE&pageurl=<%=homepageurl%>','Email','800','500')">&raquo; Email this to a friend</a></span>
			</td>
		</tr>
		
		<%
		String useragent = request.getHeader("User-Agent").toLowerCase();
		if(useragent.indexOf("msie") !=-1){
		%>
		<tr>
			<td height="30" >
			<!--<span class='bigfont'><a href="javascript:this.style.behavior='url(#default#homepage)';this.setHomePage('<%=homepageurl%>');">&raquo; Make this your home page</a></span>-->
			<span class='bigfont' onclick="this.style.behavior='url(#default#homepage)';this.setHomePage('<%=homepageurl%>');"><a href="#">&raquo; Make this your home page</a></span>
			</td>
		</tr>
		<%
		}
		%>
		
		</table>
	</td>
</tr>

	<%--<form action="/portal/lifestyle/lifestyle.jsp">
		  <input type='hidden' name='UNITID' value='<%=request.getParameter("UNITID") %>' />
     <tr>
          <td  width="800" height="30">
            <table width="100%"  >
	    	<tr><td height="30" align='center'>
		
		  <input type="submit" name="submit" value="Get your Lifestyle" />
		
	
		  </td></tr>
		<tr><td height="30" >
                  <div align="center"><input type="button" name="button1" value="Email this to a friend" onclick="javascript:popupwindow('/portal/emailprocess/emailprocess.jsp?UNITID=<%=request.getParameter("UNITID")%>&id=<%=request.getParameter("UNITID")%>&purpose=EMAIL_HOMEPAGE&pageurl=<%=homepageurl%>','Email','800','500')"/></div>
                </td></tr>
		<tr>
                <td height="30" >
                  <div align="center"><input type="button" name="button" onclick="this.style.behavior='url(#default#homepage)';this.setHomePage('<%=homepageurl%>');" value="Make this your home page" /></div>
                </td>
		</tr>
		
		</table>
           </td>
      </tr>
        </form>
	--%>
</table>
<%-- out.println(PageUtil.endContent()); --%>
