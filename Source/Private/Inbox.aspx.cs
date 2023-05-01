using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Inboxd.Source.Private
{
    public partial class Inbox : System.Web.UI.Page
    {
        public List<Email> emails = new List<Email>();
        public User loggedInUser = new Private.User();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null)
                Response.Redirect("Login.aspx");

            loggedInUser. UserID = int.Parse(Session["UserID"].ToString());
            Email email = new Email();
            string type = "";

            if (ViewState["filter"] != null && !ViewState["filter"].Equals(-1))
                type = ViewState["filter"].ToString();

            if (type.Equals("unread"))
                emails = email.GetEmailList(2);
            else
            if (type.Equals("starred"))
                emails = email.GetEmailList(4);
            else
                emails = email.GetEmailList();
        }

        protected void btnNewMail_Click(object sender, EventArgs e)
        {
            Response.Redirect("NewMail.aspx");
        }

        protected void Unnamed3_Click(object sender, EventArgs e)
        {
            ViewState["filter"] = "unread";
        }

        protected void Unnamed2_Click(object sender, EventArgs e)
        {
            ViewState["filter"] = "sender";
        }

        protected void Unnamed1_Click(object sender, EventArgs e)
        {
            ViewState["filter"] = "starred";
        }

        protected void Unnamed_Click(object sender, EventArgs e)
        {
            ViewState["filter"] = null;
        }

        protected void Unnamed_Click1(object sender, EventArgs e)
        {
            ViewState["filter"] = "recent";
        }
    }

    
}