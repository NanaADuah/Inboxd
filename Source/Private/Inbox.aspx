<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Inbox.aspx.cs" Inherits="Inboxd.Source.Private.Inbox" uiCulture="Auto" EnableSessionState="True" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server"> 
    <style>
        .lock:hover .icon-unlock,
        .lock .icon-lock {
            display: none;
        }
        .lock:hover .icon-lock {
            display: inline;
        }

        *{
            transition: 0.1s ease-in-out !important;
        }
        
    </style>
    <title>Home | Inboxd</title>
    <link href="Style/Inbox.css" rel="stylesheet" />
    <link href="Style/Header.css" rel="stylesheet" />
    <link href="Style/Default.css" rel="stylesheet" />
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js" integrity="sha384-ApNbgh9B+Y1QKtv3Rn7W3mgPxhU9K/ScQsAP7hUibX39j7fakFPskvXusvfa0b4Q" crossorigin="anonymous"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js" integrity="sha384-JZR6Spejh4U02d8jOt6vLEHfe/JQGiRRSQQxSfFWpi1MquVdAyjUar5+76PVCmYl" crossorigin="anonymous"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.4.1/dist/css/bootstrap.min.css" integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous" />
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@3.3.7/dist/js/bootstrap.min.js" integrity="sha384-Tc5IQib027qvyjSMfHjOMaLkfuWVxZxUPnCJA7l2mCWNIpG9mGCD8wGNIcPD7Txa" crossorigin="anonymous"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"/>
    <script   src="https://code.jquery.com/jquery-3.1.1.min.js"   integrity="sha256-hVVnYaiADRTO2PzUGmuLJr8BLUSjGIZsDYGmIJLv2b8="   crossorigin="anonymous"></script>
</head>
   
<body>
    

    <!-- #include file='Header.html' -->
    <form id="form1" runat="server" class="h-100">
        <asp:ScriptManager  ID="ScriptManager1" EnablePageMethods="true" EnablePartialRendering="true" runat="server" />
        <script type="text/javascript">
            function emailView(id) {
                window.location = "EmailView.aspx?id=" + id;
            }
        </script>
        <asp:Label runat="server" ID="lblMessages" Text=""></asp:Label>
        <%if (!string.IsNullOrEmpty(Session["UserID"].ToString()))
            { %>
        <div class="p-4 h-100">
            <div>
                <div class="d-flex justify-content-space-between position-sticky  mb-1">
                    <div class="flex-grow-1 flex-fill d-inline-flex" style="vertical-align:middle">
                        <h3 class="m-0">Welcome <%=loggedInUser != null ?loggedInUser.Name:"user"%>: </h3>
                        
                    </div>
                    <div class="">
                        <div class="d-inline-flex" style="gap:10px">
                            <div class="input-group rounded " style="margin-right: 5px">
                              <input type="search" class="form-control rounded" placeholder="Search"/>
                              <span class="input-group-text border-0" id="search-addon">
                                <i class="fa-solid fa-search"></i>
                              </span>
                            </div>
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
                            <li onclick="window.location = 'NewMail.aspx'" class="list-group-item bg-primary"><a class="text-white text-decoration-none" href="NewMail.aspx"><i class="fa fa-pencil"></i> Compose</a></li>
                            <li onclick="window.location = 'FilterPage.aspx?filter=default'" class="list-group-item"  style="<%=currentView.ToLower().Equals("default") || currentView.ToLower().Equals("recent") || currentView.ToLower().Equals("sender") ? "background-color: #d0d0d0":"" %>"><i class="fa fa-inbox justify-content-between"></i><a style="color: inherit !important" href="FilterPage.aspx?filter=recent" class="text-decoration-none"> Inbox</a> <span class="badge badge-primary badge-pill" style="text-align:right; float:right"><%=loggedInUser.GetEmailsCount()%></span></li>
                            <li onclick="window.location = 'FilterPage.aspx?filter=starred'" class="list-group-item"  style="<%=currentView.ToLower().Equals("starred")  ? "background-color: #d0d0d0":"" %>"><i class="fa fa-star"></i> Starred</li>
                            <li onclick="window.location = 'FilterPage.aspx?filter=spam'" class="list-group-item"  style="<%=currentView.ToLower().Equals("spam")     ? "background-color: #d0d0d0":"" %>"><i class="fa fa-exclamation-circle"></i> Spam</li>
                            <li onclick="window.location = 'FilterPage.aspx?filter=draft'" class="list-group-item"  style="<%=currentView.ToLower().Equals("draft")    ? "background-color: #d0d0d0":"" %>"><i class="fa fa-file"></i> Draft<span class="badge badge-primary badge-pill" style="text-align:right; float:right"><%=loggedInUser.GetDraftCount()%></span></li>
                            <li onclick="window.location = 'FilterPage.aspx?filter=sent'" class="list-group-item"  style="<%=currentView.ToLower().Equals("sent")     ? "background-color: #d0d0d0":"" %>"><i class="fa fa-paper-plane"></i> Sent</li>
                            <li                                                       class="list-group-item"  style="<%=currentView.ToLower().Equals("snoozed")  ? "background-color: #d0d0d0":"" %>"><i class="fa fa-clock-o" ></i> Snoozed</li>
                            <li onclick="window.location = 'FilterPage.aspx?filter=settings'" class="list-group-item"  style="<%=currentView.ToLower().Equals("settings") ? "background-color: #d0d0d0":"" %>"><i class="fa fa-cog"></i> Settings</li>
                        </ul>
                    </div>
                    <div class="flex-fill">
                        <%if (currentView.Equals("settings"))
                            { %>
                            <div>
                                <span class="display-4">Settings Page</span>
                                <hr />
                                <div class="text-center">
                                 Yeah... still under construction<br />
                                <span>In the meantime, jump over to the GitHub Repo and assist if you can :)</span><br /><br />
                                <div class="card w-50 mx-auto">
                                    <div class="card-header p-2">GitHub</div>
                                    <div class="card-body text-center">
                                        <img src="../Public/Images/SingleLogo.svg"  style="height:50px"/><br />
                                        <br />
                                        <h4 class="fw-bold">
                                            https://github.com/NanaADuah/Inboxd
                                            
                                        </h4>
                                    </div>
                                    <div class="card-footer">
                                        <h2>
                                            <a href="https://github.com/NanaADuah/Inboxd" target="_blank" class="badge link-primary badge-secondary">View</a>
                                        </h2>
                                    </div>
                                    </div>
                                </div>
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
                                                <td class="float-end" style="text-align:right; margin-right: 10px"><a class="btn btn-danger badge" href="NewMail.aspx?edit=<%=item.EmailID%>"><i class="fa fa-edit"></i></a></td>
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
                                    <th scope="col"></th>
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
                                <tr onclick="emailView('<%=item.EmailID%>')" <%if (item.EmailRead)
                                    {  %>
                                        class="text-muted" style="background: #f6f6f6"
                                    <%} %>>

                                    
                                    
                                    <td><a class="text-dark" href="EmailView.aspx?star=<%=item.EmailID%>"><i class="<%=item.EmailStarred ? "fa fa-star" : "fa-regular fa-star "%>"></i></a></td>
                                    <td>
                                        <div>
                                            <span class="font-weight-bold"><%=Inboxd.Source.Private.User.GetFullName(item.EmailSender) %></span>
                                        </div>
                                    </td>
                                    <td><span class="font-weight-bold"><%=item.EmailSubject %></span> - <span class="text-muted"><%=Inboxd.Source.Private.Additional.Truncate(item.EmailBody, 50)%></span> </td>
                                    <td class="float-end justify-content-end " style="text-align: right;" ><%=tempTime%></td>
                                    <%if (!currentView.Equals("sent"))
                                        {  %>
                                    
                                    <td class="align-content-center" style="width: 70px; text-align: center">
                                        <a href="#" class="lock text-decoration-none" style="color: inherit !important;">
                                            <i class="icon-unlock fa-regular fa-clock" ></i>
                                            <i class="icon-lock fa-solid fa-clock"></i>
                                        </a>
                                    </td>
                                        <%} %>
                                    <%--<td class="align-content-center" style="width: 70px; text-align: center">
                                        <a class="btn badge btn-primary" href="EmailView.aspx?id=<%=item.EmailID%>"><i class="fa fa-eye"></i></a>
                                        <a class="btn badge btn-success" href="EmailView.aspx?read=<%=item.EmailID%>"><i class="fa fa-check"></i></a>
                                    </td>--%>
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

