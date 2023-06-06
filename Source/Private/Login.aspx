<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="Inboxd.Source.Private.Login" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Login | Inboxd</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.4.1/dist/css/bootstrap.min.css" integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous" />
    <link rel="stylesheet" href="Style/Login.css" />
    <link href="Style/Default.css" rel="stylesheet" />
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@3.3.7/dist/js/bootstrap.min.js" integrity="sha384-Tc5IQib027qvyjSMfHjOMaLkfuWVxZxUPnCJA7l2mCWNIpG9mGCD8wGNIcPD7Txa" crossorigin="anonymous"></script>
    <link rel="apple-touch-icon" sizes="180x180" href="/apple-touch-icon.png" />
    <link rel="icon" type="image/png" sizes="32x32" href="/favicon-32x32.png" />
    <link rel="icon" type="image/png" sizes="16x16" href="/favicon-16x16.png" />
    <link rel="manifest" href="/site.webmanifest" />
    <link rel="mask-icon" href="/safari-pinned-tab.svg" color="#5bbad5" />
    <meta name="msapplication-TileColor" content="#da532c" />
    <meta name="theme-color" content="#ffffff" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <script async src="https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js?client=ca-pub-8388667342418832"
        crossorigin="anonymous"></script>
</head>
<body>
    <form id="form1" runat="server">
        <div class="h-100" id="main">
            <div id="container" class="w-50 rounded mx-auto p-2 m-2 text-center middle">
                <div id="boxShadow" class="p-2">
                <div class="h1 fw-bold lh-sm justify-content-center" style="vertical-align: middle">
                    <img src="../Public/Images/Logo.svg" id="logo" class="img-fluid w-50" />
                    <div class="h3">
                        Login
                    </div>
                </div>
                <asp:Label runat="server" ID="lblMessages" Text=""></asp:Label><br />
                <label>Your details:</label>
                <div class="text-center">
                    <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ErrorMessage="Invalid email" ControlToValidate="tbEmail" ForeColor="Red" ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"></asp:RegularExpressionValidator>
                </div>
                <div class="w-75 mx-auto row" id="infoDiv">
                    <div class="row">
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
                    </div>
                    <br />
                    <div class="row w-75 flex-fill">
                        <div class="col">
                            <asp:Button runat="server" ID="btnSignIn" class="btn btn-primary w-100" Text="Sign In" OnClick="btnSignIn_Click"></asp:Button>
                        </div>
                        <div class="col ">
                            <a href="SignUp.aspx" class="btn btn-success w-100">Sign Up</a><br />
                        </div>
                    </div>
                    <br />
                    <div class="row text-center m-2 mx-auto">
                        <span class="text-center mx-auto" style="align-items: center">Forgot your password? <a href="ForgotPassword.aspx">Click here</a></span>
                    </div>
                    
                </div>

                </div>
                <%
                    string tempUrl = HttpContext.Current.Request.Url.Host;

                    //if (tempUrl.Equals("inboxed.azurewebsites"))
                    if (false)
                    {
                %>
                <div class="w-50 m-2 mx-auto text-center card row">
                    <div class="card-header rpw"></div>
                    <div class="card-body ro">
                        <span class="display-5">We've got a new domain!</span><br />
                        <span class="display-6">Head on over</span>
                    </div>
                    <div class="card-footer">
                        <a class="badge link-primary badge-success" style="font-size: 1.5rem" href="https://inboxed.online">View</a>
                    </div>
                </div>
                <%} %>
                <div class="w-100 bg-dark p-2 text-white rounded">
                        <span class="fw-bolder">Copyright 2023.</span><br />
                        <span class="fw-bold">Inboxd Co.</span><br />
                    <div class="w-50 mx-auto text-center text-white m-2">
                        <svg class="mx-2" style="height: 30px; fill: white !important" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 512 512"><path d="M459.37 151.716c.325 4.548.325 9.097.325 13.645 0 138.72-105.583 298.558-298.558 298.558-59.452 0-114.68-17.219-161.137-47.106 8.447.974 16.568 1.299 25.34 1.299 49.055 0 94.213-16.568 130.274-44.832-46.132-.975-84.792-31.188-98.112-72.772 6.498.974 12.995 1.624 19.818 1.624 9.421 0 18.843-1.3 27.614-3.573-48.081-9.747-84.143-51.98-84.143-102.985v-1.299c13.969 7.797 30.214 12.67 47.431 13.319-28.264-18.843-46.781-51.005-46.781-87.391 0-19.492 5.197-37.36 14.294-52.954 51.655 63.675 129.3 105.258 216.365 109.807-1.624-7.797-2.599-15.918-2.599-24.04 0-57.828 46.782-104.934 104.934-104.934 30.213 0 57.502 12.67 76.67 33.137 23.715-4.548 46.456-13.32 66.599-25.34-7.798 24.366-24.366 44.833-46.132 57.827 21.117-2.273 41.584-8.122 60.426-16.243-14.292 20.791-32.161 39.308-52.628 54.253z"/></svg>
                        <svg class="mx-2" style="height: 30px; fill: white !important" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 384 512"><path d="M290.7 311L95 269.7 86.8 309l195.7 41zm51-87L188.2 95.7l-25.5 30.8 153.5 128.3zm-31.2 39.7L129.2 179l-16.7 36.5L293.7 300zM262 32l-32 24 119.3 160.3 32-24zm20.5 328h-200v39.7h200zm39.7 80H42.7V320h-40v160h359.5V320h-40z"/></svg>
                        <svg class="mx-2" style="height: 30px; fill: white !important" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 576 512"><path d="M549.655 124.083c-6.281-23.65-24.787-42.276-48.284-48.597C458.781 64 288 64 288 64S117.22 64 74.629 75.486c-23.497 6.322-42.003 24.947-48.284 48.597-11.412 42.867-11.412 132.305-11.412 132.305s0 89.438 11.412 132.305c6.281 23.65 24.787 41.5 48.284 47.821C117.22 448 288 448 288 448s170.78 0 213.371-11.486c23.497-6.321 42.003-24.171 48.284-47.821 11.412-42.867 11.412-132.305 11.412-132.305s0-89.438-11.412-132.305zm-317.51 213.508V175.185l142.739 81.205-142.739 81.201z"/></svg>
                    </div>
                        <span class="text-decoration-none" style="color: inherit !important"><a  style="color: inherit !important" href="Terms.aspx">Terms of Use</a> | <a  style="color: inherit !important" href="PrivacyPolicy.aspx">Privacy Policy</a></span>
                        
                        

                    </div>
            </div>

        </div>
    </form>
</body>
</html>
