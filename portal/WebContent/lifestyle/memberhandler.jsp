<%@page import="com.eventbee.authentication.*,java.util.*" %>
<%@ page import="com.eventbee.customconfig.MemberFeatures" %>
<%@ page import="com.eventbee.authentication.AuthDB,com.eventbee.general.*" %>

<%!

List memberpatternlist=new ArrayList();
public void jspInit(){
memberpatternlist.add("blog");
memberpatternlist.add("snapshot");
memberpatternlist.add("photos");
memberpatternlist.add("event");
}

%>


<%
 	
/*
http://192.168.1.50:8080/member/reddynr/yyyy/fdfdfdfd

requri=/member/reddynr/yyyy/fdfdfdfd
http://192.168.1.50:8080/member/reddynr/
requri=/member/reddynr/
http://192.168.1.50:8080/member/reddynr/
requri=/member/reddynr/

*/
String rollercontext=(application.getInitParameter("rollercontext")!=null)?application.getInitParameter("rollercontext"):"/roller";

   	    String pattern=config.getInitParameter("pattern");
	    String codetype=config.getInitParameter("codetype");
	    String requri=request.getRequestURI().trim();
	    //out.println(requri.lastIndexOf("/")+"anr  requri="+requri+"***"+requri.length());
	    if( requri.lastIndexOf("/")==(requri.length()-1 )){
	    	requri= requri.substring(0,requri.lastIndexOf("/"));
	    }
	    String[] uriarr=GenUtil.strToArrayStr(requri,"/");
	    
	    
	    String userid="";
	    String username="";
	    String purpose="snapshot";
	    String invid=request.getParameter("invid");
	    
	    String usertheme="sunsets";
	    
	    
	    if(uriarr.length==2){
	    	username=uriarr[1];
	    }
	    if(uriarr.length==3){
		    username=uriarr[1];
		    purpose=(   memberpatternlist.contains(uriarr[2])   )?uriarr[2]:purpose ;
	    }
	    
	    //String UNITID=EbeeConstantsF.get("defaultunitid","13578");
	    //session.setAttribute("UNITID",UNITID);
	    String redirecturl="/lifestyle/themeprocessornew.jsp";
	    if("snapshot".equals(purpose))request.setAttribute("purpose","Snapshot");
	     if("photos".equals(purpose))
	     {
	     	request.setAttribute("purpose","Photos");
		redirecturl="/photogallery/photothemeprocessor.jsp";
		}
	     
	   //String redirecturl="/lifestyle/themeprocessor.jsp?UNITID="+UNITID;

	    if("event".equals(purpose)){
	       	request.setAttribute("purpose","event");
		redirecturl="/customevents/eventhandler.jsp?GROUPID="+request.getParameter("GROUPID");
           }
	   request.setAttribute("username",username.trim());
	   HashMap hm=(new AuthDB()).getUserPreferenceInfo(username);
	    if(hm!=null){
	    
		      userid=(String)hm.get("user_id");
		       request.setAttribute("userid",userid);
		      
		      HashMap hm1=(new AuthDB()).getUserInfoByUserID(userid);
		      //System.out.println(hm1);
		      if(hm1!=null){
			request.setAttribute("rollerloginname",(String)hm1.get("login_name")    );
			request.setAttribute("userhm",hm1    );
			String fullusername=  DbUtil.getVal( "select getMemberName(?) as fullusername" ,new String[]{userid} );
			request.setAttribute("fullusername",fullusername);
			redirecturl+="?userid="+userid;
			if(!(("".equals(invid))||(invid==null)||("null".equals(invid))))
			redirecturl+="&invid="+invid;
		      }//hm1 !=null
		      
		      if("blog".equals(purpose) ){
		      	response.sendRedirect(rollercontext+"/page/"+(String)request.getAttribute("rollerloginname") );
			return;
		      }else{
			 config.getServletContext().getRequestDispatcher(redirecturl).forward(request, response);
		      }
		      
	      }else{
	      	out.println("information regarding this user is not available");
	      }
	   
	     
	      
%>


