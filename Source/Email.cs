using Inboxd.Source.Private;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Net.Mail;
using System.Text;
using System.Web;

namespace Inboxd.Source
{
    public class Email
    {
        private string connectionString = ConfigurationManager.ConnectionStrings["connectionString"].ConnectionString;
        public String EmailID { get; set; }
        public String EmailSubject { get; set; } 
        public String ReceipientEmail { get; set; }
        public String EmailBody { get; set; }
        public int EmailSender { get; set; }
        public DateTime EmailDate { get; set; }
        public bool EmailActive { get; set; }
        public bool EmailRead { get; set; }

        public Email()
        {
            
        }

        public Email(string Subject, string Receipient, string Body) 
        {
            this.EmailBody = Body;
            this.ReceipientEmail = Receipient;
            this.EmailSubject = Subject;
        }

        private Email(int SenderID, string EmailID, string Subject, int ReceipientID, string Body, DateTime Date, bool Active, bool Read)
        {
            User user = new User();
            this.EmailID = EmailID;
            this.EmailSender = SenderID;
            this.EmailBody = Body;
            this.ReceipientEmail = user.getUserEmail(ReceipientID);
            this.EmailSubject = Subject;
            this.EmailDate = Date;
            this.EmailActive = Active;
            this.EmailRead = Read;
        }

        public string SendEmail()
        {
            SqlConnection connection = new SqlConnection(connectionString);
            User user = new User();
            int currentUserID = int.Parse(HttpContext.Current.Session["UserID"].ToString());
            if (!string.IsNullOrEmpty(HttpContext.Current.Session["UserID"].ToString()))
                if (user.EmailValidator(ReceipientEmail))
                {
                    try
                    {
                        int senderID = user.getUserID(ReceipientEmail);
                        connection.Open();
                        string command = "INSERT INTO [Emails] (EmailID, [SenderID], [ReceiverID], [Email], [Read], [Date], [Active], [Subject] ) VALUES (@EmailID, @SenderID, @ReceiverID, @Email, @Read, @Date, @Active, @Subject) ";
                        SqlCommand cmd = new SqlCommand(command, connection);
                        cmd.Parameters.AddWithValue("@EmailID", GenerateEmailID(32));
                        cmd.Parameters.AddWithValue("@SenderID", currentUserID);
                        cmd.Parameters.AddWithValue("@ReceiverID", senderID);
                        cmd.Parameters.AddWithValue("@Email", Additional.RemoveSpecialCharacters(EmailBody));
                        cmd.Parameters.AddWithValue("@Subject", Additional.RemoveSpecialCharacters(EmailSubject));
                        cmd.Parameters.AddWithValue("@Date", DateTime.Now);
                        cmd.Parameters.AddWithValue("@Active", true);
                        cmd.Parameters.AddWithValue("@Read", false);
                        cmd.ExecuteNonQuery();
                        return "Success";
                    }
                    catch (SqlException ex)
                    {
                        user.LogError(ex.Message);
                    }
                    finally
                    {
                        connection.Close();
                    }
                }
                else
                    return "Receipient Email not found";
            else
                return "Insufficient permissions to send email";

            return "An error occurred";
        }

        public string GenerateEmailID(int length)
        {
            string alphabets = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
            string small_alphabets = "abcdefghijklmnopqrstuvwxyz";
            string numbers = "1234567890";

            string characters = numbers;
            characters += alphabets + small_alphabets + numbers;

            string id = string.Empty;
            for (int i = 0; i < length; i++)
            {
                string character = string.Empty;
                do
                {
                    int index = new Random().Next(0, characters.Length);
                    character = characters.ToCharArray()[index].ToString();
                } while (id.IndexOf(character) != -1);
                id += character;
            } 

            return id;
        }

        public List<Email> GetEmailList()
        {
            List<Email> list = new List<Email>();
            User user = new User();
            SqlConnection connection = new SqlConnection(connectionString);
            try
            {
                connection.Open();
                string comm = "SELECT * FROM Emails WHERE ReceiverID = @Receiver AND Active = 1 ORDER BY Date DESC";
                SqlCommand command = new SqlCommand(comm, connection);
                command.Parameters.AddWithValue("@Receiver", int.Parse(HttpContext.Current.Session["UserID"].ToString()));
                //command.Parameters.AddWithValue("@Limit", 20);
                SqlDataReader reader = command.ExecuteReader(); ;
                
                if(reader.HasRows)
                    while (reader.Read())
                    {
                        list.Add(new Email(EmailID: reader[0].ToString(),
                                           SenderID: int.Parse(reader[1].ToString()),
                                           ReceipientID: int.Parse(reader[2].ToString()),
                                           Body: reader[3].ToString(),
                                           Read: Boolean.Parse(reader[4].ToString()),
                                           Date: DateTime.Parse(reader[5].ToString()),
                                           Active: Boolean.Parse(reader[6].ToString()),
                                           Subject: reader[7].ToString()
                            ));
                    }

            }
            catch (SqlException ex)
            {
                user.LogError(ex.Message);
            }
            finally 
            { 
                connection.Close(); 
            }
            return list;
        }

    }
}