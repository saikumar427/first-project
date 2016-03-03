<%
	if("clubpagem".equals(request.getParameter("PS")))
		request.setAttribute("tabtype","unit");
	else
	if("mgreventmanage".equals(request.getParameter("PS")))
		request.setAttribute("tabtype","events");
	else
	if("eventmanage".equals(request.getParameter("PS")))
	request.setAttribute("tabtype","event");
	else{
		if(request.getParameter("DEFTAB") !=null){
			request.setAttribute("tabtype",request.getParameter("DEFTAB") );
		}else{
			request.setAttribute("tabtype","community");
		}
	}
%>
