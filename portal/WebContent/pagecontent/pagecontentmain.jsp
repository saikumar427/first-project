<%@ page import="java.util.*" %>

<%
		HashMap pagemap=(HashMap)session.getAttribute("PAGE_HASH_NETWORK");				
	  	if("true".equals((String)pagemap.get("exists"))){ //
%>			
		 <table  align="center" width="100%">
		 	<tr><td align="right"><table><tr>

				<td>
			   <form  action="/portal/mytasks/nwpagecontentfinal.jsp" method="post">		  
				<input type="hidden" name="edittype" value="delete" />
				<%= com.eventbee.general.PageUtil.writeHiddenCore( (HashMap)request.getAttribute("REQMAP") )%>
				<input type="submit" name="submit" value="Delete"/>
	                   </form>
			   </td>

			    <td>
			    <form  action="/portal/mytasks/nwpageeditmain.jsp?type=Snapshot" method="get">
			    	<%= com.eventbee.general.PageUtil.writeHiddenCore( (HashMap)request.getAttribute("REQMAP") )%>
				<input type="submit" name="submit" value="Edit"/>
			    </form>
			   </td>
			   			   
			     </tr></table>
			</td></tr>
			<tr><td><%=(String)pagemap.get("processStatement")%></td></tr>
			
	      </table>		
<%		
		}			
%>
