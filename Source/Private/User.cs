using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Security.Cryptography;
using System.Web;
using System.Web.SessionState;

namespace Inboxd.Source.Private
{
    public class User
    {
        SqlConnection connection;


        public string Name { get; set; }
        public string Surname { get; set; }
        public string Password { get; set; }
        public string Email { get; set; }
        public int UserID { get; set; }
        public DateTime DOB { get; set; }
        private string connectionString = ConfigurationManager.ConnectionStrings["connectionString"].ConnectionString;
        List<String> errors;
        private static readonly RNGCryptoServiceProvider random = new RNGCryptoServiceProvider();

        public User()
        {

        }

        public User(string Email, string Password)
        {
            this.Email = Email;
            this.Password = Password;
        }
        public User(string Name, string Surname, string Email)
        {
            this.Email = Email;
            this.Name = Name;
            this.Surname = Surname;
            this.UserID = getUserID(Email);
        }
        public User(string Name, string Surname, string Email, DateTime DOB)
        {
            this.Email = Email;
            this.Name = Name;
            this.Surname = Surname;
            this.DOB = DOB;
        }

        public int calcAge(DateTime birthdate)
        {
            int age = 0;
            age = birthdate.CompareTo(DateTime.Now);
            return age;
        }

        public bool EmailValidator(string email)
        {
            connection = new SqlConnection(connectionString);
            try
            {
                connection.Open();
                SqlCommand command = new SqlCommand($"SELECT COUNT(UserID) FROM UserDetails WHERE Email = @Email");
                command.Parameters.AddWithValue("@Email", email);
                int validity = ((int)command.ExecuteScalar());

                if (validity != 0)
                    return true;
            }
            catch (Exception e)
            {
                LogError(e.Message);
            }
            finally
            {
                connection.Close();
            }
            return false;
        }
        public bool Login()
        {
            connection = new SqlConnection(connectionString);
            try
            {
                if (EmailValidator(Email))
                {

                    SqlCommand login = new SqlCommand($"SELECT Password FROM U.UserDetails, V.Users WHERE (U.Email = @Email) AND (U.UserID = V.UserID)", connection);
                    login.Parameters.AddWithValue("@Email", Email);
                    string dbPassword = login.ExecuteScalar().ToString();

                    Hasher passwordHasher = new Hasher();

                    if(Hasher.ValidatePassword(Password, dbPassword))
                    {

                    }


                    return true;
                }
            }
            catch (SqlException ex)
            {
                LogError(ex.Message);
            }
            finally
            {
                connection.Close();
            }


            return false;
        }

        public int getUserID(string Email)
        {
            connection = new SqlConnection(connectionString);
            try
            {
                SqlCommand command = new SqlCommand("SELECT UserID FROM [UserDetails] WHERE Email = @Email", connection);
                command.Parameters.AddWithValue("@Email", Email);
                int value = (int)command.ExecuteScalar();
                if (value != 0)
                    return value;
            }
            catch (SqlException ex)
            {
                LogError(ex.Message);
            }
            return 0;
        }

        public void UserAssign()
        {
            try
            {
                HttpContext.Current.Session["UserID"] = UserID;

            }
            catch (Exception ex)
            {
                LogError(ex.Message);
            }
        }

        public void LogError(string error)
        {
            errors.Add(error);
        }

        public string CreateUser()
        {
            connection = new SqlConnection(connectionString);
            UserID = int.Parse(GenerateUniqueID(10));
            
            try
            {
                connection.Open();

                string UserCommand = "INSERT INTO Users VALUES(@UserID, @Password)";
                SqlCommand command_User = new SqlCommand(UserCommand, connection);
                command_User.Parameters.AddWithValue("@UserID", UserID);
                command_User.Parameters.AddWithValue("@Password", Hasher.CreateHash(Password));
                command_User.ExecuteNonQuery();

                string UserDetailCommand = "INSERT INTO UserDetails(Email, Name, Surname, UserID, DOB) VALUES (@Email, @Name, @Surname, @UserID, @DOB)";
                SqlCommand command_UserDetails = new SqlCommand(UserDetailCommand, connection);
                command_UserDetails.Parameters.AddWithValue("@Email", Email);
                command_UserDetails.Parameters.AddWithValue("@Name", Name);
                command_UserDetails.Parameters.AddWithValue("@Surname", Name);
                command_UserDetails.Parameters.AddWithValue("@DOB", DOB);
                command_UserDetails.Parameters.AddWithValue("@UserID", UserID);
                command_UserDetails.ExecuteNonQuery();
            }
            catch(SqlException ex)
            {
                LogError(ex.Message);
            }
            finally
            {
                connection.Close();
            }

            return "Success";
        }

        private string GenerateUniqueID(int length)
        {
            // We chose an encoding that fits 6 bits into every character,
            // so we can fit length*6 bits in total.
            // Each byte is 8 bits, so...
            int sufficientBufferSizeInBytes = (length * 6 + 7) / 8;

            var buffer = new byte[sufficientBufferSizeInBytes];
            random.GetBytes(buffer);
            return Convert.ToBase64String(buffer).Substring(0, length);
        }
    }
}