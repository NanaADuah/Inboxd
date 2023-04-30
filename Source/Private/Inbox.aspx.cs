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
        public User loggedInUser = new Private.User();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null)
                Response.Redirect("Login.aspx");

            else
            {

            }
        }

        protected void btnNewMail_Click(object sender, EventArgs e)
        {
            Response.Redirect("NewMail.aspx");
        }
    }
}