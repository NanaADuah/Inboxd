using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Inboxd.Source.Private
{
    public partial class Read : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null)
                Response.Redirect("Login.aspx");
            
            string url = "FilterPage.aspx?filter=notifications";

            if (Request.QueryString["id"] == null)
            {
                if (Session["previousUrl"] != null)
                    url = Session["previousUrl"].ToString();
                else
                    url = "Inbox.aspx";
            }
            else
            {
                Notifications notifications = Notifications.GetSingleNotification(int.Parse(Request.QueryString["id"].ToString()));
                if(notifications != null)
                {
                    notifications.DeactivateNotification();
                    Session["previousUrl"] = null;
                    url = "FilterPage.aspx?filter=notifications";
                }

            }
            
            Response.Redirect(url,false);
            
        }
    }
}