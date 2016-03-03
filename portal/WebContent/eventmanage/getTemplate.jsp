<%
com.eventbee.general.EmailTemplate defemailtemplate=new com.eventbee.general.EmailTemplate("100","EVENT_REGISTARTION_CONFIRMATION");
String eventid=request.getParameter("groupid");
String emailtype=request.getParameter("emailtype");

if("reset".equals(emailtype)){
String DELETE_TEMPLATE="delete from email_templates where  purpose='EVENT_REGISTARTION_CONFIRMATION' and groupid=?";
com.eventbee.general.DbUtil.executeUpdateQuery(DELETE_TEMPLATE,new String[]{eventid});
	}
com.eventbee.general.EmailTemplate emailtemplate=null;
	
	emailtemplate=new com.eventbee.general.EmailTemplate("13579","EVENT_REGISTARTION_CONFIRMATION",eventid);
	
	System.out.println("emailtemplate--"+emailtemplate);
     	if("Text".equals(emailtype)){
     	System.out.println("emailtemplate-text-"+emailtemplate);
     	
     	if(emailtemplate!=null&&emailtemplate.getTextFormat()!=null&&!"".equals(emailtemplate.getTextFormat())){
     	System.out.println("emailtemplate-text-qq"+emailtemplate);
     	
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