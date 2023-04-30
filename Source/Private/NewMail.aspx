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
    
</head>
<body>
    <!-- #include file='Header.html' -->
    <form id="form1" runat="server">
        <div class="card w-75 mx-auto mt-5" id="container"  >
            <div class="card-header">
                New Message
            </div>
            <div class="rounded card-body">
                <div class="input-group mb-3">
                        <div class="input-group-prepend">
                            <span class="input-group-text viewInput" id="tbToSender">Receipients</span>
                        </div>
                        <input type="email" name="email" class="form-control" />
                    </div>
                    <div class="input-group mb-3">
                        <div class="input-group-prepend">
                            <span class="input-group-text viewInput" id="tbSubject">Subject</span>
                        </div>
                        <input type="password" class="form-control" id="tbPassword" />
                    </div>

                <div>
                    <asp:TextBox runat="server" ID="tbMessage" TextMode="MultiLine" class="form-control" ></asp:TextBox>
                </div>

                
            </div>
            <div class="card-footer">
                <asp:Button runat="server" ID="btnSendMessage" class="btn btn-primary" Text="Send" />
                <a class="btn btn-danger">
                    <i class="fa fa-trash" style="color:white" aria-hidden="true"></i>
                </a>
            </div>
        </div>
    </form>
</body>
</html>
