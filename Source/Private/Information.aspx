<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Information.aspx.cs" Inherits="Inboxd.Source.Private.Information" %>

<!DOCTYPE html>
<style>
    .circle {
        display: inline-block;
        margin: 10px;
        border-radius: 50%;
    }

    .circle-inner {
        color: white;
        display: table-cell;
        vertical-align: middle;
        text-align: center;
        text-decoration: none;
        height: 100px;
        width: 100px;
        font-size: 30px;
    }
</style>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>User | Inboxd</title>
    <link href="Style/Inbox.css" rel="stylesheet" />
    <link href="Style/Header.css" rel="stylesheet" />
    <link href="Style/Default.css" rel="stylesheet" />
    <link href="Style/Information.css" rel="stylesheet" />
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
    <link rel="mask-icon" href="/safari-pinned-tab.svg" color="#5bbad5"/>
    <meta name="msapplication-TileColor" content="#da532c" />
    <meta name="viewport" content="width=device-width, initial-scale=1"/>
    <meta name="theme-color" content="#ffffff" />
    <script async src="https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js?client=ca-pub-8388667342418832"
     crossorigin="anonymous"></script>
</head>
<body>
    <!-- #include file='Header.html' -->
    <form id="form1" runat="server">
        <div>
            <%
                Inboxd.Source.Private.User user = Inboxd.Source.Private.Information.SingleUser;
                if (HttpContext.Current.Session["ViewAccountID"] != null && user != null)
                {%>
            <div class="p-4 w-75 mx-auto" id="container">
                <asp:Label runat="server" Text="" id="lblMessages"></asp:Label>
                <div class="d-inline" id="viewHeading">
                    <asp:Button runat="server" id="btnReturnBack" OnClick="btnReturnBack_Click" style="display: none"/>
                    <span class="display-4" id="headingView"><span title="Go Back" onclick="document.getElementById('btnReturnBack').click()"><i class="fa-solid fa-chevron-left"></i></span> Account Information</span>
                </div>
                <hr />
                <div class="card w-50 mx-auto text-center" id="cardView" style="<%=(user.isUserFavourite(int.Parse(HttpContext.Current.Session["ViewAccountID"].ToString())))?"background-color: #ffe0e0 !important; border: 1px solid rgb(82 30 30 / 13%) !important":""%>"/>
                    <div class="card-header">
                        <h2 class="title d-inline">Inboxd User<%=user.isUserFavourite(int.Parse(HttpContext.Current.Session["ViewAccountID"].ToString())) ? "<span class='badge badge-danger m-2' style='font-size: 1rem; vertical-align:middle'>[fav]</span>" : "" %></h2>
                    </div>
                    <div class="card-body" style="background-color:#fff">
                        <div class="text-center">
                            <%if (!user.UserHasProfileImage(int.Parse(HttpContext.Current.Session["ViewAccountID"].ToString()))) { %>
                            <div class="circle" style="background-color:<%=Inboxd.Source.Private.Additional.StringToHexColor(user.FullNameDisplay(user.UserID))%>">
                                <%  string initials = "";
                                    Inboxd.Source.Private.User.GetFullName(user.UserID).Split(' ').ToList().ForEach(i => initials += i[0].ToString());
                             %>
                                <p class="circle-inner"><%=initials %></p>
                            </div>
                            <%} else {
                                string link = user.GetProfileImageLink(int.Parse(HttpContext.Current.Session["ViewAccountID"].ToString()));
                            %> 
                            <div class=" text-center d-inline" style="align-content:center;width:300px; margin:0px !important; padding: 0px !important;">
                                <img class="" style="box-shadow: rgba(17, 12, 46, 0.15) 0px 48px 100px 0px; width: 100px; border-radius: 50%" alt="Profile Image" src="../Public/User/<%=HttpContext.Current.Session["ViewAccountID"].ToString()%>/<%=HttpContext.Current.Session["ViewAccountID"].ToString()%>.jpg"/>
                            </div>
                            <%} %>
                        </div>
                        <br />
                        <span class="h5"><b>Name:</b> <%=Inboxd.Source.Private.User.GetFullName(user.UserID)%></span><br /><br />
                        <span class="h5"><b>Date of birth:</b> <%=(user.DOB.ToString("dd, dddd MMMM yyyy"))%></span><br /><br />
                        <span class="h5"><b>Email address:</b> <%=user.Email %></span><br /><br />
                         
                        <%
                            if (1 == 2) { //currently disabled, too lazy to comment out the lines %>        
                        <div class="w-50 mx-auto">
                            <label class="form-label" for="ProfileImageUpload">Profile Image Upload</label>
                            <asp:FileUpload ToolTip="Upload image" class="form-control form-input"  ID="ProfileImageUpload" runat="server" accept="image/*" />
                            <asp:Button runat="server" ID="btnUploadProfile" class="btn btn-primary w-100 m-1" Text="Save" OnClick="btnUploadProfile_Click"/>
                        </div>
                        <%} %>
                    </div>

                    <div class="card-footer display-3 text-white">
                        <a title="Not implemented, lol" class="btn bg-success"><i class="fa-solid fa-phone"></i></a>
                        <a title="Not implemented, lol" class="btn bg-primary"><i class="fa-solid fa-video"></i></a>

                        <%if (!user.isUserFavourite(int.Parse(HttpContext.Current.Session["ViewAccountID"].ToString())))
                            {
%>
                        <asp:Button runat="server" id="btnAddFavourite" OnClick="btnAddFavourite_Click" style="display:none"/>
                        <a title="Add as favourite" class="btn bg-info" onclick="document.getElementById('btnAddFavourite').click()"><i class="fa-solid fa-heart"></i></a>
                        <%}
                            else
                            { %>
                            <asp:Button runat="server" ID="btnRemoveFavourite" OnClick="btnRemoveFavourite_Click" style="display: none"/>
                            <a title="Remove as favourite" class="btn btn-warning" onclick="document.getElementById('btnRemoveFavourite').click()"><i class="fa-solid fa-heart-circle-minus"></i></a>
                        <%} %>

                        <asp:Button runat="server" id="btnContact" style="display: none" OnClick="btnContact_Click" />
                        <a title="Send Email" class="btn bg-info" onclick="document.getElementById('btnContact').click()"><i class="fa fa-envelope"></i></a>

                        <asp:Button class="btn text-white" runat="server" ID="btnBlock" Text="Block" OnClick="btnBlock_Click" Style="display: none" />
                        <div title="Block user" class="btn btn-danger" onclick="document.getElementById('btnBlock').click()"><i class="fa fa-ban"></i></div>
                    </div>
                </div>
            </div>
            <%}
                else
                { %>
            <div class="p-3">
                <h3>Hmm, something went wrong...</h3>
                <a href="Inbox.aspx" class="btn btn-primary">Go Back</a>
            </div>
            <%} %>
        </div>
    </form>
</body>
</html>
