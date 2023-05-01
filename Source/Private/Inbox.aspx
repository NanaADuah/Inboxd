<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Inbox.aspx.cs" Inherits="Inboxd.Source.Private.Inbox" uiCulture="Auto" EnableSessionState="True" %>

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
                <div class="d-flex justify-content-space-between position-sticky ">
                    <div class="flex-grow-1">
                        <h3>Current Emails[<%=loggedInUser.getEmailsCount() %><%=(ViewState["filter"] != null) ? " - " + ViewState["filter"].ToString() : "" %>]: </h3>
                    </div>
                    <div class="">
                        <asp:Button runat="server" class="btn btn-primary btn-sm" href="Inbox.aspx?filter=recent" Text="Default" OnClick="Unnamed_Click"></asp:Button>
                        <asp:Button runat="server" class="btn btn-primary btn-sm" href="Inbox.aspx?filter=recent" Text="Starred" OnClick="Unnamed1_Click"></asp:Button>
                        <asp:Button runat="server" class="btn btn-primary btn-sm" href="Inbox.aspx?filter=starred" Text="Most Recent" OnClick="Unnamed_Click1"></asp:Button>
                        <asp:Button runat="server" class="btn btn-primary btn-sm" href="Inbox.aspx?filter=sender" Text="Sender" OnClick="Unnamed2_Click"></asp:Button>
                        <asp:Button runat="server" class="btn btn-primary btn-sm" href="Inbox.aspx?filter=unread" Text="Unread" OnClick="Unnamed3_Click"></asp:Button>
                    </div>
                </div>
            </div>
            <%if (loggedInUser.getEmailsCount() != 0)
                {
            %>
            <div class="align-content-center h-75">
                <div class="d-flex flex-row justify-content-between">
                    <div class="px-3" style="width: 20%;">
                        <div class="">
                            
                        </div>
                        <ul class="list-group">
                            <%--<li class="list-group-item"><asp:Button CssClass="btn btn-primary float-end" runat="server" ID="btnNewMail" Text="Send a new mail" OnClick="btnNewMail_Click" /></li>--%>
                            <li class="list-group-item bg-primary" ><a class="text-white" href="NewMail.aspx"><i class="fa fa-pencil"></i> Compose</a></li>
                            <li class="list-group-item"><i class="fa fa-inbox"></i> Inbox</li>
                            <li class="list-group-item" runat="server" ><i class="fa fa-star"></i><a class="text-decoration-none" href="Inbox.aspx?filter=starred"> Starred</a></li>
                            <li class="list-group-item"><i class="fa fa-exclamation-circle"></i> Spam</li>
                            <li class="list-group-item"><i class="fa fa-file"></i> Draft</li>
                            <li class="list-group-item"><i class="fa fa-paper-plane"></i> Sent</li>
                            <li class="list-group-item"><i class="fa fa-clock-o"></i> Snoozed</li>
                        </ul>
                        
                    </div>
                    <div class="flex-fill">
                        <table class="table table-hover table-sm">
                            <thead class="thead-light">
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
                    </div>

                </div>

            </div>
            <%}
                else
                { %>
            <div>
                <table class="table rounded-1">
                    <thead>
                        <tr>
                            <td>You currently have no emails
                            </td>
                        </tr>
                    </thead>

                </table>
            </div>
            <%} %>
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
