using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web.Mvc;
using Aplite.Core.Common;
using Aplite.Core.DataAccess;
using Aplite.Core.Domain;
using Aplite.Core.Services;
using Autofac;
using AutoMapper;
using LittleBanking.Transactions;
using LittleBanking.Users;

namespace LittleBanking
{
    public class AutoMapperConfiguration
    {
        public static void ConfigureObjectMapping(IContainer container)
        {
            MapPost(container);
            MapComment(container);

            Mapper.AssertConfigurationIsValid();
        }

        public static void MapPost(IContainer Container)
        {
            Mapper.CreateMap<Post, PostEdit>()
                .ForMember(d => d.ID, s => s.MapFrom(src => src.ID))
                .ForMember(d => d.BodyRaw, s => s.MapFrom(src => src.Raw.Body))
                .ForMember(d => d.Tags, s => s.MapFrom(src => src.Tags.List()))
                .ForMember(d => d.Type, s => s.MapFrom(src => src.Type.ToString()))
                .ForMember(d => d.Sticky, s => s.MapFrom(src => src.Status == Status.Sticky))
                .ForMember(d => d.Published, s => s.MapFrom(src => src.StateContent == StateContent.Normal))
                // come back and map up
                .ForMember(d => d.State, s => s.Ignore())
                .ForMember(d => d.Announcement, s => s.Ignore())
                .ForMember(d => d.Locked, s => s.Ignore())
                .ForMember(d => d.Deleted, s => s.Ignore());

            Mapper.CreateMap<PostEdit, Post>()
                .ConstructUsing(input =>
                                    {
                                        if (input.ID > 0)
                                        {
                                            return DependencyResolver.Current.GetService<IPostRepository>().Get(input.ID);
                                        }

                                        Post post = null;
                                        switch (input.Type.ToLower())
                                        {
                                            case "payment":
                                                post = new Transaction();
                                                break;
                                            default:
                                                throw new Exception("Invalid type");
                                        }

                                        post.DateCreated = DateTime.UtcNow;
                                        post.User = DependencyResolver.Current.GetService<IUserSession>().GetCurrent();
                                        post.Area = DependencyResolver.Current.GetService<IAreaRepository>().Query().Where(
                                            x => x.Name.Equals("Default") && x.Tier == 0).Single();

                                        return post;
                                    })
                .ForMember(d => d.Raw, s => s.MapFrom(src => src.ID == 0
                                                                 ? new PostRaw
                                                                       {
                                                                           Body = src.BodyRaw
                                                                       }
                                                                 : DependencyResolver.Current.GetService<IPostRepository>().Get(src.ID).Raw.
                                                                       Update(src.BodyRaw)))
                .ForMember(d => d.Status, s => s.MapFrom(src => src.Sticky ? Status.Sticky : Status.None))
                .ForMember(d => d.StateContent,
                           s => s.MapFrom(src => src.Published ? StateContent.Normal : StateContent.Unpublished))
                .ForMember(d => d.User, s => s.Ignore())
                .ForMember(d => d.Area, s => s.Ignore())
                .ForMember(d => d.UserModerated, s => s.Ignore())
                .ForMember(d => d.LastComment, s => s.Ignore())
                .ForMember(d => d.Comments, s => s.Ignore())
                .ForMember(d => d.Unread, s => s.Ignore())
                .ForMember(d => d.Type,
                           s =>
                           s.MapFrom(src => (ApType) Enum.Parse(typeof (ApType), src.Type, true)))
                .ForMember(d => d.DateCreated, s => s.Ignore())
                .ForMember(d => d.DateModified, s => s.Ignore())
                .ForMember(d => d.DateLastAction, s => s.Ignore())
                .ForMember(d => d.HasPlugin, s => s.Ignore())
                .ForMember(d => d.Rank, s => s.Ignore())
                .ForMember(d => d.CommentCount, s => s.Ignore())
                .ForMember(d => d.LastViewDate, s => s.Ignore())
                .ForMember(d => d.Tags,
                           s => s.MapFrom(src => src.Tags == null
                                                     ? null
                                                     : (from t in src.Tags.Split(',')
                                                        where !string.IsNullOrEmpty(t)
                                                        select new Tag()
                                                                   {
                                                                       Name = t.Trim()
                                                                   }).ToArray()));
        }

        public static void MapComment(IContainer Container)
        {
            Mapper.CreateMap<CommentEdit, Comment>()
                .ConstructUsing(input =>
                {
                    if (input.ID > 0)
                    {
                        var comment = DependencyResolver.Current.GetService<ICommentRepository>().Get(input.ID);
                        comment.Raw.Body = input.Body;

                        return comment;
                    }

                    return new Comment
                    {
                        Raw = new CommentRaw { Body = input.Body },
                        Post = DependencyResolver.Current.GetService<IPostRepository>().Get(input.PostID)
                    };
                })
                .ForMember(d => d.Body, s => s.Ignore())
                .ForMember(d => d.Raw, s => s.Ignore())
                .ForMember(d => d.Post, s => s.Ignore())
                .ForMember(d => d.User, s => s.Ignore())
                .ForMember(d => d.UserModerated, s => s.Ignore())
                .ForMember(d => d.DateCreated, s => s.Ignore())
                .ForMember(d => d.DateModified, s => s.Ignore())
                .ForMember(d => d.DateLastAction, s => s.Ignore())
                .ForMember(d => d.Format, s => s.Ignore())
                .ForMember(d => d.StateContent, s => s.Ignore())
                .ForMember(d => d.Rank, s => s.Ignore())
                .ForMember(d => d.Unread, s => s.Ignore())
                .ForMember(d => d.Page, s => s.Ignore());

            Mapper.CreateMap<Comment, CommentEdit>()
                .ForMember(d => d.ID, s => s.MapFrom(src => src.ID))
                .ForMember(d => d.Body, s => s.MapFrom(src => src.Raw.Body));
        }
    }
}
