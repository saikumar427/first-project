<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%
   /*
   String  path="D:\\jboss-4.2.2.GA\\server\\default\\deploy\\adminconsole.war\\";
   String  logfilepath="D:\\jboss-4.2.2.GA\\server\\default\\deploy\\adminconsole.war\\";
   String  tailscript="exp.bat";
   String  clearscript="clear.bat";
   */
    
    
  String  logfilepath="/mnt/jboss-nts/jboss-4.2.2.GA/bin/";
  String path="/mnt/jboss-nts/jboss-4.2.2.GA/server/default/deploy/portal.ear/portal.war/helplinks/";  
  String  tailscript="logtail.sh";
  String  clearscript="clearlog.sh";
  
  String  inlbfilename="aboutus.jsp";
  String  inlbfilename2="aboutus";
   
   String  logcontent="";
   String  size="";
   String  clearlogerror="";
   String  linenumber=request.getParameter("range");
   String  selectedlogfile=request.getParameter("logfile");
   String  clearlogfile=request.getParameter("clearlogfile");
   String ipaddress=request.getLocalAddr();
   String  outputfile=ipaddress+"_logout.txt";
   
   if(linenumber==null) linenumber="";
   if(clearlogfile==null) clearlogfile="";
   if(selectedlogfile==null) selectedlogfile="";
   File inlbfilehandle=new File(path+inlbfilename);
   File inlbfilehandle2=new File(path+inlbfilename2);
   int index=selectedlogfile.lastIndexOf("\\");
   
   	 if("remove".equals(request.getParameter("actiontype"))){
    inlbfilehandle.renameTo(new File(path+inlbfilename2));
	}	
  if("put".equals(request.getParameter("actiontype"))){
    inlbfilehandle2.renameTo(new File(path+inlbfilename));
	}	
   if(!"".equals(linenumber)){   
   File outputfilehandle=new File(logfilepath+outputfile); 
   try{
      if(!outputfilehandle.exists())
	 System.out.println("outputfilehandel"+outputfilehandle.createNewFile());
	 Process p = Runtime.getRuntime().exec(logfilepath+tailscript+" " +linenumber+" "+selectedlogfile+" "+logfilepath+outputfile);
     if(p!=null) p.waitFor();
	 }catch(Exception e){
	 System.out.println("Exception :"+e.getMessage());
	 }
    try{
     BufferedReader br=new BufferedReader(new FileReader(outputfilehandle));
	String log="";
    while((log=br.readLine())!=null)
    {
      log=log+"\n";
	  logcontent=logcontent+log;
	 }	
	 
	 }catch(Exception e){
	   logcontent+="Could not read log file";
	  }
	 }
	
  if("clear".equals(request.getParameter("actiontype"))){
     try{
	   Process p = Runtime.getRuntime().exec(logfilepath+clearscript+" "+selectedlogfile);
       if(p!=null) p.waitFor();	
	  }catch(Exception e){
	 clearlogerror="Exception :"+e.getMessage();
	 }
  }	
%>
<html>
<head>
<script>
  function linenumber()
  {
    var linenumber=document.logtext.range.value;
	var sellogfile=document.logtext.logfile.value;
	if(isNaN(linenumber)){
	  alert("Enter Valid Number");
	  return;
	}
	if(linenumber=="")
	{
	  alert("Enter No of Lines"); 
	  return;
	}
	if(sellogfile=="")
	{
	  alert("Select Log File"); 
	  return;
	}
	document.logtext.submit();
	}
 function clearlogfiles()
{
  var sellogfile=document.logtext.logfile.value;
  if(sellogfile=="")
       {
         alert("Select Log File");
         return;
       }
document.clearlogfrm.logfile.value=sellogfile;
document.clearlogfrm.submit();
}	
</script>
</head>
<body>
    <form method="post">
	<table>
	<tr><td>
	<%
	if(!inlbfilehandle.exists() && !inlbfilehandle2.exists()){
	%>
	Health check system files not found!
	<%
	}
	else if(inlbfilehandle.exists() && inlbfilehandle2.exists()){
	%>
	Both Health check system files are there. Something is wrong!
	<%
	}
	else if(inlbfilehandle.exists()){
	%>
	<input type="hidden" name="actiontype" value="remove">
	Server in LB <input type="submit" value="Remove From LB">
	<%
	}
	else{
	%>
	<input type="hidden" name="actiontype" value="put">
	Server is not in LB <input type="submit" value="Put In Lb">
	<%
	}
	%>
	</td></tr>
	</table></form>
	<form name="logtext" method="post">
	 <table>
	 <tr><td>Show no of lines in the log file :&nbsp;<input type="text" name="range" value="100">&nbsp;<input type="button" value="Get" onclick="linenumber()">
	  <select name="logfile"><option value="">Select</option>
	  
	  <!--
	                <option value="D:\\jboss-4.2.2.GA\\server\\default\\deploy\\adminconsole.war\\b.txt">nohup.out</option>
			<option value="D:\\jboss-4.2.2.GA\\server\\default\\deploy\\adminconsole.war\\c.txt">server.log</option>
			<option value="D:\\jboss-4.2.2.GA\\server\\default\\deploy\\adminconsole.war\\d.txt">eventbee.log</option>
			<option value="D:\\jboss-4.2.2.GA\\server\\default\\deploy\\adminconsole.war\\e.txt">exceptions.log</option>
	 -->
	
	<option value="/mnt/jboss-nts/jboss-4.2.2.GA/bin/nohup.out">nohup.out</option>
	<option value="/mnt/jboss-nts/jboss-4.2.2.GA/server/default/log/server.log">server.log</option>
	<option value="/mnt/jboss-nts/log/Eventbee.log">eventbee.log</option>
	<option value="/mnt/jboss-nts/log/Eventbee-exceptions.log">exceptions.log</option>
	
	 </select></td>
	 </tr>
	 <%if(!"".equals(linenumber)){%>
	 <tr><td colspan="2"><textarea name="logcontent" id="logcontent" rows="15" cols="70" ><%=logcontent%></textarea></td></tr><%}%>
	 </table>
	 </form>
	 <form method="post" action="serveradmin.jsp" name="clearlogfrm">
	<table>
	<tr><td><b>Clear Log Files:</b></td></tr>
     <tr><td><%=clearlogerror%></td></tr>
	<tr><td><%=selectedlogfile%>&nbsp;&nbsp;<%=new File(selectedlogfile).length()+" Bytes"%><input type="button"  value=" Clear Now" onclick="clearlogfiles()" /></td></tr>
	<input type="hidden" name="actiontype" value="clear">
	<input type="hidden" name="logfile" value='<%=selectedlogfile%>'>
	 </table></form>
</body>
</html>