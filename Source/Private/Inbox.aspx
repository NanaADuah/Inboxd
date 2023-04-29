<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Inbox.aspx.cs" Inherits="Inboxd.Source.Private.Inbox" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Home | Inboxd</title>
    <link href="Style/Inbox.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.4.1/dist/css/bootstrap.min.css" integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous" />
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-light bg-light">
        <a class="navbar-brand" href="Inbox.aspx">
            <img src="../Public/Images/inboxdLogo.png" width="40px" /></a>
        <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav">
                <li class="nav-item active">
                    <a class="nav-link" href="#">Home <span class="sr-only">(current)</span></a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="#">Notifications</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="#">Settings</a>
                </li>
            </ul>
        </div>
        <span class="h1 ">Inboxd</span>
    </nav>
    <form id="form1" runat="server">
        <div class="p-4">
            <h3>Current Emails:</h3>
            <%if (!true)
                {
%>
            <div>
                <table class="table">
                    <thead>
                        <tr>
                            <td>Hello World
                            </td>
                        </tr>
                    </thead>

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
        </div>
    </form>
</body>
</html>
