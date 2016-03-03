<%@ page import="java.util.*" %>
<%@ page import="com.eventbee.general.*" %>
<%@ page import="com.eventbee.authentication.*" %>
<%@ page import="com.eventbee.noticeboard.NoticeboardDB" %>

<%
	String role=null,groupid=null,grouptype=null,authid=null;
	String appname=("/manager".equalsIgnoreCase(request.getContextPath()))?"/manager":"/portal";
	HashMap hm=(HashMap)session.getAttribute("groupinfo");
	if(hm!=null){
		groupid=(String)hm.get("groupid");
		grouptype=(String)hm.get("grouptype");
	}
	Authenticate authData=AuthUtil.getAuthData(pageContext);
	if (authData!=null){
		 authid=authData.getUserID();
		 role=authData.getRoleName();
	}
	int maxDisplay=5;
	Vector v=NoticeboardDB.getAllNotices(groupid);
	String pname=" ";
	String from=request.getParameter("from");
	if("events".equals(from))			
	  pname=request.getParameter("evtname");
	  
	  
	  else
	  pname=request.getParameter("clubname");
	  
	
	
%>
<%
//if(request.getParameter("frompagebuilder") !=null)
//out.println(PageUtil.startContent("Noticeboard",request.getParameter("border"),request.getParameter("width"),true) );
%>
	   
	   
	   
	   <table class="portaltable" align="center" cellpadding="0" cellspacing="0" width="100%" border='0'>
        <tr><td class='memberbeelet-header'>Noticeboard</td></tr>
      <tr>
     <td>
<%
	if((v==null)||(v.size()==0)){
%>
 	<table align="center" cellpadding="5" cellspacing="0" width="100%" border='0'>
	 <form name='form' action='<%=appname%>/mytasks/enternoticeinfo.jsp' method='post'>
	 <input type='hidden' name='from' value='<%=from%>'/>
	 <input type='hidden' name='pname' value='<%=pname%>'/>
	 
	 
	 <%=com.eventbee.general.PageUtil.writeHiddenCore((HashMap) session.getAttribute("groupinfo"))%>
 	<tr >
	<!--<td  width="100%" align="left" class="oddbase">
	<%= EbeeConstantsF.get("noticeboard.empty.message","please set the property noticeboard.empty.message in emptybeelts.ebeeprops") %>
 	</td>-->
 	<td class='oddbase'><%if("events".equals(from)){%>
 	<%= EbeeConstantsF.get("noticeboard.eventmanage.message","please set the property noticeboard.empty.message in emptybeelts.ebeeprops")%>
 
 	<%}
else {%><%= EbeeConstantsF.get("noticeboard.communitymanage.message","please set the property noticeboard.empty.message in emptybeelts.ebeeprops")%>
 
<%}%></td>
 	</tr>
 	<tr >
 	<td  width="100%" align="right" colspan='4' class='oddbase'>
 	<input type='submit' name='submit' value='Post Notice'/>
         <input type='hidden' name='role' value='<%=role%>'/> 
         <input type='hidden' name='authid' value='<%=authid%>'/>
	 
	 <input type='hidden' name='isnew' value='yes' />
         
	 </td>
 	</tr>
	</form>
	</table>
 <%    
      }else{
 %>

               <table align="center" cellpadding="0" cellspacing="0" width="100%" border='0'>
	       <tr><td width='100%' colspan='3'>
	       <table align="center" cellpadding="0" cellspacing="0" width="100%" border='0'>
	         <form name='form' action='<%=appname%>/noticeboard/delnotice.jsp' method='post'>
	         
		  <%=com.eventbee.general.PageUtil.writeHiddenCore((HashMap) session.getAttribute("groupinfo"))%>
                  <tr >
                  	<td   align="left" colspan='3' class='colheader'>
				<input type='submit' name='submit' value='Delete'/>   
				
			</td>
		  </tr>
			<input type='hidden' name='source' value='getnoticeinfo'/> 
			<input type='hidden' name='authid' value='<%=authid%>'/>
			<input type='hidden' name='from' value='<%=from%>'/>
			<input type='hidden' name='pname' value='<%=pname%>'/>
 <%
                int k=0;
                String base="evenbase";
                for (int j=0;j<v.size();j++){
                	HashMap notice=(HashMap)v.elementAt(j);
 		if(k < maxDisplay){
		if(k%2==0){
			base="oddbase";
		}else{
			base="evenbase";
		}
                k++;
   %>
     <tr >
         <td  width="10%" align="left" class='evenbase'>
                   <input type='checkbox' size='2' name='noticeid' value='<%=notice.get("noticeid")%>'/>
          </td>
          <td class='evenbase' width="20%" align="left" ><%=notice.get("noticetype")%></td>
         <td class='evenbase'  align="left" ><%=notice.get("postedat1")%></td>
        </tr>
        <tr >
         <td class='evenbase'  align="left"  ></td>
         <td class='evenbase'  align="left" ></td>
          <td class='evenbase'  align="left" >
	  	
              <a href='<%=com.eventbee.general.PageUtil.appendLinkWithGroup(appname+"/mytasks/shownoticeinfo.jsp?isnew=yes&noticeid="+notice.get("noticeid")+"&authid="+authid+"&from="+from+"&pname="+pname,(HashMap) session.getAttribute("groupinfo"))%>'>
			 <%=GenUtil.textToHtml(GenUtil.TruncateData((String)notice.get("notice"),18))%>
		</a>
         </td>
         </tr>
    <%
			}
   		}
 %>
  </form>
  </table>
  </td></tr>
  <tr > 
  <td  width="100%" align="right" colspan='3' class='evenbase'>
<%  if(v.size()<5){%>
  <table border='0' cellpadding='0' cellspacing='0'>
  <tr><td>
  	<form name='form' action='<%=appname%>/mytasks/enternoticeinfo.jsp' method='post'>
  	<input type='submit' name='submit' value='Post Notice'/>
  	<input type='hidden' name='from' value='<%=from%>'/>
  	<input type='hidden' name='pname' value='<%=pname%>'/></td></tr>
	 <tr ><td class='<%=("evenbase".equals(base))?"oddbase":"evenbase"%>'>
	         
		<%=com.eventbee.general.PageUtil.writeHiddenCore((HashMap) session.getAttribute("groupinfo"))%>
		<input type='hidden' name='isnew' value='yes' />
		
	</td></tr>	
	</form>	
</table>
<%}%>	
  
            </td>
        </tr>
  </table>
  <%
   if(v.size()>maxDisplay){
   %>
   <%--
   <table align="center" cellpadding="0" cellspacing="0" width="100%" border='0'>
      
        <tr>
        <td   align="center" >
	              <a href='<%=appname%>/noticeboard/getallnoticeinfo?max=1000&u=Manager'>
				All Notices
			</a>
         </td>
         
        </tr>
      </table>
      --%>
   <%
	}
   }
  %>
     </td>
        </tr>
    
  </table>
   <%
//if(request.getParameter("frompagebuilder") !=null)
//		out.println(PageUtil.endContent()); 
%>
