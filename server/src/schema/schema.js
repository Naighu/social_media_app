import graphql, { GraphQLBoolean } from 'graphql';
import Post from '../models/post.js'
import lodash from 'lodash';
import path from 'path';
import { writeFile } from 'fs'
const post = Post.post

import User from '../models/user.js'
import { log } from 'console';
const user = User.user

const { GraphQLObjectType, GraphQLString, GraphQLSchema, GraphQLID, GraphQLList, GraphQLNonNull } = graphql;

const UserType = new GraphQLObjectType({
    name: 'User',
    fields: () => ({
        _id: { type: GraphQLID },
        phone: { type: GraphQLString },
        name: { type: GraphQLString },
        username: { type: GraphQLString },
        followers: { type: new GraphQLList(GraphQLID) },
        following: { type: new GraphQLList(GraphQLID) },
    })
});

const MentionType = new GraphQLObjectType({
    name: 'Mention',
    fields: () => ({
        name: { type: GraphQLString },
        user: { type: GraphQLString },
    })
})

const PostType = new GraphQLObjectType({
    name: 'Post',
    fields: () => ({
        _id: { type: GraphQLID },
        user: { type: UserType },
        description: { type: GraphQLString },
        image: { type: GraphQLString },
        created_at: { type: GraphQLString }
    })
});

const RootQuery = new GraphQLObjectType({
    name: 'RootQueryType',
    fields: {
        user: {
            type: UserType,
            args: { _id: { type: new GraphQLNonNull(GraphQLString) }, phone: { type: new GraphQLNonNull(GraphQLString) }, username: { type: new GraphQLNonNull(GraphQLString) } },
            async resolve(parent, args) {
                const actual_args = lodash.pickBy(args, value => value !== '');

                let u = await user.findOne(actual_args)
                console.log(actual_args);
                if (!u)
                    return {}
                else return u

            }
        },
        search_users: {
            type: new GraphQLList(UserType),
            args: { search: { type: new GraphQLNonNull(GraphQLString) } },
            resolve(parent, args) {
                console.log();

                if (args.search === 'null') {
                    console.log(args.search);

                    return user.find().limit(10)
                }
                return user.find({ username: { $regex: args.search, $options: 'i' } },)
            }
        },
        post: {
            type: PostType,
            args: { id: { type: GraphQLID } },
            async resolve(parent, args) {

                let results = await post.findById(args.id)
                return results

            }
        },
        recommended_posts: {
            type: new GraphQLList(PostType),
            args: { user_id: { type: GraphQLID } },
            async resolve(parent, args) {

                const following = await user.findById(args.user_id).select('following')

                let posts = await post.find({ $or: [{ user: { $in: following['following'] } }, { user: args.user_id }] }).populate('user')


                return posts

            }
        },
        mentioned_posts: {
            type: new GraphQLList(PostType),
            args: { username: { type: GraphQLString } },
            async resolve(parent, args) {


                let posts = await post.find({ description: { $regex: `@${args.username} `, $options: 'i' } }).populate('user')
                return posts

            }
        },
        your_posts: {
            type: new GraphQLList(PostType),
            args: { user_id: { type: GraphQLID } },
            resolve(parent, args) {
                return post.find({ user: args.user_id }).populate('user')
            }
        }
    }
});

const Mutation = new GraphQLObjectType({
    name: 'Mutation',
    fields: {
        login: {
            type: UserType,
            args: {
                phone: { type: GraphQLString },
            },
            async resolve(parent, args) {
                let u = await user.findOne({ phone: args.phone })
                if (!u) {
                    u = new user({
                        phone: args.phone
                    });

                    return u.save()
                }
                return u
            }
        },
        follow_user: {
            type: UserType,
            args: {
                user_id: { type: GraphQLID },
                follow_user: { type: GraphQLID },

            },
            async resolve(parent, args) {
                let u1 = await user.findById(args.user_id)
                let u2 = await user.findById(args.follow_user)

                if (!u2 || !u1) {
                    throw Error('User not found')
                }
                if (!u1.following.includes(args.follow_user)) {
                    u1.following.push(args.follow_user)
                }
                if (!u2.followers.includes(args.user_id)) {
                    u2.followers.push(args.user_id)
                }
                await u2.save()
                return u1.save()
            }
        },
        unfollow_user: {
            type: UserType,
            args: {
                user_id: { type: GraphQLID },
                follow_user: { type: GraphQLID },

            },
            async resolve(parent, args) {
                let u1 = await user.findById(args.user_id)
                let u2 = await user.findById(args.follow_user)

                if (!u2 || !u1) {
                    throw Error('User not found')
                }

                u1.following = u1.following.filter(item => item.toString() != args.follow_user);
                u2.followers = u2.followers.filter(item => item.toString() != args.user_id);
                await u2.save()
                console.log('Saving');
                return u1.save()
            }
        },
        createUser: {
            type: UserType,
            args: {
                user: { type: GraphQLID },
                name: { type: GraphQLString },
                username: { type: GraphQLString }
            },
            async resolve(parent, args) {
                let temp_u = await user.findOne({ username: args.username })
                if (temp_u) {
                    throw new Error('Username is already taken');
                }

                temp_u = await user.findById(args.user)
                if (!temp_u) {
                    throw new Error('User doees not exists');
                }
                console.log(temp_u);

                temp_u.name = args.name
                temp_u.username = args.username
                return temp_u.save();
            }
        },
        createPost: {
            type: PostType,
            args: {
                user: { type: GraphQLID },
                image: { type: new GraphQLNonNull(GraphQLString) },
                description: { type: new GraphQLNonNull(GraphQLString) },
            },
            async resolve(parent, args) {
                let __dirname = path.resolve();

                let filePath = __dirname + '/uploaded_assets';
                let filename
                if (args.image == 'null') {
                    args.image = null
                }


                if (args.image) {

                    // console.log(image);
                    // const base64String = Buffer.from(image).toString('base64');
                    const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1e9);
                    filename = `${uniqueSuffix}.jpg`;
                    filePath = filePath + `/${filename}`

                    writeFile(filePath, args.image, { encoding: 'base64' }, (err) => {
                        if (err) {
                            console.error('Error writing to file:', err);
                        } else {
                            console.log('Base64 string saved to', filePath);
                        }
                    });

                }
                let p = new post({
                    user: args.user,
                    description: args.description == null ? null : `${args.description} `,
                    image: args.image ? 'uploaded_assets/' + filename : null
                    // mentions: args.
                });

                console.log('Post created');

                p = await p.save();
                return post.findById(p._id).populate('user')

            }
        }
    }
});

export default new GraphQLSchema({
    query: RootQuery,
    mutation: Mutation
});