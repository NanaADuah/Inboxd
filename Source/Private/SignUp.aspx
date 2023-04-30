<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SignUp.aspx.cs" Inherits="Inboxd.Source.Private.SignUp" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Sign Up | Inboxd</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.4.1/dist/css/bootstrap.min.css" integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous" />
    <link rel="stylesheet" href="Style/SignUp.css" />
    <link href="Style/Default.css" rel="stylesheet" />
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
                        <div class="input-group mb-3">
                            <div class="input-group-prepend">
                                <span class="input-group-text viewInput">Email</span>
                            </div>
                            <input runat="server" type="email" class="form-control" id="tbEmail" />
                        </div>
                        <hr />
                        <div class="input-group mb-3">
                            <div class="input-group-prepend">
                                <span class="input-group-text viewInput">Name</span>
                            </div>
                            <input runat="server" type="email" class="form-control" id="tbName" />
                        </div>

                        <div class="input-group mb-3">
                            <div class="input-group-prepend">
                                <span class="input-group-text viewInput">Surname</span>
                            </div>
                            <input runat="server" type="email" class="form-control" id="tbSurname" />
                        </div>

                        <div class="input-group mb-3">
                            <div class="input-group-prepend">
                                <span class="input-group-text viewInput">Date of birth</span>
                            </div>
                            <input runat="server" type="date" class="form-control" id="tbDOB" />
                        </div>
                    </div>
                    <div class="card m-1">

                        <div class="card-header">Type in a password for your account:</div>
                        <div class="card-body">

                            <div class="input-group mb-3">
                                <div class="input-group-prepend">
                                    <span class="input-group-text" style="width: 10rem">Password</span>
                                </div>
                                <input runat="server" type="password" class="form-control" id="tbPassword" />
                            </div>
                            <div class="input-group mb-3">
                                <div class="input-group-prepend">
                                    <span class="input-group-text" style="width: 10rem">Confirm password</span>
                                </div>
                                <input runat="server" type="email" class="form-control" id="tbPasswordConfirm" />
                            </div>
                        </div>
                    </div>



                    <asp:Button runat="server" ID="btnSignUp" class="btn btn-primary m-2" Text="Sign Up"></asp:Button>
                    <div class="card-footer">Already have an account? <a href="Login.aspx">Click here</a></div>
                </div>
            </div>
        </div>
    </form>
</body>
</html>
