<%!

String GET_SELECTEDTHEME_INFO="select themetype,themecode,cssurl from user_roller_themes where module=? and userid=CAST(? AS INTEGER) ";
String [] getMyPublicPageThemeCodeAndType(String module,String userid,String deftheme){
		System.out.println("in theme db "+module+" "+userid);
		DBManager dbmanager=new DBManager();
		StatusObj statobj=dbmanager.executeSelectQuery(GET_SELECTEDTHEME_INFO,new String []{module,userid});
		if(statobj.getStatus()&&statobj.getCount()>0)
			return new String [] {dbmanager.getValue(0,"themetype","DEFAULT"),dbmanager.getValue(0,"themecode",deftheme),dbmanager.getValue(0,"cssurl",deftheme+".css")};
		else
			return new String [] {"DEFAULT",deftheme,deftheme+".css"};
	}
	//getPublicPageThemeData(INTEGER,VARCHAR,VARCHAR, VARCHAR,VARCHAR)
	 //getPublicPageThemeData(userid,module,'themecontent', deftheme,module )
String GET_PUBLIC_PAGE_THEME_CONTENT="select getPublicPageThemeData(?,?,'themecontent',?,?) as themecontent";
String GET_PUBLIC_PAGE_MYTHEME_CONTENT="select content from user_customized_themes where themeid=?";

String getPublicPageCSS(String themecode,String themetype, String module){
		String cssurl=module+"/"+themetype+"/"+themecode+".css";
		return ThemeFileController.readFilesNReturnContent(cssurl);
	}
	
String getPublicPageContent(String userid,String purpose,String deftheme,String themetype){
	String [] params=new String [] {deftheme};
	String query=GET_PUBLIC_PAGE_MYTHEME_CONTENT;
	String content="";
	if(!"PERSONAL".equals(themetype)){
		params=new String [] {userid,purpose,deftheme,purpose};
		query=GET_PUBLIC_PAGE_THEME_CONTENT;
	}
	content=DbUtil.getVal(query,params);
	if(content==null)content="";
	return content;
}

///////////////

String GET_PUBLIC_PAGE_CUSTOM_THEME_CONTENT="select userid,themecode,module,content,cssurl from user_custom_roller_themes where module=? and userid=? ";
void getPublicPageCustomContent(String module,String userid,String deftheme,Map thememap){
		DBManager dbmanager=new DBManager();
		StatusObj statobj=dbmanager.executeSelectQuery(GET_PUBLIC_PAGE_CUSTOM_THEME_CONTENT,new String []{module,userid});
		if(statobj.getStatus()&&statobj.getCount()>0){
			thememap.put("content",dbmanager.getValue(0,"content",null));
			thememap.put("cssurl",dbmanager.getValue(0,"cssurl",null));
		}
	}
	
String DELETE_PUBLIC_PAGE_THEME_CUSTOM_CONTENT="delete from user_custom_roller_themes where userid=? and module=?";
String INSERT_PUBLIC_PAGE_CUSTOM_THEME_CONTENT="insert into user_custom_roller_themes ( userid,themecode,module,content,cssurl) values (?,?,?,?,?)";
   
	
void updatePublicPageCustomThemes(Map thememap){
		DBQueryObj [] dbquery=new DBQueryObj [2];
		dbquery[0]=new DBQueryObj(DELETE_PUBLIC_PAGE_THEME_CUSTOM_CONTENT,new String[]{(String)thememap.get("userid"),(String)thememap.get("module")});
		dbquery[1]=new DBQueryObj(INSERT_PUBLIC_PAGE_CUSTOM_THEME_CONTENT,new String[]{(String)thememap.get("userid"),(String)thememap.get("themecode"),(String)thememap.get("module"),(thememap.get("content")!=null)?(String)thememap.get("content"):null,(thememap.get("cssurl")!=null)?(String)thememap.get("cssurl"):null});
		StatusObj statobj=DbUtil.executeUpdateQueries(dbquery);
	}	
String UPDATE_PUBLIC_PAGE_MY_THEME="update user_customized_themes set cssurl=?,content=?,updated_at=now() where themeid=?";
StatusObj updatePublicPageMyThemeContent(String [] themecontent,String themeid){
			StatusObj sobj=DbUtil.executeUpdateQuery(UPDATE_PUBLIC_PAGE_MY_THEME,new String [] {themeid+".css",themecontent[1],themeid});
		return sobj; 
	}

String DELETE_PUBLIC_PAGE_THEME_ENTRY="delete from user_roller_themes where userid=? and module=? ";
String INSERT_PUBLIC_PAGE_THEME_ENTRY="insert into user_roller_themes (userid,module,themecode,themetype,cssurl) values(?,?,?,?,?)";
String DELETE_PUBLIC_PAGE_CUSTOM_THEME="delete from user_custom_roller_themes where userid=? and module=?";

	
void updatePublicPageThemes(String userid,String module,String code,String themetype){
		
		DBQueryObj [] dbquery=new DBQueryObj [3];
		dbquery[0]=new DBQueryObj(DELETE_PUBLIC_PAGE_THEME_ENTRY,new String[]{userid,module});
		dbquery[1]=new DBQueryObj(INSERT_PUBLIC_PAGE_THEME_ENTRY,new String[]{userid,module,code,themetype,code+".css"});
		dbquery[2]=new DBQueryObj(DELETE_PUBLIC_PAGE_CUSTOM_THEME,new String[]{userid,module});
		StatusObj statobj=DbUtil.executeUpdateQueries(dbquery);
	}
///////////////////////////



String GET_PUBLIC_PAGE_THEME_TYPE="select themetype from user_roller_themes where module=? and userid=? ";
String GET_PUBLIC_PAGE_MYTHEME_CSS_AND_CONTENT="select cssurl as css,content as themecontent from user_customized_themes where themeid=?";
String GET_PUBLIC_PAGE_THEME_CSS_AND_CONTENT="select getPublicPageThemeData(CAST(? as INTEGER),?,'css',?,?) as css, getPublicPageThemeData(CAST(? as INTEGER),?,'themecontent',?,?) as themecontent";

String [] getPublicPageSelectedThemeData(String userid,String purpose,String deftheme,String modulename,String themetype){
		String [] params=new String [] {deftheme};
		String query=GET_PUBLIC_PAGE_MYTHEME_CSS_AND_CONTENT;
		String css="";
		String content="";
		if(!"PERSONAL".equals(themetype)){
					params=new String [] {userid,purpose,deftheme,modulename,userid,purpose,deftheme,modulename};
			query=GET_PUBLIC_PAGE_THEME_CSS_AND_CONTENT;
		}
				

		DBManager dbmanager=new DBManager();
		StatusObj statobj=dbmanager.executeSelectQuery(query,params);
		if(statobj.getStatus()&&statobj.getCount()>0){
			css=dbmanager.getValue(0,"css","");
			content=dbmanager.getValue(0,"themecontent","");
		}
		
		return new String [] {css,content};
	}
	
	String [] getPublicPageDefaultThemeData(String userid,String modulename,String deftheme){
		String [] params=new String [] {deftheme,modulename};
		String query="select  defaultcontent  as themecontent, cssurl as css from ebee_roller_def_themes where themecode=? and module=?";
		String css="";
		String content="";

		DBManager dbmanager=new DBManager();
		StatusObj statobj=dbmanager.executeSelectQuery(query,params);
		if(statobj.getStatus()&&statobj.getCount()>0){
			css=dbmanager.getValue(0,"css","");
			content=dbmanager.getValue(0,"themecontent","");
		}
		
		return new String [] {css,content};
	}
	
String GET_USER_SELECTED_THEME_CODE_TYPE="select themecode,themetype from user_roller_themes where userid=? and module=?";
String GET_DEF_THEME_NAME="select themename from ebee_roller_def_themes where themecode=? and module=?";
String GET_PERSONAL_THEME_NAME="select themename from user_customized_themes where themeid=?";
	
	String getPublicPageThemeName(String userid,String module){
		String themename="";
		DBManager dbmanager=new DBManager();
		StatusObj statobj=dbmanager.executeSelectQuery(GET_USER_SELECTED_THEME_CODE_TYPE,new String[]{userid,module});
		if(statobj.getStatus()&&statobj.getCount()>0){
			String themetype=dbmanager.getValue(0,"themetype","");
			String themecode=dbmanager.getValue(0,"themecode","");
			if("DEFAULT".equals(themetype)||"CUSTOM".equals(themetype)){
				themename=DbUtil.getVal(GET_DEF_THEME_NAME,new String[]{themecode,module});			
			}
			else if("PERSONAL".equals(themetype)){
				themename=DbUtil.getVal(GET_PERSONAL_THEME_NAME,new String[]{themecode});	
			}
			else{
				themename="";
			}
			
		} 
		return themename;
	}
	
	void getCustomizedThemes(Vector v,String userid,String module){
	DBManager dbmanager=new DBManager();
	String query="select themeid,themename from user_customized_themes  where userid=? and module=? order by created_at desc";
	StatusObj statobj=dbmanager.executeSelectQuery(query,new String[]{userid,module});
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






























%>
