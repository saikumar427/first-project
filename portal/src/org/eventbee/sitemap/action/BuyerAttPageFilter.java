package org.eventbee.sitemap.action;

import java.io.IOException;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.eventbee.general.GenUtil;

/**
 * Servlet Filter implementation class BuyerAttPageFilter
 */
public class BuyerAttPageFilter implements Filter {
	private FilterConfig config = null;
    /**
     * Default constructor. 
     */
    public BuyerAttPageFilter() {
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see Filter#destroy()
	 */
	public void destroy() {
		config = null;
	}

	/**
	 * @see Filter#doFilter(ServletRequest, ServletResponse, FilterChain)
	 */
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
		System.out.println("BuyerAttPageFilter: ");
		HttpServletRequest req=(HttpServletRequest)request;
		HttpServletResponse resp=(HttpServletResponse)response;
		String requri=req.getRequestURI();
		String redirecturl="";
		if(requri==null)requri="";
		if( requri.lastIndexOf("/")==(requri.length()-1 )){
			requri= requri.substring(0,requri.lastIndexOf("/"));
		}
		String[] uriarr=GenUtil.strToArrayStr(requri,"/");
	    uriarr=requri.split("/");
	    System.out.println("requri: "+requri+" length: "+uriarr.length);
		for(int i=0;i<uriarr.length;i++){	
			System.out.println("uriarr_"+i+" is:"+uriarr[i]);
		}
		
		try{
		if(uriarr.length==3){
				redirecturl="/customevents/buyerlandingpage.jsp?pkey="+uriarr[2];
		}else
			redirecturl= "/guesttasks/invalidpage.jsp";
		
	    }catch(Exception e)
		{
	    	redirecturl= "/guesttasks/invalidpage.jsp";
				
		}
		
		config.getServletContext().getRequestDispatcher(redirecturl).forward(request, response);
		
		
		//chain.doFilter(request, response);
	}

	/**
	 * @see Filter#init(FilterConfig)
	 */
	public void init(FilterConfig fConfig) throws ServletException {
		this.config = fConfig;
	}

}
