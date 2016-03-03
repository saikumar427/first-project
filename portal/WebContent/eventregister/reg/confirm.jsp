<%@ page import="com.eventbee.event.*"%>
<%@ page import="com.eventbee.eventsponsors.*"%>
<%@ page import="com.eventbee.authentication.*"%>
<%@ page import="com.eventbee.survey.*"%>
<%@ page import="com.eventbee.general.formatting.*"%>
<%@ page import="com.eventbee.general.*"%>
<%@ page import="java.util.*"%>






<%

String contextpath="/manager".equals( request.getContextPath() )?"/manager":"/portal";
String CLASS_NAME="reg/confirm.jsp";
EventRegisterBean jBean= (EventRegisterBean)session.getAttribute("regEventBean");
if(jBean==null){
		response.sendRedirect("/guesttasks/regerror.jsp");
		return;
}

EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG, CLASS_NAME, "in service", "insertedentry value is "+(String)jBean.getObject("insertedentry"), null);
if("Y".equals((String)jBean.getObject("insertedentry"))){
		response.sendRedirect("/guesttasks/regend.jsp?GROUPID="+jBean.getEventId());
		return;
}

if(jBean!=null){
	session.setAttribute("regerrors",null);
		String policy=request.getParameter("policy");
		jBean.setPolicy(policy);
		 
	   
	   	
	  
	   
	   if ((jBean.getGrandTotal()>0)&&("eventbee".equals(jBean.getSelectPayType()))){
                        jBean.setCardParams();
                        if("FB".equals(request.getParameter("context"))){
                       	 	response.sendRedirect(session.getAttribute("HTTPS_SERVER_ADDRESS")+"/guesttasks/regpayment.jsp?GROUPID="+jBean.getEventId()+"&context=FB");
							return;
                        }else{
	                      	response.sendRedirect(session.getAttribute("HTTPS_SERVER_ADDRESS")+"/guesttasks/regpayment.jsp?GROUPID="+jBean.getEventId());
							return;
						}
            }else{
                   
            
            
            
                        if(jBean.getUpgradeRegStatus()){
                        
			EventTicket[] eot=jBean.getSelectedOptTickets();
	                ProfileData[] pds=jBean.getProfileData();
 	               EventRegisterManager erm=new EventRegisterManager();
				    
                        
                        if(eot==null||eot.length==0){
                      erm.UpdateRegistrationProfile(jBean,pds);
			response.sendRedirect("/guesttasks/updateProfileInfo.jsp?GROUPID="+jBean.getEventId());
			return;
                        }
                        else{
                         jBean.setContextUnitid("13579");
 
                     StatusObj  sobj=jBean.registerEvent();
			   if(!(sobj.getStatus())){
				   response.sendRedirect("/guesttasks/regerror.jsp?GROUPID="+jBean.getEventId());
				   return;
			   }else{
					jBean.setObject("insertedentry", "Y");
					response.sendRedirect("/guesttasks/regend.jsp?GROUPID="+jBean.getEventId());
				        return;
				
				}   }
                        
                        
                        }else{
                          jBean.setContextUnitid("13579");
 			  StatusObj  sobj=jBean.registerEvent();
			   if(!(sobj.getStatus())){
				   response.sendRedirect("/guesttasks/regerror.jsp?GROUPID="+jBean.getEventId());
				   return;
			   }else{
					jBean.setObject("insertedentry", "Y");
					if("FB".equals(request.getParameter("context"))){
					response.sendRedirect("/guesttasks/regend.jsp?GROUPID="+jBean.getEventId()+"&context=FB");
					}else{
					
					
					
					                                      String paltform=(String)session.getAttribute("platform");
											String domain=(String)session.getAttribute("domain");
											String oid=(String)session.getAttribute("ningoid");
					
														
					
											if("ning".equals(paltform))
											{
					
											%>
											<script>
											top.location.href='http://<%=domain%>/opensocial/application/show?appUrl=http%3A%2F%2Fwww.eventbee.com%2Fhome%2Fning%2Feventregister.xml%3Fning-app-status%3Dnetwork&owner=<%=oid%>&view_eventid=<%=jBean.getEventId()%>&view_purpose=regdone';
				
											</script>
											<%
					
											return;
											}

					response.sendRedirect("/guesttasks/regend.jsp?GROUPID="+jBean.getEventId());
				
				
				     }
					
				}
				}
		}	
		
}else{
	response.sendRedirect("/guesttasks/regerror.jsp?GROUPID="+jBean.getEventId());
}
%>
