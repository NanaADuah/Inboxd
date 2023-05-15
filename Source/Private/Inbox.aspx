<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Inbox.aspx.cs" Inherits="Inboxd.Source.Private.Inbox" UICulture="Auto" EnableSessionState="True" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <style>
        .lock:hover .icon-unlock,
        .lock .icon-lock {
            display: none;
        }

        .lock:hover .icon-lock {
            display: inline;
        }

        * {
            transition: 0.1s ease-in-out !important;
        }

        .recent-link {
            position: relative;
            color: #252525;
            padding-bottom: 18px;
            font-size: 1rem;
        }

        .hovercard {
            position: absolute;
            opacity: 0;
            z-index: 1;
            left: 50%;
            top: -90px;
            transform: translateX(-50%);
        }

        .recent-link:hover .hovercard {
            opacity: 1;
            transition: 0.5s;
            transition-delay: 0.1s;
        }

        .tooltiptext {
            display: flex;
            flex-direction: column;
            justify-content: flex-start;
            padding: 10px;
            border-radius: 5px;
            color: white;
            transition: 1s;
            width: auto;
        }

        .circle {
            display: inline-block;
            /*background-color: #00d53b;*/
            margin: 10px;
            border-radius: 50%;
        }

        .circle-inner {
            color: white;
            display: table-cell;
            vertical-align: middle;
            text-align: center;
            text-decoration: none;
            height: 50px;
            width: 50px;
            font-size: 20px;
        }
    </style>
    <title>Home | Inboxd</title>
    <link href="Style/Inbox.css" rel="stylesheet" />
    <link href="Style/Header.css" rel="stylesheet" />
    <link href="Style/Default.css" rel="stylesheet" />
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js" integrity="sha384-ApNbgh9B+Y1QKtv3Rn7W3mgPxhU9K/ScQsAP7hUibX39j7fakFPskvXusvfa0b4Q" crossorigin="anonymous"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js" integrity="sha384-JZR6Spejh4U02d8jOt6vLEHfe/JQGiRRSQQxSfFWpi1MquVdAyjUar5+76PVCmYl" crossorigin="anonymous"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.4.1/dist/css/bootstrap.min.css" integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous" />
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@3.3.7/dist/js/bootstrap.min.js" integrity="sha384-Tc5IQib027qvyjSMfHjOMaLkfuWVxZxUPnCJA7l2mCWNIpG9mGCD8wGNIcPD7Txa" crossorigin="anonymous"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
    <script src="https://code.jquery.com/jquery-3.1.1.min.js" integrity="sha256-hVVnYaiADRTO2PzUGmuLJr8BLUSjGIZsDYGmIJLv2b8=" crossorigin="anonymous"></script>
    <link rel="apple-touch-icon" sizes="180x180" href="/apple-touch-icon.png" />
    <link rel="icon" type="image/png" sizes="32x32" href="/favicon-32x32.png" />
    <link rel="icon" type="image/png" sizes="16x16" href="/favicon-16x16.png" />
    <link rel="manifest" href="/site.webmanifest" />
    <link rel="mask-icon" href="/safari-pinned-tab.svg" color="#5bbad5" />
    <meta name="msapplication-TileColor" content="#da532c" />
    <meta name="theme-color" content="#ffffff" />
    <script async src="https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js?client=ca-pub-8388667342418832"
        crossorigin="anonymous"></script>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
</head>

<body>


    <!-- #include file='Header.html' -->
    <form id="form1" runat="server" class="h-100">
        <asp:ScriptManager ID="ScriptManager1" EnablePageMethods="true" EnablePartialRendering="true" runat="server" />
        <script type="text/javascript">
            function emailView(id) {
                window.location = "EmailView.aspx?id=" + id;
            }
        </script>
        <div class="px-2">
            <asp:Label runat="server" ID="lblMessages" Text=""></asp:Label>
        </div>
        <%if (!string.IsNullOrEmpty(Session["UserID"].ToString()))
            {
                Inboxd.Source.Private.User user = new Inboxd.Source.Private.User();
        %>
        <div class="p-4 h-100" id="mainView">
            <div>
                <div class="d-flex justify-content-space-between mb-1" >
                    <div class="flex-grow-1 flex-fill d-inline-flex" style="vertical-align: middle" id="welcomeMessage">
                        <h3 class="m-0">Welcome <%=loggedInUser != null ? loggedInUser.Name : "user"%>: </h3>

                    </div>
                    <div id="buttonView">
                        <div class="d-inline-flex" style="gap: 10px" id="filterView">
                            <div class="input-group rounded flex-fill " style="margin-right: 5px">
                                <asp:Button runat="server" ID="btnSearch" class="btn btn-primary" Text="Search" Style="display: none" OnClick="btnSearch_Click" />
                                <input type="search" id="tbSearch" runat="server" class="form-control rounded" placeholder="Search" />
                                <div class="input-group-text border-0" id="search-addon" onclick="document.getElementById('btnSearch').click()">
                                    <i class="fa-solid fa-search"></i>
                                </div>
                            </div>
                                <asp:Button runat="server" class="btn btn-primary btn-sm" ID="btnDefault" Text="Default" OnClick="btnDefault_Click" Style="display: none"></asp:Button>
                                <div class="btn btn-dark" title="Sort by default" onclick="document.getElementById('btnDefault').click()"><i class="fa-solid fa-filter"></i></div>

                                <asp:Button runat="server" class="btn btn-primary btn-sm" ID="btnSender" Text="Sender" OnClick="btnSender_Click" Style="display: none"></asp:Button>
                                <div class="btn btn-dark" title="Sort by sender" onclick="document.getElementById('btnSender').click()"><i class="fa-solid fa-arrow-down-a-z"></i></div>

                                <asp:Button runat="server" class="btn btn-primary btn-sm" ID="btnUnread" Text="Unread" OnClick="btnUnread_Click" Style="display: none"></asp:Button>
                                <div class="btn btn-dark" title="Filter unread emails" onclick="document.getElementById('btnUnread').click()"><span class="badge">UNREAD</span></div>
                        </div>
                    </div>
                </div>
            </div>
            <%
                string currentView = "default";
                if (Session["filter"] != null)
                    currentView = Session["filter"].ToString();
            %>
            <div class="align-content-center h-75 " id="defaultView">
                <div class="d-flex justify-content-between" id="viewClick">
                    <div class="px-3" style="width: 20%;" id="listView" >

                        <ul class="list-group list-group-horizontal text-center" id="horiList" style="display: none">
                            <%--<li class="list-group-item"><asp:Button CssClass="btn btn-primary float-end" runat="server" ID="btnNewMail" Text="Send a new mail" OnClick="btnNewMail_Click" /></li>--%>
                            <li onclick="window.location = 'NewMail.aspx'" class="list-group-item bg-primary"><a class="text-white text-decoration-none" href="NewMail.aspx"><i class="fa-solid fa-square-plus"></i> Compose</a></li>
                            <li onclick="window.location = 'FilterPage.aspx?filter=default'" class="list-group-item d-flex justify-content-between align-items-center" style="<%=currentView.ToLower().Equals("default") || currentView.ToLower().Equals("recent") || currentView.ToLower().Equals("sender") || currentView.ToLower().Equals("unread") ? "background-color: #d0d0d0": "" %>"><span><i class="fa fa-inbox justify-content-between"> <span class="badge badge-primary badge-pill" style="text-align: right; float: right"><%=loggedInUser.GetEmailsCount()%></span></i><a style="color: inherit !important" href="FilterPage.aspx?filter=recent" class="text-decoration-none"> Inbox</span></a></li>
                            <li onclick="window.location = 'FilterPage.aspx?filter=starred'" class="list-group-item" style="<%=currentView.ToLower().Equals("starred")  ? "background-color: #d0d0d0": "" %>"><i class="fa fa-star"></i> Starred</li>
                            <li onclick="window.location = 'FilterPage.aspx?filter=notifications'" class="list-group-item" style="<%=currentView.ToLower().Equals("notifications")  ? "background-color: #d0d0d0": "" %>"><span style="vertical-align: middle"><i class="fa-solid fa-bell-concierge"><%if (Inboxd.Source.Private.Notifications.GetNumNotifications() != 0){ %><i class="fa-solid fa-circle fa-2xs text-danger small" style="text-align: right; float: right"></i><%} %></i> Notifcations</span></li>
                            <li onclick="window.location = 'FilterPage.aspx?filter=spam'" class="list-group-item" style="<%=currentView.ToLower().Equals("spam")     ? "background-color: #d0d0d0": "" %>"><i class="fa fa-exclamation-circle"></i> Spam</li>
                            <li onclick="window.location = 'FilterPage.aspx?filter=draft'" class="list-group-item d-flex justify-content-between align-items-center" style="<%=currentView.ToLower().Equals("draft")    ? "background-color: #d0d0d0": "" %>"><span><i class="fa fa-file"><span class="badge badge-primary badge-pill" style="text-align: right; float: right"><%=loggedInUser.GetDraftCount()%></span></i> Draft</span></li>
                            <li onclick="window.location = 'FilterPage.aspx?filter=sent'" class="list-group-item" style="<%=currentView.ToLower().Equals("sent")     ? "background-color: #d0d0d0": "" %>"><i class="fa fa-paper-plane"></i> Sent</li>
                            <li onclick="window.location = 'FilterPage.aspx?filter=favourites'" class="list-group-item" style="<%=currentView.ToLower().Equals("favourites")     ? "background-color: #d0d0d0": "" %>"><i class="fa-solid fa-bookmark"></i> Favourites</li>
                            <li title="Not implemented yet" class="list-group-item" style="<%=currentView.ToLower().Equals("snoozed")  ? "background-color: #d0d0d0": "" %>"><i class="fa-solid fa-bell-slash"></i> Snoozed</li>
                            <li onclick="window.location = 'FilterPage.aspx?filter=settings'" class="list-group-item" style="<%=currentView.ToLower().Equals("settings") ? "background-color: #d0d0d0": "" %>"><i class="fa fa-cog"></i> Settings</li>
                            <li onclick="window.location = 'FilterPage.aspx?filter=trash'" class="list-group-item" style="<%=currentView.ToLower().Equals("trash") ? "background-color: #d0d0d0": "" %>"><i class="fa fa-trash"></i> Trash</li>
                        </ul>
                        <ul class="list-group " id="normalList" >
                            <%--<li class="list-group-item"><asp:Button CssClass="btn btn-primary float-end" runat="server" ID="btnNewMail" Text="Send a new mail" OnClick="btnNewMail_Click" /></li>--%>
                            <li onclick="window.location = 'NewMail.aspx'" class="list-group-item bg-primary"><a class="text-white text-decoration-none" href="NewMail.aspx"><i class="fa-solid fa-square-plus"></i> Compose</a></li>
                            <li onclick="window.location = 'FilterPage.aspx?filter=default'" class="list-group-item d-flex justify-content-between align-items-center" style="<%=currentView.ToLower().Equals("default") || currentView.ToLower().Equals("recent") || currentView.ToLower().Equals("sender") || currentView.ToLower().Equals("unread") ? "background-color: #d0d0d0": "" %>"><span><i class="fa fa-inbox justify-content-between"></i><a style="color: inherit !important" href="FilterPage.aspx?filter=recent" class="text-decoration-none"> Inbox</span></a> <span class="badge badge-primary badge-pill" style="text-align: right; float: right"><%=loggedInUser.GetEmailsCount()%></span></li>
                            <li onclick="window.location = 'FilterPage.aspx?filter=starred'" class="list-group-item" style="<%=currentView.ToLower().Equals("starred")  ? "background-color: #d0d0d0": "" %>"><i class="fa fa-star"></i> Starred</li>
                            <li onclick="window.location = 'FilterPage.aspx?filter=notifications'" class="list-group-item" style="<%=currentView.ToLower().Equals("notifications")  ? "background-color: #d0d0d0": "" %>"><span style="vertical-align: middle"><i class="fa-solid fa-bell-concierge"></i> Notifcations <%if (Inboxd.Source.Private.Notifications.GetNumNotifications() != 0)
                            { %><i class="fa-solid fa-circle fa-2xs text-danger small" style="text-align: right; float: right"></i><%} %></span></li>
                            <li onclick="window.location = 'FilterPage.aspx?filter=spam'" class="list-group-item" style="<%=currentView.ToLower().Equals("spam")     ? "background-color: #d0d0d0": "" %>"><i class="fa fa-exclamation-circle"></i> Spam</li>
                            <li onclick="window.location = 'FilterPage.aspx?filter=draft'" class="list-group-item d-flex justify-content-between align-items-center" style="<%=currentView.ToLower().Equals("draft")    ? "background-color: #d0d0d0": "" %>"><span><i class="fa fa-file"></i> Draft</span><span class="badge badge-primary badge-pill" style="text-align: right; float: right"><%=loggedInUser.GetDraftCount()%></span></li>
                            <li onclick="window.location = 'FilterPage.aspx?filter=sent'" class="list-group-item" style="<%=currentView.ToLower().Equals("sent")     ? "background-color: #d0d0d0": "" %>"><i class="fa fa-paper-plane"></i> Sent</li>
                            <li onclick="window.location = 'FilterPage.aspx?filter=favourites'" class="list-group-item" style="<%=currentView.ToLower().Equals("favourites")     ? "background-color: #d0d0d0": "" %>"><i class="fa-solid fa-bookmark"></i> Favourites</li>
                            <li title="Not implemented yet" class="list-group-item" style="<%=currentView.ToLower().Equals("snoozed")  ? "background-color: #d0d0d0": "" %>"><i class="fa-solid fa-bell-slash"></i> Snoozed</li>
                            <li onclick="window.location = 'FilterPage.aspx?filter=settings'" class="list-group-item" style="<%=currentView.ToLower().Equals("settings") ? "background-color: #d0d0d0": "" %>"><i class="fa fa-cog"></i> Settings</li>
                            <li onclick="window.location = 'FilterPage.aspx?filter=trash'" class="list-group-item" style="<%=currentView.ToLower().Equals("trash") ? "background-color: #d0d0d0": "" %>"><i class="fa fa-trash"></i> Trash</li>
                        </ul>
                    </div>
                    <div class="flex-fill overflow-auto" style="max-height: 800px">
                        <%if (currentView.Equals("settings"))
                            {
                        %>
                        <div class="p-4 m-auto overflow-auto">
                            <span class="display-4 w-50" >Settings Page</span>
                            <hr />
                            <br />
                            <nav class="nav nav-pills flex-column flex-sm-row w-50 mx-auto mb-3" id="settingHeaderNav">
                                <%
                                    string value = "";
                                    if (Request.QueryString["settings"] != null)
                                    {
                                        value = Request.QueryString["settings"];
                                    }
                                %>
                                <a class="flex-sm-fill text-sm-center nav-link <%=value == "temp" || value == "" ? "active" : "" %>" aria-current="page" href="Inbox.aspx?settings=temp">GitHub</a>
                                <a class="flex-sm-fill text-sm-center nav-link <%=value == "profile" ? "active" : "" %>" href="Inbox.aspx?settings=profile">Profile</a>
                                <a class="flex-sm-fill text-sm-center nav-link <%=value == "sync" ? "active" : "" %>" href="Inbox.aspx?settings=sync">Sync</a>
                                <a class="flex-sm-fill text-sm-center nav-link <%=value == "advanced" ? "active" : "" %>" href="Inbox.aspx?settings=advanced">Advanced</a>

                            </nav>
                            <%if (value == "temp" || value == "")
                                {%>

                            <div class="text-center">
                                Yeah... still under construction<br />
                                <span>In the meantime, jump over to the GitHub Repo and assist if you can :)</span><br />
                                <br />
                                <div class="card w-50 mx-auto">
                                    <div class="card-header p-2">GitHub</div>
                                    <div class="card-body text-center">
                                        <img src="../Public/Images/SingleLogo.svg" style="height: 50px" /><br />
                                        <br />
                                        <h4 class="fw-bold">https://github.com/NanaADuah/Inboxd
                                            
                                        </h4>
                                    </div>
                                    <div class="card-footer">
                                        <h2>
                                            <a href="https://github.com/NanaADuah/Inboxd" target="_blank" class="badge link-primary badge-secondary">View</a>
                                        </h2>
                                    </div>
                                </div>
                            </div>
                            <%}
                                else
                                if (value == "sync")
                                {
                            %>
                            <div class="card w-50 m-auto m-2 mt-3 overflow-auto" id="syncView">
                                <div class="card-header">
                                    <span class="h4">Sync Settings</span>
                                </div>
                                <div class="m-4 card-body">
                                    <div>
                                        <span>Email sync schedule</span>
                                        <span class="text-muted float-end" style="float: right; color: #ff6a00 !important">Automatically</span>
                                    </div>
                                    <hr />
                                    <div>
                                        <span>Email folders to sync</span>
                                        <span class="text-muted float-end" style="float: right; color: #ff6a00 !important">Default</span>
                                    </div>
                                    <hr />
                                    <div>
                                        <span>Email sync period</span>
                                        <span class="text-muted float-end" style="float: right; color: #ff6a00 !important">2 weeks</span>
                                    </div>
                                    <hr />
                                    <div>
                                        <span>Limit retrieval size</span>
                                        <span class="text-muted float-end" style="float: right; color: #ff6a00 !important">No limit</span>
                                    </div>
                                    <hr />
                                    <div>
                                        <span>Limit retrieval size while roaming</span>
                                        <span class="text-muted float-end" style="float: right; color: #ff6a00 !important">2KB</span>
                                    </div>
                                </div>
                            </div>
                            <%
                                }
                                else
                                if (value == "advanced")
                                {%>
                            <div class="card w-50 m-auto m-2 mt-3" id="advancedView">
                                <div class="card-header">
                                    <span>Server Settings</span>
                                </div>
                                <div class="card-body">
                                    <span class="fw-bold"><b>Incoming Server</b></span>
                                    <div class="m-2">
                                        <div>
                                            <span>IMAP server</span>
                                            <span class="text-muted float-end" style="float: right; color: #ff6a00 !important">imap.inboxd.online</span>
                                        </div>
                                        <hr />
                                        <div>
                                            <span>Security type</span>
                                            <span class="text-muted float-end" style="float: right; color: #ff6a00 !important">SSL</span>
                                        </div>
                                        <hr />
                                        <div>
                                            <span>Port</span>
                                            <span class="text-muted float-end" style="float: right; color: #ff6a00 !important">993</span>
                                        </div>
                                        <hr />
                                        <div>
                                            <span>IMAP path prefix</span>
                                            <span class="text-muted float-end" style="float: right; color: #ff6a00 !important">Optional.</span>
                                        </div>
                                    </div>
                                    <hr />
                                    <span class="fw-bold"><b>Outgoing Server</b></span><br />
                                    <div class="m-2">
                                        <div>
                                            <span>SMTP server</span>
                                            <span class="text-muted float-end" style="float: right; color: #ff6a00 !important">smtp.inboxd.online</span>
                                        </div>
                                        <div>
                                            <span>Security type</span>
                                            <span class="text-muted float-end" style="float: right; color: #ff6a00 !important">SSL</span>
                                        </div>
                                        <hr />
                                        <div>
                                            <span>Port</span>
                                            <span class="text-muted float-end" style="float: right; color: #ff6a00 !important">465</span>
                                        </div>
                                        <hr />
                                        <div>
                                            <span>Require authentication to send emails</span>
                                            <div class="float-end custom-control custom-switch" style="float: right; color: #ff6a00">
                                                <input type="checkbox" checked class="custom-control-input" id="customSwitches" style="color: #ff6a00" />
                                                <label class="custom-control-label" for="customSwitches" style="color: #ff6a00"></label>
                                            </div>
                                            <div class="my-1">
                                                <%string email = user.getUserEmail(int.Parse(Session["UserID"].ToString()));%>
                                                <input class="input-group-text mx-auto w-100" readonly value="<%=email%>" style="outline: none; box-sizing: border-box; border: none; border-bottom: 2px solid black" />
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <%
                                }
                                else
                                if (value == "profile")
                                {
                                    Inboxd.Source.Private.User views = new Inboxd.Source.Private.User();
                                    views = Inboxd.Source.Private.User.GetUserInfo(int.Parse(Session["UserID"].ToString()));
                            %>
                            <div class="card w-50 m-auto m-2 mt-3" id="profileView">
                                <div class="card-header text-center">
                                    <span class="display-5"><b>Profile</b></span>
                                </div>
                                <div class="card-body overflow-auto" style="max-height: 400px">
                                    <div class="input-group mb-3">
                                        <span class="input-group-text">Name</span>
                                        <input type="text" class="form-control" disabled="disabled" value="<%=views.Name%>" />
                                    </div>
                                    <div class="input-group mb-3">
                                        <span class="input-group-text">Surname</span>
                                        <input type="text" class="form-control" disabled="disabled" value="<%=views.Surname%>" />
                                    </div>
                                    <div class="input-group mb-3">
                                        <span class="input-group-text">Email</span>
                                        <input type="text" class="form-control" disabled="disabled" value="<%=views.Email%>" />
                                    </div>
                                    <hr />
                                    <div class="mx-2">
                                        <span>Profile Image:</span>
                                        <div class="d-flex" style="vertical-align: middle">
                                            <%if (!user.UserHasProfileImage(int.Parse(Session["UserID"].ToString())))
                                                { %>
                                            <div class="d-inline flex-fill">
                                                <div class="circle " style="background-color: <%=Inboxd.Source.Private.Additional.StringToHexColor(user.FullNameDisplay(user.UserID))%>">
                                                    <%  string initials = "";
                                                         Inboxd.Source.Private.User.GetFullName(int.Parse(Session["UserID"].ToString())).Split(' ').ToList().ForEach(i => initials += i[0].ToString());
                                                    %>
                                                    <p class="circle-inner"><%=initials %></p>
                                                </div>
                                            </div>
                                            <%}
                                                else
                                                {
                                                    string link = user.GetProfileImageLink(int.Parse(Session["UserID"].ToString()));
                                            %>
                                            <div class="d-inline flex-fill" style="margin: 0px !important; padding: 0px !important;">
                                                <img class="" style="box-shadow: rgba(17, 12, 46, 0.15) 0px 48px 100px 0px; width: 50px; border-radius: 50%" alt="Profile Image" src="../Public/User/<%=Session["UserID"].ToString()%>/<%=Session["UserID"].ToString()%>.jpg" />
                                            </div>
                                            <%} %>
                                            <div style="vertical-align: middle">
                                                <span class="badge-primary badge" style="cursor: pointer; vertical-align: middle" onclick="document.getElementById('ProfileImageUpload').click()">Change</span>
                                                <asp:FileUpload ID="ProfileImageUpload" runat="server" onchange="document.getElementById('uploadImage').click()" Style="display: none" />
                                                <asp:Button runat="server" ID="uploadImage" OnClick="uploadImage_Click" Style="display: none" class="btn btn-primary" />
                                            </div>
                                        </div>
                                    </div>
                                    <hr />
                                    <div>
                                        <span>Additional Information</span>
                                        <div class="input-group mb-3">
                                            <span class="input-group-text">Company</span>
                                            <input type="text" class="form-control" disabled="disabled" value="null" />
                                        </div>
                                        <div class="input-group mb-3">
                                            <span class="input-group-text">Job Title</span>
                                            <input type="text" class="form-control" disabled="disabled" value="null" />
                                        </div>                                        
                                        <div class="input-group mb-3">
                                            <span class="input-group-text">Department</span>
                                            <input type="text" class="form-control" disabled="disabled" value="null" />
                                        </div>
                                    </div>
                                </div>
                                 <div class="card-footer d-flex text-center justify-content-between" style="align-items: center">
                                        <div class="btn btn-dark w-50 mx-auto">Edit Details <span class="badge bg-danger">Don't click this</span></div>
                                    </div>
                            </div>

                        </div>
                        <% }
                        %>
                    </div>
                    <%}
                        else
                            if (currentView.Equals("notifications"))
                        {%>
                    <div class="p-4 table-responsive" style="font-weight: normal !important">
                        <%if (notifications.Any())
                            {%>
                        <table class="table table-hover table-sm">
                            <thead class="thead-light position-sticky">
                                <tr>
                                    <th scope="col"></th>
                                    <th scope="col"></th>
                                    <th scope="col"></th>
                                    <th scope="col"></th>
                                </tr>
                            </thead>
                            <tbody style="font-weight: normal !important">
                                <%foreach (var item in notifications)
                                    {%>
                                <tr title="Sent: <%=item.NotificationTime.ToString("dd\\/MM\\/yyyy HH:mm")%>">
                                    <th scope="row" class="text-center"><i class="fa-solid fa-bell"></i></th>
                                    <th style="font-weight: normal !important"><%=Inboxd.Source.Private.Additional.TruncateSubject(item.Notification)%></th>
                                    <th class="text-end d-flex justify-content-end" style="margin-right: 5px;"><%=Inboxd.Source.Private.Time.TimeAgo(item.NotificationTime) %></th>
                                    <asp:Button runat="server" class="btn" ID="btnDeleteNotification" Style="display: none" OnClick="btnDeleteNotification_Click" />
                                    <th title="Remove notification" class="text-end justify-content-end d-table-cell" style="text-align: center; width: 5%"><a href="Read.aspx?id=<%=item.NotificationID%>" class="text-decoration-none" style="color: inherit !important"><i onclick="document.getElementById('btnDeleteNotification').click()" class="fa-solid fa-xmark"></i></a></th>
                                </tr>
                                <%}%>
                            </tbody>
                        </table>
                        <%}
                            else
                            { %>
                        <div class="display-4 text-center p-4">
                            <hr />
                            No new notifications<br />
                            <i class="fa-solid fa-bell fa-shake"></i>
                        </div>
                        <%} %>
                    </div>
                    <%}
                        else
                                if (currentView.Equals("favourites"))
                        {%>
                    <%if (favouriteUsers.Any())
                        {
                    %>
                    <div class="p-4">
                        <table class="table table-hover table-sm">
                            <thead class="thead-light">
                                <tr>
                                    <th></th>
                                    <th></th>
                                    <th></th>
                                </tr>
                            </thead>
                            <tbody>
                                <%foreach (var item in favouriteUsers)
                                    { %>
                                <tr>
                                    <td><i class="fa-solid fa-heart"></i></td>
                                    <td><%=String.Format("{0:S} {1:S}", item.Name, item.Surname) %></td>
                                    <td><%=item.Email %></td>
                                </tr>
                            </tbody>
                            <%} %>
                        </table>
                    </div>
                    <%}
                        else
                        { %>
                    <div class="display-4 text-center p-4">
                        <hr />
                        You don't have any favourites<br />
                        <i class="fa-solid fa-heart fa-beat-fade"></i>
                    </div>
                    <%}
                        }
                        else
              if (currentView.Equals("draft"))
                        {%>
                    <table class="table table-hover table-sm">
                        <thead class="thead-light">
                            <tr>
                                <th></th>
                                <th></th>
                                <th></th>
                            </tr>
                        </thead>
                        <tbody>
                            <% int count = 0;
                                foreach (var item in emails)
                                {
                                    count++;%>
                            <tr>
                                <td><%=count%></td>
                                <td><b><%=item.EmailSubject%></b> - <%=Inboxd.Source.Private.Additional.Truncate(item.EmailBody, 50)%></td>
                                <td class="float-end" style="text-align: right; margin-right: 10px"><a class="btn btn-danger badge" href="NewMail.aspx?edit=<%=item.EmailID%>"><i class="fa fa-edit"></i></a></td>
                            </tr>
                            <%} %>
                        </tbody>
                    </table>
                    <%
                        }
                        else
                            if (emails.Count() != 0)
                        {%>
                    <table class="table table-hover table-sm">
                        <thead class="thead-light" style="position: sticky; top: 0">
                            <tr>
                                <th scope="col"></th>
                                <th scope="col"></th>
                                <th scope="col"></th>
                                <th id="additionalHeader" scope="col"></th>
                                <th id="additionalHeader" scope="col"></th>
                            </tr>
                        </thead>
                        <tbody>
                            <%foreach (var item in emails)
                                {
                                    string tempTime = Inboxd.Source.Private.Time.TimeAgo(item.EmailDate);
                            %>
                            <tr onclick="emailView('<%=item.EmailID%>')" <%if (item.EmailRead && currentView != "sent")
                                {  %>
                                class="text-muted" style="background: #f6f6f6"
                                <%} %>>


                                <%if (!currentView.Equals("sent"))
                                    {  %>
                                <td><a class="text-dark" href="EmailView.aspx?star=<%=item.EmailID%>"><i class="<%=item.EmailStarred ? "fa fa-star" : "fa-regular fa-star "%>"></i></a></td>
                                <%}
                                    else
                                    { %>
                                <td><i title="<%=item.EmailDate.ToString("dd\\/MM\\/yyyy HH:mm") %>" class="fa-solid fa-check-double"></i></td>
                                <%} %>
                                <td>
                                    <%if (!currentView.Equals("sent"))
                                        {  %>
                                    <span class="font-weight-bold"><%=Inboxd.Source.Private.User.GetFullName(item.EmailSender) %></span>
                                    <%}
                                        else
                                        {  %>
                                    <span class="font-weight-bold"><%=Inboxd.Source.Private.User.GetFullName(user.getUserID(item.ReceipientEmail)) %></span>
                                    <%} %>
                                    <!--
                                        <div class="recent-link">
                                            <span class="font-weight-bold"><%=Inboxd.Source.Private.User.GetFullName(item.EmailSender) %></span>
                                            <div class="hovercard">
                                                <div class="bg-dark tooltiptext card">
                                                    <span><%=Inboxd.Source.Private.User.GetFullName(item.EmailSender)%></span>
                                                    <span><%=user.getUserEmail(item.EmailSender)%></span>
                                                </div>
                                            </div>

                                        </div>
                                        -->
                                </td>
                                <td><span class="font-weight-bold"><%=item.EmailSubject %></span> - <span class="text-muted"><%=Inboxd.Source.Private.Additional.Truncate(item.EmailBody, 50)%></span> </td>
                                <td id="additionalHeader" class="float-end justify-content-end " style="text-align: right;"><%=tempTime%></td>
                                <%if (false/*!currentView.Equals("sent")*/)
                                    {  %>

                                <td class="align-content-center" style="width: 70px; text-align: center">
                                    <a href="#" class="lock text-decoration-none" style="color: inherit !important;">
                                        <i class="icon-unlock fa-regular fa-clock"></i>
                                        <i class="icon-lock fa-solid fa-clock"></i>
                                    </a>
                                </td>
                                <%} %>
                            </tr>
                            <%} %>
                        </tbody>
                    </table>
                    <%}
                        else
                        {
                    %>
                    <table class="table table-sm">
                        <thead class="thead-light">
                            <tr>
                                <th></th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <th class="text-center">
                                    <%if (currentView == "search")
                                    {  %>
                                    <div>
                                        Hmmm, <b>interesting search</b>, we couldn't find anything for it though.<br />
                                        Try something else?
                                            <br />
                                        <br />
                                        <div class="display-3">
                                            <i class="fa-solid fa-rotate-right fa-spin"></i>
                                        </div>
                                    </div>
                                    <%}
                                        else
                                        {  %>
                                    <div>
                                        There's nothing to display for now...
                                            <br />
                                        <img class="img-fluid m-2" style="height: 100px" src="../Public/Images/SingleLogo.svg" />
                                    </div>
                                    <%} %>
                                </th>
                            </tr>
                        </tbody>
                    </table>
                    <%} %>
                </div>
            </div>
        </div>
        <hr />
        </div>
        <%}
            else
            { %>

        <div class="card-body">
            Currently not logged in
        </div>
        <%} %>
    </form>

</body>
</html>

