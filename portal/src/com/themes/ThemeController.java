package com.themes;
import java.util.*;

import com.eventbee.general.*;
public class ThemeController{

	public static String csswebpath=EbeeConstantsF.get("usertheme.file.path","C:\\jboss-3.2.2\\server\\default\\deploy\\home.war\\userthemes\\");
	public static String cssfilepath=EbeeConstantsF.get("usertheme.file.path","/home/malini/files/");


	public static String [] getThemeCodeAndType(String module,String refid,String deftheme){
		DBManager dbmanager=new DBManager();
		StatusObj statobj=dbmanager.executeSelectQuery(ThemeQueries.GET_SELECTEDTHEME_INFO,new String []{module,refid});
		if(statobj.getStatus()&&statobj.getCount()>0)
			return new String [] {dbmanager.getValue(0,"themetype","DEFAULT"),dbmanager.getValue(0,"themecode",deftheme),dbmanager.getValue(0,"cssurl",deftheme+".css"),dbmanager.getValue(0,"module","event")};
		else{
				if(module.indexOf("%")!=-1){
					module=module.substring(0,module.indexOf("%"));
				}
				return new String [] {"DEFAULT",deftheme,deftheme+".css",module};
		   }
	}


	public static void getCustomContent(String module,String refid,String deftheme,Map thememap){
		DBManager dbmanager=new DBManager();
		StatusObj statobj=dbmanager.executeSelectQuery(ThemeQueries.GET_CUSTOM_THEME_CONTENT,new String []{module,refid});
		if(statobj.getStatus()&&statobj.getCount()>0){
			thememap.put("content",dbmanager.getValue(0,"content",null));
			thememap.put("cssurl",dbmanager.getValue(0,"cssurl",null));
		}
	}




	public static String [] getSelectedThemeData(String userid,String purpose,String deftheme,String modulename,String refid,String themetype){
		String [] params=new String [] {deftheme};
		String query=ThemeQueries.GET_MYTHEME_CSS_AND_CONTENT;
		String css="";
		String content="";
		if(!"PERSONAL".equals(themetype)){
			params=new String [] {userid,purpose,deftheme,modulename,refid,userid,purpose,deftheme,modulename,refid};
			query=ThemeQueries.GET_THEME_CSS_AND_CONTENT;
		}
		DBManager dbmanager=new DBManager();		StatusObj statobj=dbmanager.executeSelectQuery(query,params);
		if(statobj.getStatus()&&statobj.getCount()>0){
			css=dbmanager.getValue(0,"css","");
			content=dbmanager.getValue(0,"themecontent","");
		}
		/*if("PERSONAL".equals(themetype)){
			css=ThemeFileController.readFilesNReturnContent(modulename+"/"+themetype+"/"+css);
		}*/
		return new String [] {css,content};
	}


	public static String [] getDefaultThemeData(String themecode,String modulename){

			String query=ThemeQueries.GET_DEFAULT_CSS_AND_CONTENT;
			String css="";
			String content="";


			DBManager dbmanager=new DBManager();
			StatusObj statobj=dbmanager.executeSelectQuery(query,new String []{modulename,themecode});
			if(statobj.getStatus()&&statobj.getCount()>0){
				css=dbmanager.getValue(0,"cssurl","");
				content=dbmanager.getValue(0,"defaultcontent","");
			}

			return new String [] {css,content};
	}


	public static String [] getSelectedThemeDataAndCSS(String userid,String purpose,String deftheme,String modulename,String refid,String themetype){
		String [] params=new String [] {deftheme};
		String query=ThemeQueries.GET_MYTHEME_CSS_AND_CONTENT;
		String css="";
		String content="";
		if(!"PERSONAL".equals(themetype)){
			params=new String [] {userid,purpose,deftheme,modulename,refid,userid,purpose,deftheme,modulename,refid};
			query=ThemeQueries.GET_THEME_CSS_AND_CONTENT;
		}
		DBManager dbmanager=new DBManager();
		StatusObj statobj=dbmanager.executeSelectQuery(query,params);
		if(statobj.getStatus()&&statobj.getCount()>0){
			content=dbmanager.getValue(0,"themecontent","");
		}
		css="<link rel=\"stylesheet\" type=\"text/css\" href='"+csswebpath+modulename+"/"+themetype+"/"+css+"'/>";
		return new String [] {css,content};
	}



	public static void updateCustomThemes(Map thememap){
		DBQueryObj [] dbquery=new DBQueryObj [2];
		dbquery[0]=new DBQueryObj(ThemeQueries.DELETE_THEME_CUSTOM_CONTENT,new String[]{(String)thememap.get("userid"),(String)thememap.get("module"),(String)thememap.get("refid")});
		dbquery[1]=new DBQueryObj(ThemeQueries.INSERT_CUSTOM_THEME_CONTENT,new String[]{(String)thememap.get("userid"),(String)thememap.get("themecode"),(String)thememap.get("module"),(thememap.get("content")!=null)?(String)thememap.get("content"):null,(thememap.get("cssurl")!=null)?(String)thememap.get("cssurl"):null,(String)thememap.get("refid")});
		StatusObj statobj=DbUtil.executeUpdateQueries(dbquery);
	}


	public static String getDetailPageCSS(String themecode,String themetype, String module,String refid){
		String cssurl=module+"/"+themetype+"/"+themecode+".css";

         if("DEFAULT".equals(themetype)){
          cssurl=DbUtil.getVal("select cssurl from ebee_roller_def_themes where module=? and themecode=?",new String [] {module,themecode});
		 }
         else if("CUSTOM".equals(themetype)){
           cssurl=DbUtil.getVal("select cssurl from user_custom_roller_themes where module=? and refid=? ",new String [] {module,refid});
	  	}
        else{
       cssurl=DbUtil.getVal("select cssurl from user_customized_themes where module=? and themeid=?",new String [] {module,themecode});
		}
	return (cssurl);
	}

	public static void updateMyThemeCss(String css,String themeid,String module){


	StatusObj statobj=DbUtil.executeUpdateQuery(ThemeQueries.UPDATE_MY_THEME_CSS,new String[]{css,themeid});
	}






public static String getCSS(String themecode,String themetype, String module){
		String cssurl=module+"/"+themetype+"/"+themecode+".css";
         if("DEFAULT".equals(themetype)){
          cssurl=DbUtil.getVal("select cssurl from ebee_roller_def_themes where module=? and themecode=?",new String [] {module,themecode});
		 }
         else{
       cssurl=DbUtil.getVal("select cssurl from user_customized_themes where module=? and themeid=?",new String [] {module,themecode});
		}
	return (cssurl);
	}









	public static String getContent(String userid,String purpose,String deftheme,String modulename,String refid,String themetype){
		String [] params=new String [] {deftheme};
		String query=ThemeQueries.GET_MYTHEME_CONTENT;
		String content="";
		if(!"PERSONAL".equals(themetype)){
			params=new String [] {userid,purpose,deftheme,modulename,refid};
			query=ThemeQueries.GET_THEME_CONTENT;
		}
		content=DbUtil.getVal(query,params);
		if(content==null)content="";
		return content;
	}

	public static void updateThemes(String userid,String module,String code,String refid,String themetype){
		DBQueryObj [] dbquery=new DBQueryObj [3];
		dbquery[0]=new DBQueryObj(ThemeQueries.DELETE_THEME_ENTRY,new String[]{userid,module,refid});
		if(module.indexOf("%")!=-1){
			module=module.substring(0,module.indexOf("%"));
		}
		dbquery[1]=new DBQueryObj(ThemeQueries.INSERT_THEME_ENTRY,new String[]{userid,module,code,refid,themetype,code+".css"});
		dbquery[2]=new DBQueryObj(ThemeQueries.DELETE_CUSTOM_THEME,new String[]{userid,module,refid});
		StatusObj statobj=DbUtil.executeUpdateQueries(dbquery);
	}
	public static void setUpdateQueries(String userid,String module,String code,String refid,String themetype,DBQueryObj [] dbquery){
		if(dbquery.length==4){
		dbquery[1]=new DBQueryObj(ThemeQueries.DELETE_THEME_ENTRY,new String[]{userid,module,refid});
		if(module.indexOf("%")!=-1){
					module=module.substring(0,module.indexOf("%"));
		}
		dbquery[2]=new DBQueryObj(ThemeQueries.INSERT_THEME_ENTRY,new String[]{userid,module,code,refid,themetype,code+".css"});
		dbquery[3]=new DBQueryObj(ThemeQueries.DELETE_CUSTOM_THEME,new String[]{userid,module,refid});
		}
	}

	public static Map getThemes(String [] params,String query){
		Map thememap=new HashMap();
		DBManager dbmanager=new DBManager();
		StatusObj statobj=dbmanager.executeSelectQuery( query,params);
		int recount=0;
		if(statobj !=null && statobj.getStatus() && (recount=statobj.getCount())>0){
		List themenameslist=new ArrayList();
		List themevalslist=new ArrayList();
			for(int i=0;i<recount;i++){
				themenameslist.add(dbmanager.getValue(i,"themename",""));
				themevalslist.add(dbmanager.getValue(i,"themecode",""));
			}
			String[] themenames=(String [])themenameslist.toArray(new String[0]);
			String[] themevals=(String [])themevalslist.toArray(new String[0]);
			thememap.put("themenames",themenames);
			thememap.put("themevals",themevals);

		}

		return thememap;
	}

	public static Map getMyThemes(String [] params){
		return getThemes(params,ThemeQueries.GET_MY_THEMES);
	}
	public static Map getThemes(String [] params){
		return getThemes(params,ThemeQueries.GET_DEFAULT_THEMES);
	}

	public static String getThemeid(){
		String themeid=DbUtil.getVal(ThemeQueries.GET_THEME_ID,null);
		return themeid;
	}
	public static StatusObj createMyTheme(String [] themecontent,String userid,String module, String themename,String themeid){
		ThemeFileController.createFiles(themecontent[0],module+"/PERSONAL/"+themeid,".css");

		StatusObj sobj=DbUtil.executeUpdateQuery(ThemeQueries.INSERT_MYTHEME_DATA,new String [] {userid,themecontent[0],themecontent[1],module,themeid,themename});
		EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"ThemeController.java===============","status of creating new theme======="+sobj.getStatus(),"",null);


		return sobj;
	}

	public static StatusObj updateMyTheme(String [] themecontent,String themeid,String module){
		//ThemeFileController.createFiles(themecontent[0],module+"/PERSONAL/"+themeid,".css");
		updateMyThemeCss(themecontent[0],themeid,module);
		StatusObj sobj=updateMyThemeContent(themecontent,themeid);
		return sobj;
	}

	public static StatusObj updateMyThemeContent(String [] themecontent,String themeid){
			StatusObj sobj=DbUtil.executeUpdateQuery(ThemeQueries.UPDATE_MY_THEME,new String [] {themecontent[1],themeid});
		return sobj;
	}

	public static StatusObj updateMyThemeWithName(String csscontent,String themeid,String module,String themename){
		ThemeFileController.createFiles(csscontent,module+"/PERSONAL/"+themeid,".css");
		StatusObj sobj=DbUtil.executeUpdateQuery(ThemeQueries.UPDATE_MY_THEME_WITH_NAME,new String [] {themename,themeid});
		return sobj;
	}


	public static void getCustomPosterData(Vector v, String userid,String modulename){
		DBManager dbmanager=new DBManager();
		StatusObj statobj=dbmanager.executeSelectQuery(ThemeQueries.GET_CUSTOMIZED_DATA,new String[]{userid,modulename});
		if(statobj.getStatus()){
			String [] columnnames=dbmanager.getColumnNames();
			for(int i=0;i<statobj.getCount();i++){
				HashMap hm=new HashMap();
					for(int j=0;j<columnnames.length;j++){
						hm.put(columnnames[j],dbmanager.getValue(i,columnnames[j],""));
					}
				v.add(hm);
			}
		}
	}


public static	String getPublicPageContent(String userid,String purpose,String deftheme,String themetype){
		String [] params=new String [] {deftheme};
		String query=ThemeQueries.GET_PUBLIC_PAGE_MYTHEME_CONTENT;
		String content="";
		if(!"PERSONAL".equals(themetype)){
			params=new String [] {userid,purpose,deftheme,purpose};
			query=ThemeQueries.GET_PUBLIC_PAGE_THEME_CONTENT;
		}
		content=DbUtil.getVal(query,params);
		if(content==null)content="";
		return content;
}

public static HashMap getPreviewCSSAndHTML(String refid){	DBManager dbmanager=new DBManager();	HashMap previewMap=new HashMap();	String query="select cssurl,content from theme_preview where ref_id=?";	StatusObj statobj=dbmanager.executeSelectQuery(query, new String[]{refid});	if(statobj.getStatus() && statobj.getCount()>0){		previewMap.put("CSS", dbmanager.getValue(0, "cssurl", ""));		previewMap.put("HTML", dbmanager.getValue(0, "content", ""));	}	return previewMap;}











}
