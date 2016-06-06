package com.eventbee.widget;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;

import org.apache.velocity.VelocityContext;
import org.apache.velocity.app.VelocityEngine;

import com.eventbee.cachemanage.CacheManager;
import com.eventbee.general.DbUtil;
import com.eventbee.general.GenUtil;
import com.eventbee.layout.EventGlobalTemplates;

public class RenderTicketsWidgetHTML implements RenderWidgetHTML {

	@Override
	public String getHTML(HashMap<String, String> refHash,
		HashMap<String, String> dataHash, HashMap<String, String> configHash) {
		String serveraddress=refHash.get("serveraddress");
		String groupid=refHash.get("eventid");
		java.io.StringWriter out=new java.io.StringWriter();
		boolean isrsvp=false,isrecurring=false,isPriority=false;
		String recurringselect="",recurdateslabel="";
		StringBuffer sbf1=new StringBuffer();
		try{
			   HashMap eventinfoMap=(HashMap)CacheManager.getData(groupid, "eventinfo");
				HashMap configMap=((HashMap)(eventinfoMap.get("configmap")));//DBHelper.getConfigValuesFromDb(groupid);
				isrecurring=("Y".equalsIgnoreCase(GenUtil.getHMvalue(configMap,"event.recurring","N")));
				isrsvp=("Yes".equalsIgnoreCase(GenUtil.getHMvalue(configMap,"event.rsvp.enabled","no")));
				isPriority=("Y".equalsIgnoreCase(GenUtil.getHMvalue(configMap,"event.priority.enabled","N")));
				if(isrecurring){
				   recurringselect=(String)eventinfoMap.get("recurringselect");//DBHelper.getRecurringEventDates(groupid,"tickets");
					HashMap hm=(HashMap)eventinfoMap.get("recurringdateslabel");
				   recurdateslabel=(String)hm.get("RecurringDatesLabel");//DBHelper.getRecurringDatesLabel(groupid);
				}   
				VelocityContext vcontext = new VelocityContext();
		 	    vcontext.put("eid",groupid);
		 	    vcontext.put("serveraddress", serveraddress);
		 	    if(isrsvp){
		 	    	vcontext.put("isRsvpEvent","Yes");
		 	    }
		 	   else{
		 		  vcontext.put("isTicketingEvent","Yes");
		 		  if(isrecurring){
		 			  vcontext.put("recurreningSelect",recurringselect);
		 			  vcontext.put("recurringdateslabel",recurdateslabel);
		 		  }
		 		  if(isPriority) vcontext.put("isPriority","Yes");
		 	   }
			   
			   VelocityEngine ve= new VelocityEngine();
			   String tktwdgttemplate=configHash.get("global_template_ticketingwidget");
			   List<String> newTktWidgetList = new ArrayList<String>(Arrays.asList(GenUtil.getHMvalue(configMap,"new.ticket.widget","").split(",")));
			   if(newTktWidgetList.contains(groupid)){
				   tktwdgttemplate=DbUtil.getVal("select template_value from layout_templates where template_key='new_ticketingwidget_template' and lang='en_US'", null);
			   }else{
				   if(tktwdgttemplate==null || "".equals(tktwdgttemplate.trim()))
				   tktwdgttemplate=EventGlobalTemplates.getTemplateOfLanguage(refHash.get("i18nlang"),"global_template_ticketingwidget");
			   }
		 	  try{
		 	  ve.init();
		 	  boolean abletopares=ve.evaluate(vcontext,out,"ebeetemplate",tktwdgttemplate);
		 	  sbf1=out.getBuffer();
		 	  }
		 	  catch(Exception exp){
		 	  System.out.println("Exception occured in evaluate velocity"+exp.getMessage());
		 	  exp.printStackTrace();
		 	  }  
		}catch(Exception e){
			System.out.println("Exception occured in RenderTicketsWidgetHTML"+e.getMessage());
			e.printStackTrace();
		}
 	    return sbf1.toString();
	}

	@Override
	public Boolean IsRenderable(HashMap<String, String> refHash,
			HashMap<String, String> dataHash, HashMap<String, String> configHash) {
		// TODO Auto-generated method stub
		return true;
	}

}
