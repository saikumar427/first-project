<%
String style=null;
if(request.getParameter("bgColor")!=null){
 style= "body{"
+"background: "+request.getParameter("bgColor")+";"
+"text-align: center;"
+"padding: 0;"
+"font: 62.5% verdana, sans-serif;"
+"color:"+request.getParameter("fontColor")+";"
+"}"
+"#container {"
+"margin: 0 auto;"
+"text-align: left;"
+"width: 700px;"
+"color: "+request.getParameter("fontColor")+";"
+"background:"+request.getParameter("bgColor")+";"
+"padding: 0px;"
+"}"
+"a {"
+"color: "+request.getParameter("anchorColor")+";"
+"}"
+".medium {"
+"font: bold 20px veradana, sans-serif;"
+"color:"+request.getParameter("fontColor")+";"
+"}";
}
 
 %>