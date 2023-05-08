using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System;
using System.Collections;
using System.Collections.Generic;
using System.ComponentModel;
using System.Diagnostics;
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
        public List<User> favouriteUsers = new List<User>();
        public List<Notifications> notifications = new List<Notifications>();

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
            if (type.Equals("sender"))
                emails = email.GetEmailList(7);
            else
            if (type.Equals("search"))
            {
                if(Session["searchValue"] != null )
                {
                    List<Email> temp = (List<Email>)GetObject<Email>(key: "emailList");
                    emails = email.SearchResults(Session["searchValue"].ToString(), temp );
                    tbSearch.Value = Session["searchValue"].ToString();
                    Session["searchValue"] = null;
                    Session["ViewAccountID"] = null;
                } else
                    emails = email.GetEmailList();
            }
            else
            if (type.Equals("notifications"))
            {
                notifications = Notifications.GetAllNotifications(int.Parse(Session["UserID"].ToString()));
                emails = null;
            }
            else
            if (type.Equals("favourites"))
            {
                int userid = int.Parse(Session["UserID"].ToString());
                List<int> fav = loggedInUser.GetFavourites(userid); 
                foreach(var item in fav)
                {
                    favouriteUsers.Add(Private.User.GetUserInfo(item));
                }
                emails = null;
            }
            else
            if (type.Equals("trash"))
                emails = email.GetEmailList(8);
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
            User user = new User();
            List<string> temp = new List<string>();
            
            //foreach(Email item in emails)
            //{
            //    temp.Add(item.EmailSender.ToString());
            //}

           //string combinedString = string.Join(",", temp.ToArray());

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

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            string searchValue = tbSearch.Value;
            string sessionValue = "";
            if (!string.IsNullOrEmpty(searchValue))
            {
                if (Session["filter"] != null)
                    sessionValue = Session["filter"].ToString();

                if (sessionValue != "draft")
                {
                    Session["searchValue"] = searchValue;
                    Session["filter"] = "search";
                    SetObject(emails);
                    Refresh();
                }
                
            }
        }
        public static void SetObject(List<Email> value)
        {
            HttpContext.Current.Session["emailList"] = JsonConvert.SerializeObject((List<Email>)value);
        }

        public static List<Email> GetObject<Email>(string key)
        {
            var value = HttpContext.Current.Session[key].ToString();
            return value == null ? default(List<Email>) : JsonConvert.DeserializeObject<List<Email>>(value);
        }

        protected void btnDeleteNotification_Click(object sender, EventArgs e)
        {
            //string results = "failure";
            //int value;
            //Notifications notifications = new Notifications();
            //string i = notifValue.Value;
            //bool valid = int.TryParse(i, out value);
            //if(valid)
            //    notifications.SetNotificationAsRead(value, out results);

            //if (results.Equals("access"))
            //    Response.Redirect("Inbox.aspx");
            //else
            //    lblMessages.Text = "An error occurred";
        }
    }


}