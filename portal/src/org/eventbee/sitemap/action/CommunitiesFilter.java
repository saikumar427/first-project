package org.eventbee.sitemap.action;
import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.eventbee.general.*;
import com.eventbee.authentication.*;
import java.util.*;
import com.eventbee.customconfig.MemberFeatures;
import com.eventbee.authentication.AuthDB;
import com.eventbee.hub.hubDB;

public class CommunitiesFilter implements Filter {

private FilterConfig config = null;
public void init(FilterConfig config) throws ServletException {
	this.config = config;
}

public void destroy() {
	config = null;
}

public static String getURLAssumingHub(String[] uriarr,ServletRequest request){

		if(uriarr.length<2) return "";
			String communityname="";
			 communityname=uriarr[1];
			 if(communityname!=null)
			 communityname=(communityname.toLowerCase()).trim();
			 String purpose="";
			 String redirecturl="";
			 String rss="rss";
			 String purpos="";

		String query = "select clubid from clubinfo where lower(clublogo)=?";
		String groupid = DbUtil.getVal(query,new String [] {communityname});

		String forumid=DbUtil.getVal("select forumid from forum where groupid=CAST(? as INTEGER)",new String []{groupid});
		if(groupid==null||"".equals(groupid)) return "";


		if(uriarr.length==3)

			    purpos=uriarr[2];
		if(uriarr.length>3)
				purpose=uriarr[3];

				if("login".equals(purpos)){

					redirecturl="/guesttasks/pmemberlogin.jsp?PS=clubview&UNITID=13579&GROUPID="+groupid;

				}
				 else if("signup".equals(purpos)){
					redirecturl="/auth/listauth.jsp?PS=clubview&GROUPID="+groupid+"&UNITID=13579&GROUPTYPE=Club&purpose=joinhub&id=yes";

				}
				 else if("renew".equals(purpos)){

					redirecturl="/auth/listauth.jsp?PS=clubview&GROUPID="+groupid+"&UNITID=13579&GROUPTYPE=Club&purpose=memberrenewal";


				}
				 else if("forum".equals(purpose)){

					redirecturl="/discussionforums/logic/rssshowForumTopics.jsp?PS=clubview&forumid="+forumid+"&GROUPID="+groupid;

				}

					else{
						redirecturl="/hub/clubview.jsp?GROUPID="+groupid;
			}


	return 	redirecturl;
}



public void doFilter(ServletRequest request, ServletResponse response,FilterChain chain) throws IOException, ServletException {


	String groupid="";
	HttpServletRequest req=(HttpServletRequest)request;
	HttpServletResponse resp=(HttpServletResponse)response;

	String requri=req.getRequestURI();
	String redirecturl="";


	if(requri==null)requri="";
	if( requri.lastIndexOf("/")==(requri.length()-1 )){
		requri= requri.substring(0,requri.lastIndexOf("/"));
	}


	String[] uriarr=GenUtil.strToArrayStr(requri,"/");

	redirecturl=getURLAssumingHub(uriarr,request);
	if("".equals(redirecturl))
			redirecturl="/home.jsp?UNITID=13579";
	String query=req.getQueryString();
		if(query!=null)
			redirecturl+="&"+query;
		EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"CommunitiesFilter.java","in doFilter()","*******redirecturl is******* :"+redirecturl,null);
		config.getServletContext().getRequestDispatcher(redirecturl).forward(request, response);



}
}