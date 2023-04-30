<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Inbox.aspx.cs" Inherits="Inboxd.Source.Private.Inbox" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Home | Inboxd</title>
    <link href="Style/Inbox.css" rel="stylesheet" />
    <link href="Style/Header.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.4.1/dist/css/bootstrap.min.css" integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous" />
</head>
<body>
    <!-- #include file='Header.html' -->
    <form id="form1" runat="server" class="h-100">

        <%if (!string.IsNullOrEmpty(Session["UserID"].ToString()))
            { %>
        <div class="p-4 h-100">
            <h3>Current Emails[<%=loggedInUser.getEmailsCount() %>]: </h3>
            <%if (true)
                {
            %>
            <div>
                <table class="table">
                    <thead>
                        <tr>
                            <td>Hello
                            </td>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td>World</td>
                        </tr>
                    </tbody>

                </table>
            </div>
            <%}
                else
                { %>
            <div>
                <table class="table">
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
        <%} else { %>
            
            <div class="card-body">Currently not logged in
            </div>
        <%} %>
    </form>
</body>
</html>
