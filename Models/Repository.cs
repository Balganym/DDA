using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace PartyInvites.Models
{
    public static class Repository
    {
		private static List<GuestResponse> responces = new List<GuestResponse>();
		public static IEnumerable<GuestResponse> Responses { get { return responces; } }
		public static void AddResponse(GuestResponse response)
		{
			responces.Add(response);
		}

	}
}
