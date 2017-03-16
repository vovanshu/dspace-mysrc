<%--

    The contents of this file are subject to the license and copyright
    detailed in the LICENSE and NOTICE files at the root of the source
    tree and available online at

    http://www.dspace.org/license/

--%>
<%--
  - Home page JSP
  -
  - Attributes:
  -    communities - Community[] all communities in DSpace
  -    recent.submissions - RecetSubmissions
  --%>

<%@page import="org.dspace.content.Bitstream"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@ page contentType="text/html;charset=UTF-8" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>

<%@ page import="java.io.File" %>
<%@ page import="javax.servlet.jsp.jstl.core.*" %>
<%@ page import="javax.servlet.jsp.jstl.fmt.LocaleSupport" %>
<%@ page import="org.dspace.app.webui.util.UIUtil" %>
<%@ page import="org.dspace.app.webui.components.*" %>
<%@ page import="org.dspace.core.*" %>
<%@ page import="org.dspace.content.*" %>
<%@ page import="org.dspace.content.Collection" %>
<%@ page import="org.dspace.content.Community" %>
<%@ page import="org.dspace.discovery.*" %>

<%@ page import="org.dspace.storage.rdbms.*" %>

<%@ page import="org.dspace.browse.*" %>
<%@ page import="java.io.IOException" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.util.*" %>

<%@ page import="org.dspace.utils.DSpace" %>

<%@ page import="javax.servlet.ServletException" %>
<%@ page import="javax.servlet.http.HttpServletRequest" %>
<%@ page import="javax.servlet.http.HttpServletResponse" %>
<%@ page import="org.dspace.app.webui.util.JSPManager" %>
<%@ page import="org.dspace.authorize.AuthorizeException" %>
<%@ page import="org.dspace.authorize.AuthorizeManager" %>

<%

    Community[] communities = (Community[]) request.getAttribute("communities");

    Map<Integer, Collection[]> colMap = new HashMap<Integer, Collection[]>();
    Map<Integer, Community[]> commMap = new HashMap<Integer, Community[]>();

    for (int com = 0; com < communities.length; com++)
    {
        Integer comID = Integer.valueOf(communities[com].getID());
        Collection[] colls = communities[com].getCollections();
        colMap.put(comID, colls);
        Community[] comms = communities[com].getSubcommunities();
        commMap.put(comID, comms);
    }

    ItemCounter ic = new ItemCounter(UIUtil.obtainContext(request));

    boolean feedEnabled = ConfigurationManager.getBooleanProperty("webui.feed.enable");
    String feedData = "NONE";
    if (feedEnabled)
    {
        feedData = "ALL:" + ConfigurationManager.getProperty("webui.feed.formats");
    }

    RecentSubmissions submissions = (RecentSubmissions) request.getAttribute("recent.submissions");

%>

<%!

void listSub(Community c, JspWriter out, Context context, HttpServletRequest request, ItemCounter ic, Map colMap, Map commMap) throws ItemCountException, IOException, SQLException
{

  boolean showLogos = ConfigurationManager.getBooleanProperty("jspui.community-list.logos", true);
  
  
  out.println( "<div class=\"list-group-item row\">" );
  Bitstream logo = c.getLogo();
  if (showLogos && logo != null)
  {
    out.println("<a class=\"pull-left col-md-2\" href=\"" + request.getContextPath() + "/handle/" 
      + c.getHandle() + "\"><img class=\"media-object img-responsive\" src=\"" + 
      request.getContextPath() + "/retrieve/" + logo.getID() + "\" alt=\"community logo\"></a>");
  }
  out.println( "<div class=\"media-body\"><h4 class=\"media-heading\"><a href=\"" + request.getContextPath() + "/handle/" 
    + c.getHandle() + "\">" + c.getMetadata("name") + "</a>");
  if(ConfigurationManager.getBooleanProperty("webui.strengths.show"))
  {
      out.println(" <span class=\"badge pull-right\">" + ic.getCount(c) + "</span>");
  }
  out.println("</h4>");
  if (StringUtils.isNotBlank(c.getMetadata("short_description")))
  {
    out.println(c.getMetadata("short_description"));
  }
  out.println("<br>");
		
  Collection[] cols = (Collection[]) colMap.get(c.getID());

  if (cols != null && cols.length > 0)
  {
      out.println("<div class=\"list-group-item row\">");
      for (int j = 0; j < cols.length; j++)
      {
          out.println("<div class=\"list-group-item row\">");
          
          Bitstream logoCol = cols[j].getLogo();
          if (showLogos && logoCol != null)
          {
            out.println("<a class=\"pull-left col-md-2\" href=\"" + request.getContextPath() + "/handle/" 
              + cols[j].getHandle() + "\"><img class=\"media-object img-responsive\" src=\"" + 
              request.getContextPath() + "/retrieve/" + logoCol.getID() + "\" alt=\"collection logo\"></a>");
          }
          out.println("<div class=\"media-body\"><h4 class=\"media-heading\"><a href=\"" + request.getContextPath() + "/handle/" + cols[j].getHandle() + "\">" + cols[j].getMetadata("name") +"</a>");
  if(ConfigurationManager.getBooleanProperty("webui.strengths.show"))
          {
              out.println(" <span class=\"badge pull-right\">" + ic.getCount(cols[j]) + "</span>");
          }
  out.println("</h4>");
  if (StringUtils.isNotBlank(cols[j].getMetadata("short_description")))
  {
    out.println(cols[j].getMetadata("short_description"));
  }
  out.println("</div>");
          out.println("</div>");
      }
      out.println("</div>");
  }

  Map<Integer, Collection[]> subcolMap = new HashMap<Integer, Collection[]>();
  
  Community[] comms = (Community[]) commMap.get(c.getID());
  if (comms != null && comms.length > 0)
  {
      out.println("<div class=\"media-list\">");
      for (int k = 0; k < comms.length; k++)
      {
          Integer comID = Integer.valueOf(comms[k].getID());
          Collection[] subcolls = comms[k].getCollections();
          subcolMap.put(comID, subcolls);
          listSub(comms[k], out, context, request, ic, subcolMap, commMap);
      }
      out.println("</div>"); 
  }
  out.println("</div>");
  out.println("</div>");

}

%>



<dspace:layout locbar="nolink" titlekey="jsp.home.title" feedData="<%= feedData %>">


<div class="row">
<%
if (submissions != null && submissions.count() > 0)
{
%>
        <div class="col-md-8">
        <div class="panel panel-primary">        
        <div id="recent-submissions-carousel" class="panel-heading carousel slide">
          <h3><fmt:message key="jsp.collection-home.recentsub"/>
              <%
    if(feedEnabled)
    {
	    	String[] fmts = feedData.substring(feedData.indexOf(':')+1).split(",");
	    	String icon = null;
	    	int width = 0;
	    	for (int j = 0; j < fmts.length; j++)
	    	{
	    		if ("rss_1.0".equals(fmts[j]))
	    		{
	    		   icon = "rss1.gif";
	    		   width = 80;
	    		}
	    		else if ("rss_2.0".equals(fmts[j]))
	    		{
	    		   icon = "rss2.gif";
	    		   width = 80;
	    		}
	    		else
	    	    {
	    	       icon = "rss.gif";
	    	       width = 36;
	    	    }
	%>
	    <a href="<%= request.getContextPath() %>/feed/<%= fmts[j] %>/site"><img src="<%= request.getContextPath() %>/image/<%= icon %>" alt="RSS Feed" width="<%= width %>" height="15" vspace="3" border="0" /></a>
	<%
	    	}
	    }
	%>
          </h3>
          
		  <!-- Wrapper for slides -->
		  <div class="carousel-inner">
		    <%
		    boolean first = true;
		    for (Item item : submissions.getRecentSubmissions())
		    {
		        DCValue[] dcv = item.getMetadata("dc", "title", null, Item.ANY);
		        String displayTitle = "Untitled";
		        if (dcv != null & dcv.length > 0)
		        {
		            displayTitle = dcv[0].value;
		        }
		        dcv = item.getMetadata("dc", "description", "abstract", Item.ANY);
		        String displayAbstract = "";
		        if (dcv != null & dcv.length > 0)
		        {
		            displayAbstract = dcv[0].value;
		        }
		%>
		    <div style="padding-bottom: 50px; min-height: 200px;" class="item <%= first?"active":""%>">
		      <div style="padding-left: 80px; padding-right: 80px; display: inline-block;"><%= StringUtils.abbreviate(displayTitle, 400) %> 
		      	<a href="<%= request.getContextPath() %>/handle/<%=item.getHandle() %>"> 
		      		<button class="btn btn-success" type="button">Перегляд</button>
		      		</a>
                        <p><%= StringUtils.abbreviate(displayAbstract, 500) %></p>
		      </div>
		    </div>
		<%
				first = false;
		     }
		%>
		  </div>

		  <!-- Controls -->
		  <a class="left carousel-control" href="#recent-submissions-carousel" data-slide="prev">
		    <span class="icon-prev"></span>
		  </a>
		  <a class="right carousel-control" href="#recent-submissions-carousel" data-slide="next">
		    <span class="icon-next"></span>
		  </a>

          <ol class="carousel-indicators">
		    <li data-target="#recent-submissions-carousel" data-slide-to="0" class="active"></li>
		    <% for (int i = 1; i < submissions.count(); i++){ %>
		    <li data-target="#recent-submissions-carousel" data-slide-to="<%= i %>"></li>
		    <% } %>
	      </ol>
     </div></div></div>
<%
}
%>

</div>

<div class="container row">

<%

if (communities != null && communities.length != 0)
{
%>
	<div class="col-md-9 col-md-9-1">		
               <h3><fmt:message key="jsp.home.com1"/></h3>
                <p><fmt:message key="jsp.home.com2"/></p>
				<div class="list-group">
<%
	boolean showLogos = ConfigurationManager.getBooleanProperty("jspui.home-page.logos", true);
    for (int i = 0; i < communities.length; i++)
    {
      listSub(communities[i], out, context, request, ic, colMap, commMap);
    }
%>
	</div>
	</div>
<%
}

    	int discovery_panel_cols = 4;
    	int discovery_facet_cols = 4;
    %>
    <dspace:sidebar>
	<%@ include file="discovery/static-sidebar-facet.jsp" %>
	</dspace:sidebar>
</div>
<%@ include file="layout/google.translate.jsp" %>
</dspace:layout>
