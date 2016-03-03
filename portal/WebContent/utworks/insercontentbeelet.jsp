<%@ page import="com.eventbee.general.*"%>



<%

String groupid=request.getParameter("clubid");
String grouptype=request.getParameter("grouptype");
String submit="Submit";
String content=DbUtil.getVal("select content from content_beelet where group_id=? and group_type=?",new String[]{groupid,grouptype});
if(content!=null)
submit="Update";

if(content==null||"".equals(content))
content="";

%>
<table border='0' cellpadding='5' cellspacing='5'  align='center'>
<form name='f' action='inserbeeletdata.jsp' method='post'>
<input type="hidden" name="clubid" value="<%=groupid%>" >
<input type="hidden" name="grouptype" value="<%=grouptype%>" >
	<tr>
			<td><input type="text" name="clubid" size="10" value='<%=groupid%>' ></td></tr>
		
	</tr>
	<tr>
		<td><textarea name="content" rows="10" cols="40" ><%=content%> </textarea>
	
	</tr>
	<tr>
		<td align="center"><input type="submit" name="submit" value="<%=submit%>" ></td></tr>
	
	
</form>
</table>


