﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="Inboxd.Source.Private.Login"  %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Login | Inboxd</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.4.1/dist/css/bootstrap.min.css" integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous" />
    <link rel="stylesheet" href="Style/Login.css" />
    <link href="Style/Default.css" rel="stylesheet"/>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@3.3.7/dist/js/bootstrap.min.js" integrity="sha384-Tc5IQib027qvyjSMfHjOMaLkfuWVxZxUPnCJA7l2mCWNIpG9mGCD8wGNIcPD7Txa" crossorigin="anonymous"></script>
    <link rel="apple-touch-icon" sizes="180x180" href="/apple-touch-icon.png"/>
    <link rel="icon" type="image/png" sizes="32x32" href="/favicon-32x32.png"/>
    <link rel="icon" type="image/png" sizes="16x16" href="/favicon-16x16.png"/>
    <link rel="manifest" href="/site.webmanifest"/>
    <link rel="mask-icon" href="/safari-pinned-tab.svg" color="#5bbad5"/>
    <meta name="msapplication-TileColor" content="#da532c"/>
    <meta name="theme-color" content="#ffffff"/>
    <script async src="https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js?client=ca-pub-8388667342418832"
     crossorigin="anonymous"></script>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <div id="container" class="w-50 rounded mx-auto top-50 p-4 m-4 text-center mt-5">
                <div class="h1 fw-bold lh-sm justify-content-center " style="vertical-align:middle">
                    <img src="../Public/Images/Logo.svg" id="logo" class="img-fluid w-50"/>
                    <div class="h3">
                        Login
                    </div>
                </div>
                <asp:Label runat="server" ID="lblMessages" Text=""></asp:Label><br />
                <label>Your details:</label>
                <div class="w-75 mx-auto">
                    <div class="text-center">
                        <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ErrorMessage="Invalid email" ControlToValidate="tbEmail" ForeColor="Red" ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"></asp:RegularExpressionValidator>
                    </div>
                    <div class="input-group mb-3">
                        <div class="input-group-prepend">
                            <span class="input-group-text viewInput">Email</span>
                        </div>
                        <input runat="server" type="email" class="form-control" id="tbEmail" />
                    </div>

                    <br />
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ErrorMessage="Password required to log in" ControlToValidate="tbPassword" ForeColor="Red"></asp:RequiredFieldValidator>
                    <div class="input-group mb-3">
                        <div class="input-group-prepend">
                            <span class="input-group-text viewInput">Password</span>
                        </div>
                        <input runat="server" type="password" class="form-control" id="tbPassword" />
                    </div>
                    <br />

                    <asp:Button runat="server" ID="btnSignIn" class="btn btn-primary" Text="Sign In" OnClick="btnSignIn_Click"></asp:Button>
                    <a href="SignUp.aspx" class="btn btn-success">Sign Up</a><br />
                    <br />
                    <span>Forgot your password? <a href="ForgotPassword.aspx">Click here</a></span>
                </div>
                <%
                    string tempUrl = HttpContext.Current.Request.Url.Host;

                    //if (tempUrl.Equals("inboxed.azurewebsites"))
                    {
                        %>
                    <div class="w-50 m-2 mx-auto text-center card">
                        <div class="card-header"></div>
                        <div class="card-body">
                            <span class="display-5">We've got a new domain!</span><br />
                            <span class="display-6">Head on over</span>
                        </div>
                        <div class="card-footer">
                            <a class="badge link-primary badge-success" style="font-size: 1.5rem" href="https://inboxed.online">View</a>
                        </div>
                    </div>
                    <%} %>
            </div>
        
        
         </div>
    </form>
</body>
</html>
