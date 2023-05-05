<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="NewMail.aspx.cs" Inherits="Inboxd.Source.Private.NewMail" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>New Mail | Inboxd</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.4.1/dist/css/bootstrap.min.css" integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous" />
    <link rel="stylesheet" href="Style/NewMail.css" />
    <link href="Style/Default.css" rel="stylesheet"/>
    <link href="Style/Header.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css"/>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@3.3.7/dist/js/bootstrap.min.js" integrity="sha384-Tc5IQib027qvyjSMfHjOMaLkfuWVxZxUPnCJA7l2mCWNIpG9mGCD8wGNIcPD7Txa" crossorigin="anonymous"></script>
</head>
<body>
    <!-- #include file='Header.html' -->
    <form id="form1" runat="server">
        <div class="card w-75 mx-auto mt-5" id="container">
            <div class="card-header">
                New Message
            </div>
            <div class="rounded card-body">
                <asp:ValidationSummary ID="ValidationSummary1" style="text-align:left" runat="server" DisplayMode="List" ForeColor="Red" />
                <asp:Label runat="server" ID="lblMessages" Text="" class="m-1"></asp:Label><br />
                <div class="input-group mb-3">
                    
                        <div class="input-group-prepend">
                            <span class="input-group-text viewInput">Receipients <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ErrorMessage="Invalid Receipient Email address" ControlToValidate="tbToSender" ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*" Display="Dynamic" ForeColor="Red"> *</asp:RegularExpressionValidator><asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ErrorMessage="Email address required" ForeColor="Red" ControlToValidate="tbToSender"> * </asp:RequiredFieldValidator></span>
                        </div>
                        <input runat="server" type="email" id="tbToSender" class="form-control" />
                    </div>
                    <div class="input-group mb-3">
                        <div class="input-group-prepend">
                            <span class="input-group-text viewInput" id="">Subject <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ErrorMessage="Subject required" ControlToValidate="tbSubject" ForeColor="Red"> *</asp:RequiredFieldValidator></span>
                        </div>
                        <input runat="server" type="text" class="form-control" id="tbSubject" maxlength="25" />
                    </div>
                <div>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ErrorMessage="Email body required" ForeColor="Red" ControlToValidate="tbEmailArea" >*</asp:RequiredFieldValidator>
                    <textarea runat="server" id="tbEmailArea" class="form-control" type="text" style="height: 30vh"></textarea>
                </div>
            </div>
            <div class="card-footer">
                <asp:Button runat="server" ID="btnSendMessage" class="btn btn-primary" Text="Send" OnClick="btnSendMessage_Click" />
                <%--<asp:Button runat="server" ID="btnDeleteEmail" class="btn btn-danger" Text="Discard" OnClick="btnDeleteEmail_Click" />--%>
                <a href="Inbox.aspx" class="btn btn-danger">Discard</a>
                <asp:Button runat="server" ID="btnSaveDraft" class="btn btn-info" Text="Save draft" OnClick="btnSaveDraft_Click" />
                <asp:Button runat="server" ID="btnAddAttachments" class="btn btn-success" Text="Add attachments" OnClick="btnAddAttachments_Click" />
               
            </div>
        </div>
    </form>
</body>
</html>
