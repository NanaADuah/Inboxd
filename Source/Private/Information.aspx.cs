using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Inboxd.Source.Private
{
    public partial class Information : System.Web.UI.Page
    {
        public static User SingleUser = new User();   
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null)
                Response.Redirect("Login.aspx");

            if (Session["ViewAccountID"] == null)
                Response.Redirect("Inbox.aspx");

            else
            {
                SingleUser = Private.User.GetUserInfo(int.Parse(Session["ViewAccountID"].ToString()));
            }
        }

        protected void btnReturnBack_Click(object sender, EventArgs e)
        {
            string redirect = "Inbox.aspx";
            if (Session["previousUrl"] != null)
                redirect = Session["previousUrl"].ToString();

            Response.Redirect(redirect);    


        }

        protected void btnAddFavourite_Click(object sender, EventArgs e)
        {
            if (SingleUser != null)
            {
                User user = new User();
                string result = user.AddAsFavourite(SingleUser.UserID);
                if (result.Equals("success"))
                {
                    Session["filter"] = "favourites";
               //    Response.Redirect("Inbox.aspx");
                }
                else
                {
                    lblMessages.Text = "Oops, an error occurred";
                }
            }
        }

        protected void btnRemoveFavourite_Click(object sender, EventArgs e)
        {
            if (SingleUser != null)
            {
                User user = new User();
                string result = user.RemoveAsFavourite(SingleUser.UserID);
                if (result.Equals("success"))
                {
                    Session["filter"] = "favourites";
                //    Response.Redirect("Inbox.aspx");
                }
                else
                {
                    lblMessages.Text = "Oops, an error occurred";
                }
            }
        }

        protected void btnBlock_Click(object sender, EventArgs e)
        {

        }

        protected void btnContact_Click(object sender, EventArgs e)
        {

        }
    }
}