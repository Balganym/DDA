using System;
using Microsoft.AspNetCore.Mvc;
using PartyInvites.Models;
using System.Linq;

namespace PartyInvites.Controllers
{
    public class HomeController : Controller
    {
        public ViewResult Index()
        {
			int hour = DateTime.Now.Hour;
			ViewBag.Greeting = hour < 12 ? "Good Morning!" : "Good afternoon";
            return View("MyView");
        }

		public ViewResult RsvpForm()
		{
			return View();
		}

		[HttpPost]
		public ViewResult RsvpForm(GuestResponse guestResponse)
		{
			Repository.AddResponse(guestResponse);
			return View("Thanks", guestResponse);
		}

		public ViewResult ListResponces()
		{
			return View(Repository.Responses.Where(r => r.WillAttend == true));
		}

	}
}
