package org.eventbee.sitemap.action;

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.eventbee.general.*;
import java.util.*;

public class MemberFilter implements Filter{
	public static FilterConfig config = null;

	public void init(FilterConfig config) throws ServletException{
		this.config = config;
	}

	public void destroy(){
		config = null;
	}

	public static HashMap getRedirectUrl(String username,String type){
		String query="select url,outofcontext from hardcoded_urls where shorturl=? and type=?";
		DBManager dbmanager=new DBManager();
		StatusObj statobj1=dbmanager.executeSelectQuery(query,new String[]{username,type});
		HashMap hm=new HashMap();
		if(statobj1.getStatus() && statobj1.getCount()>0){
			hm.put("url",dbmanager.getValue(0,"url",""));
			String outofcontext=	dbmanager.getValue(0,"outofcontext","");
			if("F".equalsIgnoreCase(outofcontext)) {
				appendBlockedURLs(username, "blocked_custom_urls");
				System.out.println("blocked custom URL: "+username);
				hm.put("url","/guesttasks/invalidpage.jsp?fail=Y");
			}
			hm.put("outofcontext",outofcontext);
		}
	    return hm;
   }
private static void appendBlockedURLs(String blockedpattern, String blocktype){
	HashMap blockedCustomURLsMap=(HashMap)EbeeCachingManager.get(blocktype);
	if(blockedCustomURLsMap==null)	blockedCustomURLsMap=new HashMap();
	blockedCustomURLsMap.put(blockedpattern,"Y");
	EbeeCachingManager.put(blocktype, blockedCustomURLsMap);
}

private static String handleCustomURL(String username, String[] uriarr){
	HashMap rm=getRedirectUrl(username,"member");
	String redirecturl="";
	if(rm.size()>0)	{
		redirecturl=(String)GenUtil.getHMvalue(rm,"url","");
		if(uriarr.length>3){
				if("track".equals(uriarr[2]) || "t".equals(uriarr[2])){
					redirecturl+="&track="+uriarr[3];
				}
				if("n".equals(uriarr[2])){
					redirecturl+="&nts="+uriarr[3];
				}
		}
		if(uriarr.length>4){
			if("report".equals(uriarr[4])){
				redirecturl=redirecturl+"&track="+uriarr[3]+"&report="+uriarr[4];
			}if("manage".equals(uriarr[4])){
				redirecturl=redirecturl+"&track="+uriarr[3]+"&manage="+uriarr[4];
			}
		}
	}
	return redirecturl;
}
public static String getURLAssumingMember(String[] uriarr,ServletRequest request){
	System.out.println("getURLAssumingMember");
		if(uriarr.length<2) return "";
		String username=uriarr[1];
		request.setAttribute("username",username);
		if(username!=null)	username=(username.toLowerCase()).trim();
		HashMap blockedCustomURLsMap=(HashMap)EbeeCachingManager.get("blocked_custom_urls");
		if(blockedCustomURLsMap!=null && blockedCustomURLsMap.get(username)!=null){
			System.out.println("blocked custom URL: "+username);
			return "/guesttasks/invalidpage.jsp";
		}
		String userid="";
		String type="member";
		HttpServletRequest req=(HttpServletRequest)request;
		String redirecturl="";
        if("event".equals(username) ){
			if(uriarr.length>2){
				return "/customevents/eventhandler.jsp?eid="+uriarr[2];
			}else{
				return "/guesttasks/invalidpage.jsp";
			}
		}
        HashMap hm=getUserPreferenceInfo(username);
        System.out.println("hm size: "+hm.size());
        if(hm.isEmpty()){  //pattern is not username
			return handleCustomURL(username,uriarr);
		}
		if(hm.get("isBlocked")!=null){
			System.out.println("blocked user URL: "+username);
			return "/guesttasks/invalidpage.jsp";
		}
		userid=(String)hm.get("user_id");
		if(userid==null) return "";
		request.setAttribute("userid",userid);
		String purpose="";
		if(uriarr.length>2)	{
			purpose=uriarr[2];
			if("photos".equals(purpose)){
					redirecturl="/photogallery/photothemeprocessor.jsp?userid="+userid;
			}else if("events".equals(purpose) || "boxoffice".equals(purpose) || "ipad".equals(purpose)){
				redirecturl=getEventsPageVersion(userid, username, req);
			}else if("community".equals(purpose)){
				   redirecturl= handleCommunityURL(uriarr);
			}
		}else{
			redirecturl=getEventsPageVersion(userid, username, req);
		}
		return redirecturl;
}
private static HashMap getUserPreferenceInfo(String username){
	HashMap userDataMap=new HashMap();
	HashMap blockedUserURLsMap=(HashMap)EbeeCachingManager.get("blocked_user_urls");
			if(blockedUserURLsMap!=null && blockedUserURLsMap.get(username)!=null){
				System.out.println("user url '"+username+"' is already blocked");
				userDataMap.put("isBlocked","Y");
		}else{
			String query="select user_id ,accounttype  from authentication where lower(login_name)=lower(?)";
			DBManager dbmanager=new DBManager();
			StatusObj statobj1=dbmanager.executeSelectQuery(query,new String[]{username});
			if(statobj1.getStatus() && statobj1.getCount()>0){
				userDataMap.put("user_id",dbmanager.getValue(0,"user_id",""));
				String isblocked=	dbmanager.getValue(0,"accounttype","");
				if("blocked".equalsIgnoreCase(isblocked)){
						appendBlockedURLs(username, "blocked_user_urls");
						userDataMap.put("isBlocked","Y");
				}
			}
		}
		return userDataMap;

}
private static String handleCommunityURL(String[] uriarr){
	String query="";
	String groupid="";
	String redirecturl="";
	if(uriarr.length==3){
			query="select clubid from clubinfo where lower(clublogo)=lower(?)";
			groupid = DbUtil.getVal(query,new String [] {uriarr[1]+"community"});
			if(groupid==null||"".equals(groupid)) return "";
			redirecturl="/commredirect/comRedirect.jsp?purpose=view&groupId="+groupid;
	}else{
		String communityname=uriarr[3];
		if(communityname!=null)	communityname=(communityname.toLowerCase()).trim();
		query = "select clubid from clubinfo where lower(clublogo)=?";
		groupid = DbUtil.getVal(query,new String [] {communityname});
		if(groupid==null||"".equals(groupid)) return "";
		if(uriarr.length>4){
			if("login".equals(uriarr[4])){
					redirecturl="/commredirect/comRedirect.jsp?purpose=login&groupId="+groupid;
			}else if("signup".equals(uriarr[4])){
				redirecturl="/commredirect/comRedirect.jsp?purpose=signup&groupId="+groupid;
			}else if("renew".equals(uriarr[4])){
				redirecturl="/commredirect/comRedirect.jsp?purpose=renew&groupId="+groupid;
			}
		}else{
			redirecturl="/commredirect/comRedirect.jsp?purpose=view&groupId="+groupid;
		}
	}
	return redirecturl;
}
public static String getEventsPageVersion(String userid,String username,HttpServletRequest req){
	System.out.println("in events page version"+username+"userid: "+userid);
	String redirecturl="/customevents/eventspage.jsp?name="+username;
	/*String useragent=(String)req.getHeader("user-Agent");
	String boxoffice=DbUtil.getVal("select boxoffice_id from box_office_master where userid=?", new String[]{userid});
	if(boxoffice!=null && !"".equals(boxoffice)){
		if(useragent!=null && useragent.indexOf("Safari")>-1 && useragent.indexOf("iPad")>-1)
			redirecturl="/boxoffice?boxoffice="+boxoffice+"&name="+username;
	}*/
	return redirecturl;
}

public void doFilter(ServletRequest request, ServletResponse response,FilterChain chain) throws IOException, ServletException {
	HttpServletRequest req=(HttpServletRequest)request;
	HttpServletResponse resp=(HttpServletResponse)response;
	String requri=req.getRequestURI();
	if(requri==null) requri="";
	System.out.println("REQ URI in MemberFilter: "+requri);
	if( requri.lastIndexOf("/")==(requri.length()-1 )){
		requri= requri.substring(0,requri.lastIndexOf("/"));
	}
	String[] uriarr=GenUtil.strToArrayStr(requri,"/");
	String redirecturl=""; 
	if(uriarr.length>2 && uriarr[2].equalsIgnoreCase("event")){
		redirecturl="/"+uriarr[2]+"?"+req.getQueryString();
	}
		else
	redirecturl=getURLAssumingMember(uriarr,request);
	if("".equals(redirecturl))	redirecturl="/home.jsp";
	if("Y".equals((String)request.getAttribute("outofcontext"))){
			resp.sendRedirect(redirecturl);
	}else{
		String query=req.getQueryString();
		if(query!=null)	redirecturl+="&"+query;
		config.getServletContext().getRequestDispatcher(redirecturl).forward(request, response);
	}
}
}