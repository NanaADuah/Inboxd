﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Inbox.aspx.cs" Inherits="Inboxd.Source.Private.Inbox" uiCulture="Auto" EnableSessionState="True" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server"> 

    <title>Home | Inboxd</title>
    <link href="Style/Inbox.css" rel="stylesheet" />
    <link href="Style/Header.css" rel="stylesheet" />
    <link href="Style/Default.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.4.1/dist/css/bootstrap.min.css" integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous" />
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@3.3.7/dist/js/bootstrap.min.js" integrity="sha384-Tc5IQib027qvyjSMfHjOMaLkfuWVxZxUPnCJA7l2mCWNIpG9mGCD8wGNIcPD7Txa" crossorigin="anonymous"></script>
    <link rel="stylesheet" href="../../Content/font-awesome.min.css" />
</head>
   
<body>
    <!-- #include file='Header.html' -->
    <form id="form1" runat="server" class="h-100">

        <%if (!string.IsNullOrEmpty(Session["UserID"].ToString()))
            { %>
        <div class="p-4 h-100">
            <div>
                <div class="d-flex justify-content-space-between position-sticky">
                    <div class="flex-grow-1">
                        <h3>Welcome <%=loggedInUser != null ?loggedInUser.Name:"user"%>: </h3>
                    </div>
                    <div class="">
                        <div class="">
                            <asp:Button runat="server" class="btn btn-primary btn-sm" id="btnDefault" href="Inbox.aspx?filter=recent" Text="Default" OnClick="btnDefault_Click"></asp:Button>
                            <asp:Button runat="server" class="btn btn-primary btn-sm" id="btnSender" href="Inbox.aspx?filter=sender" Text="Sender" OnClick="btnSender_Click"></asp:Button>
                            <asp:Button runat="server" class="btn btn-primary btn-sm" id="btnUnread" href="Inbox.aspx?filter=unread" Text="Unread" OnClick="btnUnread_Click"></asp:Button>
                        </div>
                    </div>
                </div>
            </div>
            <%
                string currentView = "default";
                if (Session["filter"] != null)
                    currentView = Session["filter"].ToString();
            %>
            <div class="align-content-center h-75">
                <div class="d-flex flex-row justify-content-between">
                    <div class="px-3" style="width: 20%;">
                        <div class="">
                            
                        </div>
                        <ul class="list-group">
                            <%--<li class="list-group-item"><asp:Button CssClass="btn btn-primary float-end" runat="server" ID="btnNewMail" Text="Send a new mail" OnClick="btnNewMail_Click" /></li>--%>
                            <li class="list-group-item bg-primary"><a class="text-white text-decoration-none" href="NewMail.aspx"><i class="fa fa-pencil"></i> Compose</a></li>
                            <li class="list-group-item  <%=currentView.ToLower().Equals("default") || currentView.ToLower().Equals("recent") || currentView.ToLower().Equals("sender") ? "bg-light":"" %>"><i class="fa fa-inbox justify-content-between"></i><a style="color: inherit !important" href="FilterPage.aspx?filter=recent" class="text-decoration-none"> Inbox</a> <span class="text-muted" style="text-align:right; float:right"><%=loggedInUser.GetEmailsCount()%></span></li>
                            <li class="list-group-item  <%=currentView.ToLower().Equals("starred")  ? " bg-light":"" %>"><a style="color: inherit !important" href="FilterPage.aspx?filter=starred" class="text-decoration-none text-black"><i class="fa fa-star"></i> Starred</a></li>
                            <li class="list-group-item  <%=currentView.ToLower().Equals("spam")     ? " bg-light":"" %>"><a href="FilterPage.aspx?filter=spam" class="text-decoration-none" style="color: inherit!important"><i class="fa fa-exclamation-circle"></i> Spam</a></li>
                            <li class="list-group-item  <%=currentView.ToLower().Equals("draft")    ? " bg-light":"" %>"><a href="FilterPage.aspx?filter=draft" class="text-decoration-none" style="color: inherit !important"><i class="fa fa-file"></i> Draft</a><span class="text-muted" style="text-align:right; float:right"><%=loggedInUser.GetDraftCount()%></span></li>
                            <li class="list-group-item  <%=currentView.ToLower().Equals("sent")     ? " bg-light":"" %>"><a href="FilterPage.aspx?filter=sent" style="color: inherit !important" class="text-decoration-none"><i class="fa fa-paper-plane"></i> Sent</a></li>
                            <li class="list-group-item  <%=currentView.ToLower().Equals("snoozed")  ? " bg-light":"" %>"><i class="fa fa-clock-o" ></i> Snoozed</li>
                            <li class="list-group-item  <%=currentView.ToLower().Equals("settings") ? " bg-light":"" %>"><a href="FilterPage.aspx?filter=settings" style="color: inherit !important" class="text-decoration-none"><i class="fa fa-cog"></i> Settings</a></li>
                        </ul>
                        
                    </div>
                    <div class="flex-fill">
                        <%if (currentView.Equals("settings"))
                            { %>
                            <div>
                                <span class="display-4">Settings Page</span>
                                <hr />
                                 Yeah... still under construction
                            </div>
                        <%}
                            else
                            if (currentView.Equals("draft"))
                            {%>
                                <table class="table table-hover table-sm">
                                    <thead class="thead-light">
                                        <tr>
                                            <th></th>
                                            <th></th>
                                            <th></th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <% int count = 0;
                                            foreach (var item in emails) {
                                                count++;%>
                                            <tr>
                                                <td><%=count%></td>
                                                <td><b><%=item.EmailSubject%></b> - <%=Inboxd.Source.Private.Additional.Truncate(item.EmailBody, 50)%></td>
                                                <td class="float-end" style="text-align:right; margin-right: 10px"><a class="btn btn-danger badge" href="NewMail.aspx?id=<%=item.EmailID%>"><i class="fa fa-edit"></i></a></td>
                                            </tr>
                                        <%} %>
                                    </tbody>
                                </table>
                                
                            <%
                            }
                            else
                            if (emails.Count() != 0)
                            {%>
                        <table class="table table-hover table-sm">
                            <thead class="thead-light" style="position: sticky; top: 0">
                                <tr>
                                    <th scope="col"></th>
                                    <th scope="col" class=""></th>
                                    <th scope="col"></th>
                                    <th scope="col"></th>
                                    <th scope="col"></th>
                                </tr>
                            </thead>
                            <tbody>
                                <%foreach (var item in emails)
                                    {
                                        string tempTime = Inboxd.Source.Private.Time.TimeAgo(item.EmailDate);
                                %>
                                <tr <%if (item.EmailRead)
                                    {  %>class="text-muted"
                                    style="background: #f6f6f6" <%} %>>
                                    <td><a class="text-dark" href="EmailView.aspx?star=<%=item.EmailID%>"><i class="<%=item.EmailStarred?"fa fa-star":"fa fa-star-o"%>"></i></a></td>
                                    <td class="">
                                        <div>
                                            <span class="font-weight-bold"><%=Inboxd.Source.Private.User.GetFullName(item.EmailSender) %></span>
                                        </div>
                                    </td>
                                    <td><span class="font-weight-bold"><%=item.EmailSubject %></span> - <span class="text-muted"><%=Inboxd.Source.Private.Additional.Truncate(item.EmailBody, 50)%></span> </td>
                                    <td class="float-end justify-content-end" style="text-align: right"><%=tempTime%></td>
                                    <td class="align-content-center" style="width: 70px; text-align: center">
                                        <a class="btn badge btn-primary" href="EmailView.aspx?id=<%=item.EmailID%>"><i class="fa fa-eye"></i></a>
                                        <a class="btn badge btn-success" href="EmailView.aspx?read=<%=item.EmailID%>"><i class="fa fa-check"></i></a>
                                    </td>
                                </tr>
                       <%} %>
                            </tbody>
                        </table>
            <%}
                else
                { %>
                <table class="table table-sm">
                    <thead class="thead-light">
                        <tr>
                            <th></th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <th class="text-center">
                                <div>There's nothing to display for now... <br />
                                <img class="img-fluid m-2" style="height: 100px" src="../Public/Images/SingleLogo.svg"/>
                                </div>
                            </th>
                        </tr>
                    </tbody>
                </table>
            <%} %>
                    </div>
                </div>
            </div>
            <hr />
        </div>
        <%}
            else
            { %>

        <div class="card-body">
            Currently not logged in
        </div>
        <%} %>
    </form>
</body>
</html>
