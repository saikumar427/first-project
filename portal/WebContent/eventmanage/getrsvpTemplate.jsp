<%
com.eventbee.general.EmailTemplate defemailtemplate=new com.eventbee.general.EmailTemplate("100","RSVP_CONFIRMATION");
String eventid=request.getParameter("groupid");
String emailtype=request.getParameter("emailtype");

if("reset".equals(emailtype)){
String DELETE_TEMPLATE="delete from email_templates where  purpose='RSVP_CONFIRMATION' and groupid=?";
com.eventbee.general.DbUtil.executeUpdateQuery(DELETE_TEMPLATE,new String[]{eventid});
	}
com.eventbee.general.EmailTemplate emailtemplate=null;
	
	emailtemplate=new com.eventbee.general.EmailTemplate("13579","RSVP_CONFIRMATION",eventid);
	
		if("Text".equals(emailtype)){
     	
     	if(emailtemplate!=null&&emailtemplate.getTextFormat()!=null&&!"".equals(emailtemplate.getTextFormat())){
     	
     	out.println(emailtemplate.getTextFormat().trim());
     	}
     	else
     	out.println(defemailtemplate.getTextFormat().trim());
     	
     	}
     	else
     	{
     	if(emailtemplate!=null&&emailtemplate.getHtmlFormat()!=null&&!"".equals(emailtemplate.getHtmlFormat()))
     	
	out.println(emailtemplate.getHtmlFormat().trim());
          else
          out.println(defemailtemplate.getHtmlFormat().trim());
       
      }
      %>