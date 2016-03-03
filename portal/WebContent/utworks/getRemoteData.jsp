<%@ page import="java.util.*" %>
<%@ page import="com.eventbee.general.*" %>
<%@ page import="com.eventbee.general.formatting.*" %>
<%@ page import="com.eventbee.authentication.*" %>
<table border="0" width="100%" cellpadding="0" cellspacing="0" class="block">
<form name="f" method="post" action="getRemoteData1.jsp" >
<tr>
	<td  width="5%" height='30'>Url</td>
	<td width='10%'><input type="text" name="url" value="" size="50"/></td>
</tr>
<tr><td colspan="2" height="5"><table width='100%'>
<tr>
	<td width='1%' >Params</td>
	<td width='10%'>Param1</td><td width='10%'><input type="text" name="param1" value=""/></td><td width='10%'>Value1</td><td width='10%'><input type="text" name="value1" value=""/></td>
</tr>
<tr>
	<td  ></td>
	<td width='10%'>Param2</td><td width='10%'><input type="text" name="param2" value=""/></td><td width='10%'>Value2</td><td width='10%'><input type="text" name="value2" value=""/></td>
</tr>
<tr>
	<td ></td>
	<td width='10%'>Param3</td><td width='10%'><input type="text" name="param3" value=""/></td><td width='10%'>Value3</td><td width='10%'><input type="text" name="value3" value=""/></td>
</tr>
<tr>
	<td  ></td>
	<td width='10%'>Param4</td><td width='10%'><input type="text" name="param4" value=""/></td><td width='10%'>Value4</td><td width='10%'><input type="text" name="value4" value=""/></td>
</tr>
<tr>
	<td ></td>
	<td width='10%'>Param5</td><td width='10%'><input type="text" name="param5" value=""/></td><td width='10%'>Value5</td><td width='10%'><input type="text" name="value5" value=""/></td>
</tr>
<tr>
	<td ></td>
	<td width='10%'>Param6</td><td width='10%'><input type="text" name="param6" value=""/></td><td width='10%'>Value6</td><td width='10%'><input type="text" name="value6" value=""/></td>
</tr>
<tr><td colspan='3' align='center'><input type="submit" name="submit" value="Get Data"/></td></tr>
</table></td></tr>
</form>
</table>

