package com.eventbee.widget;

import java.util.HashMap;

import org.apache.velocity.VelocityContext;
import org.apache.velocity.app.VelocityEngine;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.eventbee.layout.EventGlobalTemplates;

public class RenderWhereWidgetHTML implements RenderWidgetHTML {

	@Override
	public String getHTML(HashMap<String, String> refHash,
			HashMap<String, String> dataHash, HashMap<String, String> configHash)
			throws Exception {
		JSONObject config_options = new JSONObject(configHash.get("config_options"));
		
		String longitude = dataHash.get("longitude");
		String latitude = dataHash.get("latitude");
		
		String where=config_options.getString("where");
		java.io.StringWriter out=new java.io.StringWriter();
		StringBuffer sbf1=new StringBuffer("");
		try{
			String serveraddress=refHash.get("serveraddress");
			JSONObject json=new JSONObject(where);
		    String wherec=json.has("wherec")?json.getString("wherec"):"";
		    
		    String gmap=json.has("gmap")?json.getString("gmap"):"";
		    JSONArray keyw=json.getJSONArray("keyw");
		    gmap=gmap==null?"":gmap;
		    VelocityContext vcontext = new VelocityContext();
		    vcontext.put("serveraddress", serveraddress);
		    if(wherec!=null && !"".equals(wherec)){
		    	vcontext.put("isWhere", "Yes");
		    	vcontext.put("content", replaceKeyWords(keyw,dataHash,wherec));
		    	if(gmap.indexOf("gmap")>-1)
		  	    {
		    		vcontext.put("isgMap", "Yes");
		    		vcontext.put("longitude", longitude);
		    		vcontext.put("latitude", latitude);
		    		vcontext.put("address", dataHash.get("address1"));
		    		vcontext.put("city", dataHash.get("city"));
		    		vcontext.put("state", dataHash.get("state"));
		    		vcontext.put("country", dataHash.get("country"));
		  	    }
		    }
		 
		    VelocityEngine ve= new VelocityEngine(); 
		    String wherewdgttemplate=configHash.get("global_template_wherewidget");
		    if(wherewdgttemplate==null || "".equals(wherewdgttemplate.trim()))
		    	wherewdgttemplate=EventGlobalTemplates.getTemplateOfLanguage(refHash.get("i18nlang"),"global_template_wherewidget");
			
			try{
		 	  ve.init();
		 	 boolean abletopares=ve.evaluate(vcontext,out,"ebeetemplate",wherewdgttemplate);
		 	  sbf1=out.getBuffer();
		 	  }
		 	  catch(Exception exp){
		 	  System.out.println("Exception occured in evaluate velocity"+exp.getMessage());
		 	  exp.printStackTrace();
		 	  } 
		}catch(Exception e){
			System.out.println(" where parsing error "+e.getMessage()); 
			//e.printStackTrace();
		}
		
		
	      return sbf1.toString();
}
	

	@Override
	public Boolean IsRenderable(HashMap<String, String> refHash,
			HashMap<String, String> dataHash, HashMap<String, String> configHash)
			throws Exception {
		// TODO Auto-generated method stub
		return true;
	}
	
	private static String replaceKeyWords(JSONArray keywords,HashMap<String, String> datahash, String content){
		try {
			for(int i=0;i<keywords.length();i++){			
					String key = keywords.getString(i);				
					String value=datahash.get(key.replace("$", "").toLowerCase());	
					value=value==null?"":value;			    			 
			          if(content.contains(key)){
			        	  if(value!=null && "".equals(value.trim())){	
				        		 int index=content.indexOf(key);			
				        		 if(index+key.length()+2<content.length()-1)
				        		    content=content.replace(content.substring(index,index+key.length()+2), "");	
				        		
				        		 else
				        			 content=content.replace(content.substring(index,index+key.length()), "");	
				        	 }
				        	 	else
							      content=content.replace(key, value);			    	  
				         }  		         
			     }
		} catch (JSONException e) {
			System.out.println("exception while replacing key words"+e.getMessage());	
			}
		return content;
	}

}
