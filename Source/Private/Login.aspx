<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="Inboxd.Source.Private.Login" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Login | Inboxd</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.4.1/dist/css/bootstrap.min.css" integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous" />
    <link rel="stylesheet" href="Style/Login.css" />
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <div id="container" class="w-50 rounded mx-auto top-50 p-4 m-4 text-center mt-5">
                <div class="h1 fw-bold">
                    Inboxd <img src="../Public/Images/inboxdLogo.png" id="logo" />
                    <div class="h3">
                        Login
                    </div>
                </div>
                <br />
                <label>Your details:</label>
                <div class="w-75 mx-auto">
                    <div class="input-group mb-3">
                        <div class="input-group-prepend">
                            <span class="input-group-text" id="viewInput">Email</span>
                        </div>
                        <input type="email" name="email" class="form-control" />
                    </div>

                    <br />

                    <div class="input-group mb-3">
                        <div class="input-group-prepend">
                            <span class="input-group-text" id="viewInput">Password</span>
                        </div>
                        <input type="password" class="form-control" id="tbPassword" />
                    </div>
                    <br />

                    <asp:Button runat="server" ID="btnSignIn" class="btn btn-primary" Text="Sign In" OnClick="btnSignIn_Click"></asp:Button>
                    <asp:Button runat="server" ID="btnSignUp" class="btn btn-success" Text="Sign Up"></asp:Button>
                    <span>Forgot your password> <a href="#">Click here!</a></span>
                </div>
            </div>
        </div>
    </form>
</body>
</html>
