using System;
using System.Collections.Generic;
using System.Drawing;
using System.Linq;
using System.Web;
using System.Web.DynamicData;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Inboxd.Source.Private
{
    public partial class FilterPage : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

            if (Request.QueryString["filter"] != null)
            {
                string filter = Request.QueryString["filter"].ToString();
                Session["filter"] = filter;
            }
            else
                Session["filter"] = null;

            Response.Redirect("Inbox.aspx", false);
        }
    }
}