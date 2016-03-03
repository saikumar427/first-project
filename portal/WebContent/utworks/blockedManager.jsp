 <%@page import="java.util.*,java.text.SimpleDateFormat, com.eventbee.filters.IPFilter,java.util.Map.Entry,com.eventbee.general.DateUtil,java.util.Date"%>
 <%
	if(session.getAttribute("authDatauttool")==null){
		response.sendRedirect("login.jsp?usereq=blockedManager");
		return;
	}
%>
 
 <script>

 
 function syncdb(){
 alert("sync");
 document.getElementById('mode').value='sync';
 document.blockmng.submit();
 }
 
  function removein(id)
 {
 alert("remove Ip:"+id.id);
 document.getElementById('ip').value=id.id;
 document.getElementById('mode').value='remove';
 document.blockmng.submit();
 }
  function removeAll()
 {
  document.getElementById('mode').value='removeAll';
  document.blockmng.submit();
 }
 function add()
 { alert("Ip:"+document.getElementById('ipblk').value);
   document.getElementById('ip').value=document.getElementById('ipblk').value;
   document.getElementById('mode').value='add';
   document.blockmng.submit();
 }
 function removeCount(id){
 alert("remove Ip:"+id.id);
 document.getElementById('ip').value=id.id;
 document.getElementById('mode').value='removeCount';
 document.blockmng.submit();
 }
 function removeCountAll(){
 document.getElementById('mode').value='removeCountAll';
  document.blockmng.submit();
 }
 var dis="none";
 function showhide(){
 if(dis=="none")
 {document.getElementById('ipcount').style.display="block";
 dis="block";
 }
 else
 {document.getElementById('ipcount').style.display="none";
  dis="none";
 }
 }
 function setGlobalCount(){
   alert("Limitcount:"+document.getElementById('gblcnt').value);
   document.getElementById('mode').value='setGlobalLimit';
   document.blockmng.submit();
 
 }
 function changeDate(){
   alert("changeDate:"+document.getElementById('gdate').value);
   document.getElementById('mode').value='changeDate';
   document.blockmng.submit();
 
 }
 function changeTimecount(){
 
   alert("changeTimecount:"+document.getElementById('chtime').value);
   document.getElementById('mode').value='changeTime';
   document.blockmng.submit();
 }
 function setBlockflag(){
  document.getElementById('mode').value='changeBlockFlag';
  document.blockmng.submit();
 }
 
function addunblkip(){
  alert("unblkip is:"+document.getElementById('unblkip').value);
  document.getElementById('unblkmode').value='addunblkip';
  document.unblockmng.submit();
}

 function unblkremoveAll(){
  document.getElementById('unblkmode').value='removeAll';
  document.unblockmng.submit();
 }

 function removeUnblkCount(unblkid){
 alert("remove unblock Ip:"+unblkid.id);
 document.getElementById('unblkip').value=unblkid.id;
 document.getElementById('unblkmode').value='removeunblkIp';
 document.unblockmng.submit();
 }

</script>
<script type="text/javascript" language="javascript" src="/home/js/blockManage/jquery.js"></script>
<script type="text/javascript" language="javascript" src="/home/js/blockManage/jquery.dataTables.js"></script>
<script type="text/javascript" charset="utf-8">
			$(document).ready(function() {
				$('#example').dataTable( {
					"sPaginationType": "full_numbers",
					"iDisplayLength":5
				} );
					$('#ipblktable').dataTable( {
					"sPaginationType": "full_numbers",
					"iDisplayLength":5
				} );
				
			} );
		</script>
		<style type="text/css" title="currentStyle">
			@import "/home/css/blockManage/demo_page.css";
			@import "/home/css/blockManage/demo_table.css";
		</style>
<%! public long getDateDiffer(String dateStart,String dateStop){
		long result=0;
       try{ SimpleDateFormat format = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss");	     
		Date d1 = null;
		Date d2 = null;
		d1 = format.parse(dateStart);
		d2 = format.parse(dateStop);

		//in milliseconds
		long diff = d2.getTime() - d1.getTime();
	    //in mins
		result = diff / (60 * 1000);
		
       }catch(Exception e){
	   System.out.println("timeException"+e.getMessage());
	   }
		return result;
	}%>

 <%

 String ip=request.getParameter("ip");
 String mode=request.getParameter("mode");
 String gblcnt=request.getParameter("gblcnt");
 String gdate=request.getParameter("gdate");
 String chtime=request.getParameter("chtime");
 String blkflag="Active";
 String unblkip=request.getParameter("unblkip");
 if(unblkip==null)unblkip="";
 String unblkmode=request.getParameter("unblkmode");
 if(unblkmode==null)unblkmode=""; 
 System.out.println("mode is:"+mode);
 System.out.println("ip is:"+ip);
 System.out.println("gblcnt is:"+gblcnt);
 System.out.println("gdate is:"+gdate);
 System.out.println("chtime is:"+gdate);
 System.out.println("Present StartTime is:"+IPFilter.Globalcleardate);
 System.out.println("unblock ip is:"+unblkip);
  
 System.out.println("blockedIpsList::"+request.getHeader("x-forwarded-for")+ "   "+ request.getRemoteAddr());
 
 System.out.println("date:"+DateUtil.getFormatedDate(new Date(), "MM/dd/yyyy HH:mm:ss", new Date().toGMTString()));
 System.out.println("time::"+getDateDiffer(IPFilter.Globalcleardate,DateUtil.getFormatedDate(new Date(), "MM/dd/yyyy HH:mm:ss", new Date().toGMTString())));
 
 out.println("<center>Ipblock Manage</center><br/>");
 if(!"".equals(unblkip) && "addunblkip".equals(unblkmode)){
   if(!IPFilter.allowedIpsList.contains(unblkip)){
	   
       //IPFilter.allowedIpsList.add(unblkip); 
       IPFilter.addAllow(unblkip);
      // IPFilter.blockedIpsList.remove(unblkip);
       IPFilter.removeBlockLoad(unblkip);
   }else{
     //IPFilter.blockedIpsList.remove(unblkip);
     IPFilter.removeBlockLoad(unblkip);
     }   
 }else if(!"".equals(unblkip) && "removeunblkIp".equals(unblkmode)){
   // IPFilter.allowedIpsList.remove(unblkip); 
    IPFilter.removeAllowLoad(unblkip);
  } 

 if(!"".equals(unblkmode) && "removeAll".equals(unblkmode)){
  // IPFilter.allowedIpsList.clear();
	IPFilter.removeAllowLoad();
 }

 if("add".equals(mode) && !"".equals(ip))
{
 if(!IPFilter.blockedIpsList.contains(ip))
 {  // IPFilter.blockedIpsList.add(ip);
	 IPFilter.addBlock(ip);
 if(IPFilter.allowedIpsList.contains(ip))
	 IPFilter.removeAllowLoad(ip);
 //IPFilter.allowedIpsList.remove(ip);
 out.println("<center>added</center><br/>");
 }
} 
 else if("sync".equals(mode)){
	  // IPFilter.allowedIpsList.clear();
		IPFilter.initLoad();
	 }
else if("remove".equals(mode)  && !"".equals(ip)  )
{ //IPFilter.blockedIpsList.remove(ip);
	IPFilter.removeBlockLoad(ip);
  //IPFilter.allowedIpsList.add(ip);
  IPFilter.addAllow(ip);
 out.println("<center>REMOVED ip IS: "+ip+"</center><br/>");
}
else if("removeAll".equals(mode))
{ //IPFilter.blockedIpsList.clear();
   IPFilter.removeBlockLoad();
}
else if("removeCount".equals(mode))
{ IPFilter.GlobalIpsCounts.remove(ip);
}
else if("removeCountAll".equals(mode))
{ IPFilter.GlobalIpsCounts.clear();
}
else if("setGlobalLimit".equals(mode))
{try{ if(Integer.parseInt(gblcnt.trim())< 10)
         { out.println("<font color='red'>Enter Limit Count > 10</font>"); }
  else
  IPFilter.Globalblockcount=Integer.parseInt(gblcnt.trim());
}catch(Exception e){out.println("<font color='red'>Enter Valid Limit Count</font>");}
}
else if("changeDate".equals(mode))
{ IPFilter.Globalcleardate=gdate;
}
else if("changeTime".equals(mode))
{ try{ 
IPFilter.GlobalminitLimit=Integer.parseInt(chtime.trim());
}catch(Exception e){out.println("<font color='red'>Enter Valid TimeLimit Count</font>");}
}
else if("changeBlockFlag".equals(mode))
{ 
  if(IPFilter.blockflag)
  IPFilter.blockflag=false; 
  else
  IPFilter.blockflag=true;  
}


if(IPFilter.blockflag)  
  blkflag="Active";  
  else  
  blkflag="InActive";
 
StringBuffer br=new StringBuffer();

 br.append("<form id='blockmng'  name='blockmng' method='post' action=''><center>Total Ips In Blocked:"+IPFilter.blockedIpsList.size()+" &nbsp;&nbsp;&nbsp;&nbsp;<a href='#' onclick='removeAll();'>removeAll</a></center> <br/>");

 br.append("<div style='width:300px;float:left'>Add Ip &nbsp;&nbsp;&nbsp;&nbsp;<input type='text' id='ipblk' value=''/><input type='button' value='add' onclick='add();'></div>");

 int iplength =IPFilter.blockedIpsList.size();
 br.append("<div style='float:right'><table cellpadding='0' cellspacing='0' border='0' class='display' id='ipblktable'><thead><tr><th>IPs</th><th>Action</th></tr><tbody>");
		for(int i=0;i<iplength;i++){
		String key=IPFilter.blockedIpsList.get(i);
  br.append("<tr><td>"+key+"</td><td><a href='#' id='"+key+"' onclick='removein(this);'>remove</a></td></tr>");
		}
		br.append("</table></div>");
	
	 out.println(br.toString());

  StringBuffer br1=new StringBuffer();

  out.println("<center><div style='clear:both'><br/><br/>IPCount Manage");
  out.println("<input type='hidden' id='ip' name='ip' value=''><input type='hidden' id='mode' name='mode' value=''></div>");
  
  out.println("<div onclick='showhide()' style='cursor:pointer;display:inline;'>Total  Ips:"+IPFilter.GlobalIpsCounts.size()+"&nbsp;&nbsp;&nbsp;&nbsp;<a href='#' onclick='removeCountAll();'>removeAll</a></div></center><br/><br/>");
 
    br1.append("<div style='width:300px;float:left'>");   
    br1.append("BlockStatus:<input type='button' value='"+blkflag+"' onclick='setBlockflag();'><br/><br/>");
  
    br1.append("current Limit:"+IPFilter.Globalblockcount+"<br/><input type='text' id='gblcnt' name='gblcnt' value=''/><input type='button' value='ChangeLimitCount' onclick='setGlobalCount();'><br/><br/>");
	
	br1.append("current Limit Timecount(in mins):"+IPFilter.GlobalminitLimit+"<br/><input type='text' id='chtime' name='chtime' value=''/><input type='button' value='ChangeDate' onclick='changeTimecount();'><br/><br/>");
	
	 
    br1.append("current Limit StartTime:"+IPFilter.Globalcleardate+"<br/><input type='text' id='gdate' name='gdate' value=''/><input type='button' value='ChangeDate' onclick='changeDate();'><br/>(MM/dd/yyyy HH:mm:ss)<br/>");
	
	
	br1.append("<br/>current Time :"+DateUtil.getFormatedDate(new Date(), "MM/dd/yyyy HH:mm:ss", new Date().toGMTString())+"<br/>");
 
	
	 br1.append("<br/>SyncWithDB:<input type='button' value='Sync' onclick='syncdb();'><br/>");
		
     br1.append("</div>");
  
  
  
	Iterator entries =IPFilter.GlobalIpsCounts.entrySet().iterator();
	br1.append("<div id='ipcount' style='float:right;  overflow-y: hidden;  width: 660px;'><table cellpadding='0' cellspacing='0' border='0' class='display' id='example'>	<thead><tr><th>IPs</th><th>Count</th><th>Action</th></tr><tbody>");
	
	while (entries.hasNext()) {
	Entry thisEntry = (Entry) entries.next();
	Object key = thisEntry.getKey();
  
    br1.append("<tr class='gradeA odd'><td>"+key+"</td><td>"+IPFilter.GlobalIpsCounts.get((String)key)+"</td><td><a href='#' id='"+key+"' onclick='removeCount(this);'>remove</a><br/></td></tr>");
		}
	br1.append("</table></div></div>");
	out.println(br1.toString()+"</form><br/>");

        StringBuffer br2=new StringBuffer();
	

      br2.append("<br/><br/><br/><br/><br/><div><form id='unblockmng'  name='unblockmng' method='post' action=''>");

       br2.append("<br><div style='padding-right:250px;padding-top:30px;float:right'>Add Ip to be Allowed List &nbsp;&nbsp;&nbsp;&nbsp;<input type='text' name='unblkip' id='unblkip' value=''/><input type='button' value='addunblockip' onclick='addunblkip();'></div><div><input type='hidden' id='unblkmode' name='unblkmode' value=''></div><br/>");

	br2.append("<br/><br/><br/><br/><div id='unblkipcount' style='float:right;  overflow-y: hidden;  width: 660px;'><table><tr><td><center>Total Ips In UnBlocked:"+IPFilter.allowedIpsList.size()+" &nbsp;&nbsp;&nbsp;&nbsp;<a href='#' onclick='unblkremoveAll();'>removeAll</a></center></td></tr></table><br/><table cellpadding='0' cellspacing='0' border='0' class='display' id='unblkexample'><thead><tr><th>Allowed IPs</th><th>Action</th></tr><tbody>");
	for(String unblockip:IPFilter.allowedIpsList){
		br2.append("<tr class='gradeA odd'><td>"+unblockip+"</td><td><a href='#' id='"+unblockip+"' onclick='removeUnblkCount(this);'>remove</a><br/></td></tr>");
	}
	br2.append("</table></div>");
	out.println(br2.toString()+"</form></div>");
	

%>
