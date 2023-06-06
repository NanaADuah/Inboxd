<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SignUp.aspx.cs" Inherits="Inboxd.Source.Private.SignUp" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Sign Up | Inboxd</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.4.1/dist/css/bootstrap.min.css" integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous" />
    <link rel="stylesheet" href="Style/SignUp.css" />
    <link href="Style/Default.css" rel="stylesheet" />
    <link rel="apple-touch-icon" sizes="180x180" href="/apple-touch-icon.png"/>
    <link rel="icon" type="image/png" sizes="32x32" href="/favicon-32x32.png"/>
    <link rel="icon" type="image/png" sizes="16x16" href="/favicon-16x16.png"/>
    <link rel="manifest" href="/site.webmanifest"/>
    <link rel="mask-icon" href="/safari-pinned-tab.svg" color="#5bbad5"/>
    <meta name="msapplication-TileColor" content="#da532c"/>
    <meta name="theme-color" content="#ffffff"/>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <script async src="https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js?client=ca-pub-8388667342418832"
     crossorigin="anonymous"></script>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <div id="container" class="w-50 rounded mx-auto top-50 p-4 m-4 text-center mt-5 overflow-scroll">
                <div class="h1 fw-bold lh-sm">
                    Inboxd
                    <img src="../Public/Images/inboxdLogo.png" id="logo" />
                    <div class="h3">
                        Sign Up
                    </div>
                </div>
                <asp:Label runat="server" ID="lblMessages" Text=""></asp:Label><br />

                <div class=" card w-75 mx-auto">

                    <div class="card-header">Your details:</div>

                    <div class="card-body">
                        <asp:ValidationSummary style="text-align:left" ID="ValidationSummary1" runat="server" DisplayMode="List" ForeColor="Red" HeaderText="Note:" />
                        <%--<div class="input-group mb-3">
                            <div class="input-group-prepend">
                                <span class="input-group-text viewInput">Email <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ErrorMessage="Invalid Email " ControlToValidate="tbEmail" ForeColor="Red" ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*">*</asp:RegularExpressionValidator><asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" ErrorMessage="Invalid Email address" ControlToValidate="tbEmail" ForeColor="Red">*</asp:RequiredFieldValidator></span>
                            </div>
                            <input runat="server" type="email" class="form-control" id="tbEmail" />
                        </div>--%>
                        <hr />
                        
                        <div class="input-group mb-3">
                            <div class="input-group-prepend">
                                <span class="input-group-text viewInput">Name <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ErrorMessage="Name is required" ForeColor="Red" ControlToValidate="tbName"> *</asp:RequiredFieldValidator></span>
                            </div>
                            <input runat="server" type="text" class="form-control" id="tbName" pattern="^[A-Za-z -]+$" />
                        </div>

                        
                        <div class="input-group mb-3">
                            <div class="input-group-prepend">
                                <span class="input-group-text viewInput">Surname <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ErrorMessage="Surname is required" ControlToValidate="tbSurname" ForeColor="Red"> *</asp:RequiredFieldValidator></span>
                            </div>
                            <input runat="server" type="text" class="form-control" id="tbSurname" pattern="^[A-Za-z -]+$" title="Surname" />
                        </div>

                        
                        <div class="input-group mb-3">
                            <div class="input-group-prepend">
                                <span class="input-group-text viewInput">Date of birth <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ErrorMessage="Date of birth required" ControlToValidate="tbDOB" ForeColor="Red"> *</asp:RequiredFieldValidator></span>
                            </div>
                            <input runat="server" type="date" class="form-control" id="tbDOB" />
                        </div>
                    </div>
                    <div class="card m-1">
                        <div class="card-header">Type in a password for your account:</div>
                        <div class="card-body">
                            <div class="input-group mb-3">
                                <div class="input-group-prepend">
                                    
                                    <span class="input-group-text" style="width: 10rem">Password <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" ErrorMessage="Password Required" ControlToValidate="tbPassword">*</asp:RequiredFieldValidator></span>
                                </div>
                                <input runat="server" type="password" class="form-control" id="tbPassword" />
                            </div>
                            <div class="input-group mb-3">
                                <div class="input-group-prepend">
                                    <span class="input-group-text" style="width: 10rem">Confirm password <asp:RequiredFieldValidator ID="RequiredFieldValidator6" runat="server" ErrorMessage="Password Required" ControlToValidate="tbPasswordConfirm" ForeColor="Red">*</asp:RequiredFieldValidator></span>
                                </div>
                                <input runat="server" type="password" class="form-control" id="tbPasswordConfirm" />
                            </div>
                        </div>
                    </div>
                    <asp:Button class="btn btn-primary m-2" Text="Accept" runat="server" OnClick="btnAccept_Click" ID="btnAccept"/>
                    
                        <div runat="server" id="emailSelection" class="card text-center"> 
                            <span>Select an available email from below:</span>

                            <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" ErrorMessage="Please select a email address to use" ControlToValidate="lbAvailEmails">*</asp:RequiredFieldValidator>
                            <asp:ListBox runat="server" ID="lbAvailEmails" class="list-group w-50 mx-auto text-center" style="outline: none">

                            </asp:ListBox>

                        </div>
                        <asp:Button runat="server" ID="btnSignUp" class="btn btn-primary m-2" Text="Sign Up" OnClick="btnSignUp_Click"></asp:Button>
                    <div class="card-footer">Already have an account? <a href="Login.aspx">Click here</a></div>
                </div>
            </div>
        </div>
    </form>
</body>
</html>
