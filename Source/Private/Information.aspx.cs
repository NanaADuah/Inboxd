using System;
using System.Collections.Generic;
using System.Drawing.Imaging;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Drawing.Drawing2D;

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

        protected void btnUploadProfile_Click(object sender, EventArgs e)
        {
            string uploadDirectory = Server.MapPath($"~/Source/Public/User/{Session["UserID"]}");
            try
            {
                using (Stream strm = ProfileImageUpload.PostedFile.InputStream)
                {
                    using (var image = System.Drawing.Image.FromStream(strm))
                    {
                        int newWidth = 512; // New Width of Image in Pixel  
                        int newHeight = 512; // New Height of Image in Pixel  

                        int cropX, cropY, cropSize;

                        if (image.Width > image.Height)
                        {
                            cropSize = image.Height;
                            cropX = (image.Width - cropSize) / 2;
                            cropY = 0;
                        }
                        else
                        {
                            cropSize = image.Width;
                            cropX = 0;
                            cropY = (image.Height - cropSize) / 2;
                        }

                        var thumbImg = new Bitmap(newWidth, newHeight);
                        var thumbGraph = Graphics.FromImage(thumbImg);
                        thumbGraph.CompositingQuality = CompositingQuality.HighQuality;
                        thumbGraph.SmoothingMode = SmoothingMode.HighQuality;
                        thumbGraph.InterpolationMode = InterpolationMode.HighQualityBicubic;

                        // create a square crop rectangle
                        var cropRectangle = new Rectangle(cropX, cropY, cropSize, cropSize);
                        thumbGraph.DrawImage(image, new Rectangle(0, 0, newWidth, newHeight), cropRectangle, GraphicsUnit.Pixel);

                        string fileName = String.Format("{0}\\{1}.jpg", uploadDirectory, Session["UserID"]);

                        // Save the file as a JPG
                        var encoder = ImageCodecInfo.GetImageEncoders().FirstOrDefault(c => c.FormatID == ImageFormat.Jpeg.Guid);
                        var encoderParams = new EncoderParameters(1);
                        encoderParams.Param[0] = new EncoderParameter(Encoder.Quality, 90L);
                        thumbImg.Save(fileName, encoder, encoderParams);
                        Server.TransferRequest(Request.Url.AbsolutePath, false);
                    }
                }


            }
            catch (Exception ex)
            {
                Private.User.LogError(ex.Message);
            }
        }
    }
}