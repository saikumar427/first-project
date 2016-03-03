package com.themes;
public class ThemeQueries{
	public static String GET_PUBLIC_PAGE_THEME_CONTENT="select getPublicPageThemeData(CAST(? AS INTEGER),?,'themecontent',?,?) as themecontent";
	public static String GET_PUBLIC_PAGE_MYTHEME_CONTENT="select content from user_customized_themes where themeid=?";
	public static String GET_THEME_TYPE="select themetype from user_roller_themes where module=? and refid=? ";

	//public static String GET_SELECTEDTHEME_INFO="select themetype,themecode,cssurl from user_roller_themes where module=? and refid=? ";

	public static String GET_SELECTEDTHEME_INFO="select themetype,themecode,cssurl,module from user_roller_themes where module like ? and refid=? ";

	public static String GET_MY_THEMES="select themename,themeid as themecode from user_customized_themes where userid=? and module=?";

	public static String GET_DEFAULT_THEMES="select themename,themecode from ebee_roller_def_themes where module=? order by themename";

	public static String GET_THEME_CSS_AND_CONTENT="select getThemeDataNew(CAST(? AS INTEGER),?,'css',?,?,?) as css, getThemeDataNew(CAST(? AS INTEGER),?,'themecontent',?,?,?) as themecontent";

	public static String GET_MYTHEME_CSS_AND_CONTENT="select cssurl as css,content as themecontent from user_customized_themes where themeid=?";

	public static String DELETE_THEME_ENTRY="delete from user_roller_themes where userid=CAST(? AS INTEGER) and module like ? and refid=?";

	public static String INSERT_THEME_ENTRY="insert into user_roller_themes (userid,module,themecode,refid,themetype,cssurl) values(CAST(? AS INTEGER),?,?,?,?,?)";

	public static String DELETE_CUSTOM_THEME="delete from user_custom_roller_themes where userid=CAST(? AS INTEGER) and module=? and refid=?";

	public static String GET_CUSTOM_THEME_DATA="select userid,themecode,module,content,cssurl from user_custom_roller_themes where userid=CAST(? AS INTEGER) and module=? and refid=?";

	public static String GET_MYTHEME_CSS="select cssurl from user_customized_themes where themeid=?";

	public static String GET_MYTHEME_CONTENT="select content from user_customized_themes where themeid=?";

	public static String GET_THEME_CSS="select getThemeDataNew(CAST(? AS INTEGER),?,'css',?,?,?) as css ";

	public static String GET_THEME_CONTENT="select getThemeDataNew(CAST(? AS INTEGER),?,'themecontent',?,?,?) as themecontent";

	public static String DELETE_THEME_CUSTOM_CONTENT="delete from user_custom_roller_themes where userid=CAST(? AS INTEGER) and module=? and refid=?";

	public static String INSERT_CUSTOM_THEME_CONTENT="insert into user_custom_roller_themes ( userid,themecode,module,content,cssurl,refid) values (CAST(? AS INTEGER),?,?,?,?,?)";

	public static String UPDATE_CSSURL="update user_roller_themes set cssurl=? where refid=? and module=? ";

	public static String GET_CUSTOM_THEME_CONTENT="select userid,themecode,module,content,cssurl from user_custom_roller_themes where module=? and refid=? ";

	public static String INSERT_MYTHEME_DATA="insert into user_customized_themes (userid,cssurl,content,module,themeid,themename,created_at,updated_at) values(?,?,?,?,?,?,now(),now())";

	public static String GET_THEME_ID="select nextval('user_custom_themeid') as themeid";

	public static String UPDATE_MY_THEME="update user_customized_themes set content=?,updated_at=now() where themeid=?";

	public static String UPDATE_MY_THEME_WITH_NAME="update user_customized_themes set updated_at=now(), themename=? where themeid=?";

	public static String GET_CUSTOMIZED_DATA="select themeid,themename from user_customized_themes where userid=? and module=?";

	public static String GET_DEFAULT_CSS_AND_CONTENT="select cssurl,defaultcontent from ebee_roller_def_themes where module like ? and themecode=?";

    public static String UPDATE_MY_THEME_CSS="update user_customized_themes set cssurl=?,updated_at=now() where themeid=?";


}
