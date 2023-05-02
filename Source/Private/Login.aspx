<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="Inboxd.Source.Private.Login" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Login | Inboxd</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.4.1/dist/css/bootstrap.min.css" integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous" />
    <link rel="stylesheet" href="Style/Login.css" />
    <link href="Style/Default.css" rel="stylesheet"/>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@3.3.7/dist/js/bootstrap.min.js" integrity="sha384-Tc5IQib027qvyjSMfHjOMaLkfuWVxZxUPnCJA7l2mCWNIpG9mGCD8wGNIcPD7Txa" crossorigin="anonymous"></script>
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
                            <span class="input-group-text viewInput" >Email</span>
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
                    <asp:Button runat="server" ID="btnSignUp" class="btn btn-success" Text="Sign Up" OnClick="btnSignUp_Click"></asp:Button><br />
                    <br />
                    <span>Forgot your password? <a href="ForgotPassword.aspx">Click here</a></span>
                </div>
            </div>
        </div>
    </form>
</body>
</html>
