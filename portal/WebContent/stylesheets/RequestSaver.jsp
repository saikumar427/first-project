<%@ page import="java.util.*" %>
<%@ page import="com.eventbee.general.*" %>



<%
		
		HashMap map=null;

		boolean reuse =(request.getParameter("REUSE")==null)?false:true;
		String savebyname=(request.getParameter("SAVEBYNAME")==null)?"reqsave":request.getParameter("SAVEBYNAME")   ;//param.getParameter("savebyname","reqsave");
		String scope=(request.getParameter("SCOPE")==null)?"both":request.getParameter("SCOPE")    ;//param.getParameter("scope","both");
		if(reuse){
			map=(HashMap)session.getAttribute(savebyname);
		}
		
		
		if(map==null){
			map=new HashMap();
		}

        Enumeration parameters=request.getParameterNames();
        while (parameters.hasMoreElements()) {
            String parameter=(String)parameters.nextElement();
            String values[]=request.getParameterValues(parameter);
            if(values!=null){
				if(values.length==1){
					map.put(parameter,values[0]);

				}else{
					map.put(parameter,values);
				}

			}

		}

		


		if("request".equals(scope)){
			request.setAttribute(savebyname,map);
		}else if("session".equals(scope)){
			session.setAttribute(savebyname,map);
		}else{
			request.setAttribute(savebyname,map);
			session.setAttribute(savebyname,map);
		}
		
		
		//System.out.println(new Date()+" RequestSaver.jsp savebyname="+savebyname+"\nmapentries="+map);
		
%>
