<%@ page import="com.eventbee.general.DbUtil" %>

<%
	String groupid=request.getParameter("GROUPID");
	String clubid=request.getParameter("GROUPID");
	try{
		clubid=""+Integer.parseInt(clubid);
	}
	catch(Exception e){
		clubid="-1";
	}
	String clubname="";
	if(!"-1".equals(clubid))
	clubname=DbUtil.getVal("select clubname from clubinfo where clubid=?",new String[]{clubid});
	if(clubname==null)
	clubname="Community";
	String clubmanagelink="<a href='/mytasks/clubmanage.jsp?type=Community&GROUPID="+clubid+"'/>"+clubname+"</a>";
	String type=request.getParameter("type");
	String title=request.getParameter("title");
        request.setAttribute("tasktitle",title);
	if("mypagesevents".equalsIgnoreCase(type)){
	
			request.setAttribute("mtype","My Public Pages");
			//request.setAttribute("DisplayText","Theme Updated successfully");
			request.setAttribute("nexturl","/portal/mytasks/publicpages.jsp");
			request.setAttribute("URLText","Back to My Public Pages");
			request.setAttribute("tasktitle","My Events Theme Page > <a href='/mytasks/eventstheme.jsp?type=eventspage'>Change Theme</a> > Success");
			

				
	}else if("mypageshubs".equals(type)){
			request.setAttribute("mtype","My Public Pages");
			//request.setAttribute("DisplayText","Theme Updated successfully");
			request.setAttribute("nexturl","/portal/mytasks/publicpages.jsp");
			request.setAttribute("URLText","Back to My Public Pages");
			request.setAttribute("tasktitle","My Community Page > <a href='/mytasks/hubstheme.jsp'>Change Theme</a> > Success");
			

	
    } else if("mypagephotos".equals(type)){
          	request.setAttribute("mtype","My Public Pages");
			//request.setAttribute("DisplayText","Theme Updated successfully");
			request.setAttribute("nexturl","/portal/mytasks/publicpages.jsp");
			request.setAttribute("URLText","Back to My Public Pages");
			request.setAttribute("tasktitle","Photos Theme Page > <a href='/mytasks/photostheme.jsp?type=Photos'>Change Theme</a> > Success");
            
	
	                      
	}else if("mypagephototemplates".equals(type)){
          	request.setAttribute("mtype","My Public Pages");
			request.setAttribute("DisplayText","Templates Updated successfully");
			request.setAttribute("nexturl","/portal/mytasks/publicpages.jsp");
			request.setAttribute("URLText","Back to My Public Pages");
			request.setAttribute("tasktitle","Photos Theme Templates");
                        request.setAttribute("tasksubtitle","Updated");

		                      
	}else if("mypagelifestyle".equals(type)){
	
			request.setAttribute("mtype","My Public Pages");
			//request.setAttribute("DisplayText","Theme Updated successfully");
			request.setAttribute("nexturl","/portal/mytasks/publicpages.jsp");
			request.setAttribute("URLText","Back to My Public Pages");
			request.setAttribute("tasktitle","My  Network  Page Theme > <a href='/mytasks/Networktheme.jsp?type=Snapshot&ltype=theme'>Change Theme</a> > Success");
			

			
		          
			                      
	}else if("hubthemepage".equals(type)){
			
			request.setAttribute("mtype","My Console"); 
			request.setAttribute("DisplayText","Templates Updated Successfully");
			request.setAttribute("nexturl","/portal/mytasks/myhubs.jsp");
			request.setAttribute("URLText"," Back to Communities");
			
			

				                      
	}else if("hubtemplates".equals(type)){
	             
		      request.setAttribute("tasktitle","Community Manage > "+clubmanagelink);
                       request.setAttribute("tasksubtitle"," Theme Templates Updated");
	
	
			request.setAttribute("mtype","My Console"); 
			request.setAttribute("DisplayText","Templates Updated Successfully");
			request.setAttribute("nexturl","/portal/mytasks/clubmanage.jsp?GROUPID="+groupid);
			request.setAttribute("URLText","Back to community manage");

		                     
	}else {
	
			request.setAttribute("mtype","My Themes");
			request.setAttribute("DisplayText","Templates Updated Successfully");
			request.setAttribute("nexturl","/portal/mytasks/mythemes.jsp");
			request.setAttribute("URLText","Back to My Themes");

	
	}%>
<%@ include file="/templates/taskpagetop.jsp" %>

<%
       	taskpage="/mythemes/ThemeDone.jsp";
%>
<%@ include file="/templates/taskpagebottom.jsp" %>
	

	
		
