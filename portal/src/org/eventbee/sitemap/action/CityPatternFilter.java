package org.eventbee.sitemap.action;
import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.util.*;
import com.eventbee.general.*;




  public class CityPatternFilter implements Filter {
  private FilterConfig config = null;
  public void init(FilterConfig config) throws ServletException {
  	 
  	  this.config = config;
    }
  public void doFilter(ServletRequest request, ServletResponse response,FilterChain chain) throws IOException, ServletException {
    
	
	HttpServletRequest req=(HttpServletRequest)request;
	HttpServletResponse resp=(HttpServletResponse)response;
	String requri=req.getRequestURI();
	String hostname="";
	String redirecturl="";
	String domainname="";
	try{
		hostname=(new java.net.URL(req.getRequestURL().toString())).getHost();
	}catch(Exception e){
		System.out.println("Exception occured in getting hostname in CityPatternFilter");
	}
	hostname=hostname.toLowerCase();
	String[] hostarr=GenUtil.strToArrayStr(hostname,"."); 		
	domainname=hostarr[0];
	if(requri==null)requri="";
	if( requri.lastIndexOf("/")==(requri.length()-1 )){
		requri= requri.substring(0,requri.lastIndexOf("/"));
	}
	String[] uriarr=GenUtil.strToArrayStr(requri,"/");
    uriarr=requri.split("/");
	for(int i=0;i<uriarr.length;i++)
	{	
	//System.out.println("uriarr_"+i+" is:"+uriarr[i]);
	}
	
	try{
	if(uriarr.length==2){
			redirecturl="/city.jsp?city=san-francisco-"+domainname;
	    }
	if(uriarr.length==3)
		redirecturl="/city.jsp?city="+uriarr[2]+"";
    }catch(Exception e)
	{
			redirecturl="/city.jsp";
			
	}
	
	config.getServletContext().getRequestDispatcher(redirecturl).forward(request, response);
	}
    public void destroy() {
		config = null;
	  }
    
}	