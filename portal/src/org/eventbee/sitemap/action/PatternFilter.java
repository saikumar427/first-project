package org.eventbee.sitemap.action;
import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;

import com.eventbee.general.*;

public class PatternFilter implements Filter {

private FilterConfig config = null;

public void init(FilterConfig config) throws ServletException {
	this.config = config;
}
public void destroy() {
	config = null;
}
public void doFilter(ServletRequest request, ServletResponse response,FilterChain chain) throws IOException, ServletException {


	HttpServletRequest req=(HttpServletRequest)request;
	HttpServletResponse resp=(HttpServletResponse)response;
	String requri=req.getRequestURI();
	if("/view/goplaynw/event".equals(requri)){
		resp.sendRedirect("/main/sorry.html");
		return;
	}
	if("/v/nye".equals(requri)){
		resp.sendRedirect("http://nye.eventbee.com/city/san-francisco-nye");
		return;
	}
	if("/v/halloween".equals(requri)){
		resp.sendRedirect("http://halloween.eventbee.com/city/san-francisco-halloween");
		return;
	}
	System.out.println("requri: "+requri);
	String redirecturl="";
	if(requri==null)requri="";
	if( requri.lastIndexOf("/")==(requri.length()-1 )){
		requri= requri.substring(0,requri.lastIndexOf("/"));
	}
	String[] uriarr=GenUtil.strToArrayStr(requri,"/");
	if(uriarr.length>2 && uriarr[2].equalsIgnoreCase("event")){
		redirecturl="/"+uriarr[2]+"?"+req.getQueryString();
	}
		else
	redirecturl = MemberFilter.getURLAssumingMember(uriarr,request);
	System.out.println("initial url: "+redirecturl);
	if("".equals(redirecturl))
			redirecturl=CommunitiesFilter.getURLAssumingHub(uriarr,request);
	System.out.println("after 1st operation: "+redirecturl);
	if("".equals(redirecturl))
			redirecturl="/home.jsp?UNITID=13579";
	if("Y".equals((String)request.getAttribute("outofcontext"))){
			resp.sendRedirect(redirecturl);
	}else{
		String query=req.getQueryString();
		System.out.println("query: "+query);
	if(query!=null)
			redirecturl+="&"+query;
		config.getServletContext().getRequestDispatcher(redirecturl).forward(request, response);
	}
}
}

