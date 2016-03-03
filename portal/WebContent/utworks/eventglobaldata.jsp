<%@page import="com.eventbee.cachemanage.CacheManager"%>
<%@page import="com.eventbee.cachemanage.InstanceWatcher"%>
<%@page import="com.eventbee.util.CoreConnector"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.HashSet"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.Set"%>
<%
	String action=request.getParameter("action");
     if(action==null)action="";
     if(!"allow".equals(action)){
			if(session.getAttribute("authDatauttool")==null){
				response.sendRedirect("login.jsp?usereq=eventglobaldata");
				return;
			}
     }
%>
<script type="text/javascript" language="javascript" src="/home/js/blockManage/jquery.js"></script>
<script type="text/javascript" language="javascript" src="/home/js/blockManage/jquery.dataTables.js"></script>
<script type="text/javascript" charset="utf-8">
			$(document).ready(function() {
				
					$('#globalmaptable').dataTable( {
					"sPaginationType": "full_numbers",
					"iDisplayLength":5
				} );
				$('#toggleeventpagetable').dataTable( {
					"sPaginationType": "full_numbers",
					"iDisplayLength":5
				} );
				
			} );
		</script>
		<style type="text/css" title="currentStyle">
			@import "/home/css/blockManage/demo_page.css";
			@import "/home/css/blockManage/demo_table.css";
		</style>
		
		<script>
function removein(id)
{
alert("remove key:"+id.id);
document.getElementById('rmkey').value=id.id;
document.getElementById('mode').value='remove';
document.globaldata.submit();
}
function removeEvent(id){
	alert("removeEvent key:"+id.id);
	document.getElementById('rmkey').value=id.id;
	document.getElementById('mode').value='removeevent';
	document.globaldata.submit();	
}
 function removeAll()
{
	 alert("removeAll"); 
 document.getElementById('mode').value='removeAll';
 document.globaldata.submit();
}
 
 function confirmToggle(){
	 return confirm('Are you sure you want to toggle eventpage');
 }
</script>

<%!
public void toggleEventHandlerFile(String jbossserver){
	System.out.println("toggleEventHandlerFile jbossserver:::: "+jbossserver);
	Map<String, String> params=new HashMap<String, String>();
	params.put("jbossserver",jbossserver);
	CoreConnector cn1=new CoreConnector("http://localhost/customevents/toggleEventHandler.jsp");
	cn1.setArguments(params);
	cn1.setTimeout(500000);
	try{
		cn1.MPost();
	}catch(Exception e){
		   System.out.println("Exception :"+e.getMessage());
	  }
	
}

%>
		

<%
String rmkey=request.getParameter("rmkey");
String mode=request.getParameter("mode");
System.out.println("mode is:"+mode);
System.out.println("rmkey is:"+rmkey);

if("removeAll".equals(mode))
{
	CacheManager.getGlobalMap().clear();
}else if("remove".equals(mode)){
	CacheManager.clearData(rmkey);
}else if("removeevent".equals(mode)){
	if("0".equals(rmkey))
		CacheManager.clearData("0_globalstatic");
	else{
		CacheManager.clearData(rmkey+"_eventinfo");
		CacheManager.clearData(rmkey+"_eventmeta");
		CacheManager.clearData(rmkey+"_ticketsettings");
		CacheManager.clearData(rmkey+"_ticketsinfo");
		CacheManager.clearData(rmkey+"_checkticketstatus");
		CacheManager.clearData(rmkey+"_regformaction");
		CacheManager.clearData(rmkey+"_baseprofiles");
		CacheManager.clearData(rmkey+"_i18nlang");
		CacheManager.clearData(rmkey+"_layoutmanage");
		
	}
}

if(request.getParameter("togglesubmit")!=null && request.getParameter("jbossserver")!=null){
	toggleEventHandlerFile(request.getParameter("jbossserver"));
}

out.println("<center>EventPage GlobalMap</center><br/>");
StringBuffer br=new StringBuffer();
Map<String,InstanceWatcher> globalMap = CacheManager.getGlobalMap();
br.append("<form id='globaldata'  name='globaldata' method='post' action='eventglobaldata.jsp' ><center>Total GlobalMap Size Is: "+globalMap.size()+" &nbsp;&nbsp;<a href='#' onclick='removeAll();'>RemoveAll</a></center> <br/>");

Set<String> globalkeys= globalMap.keySet();
br.append("<input type='hidden' id='rmkey' name='rmkey' value=''><input type='hidden' id='mode' name='mode' value=''>");
br.append("<div style='float:center'><table cellpadding='0' cellspacing='0' border='0' class='display' id='globalmaptable'><thead><tr><th>Keys</th><th>LastAccessTime</th><th>CurrrentTime</th><th>Action</th></tr></thead><tbody>");
for(String key:globalkeys){
	String[] temp;
	temp = key.split("_");
	InstanceWatcher iw=globalMap.get(key);	
 		br.append("<tr><td>"+key+"</td><td>"+new java.util.Date(iw.getLastAccessTime())+"</td><td>"+new java.util.Date()+"</td><td><a href='#' id='"+key+"' onclick='removein(this);'>remove</a>&nbsp;|&nbsp;<a href='#' id='"+temp[0]+"' onclick='removeEvent(this);'>removeEvent</a></td></tr>");
		}
	br.append("</table></div></form><br/>");
	br.append("<form id='toggleevenpage' name='toggleevenpage' method='post' action='eventglobaldata.jsp'><b>Toggle EventPage Name</b></br>");
	br.append("<div style='float:center'><table cellpadding='0' cellspacing='0' border='0'><tr><td><table><tr><td>Select Map:</td><td><select id='jbossserver' name='jbossserver'><option value='jboss7'>Jboss 7</option><option value='jboss4'>Jboss 4</option></select>");
	br.append("</td></tr><tr><td colspan='2'><input type='submit' name='togglesubmit' value='ToggleEventPage' onclick='return confirmToggle();'/></td>"); 
	br.append("</tr></table></td></tr></table></div></form>"); 
	
	 out.println(br.toString());
%>