﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Inboxd.Source.Private
{
    public partial class Inbox : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            //TODO: Redirect if not logged in
        }

        protected void btnNewMail_Click(object sender, EventArgs e)
        {
            Response.Redirect("NewMail.aspx");
        }
    }
}