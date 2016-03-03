package com.eventbee.widget;

import java.util.ArrayList;
import java.util.HashMap;

import org.apache.velocity.VelocityContext;
import org.apache.velocity.app.VelocityEngine;
import org.json.JSONObject;

import com.eventbee.general.GenUtil;
import com.eventbee.layout.DBHelper;
import com.eventbee.layout.EventGlobalTemplates;

public class RenderAttendeezoneWidgetHTML implements RenderWidgetHTML {

	@Override
	public String getHTML(HashMap<String, String> refHash,
			HashMap<String, String> dataHash, HashMap<String, String> configHash)
			throws Exception {
		JSONObject config_options = new JSONObject(configHash.get("config_options"));
		String data=config_options.getString("attendeezone");
		java.io.StringWriter out=new java.io.StringWriter();
		StringBuffer sbf=new StringBuffer();
		try{
		
		String serveraddress=refHash.get("serveraddress");
		String groupid=refHash.get("eventid");
		String optionslist="",azoptions="";
		JSONObject jsondata=new JSONObject(data);
		optionslist=jsondata.get("attendeezoneoptions")+"";
	    if(optionslist!=null && !"".equals(optionslist))
			azoptions=optionslist.substring(1, optionslist.length()-1);
			String[] strarr=GenUtil.strToArrayStr(azoptions,",");
			ArrayList<String> attendeezoneoptions=new ArrayList<String>();
			for(int i=0;i<strarr.length;i++){
				attendeezoneoptions.add(strarr[i]);
			}
			JSONObject labels=jsondata.getJSONObject("labels");
			
			VelocityContext vcontext = new VelocityContext();
			vcontext.put("serveraddress", serveraddress);
			vcontext.put("eid", groupid);
			if(attendeezoneoptions.contains("contact")){
				String contactlabel=labels.getString("contact");
				if(contactlabel==null || "".equals(contactlabel))contactlabel="Contact";
				vcontext.put("contactlink", "Yes");
				vcontext.put("contactlabel", contactlabel);
				
			}
			
            if(attendeezoneoptions.contains("gettickets")){
            	String getticketslabel=labels.getString("gettickets");
				if(getticketslabel==null || "".equals(getticketslabel))getticketslabel="Tickets";
            	vcontext.put("getticketslink", "Yes");
            	vcontext.put("getticketslabel", getticketslabel);
			}
            
            if(strarr.length==0){}else{
            	
                VelocityEngine ve= new VelocityEngine(); 
         	    
                String attendeezonetemplate=configHash.get("global_template_attendeezone");
                System.out.println("attendeezonetemplate is:"+attendeezonetemplate);
                if(attendeezonetemplate==null || "".equals(attendeezonetemplate.trim()))
                	attendeezonetemplate=EventGlobalTemplates.getTemplateOfLanguage(refHash.get("i18nlang"),"global_template_attendeezone");
    			try{
          	  ve.init();
          	  boolean abletopares=ve.evaluate(vcontext,out,"ebeetemplate",attendeezonetemplate);
          	  sbf=out.getBuffer();
          	  }
          	  catch(Exception exp){
          	  System.out.println("Exception occured in evaluate velocity"+exp.getMessage());
          	  exp.printStackTrace();
          	  }  
            	
            }
		
		}catch(Exception e){
			System.out.println("Exception occured in RenderAttendeezoneWidgetHTML"+e.getMessage());
			e.printStackTrace();
		}
		return sbf.toString() ;
    }

	@Override
	public Boolean IsRenderable(HashMap<String, String> refHash,
			HashMap<String, String> dataHash, HashMap<String, String> configHash)
			throws Exception {
		System.out.println("IsRenderable method of attendeezone");
		try{
		JSONObject config_options = new JSONObject(configHash.get("config_options"));
		String data=config_options.getString("attendeezone");
		String azoptions="",optionslist="";
		JSONObject jsondata=new JSONObject(data);
		optionslist=jsondata.get("attendeezoneoptions")+"";
		if(optionslist!=null && !"".equals(optionslist))
			azoptions=optionslist.substring(1, optionslist.length()-1);
			String[] strarr=GenUtil.strToArrayStr(azoptions,",");
		if(strarr.length==0)
			return false;
		}catch(Exception e){
			System.out.println("Attendeezone IsRenderable  parsing error "+e.getMessage());
			return false;
		}
		return true;
	}
}
