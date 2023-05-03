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
    <link rel="stylesheet" href="../../Content/font-awesome.min.css" />
</head>
<body>
    <!-- #include file='Header.html' -->
    <form id="form1" runat="server">
        <div class="p-2 mx-auto mt-5">
            <%if (ValidView)
                { %>
            <div class="w-50 m-auto">
                <asp:Label ID="lblMessages" runat="server" Text=""></asp:Label>
                <div class="card">
                    <div class="card-header <%=SingleEmail.EmailSpam?"bg-warning":"" %> ">
                        <div>
                            <div>
                                <span class="h3">Subject <i class="fa fa-pencil"></i></span>
                                <%if (!SingleEmail.EmailSpam)
                                    {  %> 
                                <div class="btn btn-warning badge justify-content-between px-2" style=" float:right">
                                    <i class="fa fa-warning"></i><asp:Button class="btn btn-sm" runat="server" ID="btnSpamSet" Text="Set as spam" OnClick="btnSpamSet_Click"/>
                                </div>
                                <%}else { %> 
                                <div class="btn btn-dark badge text-white justify-content-between px-2" style=" float:right">
                                    <i class="fa fa-warning"></i><asp:Button class="btn btn-sm text-white" runat="server" ID="btnUnsetSpam" Text="Unset as spam" OnClick="btnSpamSet_Click"/>
                                </div>
                                <%} %>
                            </div> 
                            <asp:Label runat="server" ID="tbEmailSubject" Text="Email Subject"></asp:Label>
                        </div>
                        <hr class="p-1 m-1"/>

                        <div style="text-align:right">
                            <asp:Label class="h7" runat="server" ID="tbEmailDate" Text="Email Date"></asp:Label><br />
                            <asp:Label runat="server" ID="tbEmailTime" Text="Email Time"></asp:Label>
                        </div>
                    </div>
                        <div class="card-body">
                            <asp:TextBox class="form-control" runat="server" TextMode="MultiLine" ID="tbEmailInformation" ReadOnly="true" style="height: 35vh"></asp:TextBox>
                        </div>
                    <div class="card-footer d-flex justify-content-between text-center" style="align-items:center">
                        <asp:Button runat="server" ID="btnReturn" OnClick="btnGoBack_Click" Text="GO BACK" class="btn btn-primary w-25 mx-2 bg-info btn-outline-info text-white" />
                        <%
                            Inboxd.Source.Private.User user = new Inboxd.Source.Private.User();
                            if (SingleEmail.ReceipientEmail.Equals(user.getUserEmail(int.Parse(Session["UserID"].ToString())))){
                        %>


                        <asp:Button runat="server" ID="btnReply"  Text="REPLY" class="btn btn-success w-75 mx-2 bg-info btn-outline-info text-white" OnClick="btnReply_Click" />
                        <%if (SingleEmail.EmailRead)
                            {  %>
                            <asp:Button runat="server" ID="btnMarkRead1" class="btn btn-danger mx-2 w-25 bg-info btn-outline-info text-white" OnClick="btnMarkRead_Click" Text="MARK AS UNREAD"/>
                           <%}
                               else
                               {                            %>
                        <%--<asp:Button runat="server" ID="btnMarkRead2" class="btn btn-danger mx-2 w-25 bg-info btn-outline-info text-white" OnClick="btnMarkRead_Click" Text="MARK AS READ"/>--%>
                        <%
                            }%>
                                <asp:Button runat="server" ID="btnDelete"  Text="DELETE" class="btn btn-danger mx-2 w-25" OnClick="btnDelete_Click" />
                        <%
                        } %>
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
