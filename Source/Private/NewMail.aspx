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
                <asp:Label runat="server" ID="lblMessages" Text="" class="m-1"></asp:Label><br />
                <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ErrorMessage="Invalid Receipient Email address" ControlToValidate="tbToSender" ForeColor="Red" ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*" Display="Dynamic"></asp:RegularExpressionValidator>
                <div class="input-group mb-3">
                        <div class="input-group-prepend">
                            <span class="input-group-text viewInput">Receipients</span>
                        </div>
                        <input runat="server" type="email" id="tbToSender" class="form-control" />
                    </div>
                    <div class="input-group mb-3">
                        <div class="input-group-prepend">
                            <span class="input-group-text viewInput" id="">Subject</span>
                        </div>
                        <input runat="server" type="text" class="form-control" id="tbSubject" />
                    </div>

                <div>
                    <asp:TextBox runat="server" ID="tbMessage" TextMode="MultiLine" class="form-control" style="height: 30vh"></asp:TextBox>
                </div>
            </div>
            <div class="card-footer">
                <asp:Button runat="server" ID="btnSendMessage" class="btn btn-primary" Text="Send" OnClick="btnSendMessage_Click" />
                <asp:Button runat="server" ID="btnDeleteEmail" class="btn btn-danger" Text="Discard" OnClick="btnDeleteEmail_Click" />
               
            </div>
        </div>
    </form>
</body>
</html>
