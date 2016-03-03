<%@ page import="java.lang.management.*" %>
<%@ page import="java.util.*" %>

JVM Memory Monitor
<table border="1">
<tr>
<td>Heap Memory Usage</td><td>Non-Heap Memory Usage</td>
</tr>
<tr>
<td><%=ManagementFactory.getMemoryMXBean().getHeapMemoryUsage()%></td>
<td><%=ManagementFactory.getMemoryMXBean().getNonHeapMemoryUsage()%></td>
</tr>
</table>

Memory Pool MXBeans
<table border="1">
<tr>
<td>Name</td><td>Type</td><td>Usage</td><td>Peak Usage</td><td>Collection Usage</td>
</tr>

<%
Iterator<MemoryPoolMXBean> iter = ManagementFactory.getMemoryPoolMXBeans().iterator();
while (iter.hasNext())
{
MemoryPoolMXBean item = iter.next();
%>
<tr>
<td><%= item.getName() %></td>
<td><%= item.getType() %></td> 
<td><%= item.getUsage()%></td>
<td><%= item.getPeakUsage() %></td>
<td><%= item.getCollectionUsage() %></td>
</tr>
<%
}
%>
</table>