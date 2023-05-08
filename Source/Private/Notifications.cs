using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.Services.Description;

namespace Inboxd.Source.Private
{
    public class Notifications
    {
        public int NotificationID { get; set; }
        public int NotificationSenderID { get; set; }
        public int NotificationReceiverID { get; set; }
        public string Notification { get; set; }
        public bool NotificationRead { get; set; }
        public bool NotificationActive { get; set; }
        public DateTime NotificationTime { get; set; }

        private SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["connectionString"].ConnectionString);
        private string connectionString = ConfigurationManager.ConnectionStrings["connectionString"].ConnectionString;

        public Notifications() { 
        }
        
        public Notifications(int NotificationID, int NotificationSenderID, int NotificationReceiverID, string Notification, int UserID, bool NotificationRead, bool NotificationActive, DateTime NotificationTime) 
        { 
            this.NotificationID = NotificationID;
            this.NotificationSenderID = NotificationSenderID;
            this.NotificationReceiverID = NotificationReceiverID;
            this.Notification = Notification;
            this.NotificationTime = NotificationTime;
            this.NotificationRead = NotificationRead;
            this.NotificationActive = NotificationActive;
        }

        public Notifications(int NotificationID, string Notification, DateTime NotificationTime, bool NotificationRead, bool NotificationActive, int NotificationSenderID, int NotificationReceiverID)
        {
            this.NotificationID = NotificationID;
            this.Notification = Notification;
            this.NotificationTime = NotificationTime;
            this.NotificationRead = NotificationRead;
            this.NotificationActive = NotificationActive;
            this.NotificationSenderID = NotificationSenderID;
            this.NotificationReceiverID = NotificationReceiverID;
        }

        public void SendNotification(int UserReceiverID, string Message, out string results, string href = "")  //add references later to include links to other pages, like profiles
        {
            results = "failure";
            try
            {
                connection.Open();
                string commStr = "INSERT INTO [Notification]([Notification], [Time], [Read], [Active], [SenderUserID], [ReceiverUserID]) VALUES (@Notification, @Time, @Read, @Active, @SenderUserID, @ReceiverUserID)";
                SqlCommand command = new SqlCommand(commStr, connection);
                command.Parameters.AddWithValue("@Notification", Message);
                command.Parameters.AddWithValue("@Time", DateTime.Now);
                command.Parameters.AddWithValue("@Read", false);
                command.Parameters.AddWithValue("@Active", true);
                command.Parameters.AddWithValue("@SenderUserID", int.Parse(HttpContext.Current.Session["UserID"].ToString()));
                command.Parameters.AddWithValue("@ReceiverUserID", UserReceiverID);

                command.ExecuteNonQuery();
                results = "success";

            }
            catch (SqlException ex)
            {
                User.LogError(ex.Message);
            }
            finally
            {
                connection.Close();
            }
        }

        public void SetNotificationAsRead(int NotificationID, out string results)
        {
            results = "failure";
            SqlConnection connect = new SqlConnection(ConfigurationManager.ConnectionStrings["connectionString"].ConnectionString);
            int currentLoggedIn = int.Parse(HttpContext.Current.Session["UserID"].ToString());
            Notifications notif = GetSingleNotification(NotificationID);
            
            if (notif != null)
            {
                try
                {
                    connect.Open();
                    string commStr = "UPDATE [Notification] SET [Read] = @Read WHERE (NotificationID = @NotificationID) AND (ReceiverUserID = @ReceiverUserID)";
                    SqlCommand command = new SqlCommand(commStr, connect);
                    command.Parameters.AddWithValue("@Read", 1);
                    command.Parameters.AddWithValue("@NotificationID", NotificationID);
                    command.Parameters.AddWithValue("@ReceiverUserID", currentLoggedIn);
                    command.ExecuteNonQuery();
                    results = "success";

                }
                catch (SqlException ex)
                {
                    User.LogError(ex.Message);
                }
                finally { connect.Close(); }
            }
        }
        
        public string DeactivateNotification()
        {
            SqlConnection connect = new SqlConnection(ConfigurationManager.ConnectionStrings["connectionString"].ConnectionString);
            int currentLoggedIn = int.Parse(HttpContext.Current.Session["UserID"].ToString());

            try
            {
                connect.Open();
                string commStr = "UPDATE [Notification] SET [Active] = @Active WHERE (NotificationID = @NotificationID) AND (ReceiverUserID = @ReceiverUserID)";
                SqlCommand command = new SqlCommand(commStr, connect);
                command.Parameters.AddWithValue("@Active", 0);
                command.Parameters.AddWithValue("@NotificationID", this.NotificationID);
                command.Parameters.AddWithValue("@ReceiverUserID", currentLoggedIn);
                command.ExecuteNonQuery();
                return "success";
            }
            catch (SqlException ex)
            {
                User.LogError(ex.Message);
            }
            finally 
            { 
                connect.Close(); 
            }

            return "failure";
        }

        public static int GetNumNotifications()
        {
            int value = 0;
            SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["connectionString"].ConnectionString);
            try
            {
                connection.Open();
                string sql = "SELECT COUNT(ReceiverUserID) FROM [Notification] WHERE [ReceiverUserID] = @ReceiverUserID AND [Read] = @Read AND [Active] = @Active";
                SqlCommand command = new SqlCommand(sql, connection);
                command.Parameters.AddWithValue("@ReceiverUserID", int.Parse(HttpContext.Current.Session["UserID"].ToString()));
                command.Parameters.AddWithValue("@Read", 0);
                command.Parameters.AddWithValue("@Active", 1);
                value = int.Parse(command.ExecuteScalar().ToString());
            }
            catch (SqlException ex)
            {
                User.LogError(ex.Message);
            }
            finally
            {
                connection.Close();
            }
            return value;
        }
        
        public static Notifications GetSingleNotification(int NotificationID)
        {
            Notifications notification = null;
            SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["connectionString"].ConnectionString);
            try
            {
                connection.Open();
                string sql = "SELECT TOP 1 * FROM [Notification] WHERE [ReceiverUserID] = @ReceiverUserID AND [NotificationID] = @ReadNotificationID";
                SqlCommand command = new SqlCommand(sql, connection);
                command.Parameters.AddWithValue("@ReceiverUserID", int.Parse(HttpContext.Current.Session["UserID"].ToString()));
                command.Parameters.AddWithValue("@ReadNotificationID", NotificationID);
                SqlDataReader reader = command.ExecuteReader();

                if(reader.HasRows)
                    while(reader.Read())
                    {
                        notification = new Notifications(
                            NotificationID: int.Parse(reader.GetValue(0).ToString()),
                            Notification: reader.GetValue(1).ToString(),
                            NotificationTime: DateTime.Parse(reader.GetValue(2).ToString()),
                            NotificationRead: bool.Parse(reader.GetValue(3).ToString()),
                            NotificationActive: bool.Parse(reader.GetValue(4).ToString()),
                            NotificationSenderID: int.Parse(reader.GetValue(5).ToString()),
                            NotificationReceiverID: int.Parse(reader.GetValue(6).ToString())
                            );
                    }
            }
            catch (SqlException ex)
            {
                User.LogError(ex.Message);
            }
            finally
            {
                connection.Close();
            }
            return notification;
        }

        public static List<Notifications> GetAllNotifications(int UserID)
        {
            List<Notifications> list = new List<Notifications> ();
            SqlConnection sql = new SqlConnection(ConfigurationManager.ConnectionStrings["connectionString"].ConnectionString);
            try
            {
                sql.Open();
                string commStr = "SELECT * FROM [Notification] WHERE ReceiverUserID = @UserID AND [Active] = @Active ORDER BY [Time] DESC";
                SqlCommand command = new SqlCommand(commStr, sql);
                command.Parameters.AddWithValue("@UserID", UserID);
                command.Parameters.AddWithValue("@Active", 1);
                SqlDataReader reader = command.ExecuteReader();

                if(reader.HasRows)
                    while(reader.Read())
                    {
                        list.Add(new Notifications(
                                    NotificationID: int.Parse(reader.GetValue(0).ToString()),
                                    Notification: reader.GetValue(1).ToString(),
                                    NotificationTime: DateTime.Parse(reader.GetValue(2).ToString()),
                                    NotificationRead: bool.Parse(reader.GetValue(3).ToString()),
                                    NotificationActive: bool.Parse(reader.GetValue(4).ToString()),
                                    NotificationSenderID: int.Parse(reader.GetValue(5).ToString()),
                                    NotificationReceiverID: int.Parse(reader.GetValue(6).ToString())
                            )
                            );
                    }
            }
            catch (SqlException ex)
            {
                User.LogError(ex.Message);
            }
            finally
            {
                sql.Close();
            }

            return list;
        }
    }
}