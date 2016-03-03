<%@ page import="java.io.*, java.util.*,java.sql.*,com.eventbee.authentication.*,com.eventbee.context.ContextConstants" %>
<%@ page import="com.eventbee.general.*,com.eventbee.general.formatting.*" %>
<%@ page import="com.eventbee.context.ContextConstants,com.eventbee.authentication.*,com.eventbee.general.*" %>
<%
Map propmap=EbeeConstantsF.getAllProperties();

String key1="";
String val1="";

String message="";
String error="";



String submit=request.getParameter("submit");
if(submit != null){

	
	if("SetVal".equals(submit)){
		String tempkey=request.getParameter("key").trim();
		if( !("".equals(tempkey) ) ){
		propmap.put(tempkey,request.getParameter("val").trim());
			message=tempkey+" property is set";
		}else{
			error="Enter a Key";
		}
	}else
	if("GetVal".equals(submit)){
		String tempkey=request.getParameter("key").trim();
		key1=tempkey;
		if( !("".equals(tempkey) ) ){
		val1=EbeeConstantsF.get(tempkey,null);
		if(val1 ==null){
			error="No value for this Key";
			val1="";
		}
		}else{
			error="Enter a Key";
		}
	}else
	if("Reload Prop".equals(submit)){
		EbeeConstantsF.reload();
		propmap=EbeeConstantsF.getAllProperties();
	}else
	if("Remove Key".equals(submit)){
		String tempkey=request.getParameter("key").trim();
		key1=tempkey;
		if( !("".equals(tempkey) ) ){
			propmap.remove( tempkey);
			message=tempkey+" property is removed";
		}else{
			error="Enter a Key";
		}
	}
	

}//submit != null




    
%>

<html title="Properties" sub-title="Manage">
<body>
<form	action="properties" method="post">


<table width="100%"><tr><td align="right"><input type="submit" name="submit" value="Reload Prop"/></td></tr></table>

<table align='center' width='100%'>

<tr><td>


<table width="100%">
<tr><td align="center"><%=message %></td></tr>
<tr><td align="center"><font color="red"><%=error %></font></td></tr>
<tr><td>Key</td><td><input type="text" name="key" value="<%=key1 %>"/></td></tr>
<tr><td>Value</td><td><input type="text" name="val" value="<%=val1 %>"/></td></tr>

</table>
</td>
<td><table>
<tr><td><input type="submit" name="submit" value="GetVal"/></td></tr>
<tr><td><input type="submit" name="submit" value="Remove Key"/></td></tr>

</table></td>
</tr>

<tr><td  align="center"><input type="submit" name="submit" value="SetVal"/></td></tr>



<tr class="subheader"><td class='inform'><b> Keys </b></td><td class='inform'><b> Values</b></td></tr>
<tr class="subheader"><td class='inform'></td><td class='inform'></td></tr>



<%

 Map map = new TreeMap(propmap);
 Set set=map.entrySet();
for( Iterator iter=set.iterator();iter.hasNext();){
		Map.Entry me=(Map.Entry)iter.next();
		String key=me.getKey().toString();
		String val=me.getValue().toString();
		
%>
<tr ><td class='inform'> <%=key %> </td><td class='inform'> <%=val %></td></tr>

<%
	}

%>


</table>

</form>
</body>

</html>
