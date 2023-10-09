import mongoose from 'mongoose';

const MentionSchema = mongoose.Schema({
    name: String,
    user: {
        type: mongoose.Schema.ObjectId,
        ref: "Users",
    },

});

const postSchema = new mongoose.Schema({

    user: {
        type: mongoose.Schema.ObjectId,
        ref: "Users",
    },
    description: {
        type: String,
    },
    image: {
        type: String
    },
    created_at: {
        type: Date,
        default: Date.now
    },
    updated_at: {
        type: Date
    }
})



postSchema.pre('save', async function save(next) {
    this.increment();

    this.updated_at = new Date;
    return next();
});

let post = mongoose.model('Posts', postSchema)

export default {
    post
}