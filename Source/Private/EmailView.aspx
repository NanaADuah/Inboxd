<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="EmailView.aspx.cs" Inherits="Inboxd.Source.Private.EmailView" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Email | Inboxd</title>
    <link href="Style/Header.css" rel="stylesheet" />
    <link href="Style/Default.css" rel="stylesheet" />
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@3.3.7/dist/js/bootstrap.min.js" integrity="sha384-Tc5IQib027qvyjSMfHjOMaLkfuWVxZxUPnCJA7l2mCWNIpG9mGCD8wGNIcPD7Txa" crossorigin="anonymous"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.4.1/dist/css/bootstrap.min.css" integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous" />
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@3.3.7/dist/js/bootstrap.min.js" integrity="sha384-Tc5IQib027qvyjSMfHjOMaLkfuWVxZxUPnCJA7l2mCWNIpG9mGCD8wGNIcPD7Txa" crossorigin="anonymous"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />

</head>
<body>
    <!-- #include file='Header.html' -->
    <form id="form1" runat="server">
        <div class="p-2 mx-auto mt-5">
            <%
                Inboxd.Source.Private.User user = new Inboxd.Source.Private.User();
                if (ValidView)

                { %>
            <div class="w-50 m-auto">
                <asp:Label ID="lblMessages" runat="server" Text=""></asp:Label>
                <div class="card">
                    <div class="card-header <%=SingleEmail.EmailSpam?"bg-warning":"" %> ">
                        <div>
                            <div>
                                <div style="vertical-align: middle" class="h3 align-content-center d-flex">
                                    <div class="d-inline">
                                        <asp:Button runat="server" ID="btnReturn" OnClick="btnGoBack_Click" Text="GO BACK" class="btn btn-primary w-25 mx-2 bg-info btn-outline-info text-white" Style="display: none" />
                                        <i class="fa-solid fa-chevron-left h-75" onclick="document.getElementById('btnReturn').click()"></i>
                                    </div>
                                    <asp:Label runat="server" ID="tbEmailSubject" Text="Email Subject"></asp:Label>
                                    <%if (SingleEmail.EmailSpam)
                                        { %>
                                    <span class="badge badge-secondary h-50 my-auto m-2" style="font-size: 0.8rem">Spam</span>
                                    <%}
                                        else
                                    if (Session["filter"] != null)
                                        if (Session["filter"].ToString().Equals("sent")){ %>
                                        <span class="badge badge-secondary h-50 my-auto m-2" style="font-size: 0.8rem">Sent</span>
                                    <%}else
                                        {%>
                                    <span class="badge badge-secondary h-50 my-auto m-2" style="font-size: 0.8rem"><a style="color:inherit !important" class="text-decoration-none" href="Inbox.aspx?filter=default">Inbox</a></span>
                                    <%}%>
                                    <div class="float-end justify-content-end d-inline" style="margin-left: auto; font-size: 1.1rem">
                                        <%if (SingleEmail.EmailStarred)
                                            { %>
                                        <i class="fa fa-star" style="vertical-align: middle"></i>
                                        <%}
                                            else
                                            { %>
                                        <i class="fa-regular fa-star" style="vertical-align: middle"></i>
                                        <%} %>
                                    </div>
                                </div>

                            </div>

                        </div>
                        <hr class="p-1 m-1" />
                        <div class="px-3 d-flex flex-row">
                            <div class="h2">
                                <div style="vertical-align: middle" class="mx-auto">
                                    <i class="fa fa-user-circle px-2"></i>
                                </div>
                            </div>
                            <div>
                                <%
                                if (SingleEmail != null)
                                {  %>
                                <span style="cursor: pointer" title="<%=user.getUserEmail(SingleEmail.EmailSender)%> - Inboxd" class="h6 fw-bolder "><b><%= (Inboxd.Source.Private.User.GetFullName(SingleEmail.EmailSender)) %></b></span><br />
                                <span class="h6 text-muted">to <%=(SingleEmail.ReceipientEmail) %><i class="fa-solid fa-chevron-down p-1"></i></span><br />
                                <%} %>
                            </div>

                        </div>
                        <hr class="p-1 m-1" />

                        <div style="text-align: right">
                            <asp:Label class="h7" runat="server" ID="tbEmailDate" Text="Email Date"></asp:Label><br />
                            <asp:Label runat="server" ID="tbEmailTime" Text="Email Time"></asp:Label>
                        </div>
                    </div>
                    <div class="card-body">
                        <asp:TextBox class="form-control" runat="server" TextMode="MultiLine" ID="tbEmailInformation" ReadOnly="true" Style="height: 35vh"></asp:TextBox>
                    </div>
                    <div class="card-footer d-flex justify-content-end  text-center" style="align-items: center; gap: 10px">

                        <%
                            if (SingleEmail.ReceipientEmail.Equals(user.getUserEmail(int.Parse(Session["UserID"].ToString()))))
                            {
                        %>


                        <asp:Button runat="server" ID="btnReply" Text="REPLY" class="btn btn-success w-75 mx-2 bg-info btn-outline-info text-white" Style="display: none" OnClick="btnReply_Click" />
                        <div  title="Reply to email" class="btn btn-primary" onclick="document.getElementById('btnReply').click()"><i class="fa-solid fa-reply"></i></div>

                        <%if (SingleEmail.EmailRead)
                            {  %>
                        <asp:Button runat="server" ID="btnMarkRead1" class="btn btn-danger mx-2 w-25 bg-info btn-outline-info text-white" OnClick="btnMarkRead_Click" Text="MARK AS UNREAD" style="display: none"/>
                        <div title="Mark as unread" onclick="document.getElementById('btnMarkRead1').click()" class="btn btn-success"><i class="fa-solid fa-envelope"></i></div>
                        <%}
                            else
                            {
                        %>
                        <%--<asp:Button runat="server" ID="btnMarkRead2" class="btn btn-danger mx-2 w-25 bg-info btn-outline-info text-white" OnClick="btnMarkRead_Click" Text="MARK AS READ"/>--%>
                        <%
                            }%>
                        <asp:Button runat="server" ID="btnDelete" Text="DELETE" class="btn btn-danger mx-2 w-25" OnClick="btnDelete_Click" Style="display: none" />
                        <div title="Delete Email" class="btn btn-danger" onclick="document.getElementById('btnDelete').click()"><i class="fa-solid fa-trash"></i></div>
                        <%
                            } %>
                        <%if (!SingleEmail.EmailSpam)
                            {  %>
                        <div title="Mark as spam" class="btn btn-warning badge justify-content-between px-2 d-inline" style="float: right">
                            <asp:Button class="btn btn-sm" runat="server" ID="btnSpamSet" Text="Mark as spam" OnClick="btnSpamSet_Click" Style="display: none" />
                            <div class="btn btn-sm" onclick="document.getElementById('btnSpamSet').click()"><i class="fa fa-warning"></i></div>
                        </div>
                        <%}
                            else
                            { %>
                        <div title="Unmark as spam" class="btn btn-info badge justify-content-between px-2 d-inline" style="float: right">
                            <asp:Button class="btn btn-sm text-white" runat="server" ID="btnUnsetSpam" Text="Unset as spam" OnClick="btnSpamSet_Click" style="display:none" />
                            <div class="btn btn-sm " onclick="document.getElementById('btnUnsetSpam').click()"><i class="fa fa-warning"></i></div>
                        </div>
                        <%} %>
                    </div>
                </div>
            </div>
            <%}
                else
                {  %>
            <div class="p-4">
                <div class="form-control">
                    Cannot view this email.
                </div>

                <asp:Button runat="server" ID="btnGoBack" class="btn btn-dark my-2" Text="GO BACK" OnClick="btnGoBack_Click" />
            </div>
            <%} %>
        </div>
    </form>
</body>
</html>
