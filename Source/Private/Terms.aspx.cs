using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Inboxd.Source.Private
{
    public partial class Terms : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void btnGoBack_Click(object sender, EventArgs e)
        {
            string url = "Inbox.aspx";
            if (Session["previousUrl"] != null)
                url = Session["previousUrl"].ToString();

            Response.Redirect(url, false);
        }
    }
}