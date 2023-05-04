using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Runtime.Remoting;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Inboxd.Source.Private
{
    public partial class Inbox : System.Web.UI.Page
    {
        public List<Email> emails = new List<Email>();
        public User loggedInUser = new Private.User();

        public string _jsPostBackCall;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null)
                Response.Redirect("Login.aspx");

            loggedInUser = Private.User.GetUserInfo(int.Parse(Session["UserID"].ToString()));
            
            Email email = new Email();
            string type = "default";

            if (Session["filter"] != null && !Session["filter"].Equals(-1))
                type = Session["filter"].ToString();

            if (type.Equals("recent") || type.Equals("default"))
                emails = email.GetEmailList(1);
            else
            if (type.Equals("unread"))
                emails = email.GetEmailList(2);
            else
            if (type.Equals("starred"))
                emails = email.GetEmailList(4);
            else
            if (type.Equals("draft"))
                emails = email.GetDraftList();
            else
            if (type.Equals("sent"))
                emails = email.GetEmailList(5);
            else
            if (type.Equals("spam"))
                emails = email.GetEmailList(6);
            else
                emails = email.GetEmailList();
        }

        protected void btnNewMail_Click(object sender, EventArgs e)
        {
            Response.Redirect("NewMail.aspx");
        }

        private void Refresh() { Response.Redirect("Inbox.aspx"); }

        protected void btnDefault_Click(object sender, EventArgs e)
        {
            Session["filter"] = "default";
            Refresh();
        }

        protected void btnSender_Click(object sender, EventArgs e)
        {
            Session["filter"] = "sender";
            Refresh();
        }

        protected void btnUnread_Click(object sender, EventArgs e)
        {
            Session["filter"] = "unread";
            Refresh();
        }

        [WebMethod]
        public void StoreUrl()
        {
            try
            {
                Session["previousUrl"] = HttpContext.Current.Request.Url.ToString();
            }
            catch
            {
                //oh well
            }
        }
    }

    
}