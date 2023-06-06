<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="NewMail.aspx.cs" Inherits="Inboxd.Source.Private.NewMail" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>New Mail | Inboxd</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.4.1/dist/css/bootstrap.min.css" integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous" />
    <link rel="stylesheet" href="Style/NewMail.css" />
    <link href="Style/Default.css" rel="stylesheet"/>
    <link href="Style/Header.css" rel="stylesheet" />
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@3.3.7/dist/js/bootstrap.min.js" integrity="sha384-Tc5IQib027qvyjSMfHjOMaLkfuWVxZxUPnCJA7l2mCWNIpG9mGCD8wGNIcPD7Txa" crossorigin="anonymous"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.4.1/dist/css/bootstrap.min.css" integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous" />
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@3.3.7/dist/js/bootstrap.min.js" integrity="sha384-Tc5IQib027qvyjSMfHjOMaLkfuWVxZxUPnCJA7l2mCWNIpG9mGCD8wGNIcPD7Txa" crossorigin="anonymous"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
    <link rel="apple-touch-icon" sizes="180x180" href="/apple-touch-icon.png"/>
    <link rel="icon" type="image/png" sizes="32x32" href="/favicon-32x32.png"/>
    <link rel="icon" type="image/png" sizes="16x16" href="/favicon-16x16.png"/>
    <link rel="manifest" href="/site.webmanifest"/>
    <link rel="mask-icon" href="/safari-pinned-tab.svg" color="#5bbad5"/>
    <meta name="msapplication-TileColor" content="#da532c"/>
    <meta name="theme-color" content="#ffffff"/>
    <script src="../../Scripts/ckeditor/ckeditor.js"></script>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <script async src="https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js?client=ca-pub-8388667342418832"
     crossorigin="anonymous"></script>
    <script src="https://cdn.ckeditor.com/ckeditor5/37.1.0/classic/ckeditor.js"></script>
    <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js" type="text/javascript"></script>
    <script src="assets/plugins/custom/ckeditor/ckeditor-classic.bundle.js"></script>
    <script src="assets/plugins/custom/ckeditor/ckeditor-inline.bundle.js"></script>
    <script src="assets/plugins/custom/ckeditor/ckeditor-balloon.bundle.js"></script>
    <script src="assets/plugins/custom/ckeditor/ckeditor-balloon-block.bundle.js"></script>
    <script src="assets/plugins/custom/ckeditor/ckeditor-document.bundle.js"></script>
    </head>
<body>
    <!-- #include file='Header.html' -->
    <form id="form1" runat="server">
        <div class="card w-75 mx-auto mt-5" id="container">
            <div class="card-header">
                <a href="Inbox.aspx" class="text-decoration-none" style="color: inherit !important"><i class="fa fa-chevron-left"></i></a> New Message
            </div>
            <div class="rounded card-body">
                <asp:ValidationSummary ID="ValidationSummary1" style="text-align:left" runat="server" DisplayMode="List" ForeColor="Red" />
                <asp:Label runat="server" ID="lblMessages" Text="" class="m-1"></asp:Label><br />
                <div class="input-group mb-3">
                    
                        <div class="input-group-prepend">
                            <span class="input-group-text viewInput">Receipients <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ErrorMessage="Invalid Receipient Email address" ControlToValidate="tbToSender" ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*" Display="Dynamic" ForeColor="Red"> *</asp:RegularExpressionValidator><asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ErrorMessage="Email address required" ForeColor="Red" ControlToValidate="tbToSender"> * </asp:RequiredFieldValidator></span>
                        </div>
                        <input runat="server" type="email" id="tbToSender" class="form-control" />
                    </div>
                    <div class="input-group mb-3">
                        <div class="input-group-prepend">
                            <span class="input-group-text viewInput" id="">Subject <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ErrorMessage="Subject required" ControlToValidate="tbSubject" ForeColor="Red"> *</asp:RequiredFieldValidator></span>
                        </div>
                        <input runat="server" type="text" class="form-control" id="tbSubject" maxlength="25" />
                    </div>
                <div>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ErrorMessage="Email body required" ForeColor="Red" ControlToValidate="tbEmailArea" >*</asp:RequiredFieldValidator>
                    <asp:TextBox runat="server" id="tbEmailArea" class="form-control" TextMode="MultiLine" style="height: 30vh"></asp:TextBox>
                    <script type="text/javascript" lang="javascript">CKEDITOR.replace('<%=tbEmailArea.ClientID%>');</script> 
                    <%if (!String.IsNullOrEmpty(Request.QueryString["reply"]))
                    { %>
                    <div class="form-check my-2" >
                        <asp:CheckBox class="form-check-inline" runat="server" ID="includeReply" OnCheckedChanged="includeReply_CheckedChanged" AutoPostBack="true" />
                        <label class="form-check-label" for="includeReply">Include Previous Message</label>
                    </div>
                    <%}
                    %>
                </div>
            </div>
            <div class="card-footer">
                <div class="d-flex" style="gap: 5px"> 
                <asp:Button runat="server" ID="btnSendMessage" class="btn btn-primary" Text="Send" OnClick="btnSendMessage_Click" style="display: none"/>
                <div title="Send email" class="btn btn-primary" onclick="document.getElementById('btnSendMessage').click()"><i class="fa-solid fa-paper-plane"></i></div>

                <asp:Button runat="server" ID="btnSaveDraft" class="btn btn-info" Text="Save draft" OnClick="btnSaveDraft_Click" style="display: none" />
                <div title="Save as draft" class="btn btn-info" onclick="document.getElementById('btnSaveDraft').click()"><i class="fa-solid fa-file-pen"></i></div>
                
                <asp:Button runat="server" ID="btnAddAttachments" class="btn btn-success" Text="Add attachments" style="display:none"/>
                <div title="Add Attachment" class="btn btn-success" onclick="document.getElementById('attachmentsUpload').click();document.getElementById('btnDisplay').click(); " ><i class="fa-solid fa-paperclip"></i></div>
                <asp:FileUpload ID="attachmentsUpload" runat="server" AllowMultiple="true" style="display:none"/>
                <asp:Button runat="server" ID="btnDisplay" style="display: none" OnClick="btnDisplay_Click" OnClientClick="return false"/>
                <asp:Label runat="server" ID="lblFiles"></asp:Label>

                <%--<asp:Button runat="server" ID="btnDeleteEmail" class="btn btn-danger" Text="Discard" OnClick="btnDeleteEmail_Click" style="display: none"/>--%>
                <a href="Inbox.aspx" class="text-decoration-none justify-content-end " style="color: inherit !important; margin-left: auto"><div title="Discard" class="btn btn-danger" ><i class="fa-solid fa-trash"></i></div></a>
               </div>
            </div>
        </div>
    </form>
</body>
</html>
