using System;
using System.CodeDom.Compiler;
using System.CodeDom;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Web;
using System.Security.Cryptography;
using System.Data.SqlClient;
using System.Configuration;
using System.Globalization;

namespace Inboxd.Source.Private
{
    public static class Additional
    {

        public static string ToUpperEveryWord(this string s)
        {
            // Check for empty string.  
            if (string.IsNullOrEmpty(s))
            {
                return string.Empty;
            }

            var words = s.Split(' ');

            var t = "";
            foreach (var word in words)
            {
                t += char.ToUpper(word[0]) + word.Substring(1) + ' ';
            }
            return t.Trim();
        }
        public static string RemoveSpecialCharacters(this string str)
        {
            StringBuilder sb = new StringBuilder();
            foreach (char c in str)
            {
                if ((c >= '0' && c <= '9') || (c >= 'A' && c <= 'Z') || (c >= 'a' && c <= 'z') || c == '.' || c == '_' || c == ' ' || c == '!'|| c == '#'|| c == '@'|| c == ':')
                {
                    sb.Append(c);
                }
            }
            return sb.ToString();
        }
        public static string Truncate(this string text, int length, bool keepFullWordAtEnd = false)
        {
            if (string.IsNullOrEmpty(text)) return string.Empty;

            if (text.Length < length) return text;

            text = text.Substring(0, length);

            if (keepFullWordAtEnd)
            {
                text = text.Substring(0, text.LastIndexOf(' '));
            }

            return text + "...";
        }
        
        public static string TruncateSubject(this string text)
        {
            if (string.IsNullOrEmpty(text)) return string.Empty;

            if (text.Length < 45) return text;

            text = text.Substring(0, 45);
            text = text.Substring(0, text.LastIndexOf(' '));

            return text + "...";
        }
        public static string RemoveReFromSubject(string subject)
        {
            if (subject.Contains("RE: "))
            {
                subject = subject.Replace("RE: ", "");
            }
            return subject;
        }

        public static string ToLiteral(string input)
        {
            using (var writer = new StringWriter())
            {
                using (var provider = CodeDomProvider.CreateProvider("CSharp"))
                {
                    provider.GenerateCodeFromExpression(new CodePrimitiveExpression(input), writer, new CodeGeneratorOptions { IndentString = "\t" });
                    var literal = writer.ToString();
                    literal = literal.Replace(string.Format("\" +{0}\t\"", Environment.NewLine), "");
                    return literal;
                }
            }
        }
        public static int GenerateRandomNumber(int min, int max)
        {
            RNGCryptoServiceProvider rng = new RNGCryptoServiceProvider();
            byte[] bytes = new byte[4];
            rng.GetBytes(bytes);
            int randomNumber = BitConverter.ToInt32(bytes, 0);
            randomNumber = randomNumber % (max - min + 1) + min;
            return randomNumber;
        }
        public static string FirstCharToUpper(this string input)
        {
            switch (input)
            {
                case null: throw new ArgumentNullException(nameof(input));
                case "": throw new ArgumentException($"{nameof(input)} cannot be empty", nameof(input));
                default: return input[0].ToString().ToUpper() + input.Substring(1);
            }
        }

        public static void LogActivity(String Activity, int UserID)
        {
            SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["connectionString"].ConnectionString);
            try
            {
                connection.Open();
                string commStr = "INSERT INTO Activities ([UserID], [Activity]) VALUES (@UserID, @Activity)"; 
                SqlCommand command = new SqlCommand(commStr, connection);
                command.Parameters.AddWithValue("@UserID",   UserID);
                command.Parameters.AddWithValue("@Activity", Activity);
                command.ExecuteNonQuery();
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
        public static bool IsValidDate(string input)
        {
            DateTime date;
            bool success = DateTime.TryParseExact(input, new string[] { "dd/MM/yyyy", "ddMMM yyyy" }, CultureInfo.InvariantCulture, DateTimeStyles.None, out date);

            return success;
        }

    }
}