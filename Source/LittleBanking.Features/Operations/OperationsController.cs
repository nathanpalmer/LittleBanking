using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Aplite.Core.Common;
using Aplite.Core.DataAccess;
using Aplite.Core.Domain;
using Aplite.Core.Services;
using Aplite.DataAccess.DataAccess;
using AutoMapper;
using Elmah;

namespace LittleBanking.Operations
{
    public class OperationsController : ApplicationController
    {
        public OperationsController(
            IUserSession UserSession,
            IMiddleManagement MiddleManagement, IFormsAuthentication FormsAuthentication)
            : base(MiddleManagement, UserSession, FormsAuthentication)
        {
        }

        private void LogException(Exception e)
        {
            ErrorSignal.FromCurrentContext().Raise(e);
        }

        private PostEdit GetType(ApType Type)
        {
            PostEdit postEdit;
            switch (Type)
            {
                case ApType.blog:
                    postEdit = new PostEdit
                    {
                        Type = Type.ToProper(),
                        Format = Format.PlainText,
                        Published = true,
                        Promote = true
                    };
                    break;
                default:
                    throw new ArgumentOutOfRangeException("");
            }

            return postEdit;
        }

        [HttpGet]
        [AreaFilter("Operations", true, EntityOperator.Post, PermissionAction.Create)]  
        public ActionResult Create(PermissionArea Area, ApType ApType)
        {
            var postEdit = GetType(ApType);

            ViewData["Post"] = postEdit;
            ViewData["Salt"] = "PostCreate";

            return View("Form" + ApType.ToProper(), Area);
        }

        [HttpPost]
        [ValidateAntiForgeryToken(Salt = "PostCreate")]
        [ApTypeMatchingValues(new[] { ApType.blog })]
        [AreaFilter("Operations", true, EntityOperator.Post, PermissionAction.Create)]
        public ActionResult Create(PermissionArea Area, ApType ApType, PostEdit PostEdit)
        {
            if (!ModelState.IsValid)
            {
                ViewData["Post"] = PostEdit;
                ViewData["Salt"] = "PostCreate";

                return View("Form" + ApType.ToProper(), Area);
            }

            //////////////////////////
            // Everything passed. Create new post
            //////////////////////////
            var post = Mapper.Map<PostEdit, Post>(PostEdit);
            middleManagement.Post.Add(post);

            //////////////////////////
            // Send user to new post
            //////////////////////////
            return RedirectToAction("View", "Blog",
                                    new
                                    {
                                        postid = post.ID,
                                        title = post.Title.ToUrlFriendly()
                                    });
        }

        [HttpGet]
        [AreaFilter("Operations", true, EntityOperator.Comment, PermissionAction.Create)]
        [PostFilter(Flags: PostFlags.FilterOutDeletedAndUnpublished)]
        public ActionResult Reply(PermissionArea Area, PermissionPost Post, ApType ApType)
        {
            var postEdit = Mapper.Map<Post, PostEdit>(Post.Entity);
            
            ViewData["Post"] = postEdit;
            ViewData["Comment"] = new CommentEdit();
            ViewData["Salt"] = "CommentReply";

            return View("FormComment", Area);
        }

        [HttpPost]
        [ValidateAntiForgeryToken(Salt = "CommentReply")]
        [AreaFilter("Operations", true, EntityOperator.Comment, PermissionAction.Create)]
        [PostFilter(Flags: PostFlags.FilterOutDeletedAndUnpublished)]
        public ActionResult Reply(PermissionArea Area, PermissionPost Post, ApType ApType, CommentEdit CommentEdit)
        {
            if (!ModelState.IsValid)
            {
                var postEdit = Mapper.Map<Post, PostEdit>(Post.Entity);
            
                ViewData["Post"] = postEdit;
                ViewData["Comment"] = CommentEdit;
                ViewData["Salt"] = "CommentReply";

                return View("FormComment", Area);
            }

            var comment = Mapper.Map<CommentEdit, Comment>(CommentEdit);
            
            var permissionComment = middleManagement.Comment.Add(comment);

            return Redirect(Url.Action("View", "Blog",
                                    new
                                    {
                                        postid = Post.Entity.ID,
                                        title = Post.Entity.Title.ToUrlFriendly()
                                    }) + string.Format("#{0}", permissionComment.Entity.ID));
        }

        // Edit new Post
        [HttpGet]
        [StrictRouteMatching(new[] { "postid", "type" })]
        [AreaFilter("Operations", true, EntityOperator.Post, PermissionAction.Edit)]
        [PostFilter(PermissionAction: PermissionAction.Edit, Flags: PostFlags.FilterOutDeletedAndUnpublished)]
        public ActionResult Edit(PermissionArea Area, PermissionPost Post, ApType ApType)
        {
            PostEdit postEdit;

            switch (ApType)
            {
                case ApType.blog:
                    postEdit = Mapper.Map<Post, PostEdit>(Post.Entity);
                    break;
                default:
                    throw new ArgumentOutOfRangeException("ApType");
            }

            ViewData["Post"] = postEdit;
            ViewData["Salt"] = "PostEdit";

            return View("Form" + ApType.ToProper(), Area);
        }

        [HttpPost]
        [ValidateAntiForgeryToken(Salt = "PostEdit")]
        [StrictRouteMatching(new[] { "postid", "type" })]
        [ApTypeMatchingValues(new[] { ApType.blog })]
        [AreaFilter("Operations", true, EntityOperator.Post, PermissionAction.Edit)]
        [PostFilter(PermissionAction: PermissionAction.Edit, Flags: PostFlags.FilterOutDeletedAndUnpublished)]
        public ActionResult Edit(PermissionArea Area, PostEdit PostEdit, ApType ApType)
        {
            if (!ModelState.IsValid)
            {
                ViewData["Post"] = PostEdit;
                ViewData["Salt"] = "PostEdit";

                return View("Form" + ApType.ToProper(), Area);
            }

            var postToSave = Mapper.Map<PostEdit, Post>(PostEdit);

            middleManagement.Post.Save(postToSave);

            return RedirectToAction("View", "Blog", new
            {
                postid = postToSave.ID,
                title = postToSave.Title.ToUrlFriendly()
            });
        }

        // Edit new Comment
        [HttpGet]
        [StrictRouteMatching(new[] { "postid", "commentid", "type" })]
        [AreaFilter("Operations", true, EntityOperator.Comment, PermissionAction.Edit)]
        [PostFilter(Flags: PostFlags.FilterOutDeletedAndUnpublished)]
        [CommentFilter(PermissionAction: PermissionAction.Edit, Flags: CommentFlags.FitlerOutDeletedAndUnpublished)]
        public ActionResult Edit(PermissionArea Area, PermissionPost Post, PermissionEntity<Comment> Comment)
        {
            var postEdit = Mapper.Map<Post, PostEdit>(Post.Entity);
            var commentEdit = Mapper.Map<Comment, CommentEdit>(Comment.Entity);

            ViewData["Post"] = postEdit;
            ViewData["Comment"] = commentEdit;
            ViewData["Salt"] = "CommentEdit";

            return View("FormComment", Area);
        }

        [HttpPost]
        [ValidateAntiForgeryToken(Salt = "CommentEdit")]
        [StrictRouteMatching(new[] { "postid", "commentid", "type" })]
        [AreaFilter("Operations", true, EntityOperator.Comment, PermissionAction.Edit)]
        [PostFilter(Flags: PostFlags.FilterOutDeletedAndUnpublished)]
        [CommentFilter(PermissionAction: PermissionAction.Edit, Flags: CommentFlags.FitlerOutDeletedAndUnpublished)]
        public ActionResult Edit(PermissionArea Area, PermissionPost Post, CommentEdit CommentEdit, ApType ApType)
        {
            if (!ModelState.IsValid)
            {
                var postEdit = Mapper.Map<Post, PostEdit>(Post.Entity);

                ViewData["Post"] = postEdit;
                ViewData["Comment"] = CommentEdit;
                ViewData["Salt"] = "PostComment";

                return View("FormComment", Area);
            }

            var commentToSave = Mapper.Map<CommentEdit, Comment>(CommentEdit);
            middleManagement.Comment.Save(commentToSave);

            return RedirectToAction("View", "Blog", new
            {
                postid = Post.Entity.ID,
                title = Post.Entity.Title.ToUrlFriendly()
            });
        }

        // Delete new Post
        [HttpGet]
        [StrictRouteMatching(new[] { "postid", "type" })]
        [AreaFilter("Operations", true, EntityOperator.Post, PermissionAction.Delete)]
        [PostFilter(PermissionAction: PermissionAction.Delete, Flags: PostFlags.FilterOutDeletedAndUnpublished)]
        public ActionResult Delete(PermissionArea Area, PermissionPost Post)
        {
            var currentUser = userSession.GetCurrent();
            var interop = Post.ToInterop(Area.Entity, currentUser);

            ViewData["Post"] = interop;
            ViewData["Salt"] = "PostDelete";

            return View("FormDelete", Area);
        }

        [HttpPost]
        [ValidateAntiForgeryToken(Salt = "PostDelete")]
        [StrictRouteMatching(new[] { "postid", "type" })]
        [AreaFilter("Operations", true, EntityOperator.Post, PermissionAction.Delete)]
        [PostFilter(PermissionAction: PermissionAction.Delete, Flags: PostFlags.FilterOutDeletedAndUnpublished)]
        public ActionResult Delete(PermissionArea Area, PermissionPost Post, ApType ApType, string Action)
        {
            if (String.IsNullOrWhiteSpace(Action) ||
                !Action.Equals("Yes"))
            {
                return RedirectToAction("View", "Blog", new
                {
                    postid = Post.Entity.ID,
                    title = Post.Entity.Title.ToUrlFriendly()
                });
            }

            middleManagement.Post.Delete(Post.Entity);

            return RedirectToAction("Index", "Blog", new
            {
                page = 1
            });
        }

        // Delete comment
        [HttpGet]
        [StrictRouteMatching(new[] { "postid", "commentid", "type" })]
        [AreaFilter("Operations", true, EntityOperator.Comment, PermissionAction.Delete)]
        [PostFilter(Flags: PostFlags.FilterOutDeletedAndUnpublished)]
        [CommentFilter(PermissionAction: PermissionAction.Delete, Flags: CommentFlags.FitlerOutDeletedAndUnpublished)]
        public ActionResult Delete(PermissionArea Area, PermissionPost Post, PermissionEntity<Comment> Comment)
        {
            var currentUser = userSession.GetCurrent();
            var interop = Comment.ToInterop(Area.Entity, Post.Entity, currentUser);

            ViewData["Post"] = interop;
            ViewData["Salt"] = "CommentDelete";

            return View("FormDelete", Area);
        }

        [HttpPost]
        [ValidateAntiForgeryToken(Salt = "CommentDelete")]
        [StrictRouteMatching(new[] { "postid", "commentid", "type" })]
        [AreaFilter("Operations", true, EntityOperator.Comment, PermissionAction.Delete)]
        [PostFilter(Flags: PostFlags.FilterOutDeletedAndUnpublished)]
        [CommentFilter(PermissionAction: PermissionAction.Delete, Flags: CommentFlags.FitlerOutDeletedAndUnpublished)]
        public ActionResult Delete(PermissionArea Area, PermissionPost Post, PermissionEntity<Comment> Comment, ApType ApType, string Action)
        {
            if (String.IsNullOrWhiteSpace(Action) ||
                !Action.Equals("Yes"))
            {
                return RedirectToAction("View", "Blog", new
                {
                    postid = Post.Entity.ID,
                    title = Post.Entity.Title.ToUrlFriendly()
                });
            }

            middleManagement.Comment.Delete(Comment.Entity);

            return RedirectToAction("View", "Blog", new
            {
                postid = Post.Entity.ID,
                title = Post.Entity.Title.ToUrlFriendly()
            });
        }

        //[HttpPost]
        [AreaFilter("Operations", true, EntityOperator.Post, PermissionAction.Create)]
        [PostFilter(PermissionAction: PermissionAction.Create, Flags: PostFlags.FilterOutDeletedAndUnpublished)]
        public ActionResult Rank(PermissionPost Post, short rank)
        {
            var value = 0;
            if (rank > 1)
            {
                rank = 1;
            }

            if (rank < -1)
            {
                rank = -1;
            }

            if (rank != 0)
            {
                //update rank
                value = middleManagement.Post.Rank(Post.Entity, rank);
            }
            else
            {
                // return current
                value = Post.Entity.Rank;
            }

            return RedirectToAction("View", "Blog", new
            {
                postid = Post.Entity.ID,
                title = Post.Entity.Title.ToUrlFriendly()
            });
        }
    }
}
