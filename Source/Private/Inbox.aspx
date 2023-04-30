<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Inbox.aspx.cs" Inherits="Inboxd.Source.Private.Inbox" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Home | Inboxd</title>
    <link href="Style/Inbox.css" rel="stylesheet" />
    <link href="Style/Header.css" rel="stylesheet" />
    <link href="Style/Default.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.4.1/dist/css/bootstrap.min.css" integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous" />
</head>
<body>
    <!-- #include file='Header.html' -->
    <form id="form1" runat="server" class="h-100">

        <%if (!string.IsNullOrEmpty(Session["UserID"].ToString()))
            { %>
        <div class="p-4 h-100">
            <h3>Current Emails[<%=loggedInUser.getEmailsCount() %>]: </h3>
            <%if (loggedInUser.getEmailsCount() != 0)
                {
            %>
            <div class="card-body align-content-center">
                <table class="table rounded table-hover table-sm">
                    <thead class="thead-dark">
                        <tr>
                            <th scope="col" class="w-25">Information</th>
                            <th scope="col"></th>
                            <th scope="col"></th>
                        </tr>
                    </thead>
                    <tbody>
                        <%foreach (var item in emails)
                        {
                           string tempTime = Inboxd.Source.Private.Time.TimeAgo(item.EmailDate);
                        %>
                        <tr>
                            <td>
                                <div>
                                    <span class="fs-1"><b><%=item.EmailSubject%></b></span><br />
                                    <span class="fs-4"><%=item.EmailSender %></span>
                                </div>
                            </td>
                            <td><%=item.EmailBody%></td>
                            <td class="float-end justify-content-end " style="text-align: right"><%=tempTime%></td>
                        </tr>
                        <%} %>
                    </tbody>

                </table>
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
            <div class="w-100 d-flex justify-content-end position-sticky bottom-0 h-25">
                <asp:Button CssClass="btn btn-primary float-end" runat="server" ID="btnNewMail" Text="Send a new mail" OnClick="btnNewMail_Click" />
            </div>
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
