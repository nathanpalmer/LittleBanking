using System;
using System.Collections.Generic;
using System.IO;
using System.Net;
using System.Net.Security;
using System.Security.Cryptography.X509Certificates;
using System.Web;
using System.Web.Mvc;
using System.Web.Security;
using Aplite.Core.Common;
using Aplite.Core.Common.Extensions;
using Aplite.Core.Domain;
using Aplite.Core.Services;
using DotNetOpenAuth.OpenId.RelyingParty;
using LittleBanking.Errors;
using LittleBanking.Users;

namespace LittleBanking.Users
{
    public class UserController : ApplicationController
    {
        private readonly IUserManagement userManagement;
        private readonly IUserAuthentication userAuthentication;
        private readonly IEnumerable<IUserAuthenticator> userAuthenticators;
        private readonly IFormsAuthentication formsAuthentication;
        private readonly IStringHash stringHash;

        public UserController(
            IUserManagement UserManagement,
            IMiddleManagement MiddleManagment,
            IUserSession UserSession,
            IUserAuthentication UserAuthentication,
            IEnumerable<IUserAuthenticator> UserAuthenticators,
            IFormsAuthentication FormsAuthentication,
            IStringHash StringHash)
            : base(MiddleManagment, UserSession, FormsAuthentication)
        {
            userManagement = UserManagement;
            userAuthentication = UserAuthentication;
            userAuthenticators = UserAuthenticators;
            formsAuthentication = FormsAuthentication;
            stringHash = StringHash;
        }

        public ActionResult Login(string ReturnUrl)
        {
            ViewData["ReturnUrl"] = ReturnUrl;
            ViewData["Authenticators"] = userAuthenticators;

            string host = HttpContext.Request.GetSubDomain();
            if (!String.IsNullOrEmpty(host))
            {
                var parentUser = userManagement.Get(x => x.HomePage.Equals(host));
                if (parentUser.EntityFound)
                {
                    if (parentUser.Entity.StateUser == StateUser.Active)
                    {
                        var UserLogin = new UserLogin
                                        {
                                            Title = parentUser.Entity.Business
                                        };

                        return View("BankLogin", UserLogin);
                    }
                    return View("AccountInactive");
                }
            }

            // default login screen
            return View();
        }

        public ActionResult Authenticate(UserLogin UserLogin, bool? RememberMe, string ReturnUrl)
        {
            string identifier = UserLogin.Identifier;
            string host = HttpContext.Request.GetSubDomain();
            PermissionEntity<User> parentUser = null;
            if (!String.IsNullOrEmpty(host))
            {
                parentUser = userManagement.Get(x => x.HomePage.Equals(host));
                if (parentUser.EntityFound)
                {
                    if (parentUser.Entity.StateUser == StateUser.Active)
                    {
                        DateTime birthDate;
                        if (!DateTime.TryParse(UserLogin.Password, out birthDate))
                        {
                            ModelState.AddModelError("_FORM", "Invalid Birth Date");
                            return View("BankLogin", UserLogin);
                        }
                        identifier = parentUser.Entity.ID + "/" + UserLogin.Identifier + ":" + birthDate.ToShortDateString();
                    }
                    else
                    {
                        return View("AccountInactive");
                    }
                }
            }

            User user = null;
            ActionResult redirect = null;
            UserAuthenticationStatus? status = null;

            ViewData["Authenticators"] = userAuthenticators;

            try
            {
                status = userAuthentication.Authenticate(UserLogin.AuthenticationType, identifier, ReturnUrl, out user, out redirect);
            }
            catch (Exception ex)
            {
                ModelState.AddModelError("_FORM", ex.Message);
                return !String.IsNullOrEmpty(host) ? View("BankLogin", UserLogin) : View("Login");
            }

            switch (status)
            {
                case UserAuthenticationStatus.RequiresRedirect:
                    if (redirect == null)
                    {
                        ModelState.AddModelError("_FORM", "An unknown error has occurred while attempting to redirect for authentication");
                        break;
                    }

                    return redirect;

                case UserAuthenticationStatus.RequiresConfirmation:
                    if (user == null)
                    {
                        ModelState.AddModelError("_FORM", "An unknown error has occurred while attempting to confirm your user account");
                        break;
                    }

                    return RedirectToAction("Confirm", new { ProviderUserKey = user.ProviderUserKey.Value });

                case UserAuthenticationStatus.Failed:
                    ModelState.AddModelError("_FORM", "Authentication has failed");
                    break;

                case UserAuthenticationStatus.Authenticated:
                    if (user == null)
                    {
                        ModelState.AddModelError("_FORM", "An unknown error has occurred while attempting to log you in");
                        break;
                    }

                    formsAuthentication.SignIn(user.LoginName, RememberMe.HasValue ? RememberMe.Value : false);

                    if (!string.IsNullOrEmpty(ReturnUrl))
                    {
                        return Redirect(ReturnUrl);
                    }

                    
                    return !String.IsNullOrEmpty(host)
                        ? RedirectToAction("Dashboard", "Child")
                        : RedirectToAction("Dashboard", "Leader");
            }

            return !String.IsNullOrEmpty(host) ? View("BankLogin", UserLogin) : View("Login");
        }

        [HttpGet]
        public ActionResult Confirm(Guid? ProviderUserKey, string ReturnUrl)
        {
            if (!ProviderUserKey.HasValue)
            {
                return RedirectToAction("Home", "Public");
            }

            var user = userManagement.Get(u => u.ProviderUserKey == ProviderUserKey);
            if (user.EntityFound)
            {
                var confirm = new UserConfirm
                              {
                                  ProviderUserKey = ProviderUserKey.Value,
                                  LoginName = user.Entity.LoginName,
                                  Email = user.Entity.EmailAddress
                              };

                ViewData["ReturnUrl"] = ReturnUrl;

                return View(confirm);
            }

            return RedirectToAction("Home", "Public");
        }

        [HttpPost]
        public ActionResult Confirm(UserConfirm UserConfirm, string ReturnUrl)
        {
            if (!ModelState.IsValid)
            {
                return View(UserConfirm);
            }

            var existingUser = userManagement.Get(x => x.UserName == UserConfirm.DisplayName);
            if (existingUser.EntityFound)
            {
                ModelState.AddModelError("DisplayName", "Display Name already exists, please choose another.");
                return View(UserConfirm);
            }

            var user = userManagement.ConfirmRegistration(UserConfirm.ProviderUserKey.Value);
            if (user.EntityFound)
            {
                user.Entity.UserName = UserConfirm.DisplayName;
                if (!String.IsNullOrWhiteSpace(UserConfirm.Email))
                {
                    user.Entity.EmailAddress = UserConfirm.Email;
                }
                user.Entity.Business = UserConfirm.BankName;
                user.Entity.HomePage = UserConfirm.Url;

                userManagement.Save(user.Entity);

                formsAuthentication.SignIn(user.Entity.LoginName, false);

                if (!string.IsNullOrEmpty(ReturnUrl))
                {
                    return Redirect(ReturnUrl);
                }

                TempData["Message"] = "Your account has been activated.";
                return RedirectToAction("Home", "Public");
            }

            return View();
        }

        public ActionResult Register()
        {
            return View();
        }

        [HttpPost]
        public ActionResult Register(UserRegistration UserRegistration)
        {
            if (!ModelState.IsValid)
            {
                return View();
            }

            var newUser = new User
            {
                UserName = HttpUtility.HtmlEncode(UserRegistration.UserName),
                LoginName = HttpUtility.HtmlEncode(UserRegistration.UserName),
                Password = HttpUtility.HtmlEncode(UserRegistration.Password),
                EmailAddress = HttpUtility.HtmlEncode(UserRegistration.Email),
                ProviderUserKey = Guid.NewGuid()
            };

            var status = userManagement.Add(newUser);
            if (status != MembershipCreateStatus.Success)
            {
                ModelState.AddModelError("_FORM", status.ConvertToFriendlyString());
                return View();
            }

            //TODO: Add email

            return View("RegisterConfirmation");
        }

        public ActionResult Logout()
        {
            formsAuthentication.SignOut();
            return RedirectToAction("Home", "Public");
        }

        public ActionResult Profile(int UserId, string UserName)
        {
            var currentUser = userSession.GetCurrent();
            if (UserId != currentUser.ID) return RedirectToAction("Index", "Error");

            var user = middleManagement.User.Get(UserId);
            var userProfile = new LittleBanking.Users.UserProfile
                              {
                                  UserID = UserId,
                                  DisplayName = user.UserName,
                                  Email = user.EmailAddress,
                                  Password = user.Password,
                                  Local = !(user.LoginName.StartsWith("http://") ||
                                            user.LoginName.StartsWith("https://") ||
                                            user.LoginName.StartsWith("facebook://") ||
                                            user.LoginName.StartsWith("twitter://"))
                              };
            
            return View(userProfile);
        }

        [HttpPost]
        public ActionResult Profile(LittleBanking.Users.UserProfile UserProfile)
        {
            if (!ModelState.IsValid) return View(UserProfile);

            var currentUser = userSession.GetCurrent();
            if (UserProfile.UserID != currentUser.ID) return RedirectToAction("Index", "Error");

            var user = middleManagement.User.Get(UserProfile.UserID);
            user.UserName = UserProfile.DisplayName;
            user.EmailAddress = UserProfile.Email;
            if (UserProfile.Local && !string.IsNullOrWhiteSpace(UserProfile.Password))
            {
                user.Password = stringHash.Hash(UserProfile.Password);
            }
            middleManagement.User.Save(user);

            return RedirectToAction("Dashboard", "Leader");
        }

        public ActionResult Bank()
        {
            var user = userSession.GetCurrent();

            var userBank = new UserBank
                           {
                               BankName = user.Business,
                               Url = user.HomePage
                           };

            return View(userBank);
        }

        [HttpPost]
        public ActionResult Bank(UserBank UserBank)
        {
            if (!ModelState.IsValid) return View(UserBank);

            var currentUser = userSession.GetCurrent();
            var user = middleManagement.User.Get(currentUser.ID);
            user.Business = UserBank.BankName;
            user.HomePage = UserBank.Url;
            middleManagement.User.Save(user);

            return RedirectToAction("Dashboard", "Leader");
        }
    }
}
