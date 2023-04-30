using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;

namespace Inboxd.Source.Private
{
    public static class Additional
    {

        public static string RemoveSpecialCharacters(this string str)
        {
            StringBuilder sb = new StringBuilder();
            foreach (char c in str)
            {
                if ((c >= '0' && c <= '9') || (c >= 'A' && c <= 'Z') || (c >= 'a' && c <= 'z') || c == '.' || c == '_' || c == ' ' || c == '!'|| c == '#'|| c == '@')
                {
                    sb.Append(c);
                }
            }
            return sb.ToString();
        }
    }
}