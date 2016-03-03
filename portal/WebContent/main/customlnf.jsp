<%@ page import="java.util.*,com.eventbee.general.*,com.eventbee.general.formatting.*,com.themes.*,java.io.*" %>
<%!
String query="select themecode,themetype from user_roller_themes where userid=? and module='hubpage' and refid=(select clubid from clubinfo where mgr_id=? and created_by='AUTOHUB')";
DBManager dbmanager=new DBManager();
String THEMEQ="select themecode,themetype,module from user_roller_themes where refid=? and module like ?";
	HashMap getthemeval(String userid){

		HashMap hm=new HashMap();
		StatusObj stobj=dbmanager.executeSelectQuery(query,new String[]{userid,userid});
		if(stobj.getStatus()){
			hm.put("themecode",dbmanager.getValue(0,"themecode",""));
			hm.put("themetype",dbmanager.getValue(0,"themetype",""));
		}
		return hm;
	}
	
	HashMap getThemeDetails(String refid,String module){
				
			HashMap hm=new HashMap();
			StatusObj stobj=dbmanager.executeSelectQuery(THEMEQ,new String[]{refid,module});
			if(stobj.getStatus()){
				hm.put("themecode",dbmanager.getValue(0,"themecode",""));
				hm.put("themetype",dbmanager.getValue(0,"themetype",""));
			}
			return hm;
	}
	
%>

<%

if(request.getAttribute("CustomLNF_Type")!=null){
     String referid=(String)request.getAttribute("CustomLNF_ID");
    
     String header=null;
     String footer=null;
     HashMap hm=null;
     String themecode="";
     String themetype="";
     String cssurl=null;
     String navhtml=null;
			

    if("Community".equals(request.getAttribute("CustomLNF_Type"))){
    	String userid=DbUtil.getVal("select userid from group_partner where partnerid=? and status='Active'",new String [] {referid});
    	String hasheader=DbUtil.getVal("select 'yes' from layout_config where refid=(select clubid from clubinfo where mgr_id=? and created_by='AUTOHUB') and idtype=? ",new String [] {userid,"COMMUNITY_HUBID"});
	
        if("yes".equals(hasheader)){
			DBManager dbmanager=new DBManager();
			StatusObj statobj=dbmanager.executeSelectQuery("select * from configure_looknfeel where refid=(select clubid from clubinfo where mgr_id=? and created_by='AUTOHUB') and idtype=? ",new String []{userid,"COMMUNITY_HUBID"});
			if(statobj.getStatus()){
			
			header=dbmanager.getValue(0,"headerhtml",null);
			footer=dbmanager.getValue(0,"footerhtml",null);
			
			}
			request.setAttribute("CUSTOM_HEADER",header);
   			request.setAttribute("CUSTOM_FOOTER",footer);

			
		}  
		 hm=getthemeval(userid);
			
		if(hm!=null){
		themecode=GenUtil.getHMvalue(hm,"themecode","",true);
		themetype=GenUtil.getHMvalue(hm,"themetype","",true);
		}

		if("DEFAULT".equals(themetype))
		{

		cssurl=DbUtil.getVal("select cssurl from ebee_roller_def_themes where module='hubpage' and themecode=?",new String [] {themecode});

		}

		else{
		String url=DbUtil.getVal("select cssurl from user_roller_themes where module='hubpage' and refid=(select clubid from clubinfo where mgr_id=? and created_by='AUTOHUB') and userid=?",new String [] {userid,userid});

		String path="hubpage/"+themetype+"/"+url;
		//cssurl=ThemeFileController.readFilesNReturnContent(path);
                cssurl=ThemeController.getDetailPageCSS(themecode,themetype,"hubpage",referid);
		}

		request.setAttribute("CUSTOM_CSS",cssurl);
		}

  	if("EventDetails".equals(request.getAttribute("CustomLNF_Type"))){
  		String hasheader=DbUtil.getVal("select 'yes' from layout_config where refid=? and idtype=? ",new String [] {referid,"eventdetails"});
		String thememodule="event";	
		String fb_ebee_theme=null;
		        if("yes".equals(hasheader)){
				DBManager dbmanager=new DBManager();
				StatusObj statobj=dbmanager.executeSelectQuery("select * from configure_looknfeel where refid=? and idtype=? ",new String []{referid,"eventdetails"});
				if(statobj.getStatus()){

				header=dbmanager.getValue(0,"headerhtml",null);
				footer=dbmanager.getValue(0,"footerhtml",null);

				}
				request.setAttribute("CUSTOM_HEADER",header);
				request.setAttribute("CUSTOM_FOOTER",footer);
			}else{
				header="";
				request.setAttribute("CUSTOM_HEADER",header);
				request.setAttribute("CUSTOM_FOOTER",footer);
			}
    	
  			 hm=getThemeDetails(referid,"event%");
  			if(hm!=null){
  				themecode=GenUtil.getHMvalue(hm,"themecode","basic",true);
  				themetype=GenUtil.getHMvalue(hm,"themetype","DEFAULT",true);
  				thememodule=GenUtil.getHMvalue(hm,"module","event",true);
  	                }
  			   
  		         if("DEFAULT".equals(themetype)){
  		         	//System.out.println("context val in customlnf.jsp======="+request.getParameter("context"));
  		         	if("FB".equals(request.getParameter("context"))){
  		         		fb_ebee_theme=DbUtil.getVal("select fbtheme  from facebook_ebee_themes where ebeetheme=?", new String []{themecode});
  		         		if(fb_ebee_theme==null)
							fb_ebee_theme="basic";
  		         		cssurl=DbUtil.getVal("select cssurl from ebee_roller_def_themes where module='event_fb' and themecode=?",new String [] {fb_ebee_theme});
  		         	}
  		         	
  		         	
  		         	
  		         	
  		         	else{
  		         	 	cssurl=DbUtil.getVal("select cssurl from ebee_roller_def_themes where module='event' and themecode=?",new String [] {themecode});
  		         	 }
  				}
  			else{
  				if("FB".equals(request.getParameter("context"))){
  					cssurl=DbUtil.getVal("select cssurl from ebee_roller_def_themes where module='event_fb' and themecode=?",new String [] {"basic"});
  				}else{
	  				String url=DbUtil.getVal("select cssurl from user_roller_themes where module='event' and refid=?",new String [] {referid});
	  				String path="event/"+themetype+"/"+url;
	  				//cssurl=ThemeFileController.readFilesNReturnContent(path);
	  				   cssurl=ThemeController.getDetailPageCSS(themecode,themetype,thememodule,referid);
		
  				}
  			 
  			 }
  			 
  			 if("ning".equals((String)session.getAttribute("platform"))){
  		         	
  		         	
  		         	cssurl=DbUtil.getVal("select cssurl from ebee_roller_def_themes where module='event_ning' and themecode=?",new String [] {"basic"});
  		         	
  		         	 request.setAttribute("CUSTOM_HEADER","");
  		         	
  		         	} 
  			 
  		   request.setAttribute("CUSTOM_CSS",cssurl);
  		  
  
	}   
	
	if("HubPage".equals(request.getAttribute("CustomLNF_Type"))){
	  		String hasheader=DbUtil.getVal("select 'yes' from layout_config where refid=? and idtype=? ",new String [] {referid,"COMMUNITY_HUBID"});
	  		String iscustom="";
				
			        if("yes".equals(hasheader)){
					DBManager dbmanager=new DBManager();
					StatusObj statobj=dbmanager.executeSelectQuery("select * from configure_looknfeel where refid=? and idtype=? ",new String []{referid,"COMMUNITY_HUBID"});
					if(statobj.getStatus()){
	
					header=dbmanager.getValue(0,"headerhtml",null);
					footer=dbmanager.getValue(0,"footerhtml",null);
					navhtml=dbmanager.getValue(0,"navhtml",null);
	
					}
					request.setAttribute("CUSTOM_HEADER",header);
					request.setAttribute("CUSTOM_FOOTER",footer);
					iscustom=DbUtil.getVal("select value from community_config_settings where clubid=? and key='CUSTOM_LAYOUT' ",new String [] {referid});
					if("Y".equals(iscustom))
						request.setAttribute("CUSTOM_HTML_LAYOUT","Y");
					if(navhtml!=null)						
						request.setAttribute("CUSTOM_NAVHTML",navhtml);
				}
	    	
	  			 hm=getThemeDetails(referid,"hubpage");
	  			if(hm!=null){
	  				themecode=GenUtil.getHMvalue(hm,"themecode","basic",true);
	  				themetype=GenUtil.getHMvalue(hm,"themetype","DEFAULT",true);
	  	                }
	  			   
	  		         if("DEFAULT".equals(themetype)){
	  		         	 cssurl=DbUtil.getVal("select cssurl from ebee_roller_def_themes where module='hubpage' and themecode=?",new String [] {themecode});
	  			}
	  			else{
	  				String url=DbUtil.getVal("select cssurl from user_roller_themes where module='hubpage' and refid=?",new String [] {referid});
	  				String path="hubpage/"+themetype+"/"+url;
	  				//cssurl=ThemeFileController.readFilesNReturnContent(path);
	  				  cssurl=ThemeController.getDetailPageCSS(themecode,themetype,"hubpage",referid);
	
	  				
	  			 
	  			 }
	  		if("Y".equals(iscustom))
	  			request.setAttribute("CUSTOM_LAYOUT_CSS",cssurl);
	  		else
	  			request.setAttribute("CUSTOM_CSS",cssurl);
	  		   
	  
	}   
}
%>