<%@ page contentType="text/html;charset=UTF-8" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>

<%@ page import="java.io.File" %>
<%@ page import="java.util.Enumeration"%>
<%@ page import="java.util.Locale"%>
<%@ page import="javax.servlet.jsp.jstl.core.*" %>
<%@ page import="javax.servlet.jsp.jstl.fmt.LocaleSupport" %>
<%@ page import="org.dspace.core.I18nUtil" %>
<%@ page import="org.dspace.app.webui.util.UIUtil" %>
<%@ page import="org.dspace.app.webui.components.RecentSubmissions" %>
<%@ page import="org.dspace.content.Community" %>
<%@ page import="org.dspace.core.ConfigurationManager" %>
<%@ page import="org.dspace.browse.ItemCounter" %>
<%@ page import="org.dspace.content.DCValue" %>
<%@ page import="org.dspace.content.Item" %>

<div style="width:100.00%; height: 145px">
  <div style="background: url('/static/bg_header.jpg') repeat-x; width: 100%; height: 145px; padding: 0px;">
    <table style="height: 100%; max-width: 800px;" border="0" align="center">
      <tbody>
	<tr>
	  <td width="*" style="background: url('/static/logo_pntu.png') no-repeat; -webkit-filter: drop-shadow(0px 0px 2px white);">
	  </td>
	  <td width="20%" align="center">
	    <a href="../../../xmlui"><img height="50%" width="auto" title="" src="/image/dspace-logo-only.png" /><br />
	    Альтернативний вигляд</a>
	</td>
	</tr>
      </tbody>
    </table>
  </div>
</div>
